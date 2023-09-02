import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:likeminds_chat_fl/likeminds_chat_fl.dart';
import 'package:likeminds_flutter_sample/chat/navigation/router.dart';
import 'package:likeminds_flutter_sample/chat/service/likeminds_service.dart';
import 'package:likeminds_flutter_sample/chat/service/service_locator.dart';
import 'package:likeminds_flutter_sample/chat/utils/branding/theme.dart';
import 'package:likeminds_flutter_sample/chat/utils/imports.dart';
import 'package:likeminds_flutter_sample/chat/utils/local_preference/local_prefs.dart';
import 'package:likeminds_flutter_sample/chat/views/home/bloc/home_bloc.dart';
import 'package:overlay_support/overlay_support.dart';

class ChatroomMenu extends StatefulWidget {
  final ChatRoom chatroom;
  final List<ChatroomAction> chatroomActions;

  const ChatroomMenu({
    Key? key,
    required this.chatroom,
    required this.chatroomActions,
  }) : super(key: key);

  @override
  State<ChatroomMenu> createState() => _ChatroomMenuState();
}

class _ChatroomMenuState extends State<ChatroomMenu> {
  CustomPopupMenuController? _controller;
  List<ChatroomAction>? chatroomActions;
  final User user = UserLocalPreference.instance.fetchUserData();

  ValueNotifier<bool> rebuildChatroomMenu = ValueNotifier(false);

  HomeBloc? homeBloc;
  @override
  void initState() {
    super.initState();
    chatroomActions = widget.chatroomActions;
    _controller = CustomPopupMenuController();
  }

  @override
  Widget build(BuildContext context) {
    homeBloc = BlocProvider.of<HomeBloc>(context);
    return CustomPopupMenu(
      pressType: PressType.singleClick,
      showArrow: false,
      controller: _controller,
      enablePassEvent: false,
      menuBuilder: () => ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Container(
          constraints: BoxConstraints(
            minWidth: 10.w,
            maxWidth: 52.w,
          ),
          color: Colors.white,
          child: ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemCount: chatroomActions?.length,
            itemBuilder: (BuildContext context, int index) {
              return getListTile(chatroomActions![index]);
            },
          ),
        ),
      ),
      child: Icon(
        Icons.more_vert_rounded,
        size: 18.sp,
        color: LMTheme.buttonColor,
      ),
    );
  }

  Widget? getListTile(ChatroomAction action) {
    return ListTile(
      onTap: () {
        performAction(action);
      },
      title: Text(
        action.title,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        style: LMTheme.regular.copyWith(
          fontSize: 10.sp,
          fontWeight: FontWeight.w400,
          color: LMTheme.buttonColor,
        ),
      ),
    );
  }

  void performAction(ChatroomAction action) {
    switch (action.id) {
      case 2:
        // _controller.hideMenu();
        _controller!.hideMenu();
        router.push("/participants", extra: widget.chatroom);
        break;
      case 6:
        muteChatroom(action);
        break;
      case 8:
        muteChatroom(action);
        break;
      case 4:
        joinOrLeaveChatroom(action);
        break;
      case 9:
        joinOrLeaveChatroom(action);
        break;
      case 15:
        leaveSecretChatroom();
        break;
      default:
        unimplemented();
    }
  }

  void joinOrLeaveChatroom(ChatroomAction action) async {
    final response = await locator<LikeMindsService>()
        .followChatroom((FollowChatroomRequestBuilder()
              ..chatroomId(widget.chatroom.id)
              ..memberId(user.id)
              ..value(!widget.chatroom.followStatus!))
            .build());
    if (response.success) {
      Fluttertoast.showToast(
          msg: widget.chatroom.followStatus!
              ? "Chatroom left"
              : "Chatroom joined");
      widget.chatroom.followStatus = !widget.chatroom.followStatus!;
      action.title =
          widget.chatroom.followStatus! ? "Leave chatroom" : "Join chatroom";

      _controller!.hideMenu();
      homeBloc?.add(UpdateHomeEvent());
    } else {
      Fluttertoast.showToast(msg: response.errorMessage!);
    }
  }

  void unimplemented() {
    Fluttertoast.showToast(msg: "Coming Soon");
  }

  void muteChatroom(ChatroomAction action) async {
    final response = await locator<LikeMindsService>()
        .muteChatroom((MuteChatroomRequestBuilder()
              ..chatroomId(widget.chatroom.id)
              ..value(!widget.chatroom.muteStatus!))
            .build());
    if (response.success) {
      // _controller.hideMenu();
      // rebuildChatroomMenu.value = !rebuildChatroomMenu.value;
      Fluttertoast.showToast(
          msg: (action.title.toLowerCase() == "mute notifications")
              ? "Chatroom muted"
              : "Chatroom unmuted");
      chatroomActions = chatroomActions?.map((element) {
        if (element.title.toLowerCase() == "mute notifications") {
          element.title = "Unmute notifications";
        } else if (element.title.toLowerCase() == "unmute notifications") {
          element.title = "Mute notifications";
        }

        return element;
      }).toList();
      rebuildChatroomMenu.value = !rebuildChatroomMenu.value;
      _controller!.hideMenu();
      homeBloc!.add(UpdateHomeEvent());
    } else {
      toast(response.errorMessage!);
    }
  }

  void leaveSecretChatroom() async {
    final response = await locator<LikeMindsService>()
        .deleteParticipant((DeleteParticipantRequestBuilder()
              ..chatroomId(widget.chatroom.id)
              ..memberId(user.userUniqueId)
              ..isSecret(true))
            .build());
    if (response.success) {
      widget.chatroom.isGuest = true;
      widget.chatroom.followStatus = false;
      Fluttertoast.showToast(msg: "Chatroom left");
      _controller!.hideMenu();
      homeBloc?.add(UpdateHomeEvent());
      router.pop();
    } else {
      Fluttertoast.showToast(msg: response.errorMessage!);
    }
  }
}
