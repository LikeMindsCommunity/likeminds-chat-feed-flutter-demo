import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:likeminds_chat_fl/likeminds_chat_fl.dart';
import 'package:likeminds_flutter_sample/chat/service/likeminds_service.dart';
import 'package:likeminds_flutter_sample/chat/service/service_locator.dart';
import 'package:likeminds_flutter_sample/chat/utils/imports.dart';
import 'package:likeminds_flutter_sample/chat/views/chatroom/bloc/chat_action_bloc/chat_action_bloc.dart';
import 'package:overlay_support/overlay_support.dart';

Widget flutterEmojiPicker(
    TextEditingController textEditingController,
    ChatActionBloc chatActionBloc,
    Conversation conversation,
    User loggedinUser,
    ChatRoom chatroom) {
  return SizedBox(
    height: 35.h,
    child: EmojiPicker(
      onEmojiSelected: (category, emoji) async {
        if (!chatroom.followStatus!) {
          Future<LMResponse> response = locator<LikeMindsService>()
              .followChatroom((FollowChatroomRequestBuilder()
                    ..chatroomId(chatroom.id)
                    ..memberId(loggedinUser.id)
                    ..value(true))
                  .build())
            ..then((value) {
              if (value.success) {
                toast("Chatroom joined");
              }
            });
        }
        PutReactionRequest putReactionRequest = (PutReactionRequestBuilder()
              ..conversationId(conversation.id)
              ..reaction(emoji.emoji))
            .build();
        chatActionBloc.add(PutReaction(putReactionRequest: putReactionRequest));
      },
      onBackspacePressed: null,
      textEditingController:
          textEditingController, // pass here the same [TextEditingController] that is connected to your input field, usually a [TextFormField]
      config: Config(
        columns: 7,
        emojiSizeMax: 32 *
            (foundation.defaultTargetPlatform == TargetPlatform.iOS
                ? 1.30
                : 1.0), // Issue: https://github.com/flutter/flutter/issues/28894
        verticalSpacing: 0,
        horizontalSpacing: 0,
        gridPadding: EdgeInsets.zero,
        initCategory: Category.RECENT,
        bgColor: const Color(0xFFF2F2F2),
        indicatorColor: Colors.blue,
        iconColor: Colors.grey,
        iconColorSelected: Colors.blue,
        backspaceColor: Colors.blue,
        skinToneDialogBgColor: Colors.white,
        skinToneIndicatorColor: Colors.grey,
        enableSkinTones: true,
        recentTabBehavior: RecentTabBehavior.RECENT,
        recentsLimit: 28,
        noRecents: const Text(
          'No Recents',
          style: TextStyle(fontSize: 20, color: Colors.black26),
          textAlign: TextAlign.center,
        ), // Needs to be const Widget
        loadingIndicator: const SizedBox.shrink(), // Needs to be const Widget
        tabIndicatorAnimDuration: kTabScrollDuration,
        categoryIcons: const CategoryIcons(),
        buttonMode: ButtonMode.MATERIAL,
      ),
    ),
  );
}
