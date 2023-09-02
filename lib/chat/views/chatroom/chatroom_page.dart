import 'package:flutter/services.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:likeminds_chat_fl/likeminds_chat_fl.dart';
import 'package:likeminds_flutter_sample/chat/navigation/router.dart';
import 'package:likeminds_flutter_sample/chat/utils/analytics/analytics.dart';
import 'package:likeminds_flutter_sample/chat/utils/branding/theme.dart';
import 'package:likeminds_flutter_sample/chat/utils/chatroom/conversation_state.dart';
import 'package:likeminds_flutter_sample/chat/utils/chatroom/conversation_utils.dart';
import 'package:likeminds_flutter_sample/chat/utils/imports.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:likeminds_flutter_sample/chat/utils/local_preference/local_prefs.dart';
import 'package:likeminds_flutter_sample/chat/service/media_service.dart';
import 'package:likeminds_flutter_sample/chat/utils/simple_bloc_observer.dart';
import 'package:likeminds_flutter_sample/chat/utils/tagging/helpers/tagging_helper.dart';
import 'package:likeminds_flutter_sample/chat/views/chatroom/bloc/chat_action_bloc/chat_action_bloc.dart';
import 'package:likeminds_flutter_sample/chat/views/chatroom/chatroom_components/Poll/bloc/poll_bloc.dart';
import 'package:likeminds_flutter_sample/chat/views/chatroom/chatroom_components/Reaction/reaction_emoji_keyboard.dart';
import 'package:likeminds_flutter_sample/chat/views/chatroom/chatroom_components/chat_bar.dart';
import 'package:likeminds_flutter_sample/chat/views/conversation/bloc/conversation_bloc.dart';
import 'package:likeminds_flutter_sample/chat/views/home/bloc/home_bloc.dart';
import 'package:likeminds_flutter_sample/chat/widgets/picture_or_initial.dart';
import 'package:likeminds_flutter_sample/chat/widgets/back_button.dart' as bb;
import 'package:likeminds_flutter_sample/chat/views/chatroom/chatroom_components/chatroom_skeleton.dart';

import 'bloc/chatroom_bloc.dart';
import 'chatroom_components/chat_bubble.dart';
import 'chatroom_components/chatroom_menu.dart';

class ChatroomPage extends StatefulWidget {
  final int chatroomId;
  final bool isRoot;
  const ChatroomPage({
    super.key,
    required this.chatroomId,
    required this.isRoot,
  });

  @override
  State<ChatroomPage> createState() => _ChatroomPageState();
}

class _ChatroomPageState extends State<ChatroomPage> {
  ChatActionBloc? chatActionBloc;
  Map<String, List<Media>> conversationAttachmentsMeta =
      <String, List<Media>>{};
  Map<String, List<Media>> mediaFiles = <String, List<Media>>{};
  int currentTime = DateTime.now().millisecondsSinceEpoch;
  ValueNotifier rebuildConversationList = ValueNotifier(false);
  final ConversationBloc conversationBloc = ConversationBloc();
  Map<int, User?> userMeta = <int, User?>{};
  ChatRoom? chatroom;
  ValueNotifier rebuildChatBar = ValueNotifier(false);
  ValueNotifier showConversationActions = ValueNotifier(false);
  User currentUser = UserLocalPreference.instance.fetchUserData();
  MemberStateResponse memberState =
      UserLocalPreference.instance.fetchMemberRights();
  bool showScrollButton = false;
  int lastConversationId = 0;
  List<Conversation> selectedConversations = <Conversation>[];
  FocusNode focusNode = FocusNode();

  ScrollController scrollController = ScrollController();
  PagingController<int, Conversation> pagedListController =
      PagingController<int, Conversation>(firstPageKey: 1);

  int _page = 1;

  bool checkDeletePermissions(Conversation conversation) {
    if (conversation.deletedByUserId != null) {
      return false;
    } else if (memberState.member?.state == 1) {
      return true;
    } else if (currentUser.id == conversation.userId) {
      return true;
    } else {
      return false;
    }
  }

  bool checkEditPermissions(Conversation conversation) {
    if (conversation.answer.isEmpty || conversation.deletedByUserId != null) {
      return false;
    } else if (memberState.member?.state == 1) {
      return true;
    } else if (currentUser.id == conversation.userId) {
      return true;
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    Bloc.observer = SimpleBlocObserver();
    _addPaginationListener();
    chatActionBloc = BlocProvider.of<ChatActionBloc>(context);
    focusNode.addListener(
      () {
        if (chatActionBloc != null) {
          if (focusNode.hasFocus &&
              chatActionBloc!.state is ConversationToolBarState) {
            chatActionBloc!.add(RemoveConversationToolBar());
          }
        }
      },
    );
    scrollController.addListener(
      () {
        _showScrollToBottomButton();
        if (chatActionBloc != null &&
            chatActionBloc!.state is ConversationToolBarState) {
          ConversationToolBarState state =
              chatActionBloc!.state as ConversationToolBarState;
          if (state.showReactionBar == true) {
            chatActionBloc!.add(
              ConversationToolBar(
                selectedConversation: state.selectedConversation,
                showReactionKeyboard: state.showReactionKeyboard,
                showReactionBar: false,
              ),
            );
          }
        }
      },
    );

    // conversationBloc = ConversationBloc();
  }

  @override
  void dispose() {
    pagedListController.dispose();
    scrollController.dispose();
    chatActionBloc!.add(ReplyRemove());
    lastConversationId = 0;
    focusNode.dispose();
    super.dispose();
  }

  _addPaginationListener() {
    pagedListController.addPageRequestListener(
      (pageKey) {
        conversationBloc.add(
          GetConversation(
            getConversationRequest: (GetConversationRequestBuilder()
                  ..chatroomId(widget.chatroomId)
                  ..page(pageKey)
                  ..pageSize(500)
                  ..minTimestamp(0)
                  ..maxTimestamp(currentTime))
                .build(),
          ),
        );
      },
    );
  }

  void addLocalConversationToPagedList(Conversation conversation) {
    List<Conversation> conversationList =
        pagedListController.itemList ?? <Conversation>[];

    conversationList.insert(0, conversation);
    if (conversationList.length >= 500) {
      conversationList.removeLast();
    }
    if (!userMeta.containsKey(currentUser.id)) {
      userMeta[currentUser.id] = currentUser;
    }

    pagedListController.itemList = conversationList;
    rebuildConversationList.value = !rebuildConversationList.value;
  }

  void addConversationToPagedList(Conversation conversation) {
    List<Conversation> conversationList =
        pagedListController.itemList ?? <Conversation>[];

    int index = conversationList.indexWhere(
        (element) => element.temporaryId == conversation.temporaryId);
    if (index != -1) {
      conversationList[index] = conversation;
    } else {
      if (conversationList.first.date != conversation.date) {
        conversationList.insert(
          0,
          Conversation(
            isTimeStamp: true,
            id: 1,
            hasFiles: false,
            attachmentCount: 0,
            attachmentsUploaded: false,
            createdEpoch: conversation.createdEpoch,
            chatroomId: chatroom!.id,
            date: conversation.date,
            memberId: conversation.memberId,
            userId: conversation.userId,
            temporaryId: conversation.temporaryId,
            answer: conversation.date ?? '',
            communityId: chatroom!.communityId!,
            createdAt: conversation.createdAt,
            header: conversation.header,
          ),
        );
      }
      conversationList.insert(0, conversation);
      if (conversationList.length >= 500) {
        conversationList.removeLast();
      }
      if (!userMeta.containsKey(currentUser.id)) {
        userMeta[currentUser.id] = currentUser;
      }
    }
    pagedListController.itemList = conversationList;
    rebuildConversationList.value = !rebuildConversationList.value;
  }

  void addMultiMediaConversation(MultiMediaConversationPosted state) {
    if (!userMeta.containsKey(currentUser.id)) {
      userMeta[currentUser.id] = currentUser;
    }
    if (!conversationAttachmentsMeta
        .containsKey(state.postConversationResponse.conversation!.id)) {
      List<Media> putMediaAttachment = state.putMediaResponse;
      conversationAttachmentsMeta[
              '${state.postConversationResponse.conversation!.id}'] =
          putMediaAttachment;
    }
    List<Conversation> conversationList =
        pagedListController.itemList ?? <Conversation>[];

    conversationList.removeWhere((element) =>
        element.temporaryId ==
        state.postConversationResponse.conversation!.temporaryId);

    mediaFiles.remove(state.postConversationResponse.conversation!.temporaryId);

    conversationList.insert(
      0,
      Conversation(
        id: state.postConversationResponse.conversation!.id,
        hasFiles: true,
        attachmentCount: state.putMediaResponse.length,
        attachmentsUploaded: true,
        chatroomId: chatroom!.id,
        state: state.postConversationResponse.conversation!.state,
        date: state.postConversationResponse.conversation!.date,
        memberId: state.postConversationResponse.conversation!.memberId,
        userId: state.postConversationResponse.conversation!.userId,
        temporaryId: state.postConversationResponse.conversation!.temporaryId,
        answer: state.postConversationResponse.conversation!.answer,
        communityId: chatroom!.communityId!,
        createdAt: state.postConversationResponse.conversation!.createdAt,
        header: state.postConversationResponse.conversation!.header,
      ),
    );

    if (conversationList.length >= 500) {
      conversationList.removeLast();
    }
    rebuildConversationList.value = !rebuildConversationList.value;
  }

  void _scrollToBottom() {
    scrollController.animateTo(
      scrollController.position.minScrollExtent,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
    );
  }

  void _showScrollToBottomButton() {
    if (scrollController.position.pixels >
        scrollController.position.viewportDimension) {
      _showButton();
    }
    if (scrollController.position.pixels <
        scrollController.position.viewportDimension) {
      _hideButton();
    }
  }

  void _showButton() {
    setState(() {
      showScrollButton = true;
    });
  }

  void _hideButton() {
    setState(() {
      showScrollButton = false;
    });
  }

  void updatePagingControllers(Object? state) {
    if (state is ConversationLoaded) {
      _page++;

      if (state.getConversationResponse.conversationAttachmentsMeta != null &&
          state.getConversationResponse.conversationAttachmentsMeta!
              .isNotEmpty) {
        Map<String, List<Media>> getConversationAttachmentData = state
            .getConversationResponse.conversationAttachmentsMeta!
            .map((key, value) {
          return MapEntry(
            key,
            (value as List<dynamic>?)?.map((e) => Media.fromJson(e)).toList() ??
                [],
          );
        });
        conversationAttachmentsMeta.addAll(getConversationAttachmentData);
      }

      if (state.getConversationResponse.userMeta != null) {
        userMeta.addAll(state.getConversationResponse.userMeta!);
      }
      List<Conversation>? conversationData =
          state.getConversationResponse.conversationData;
      filterOutStateMessage(conversationData ?? []);
      conversationData = addTimeStampInConversationList(
          conversationData, chatroom!.communityId!);
      if (state.getConversationResponse.conversationData == null ||
          state.getConversationResponse.conversationData!.isEmpty ||
          state.getConversationResponse.conversationData!.length < 500) {
        pagedListController.appendLastPage(conversationData ?? []);
      } else {
        pagedListController.appendPage(conversationData!, _page);
      }
    }
  }

  void updatePollConversation(Conversation pollConversation) {
    List<Conversation> conversationList =
        pagedListController.itemList ?? <Conversation>[];
    int index = conversationList
        .indexWhere((element) => element.id == pollConversation.id);
    if (index != -1) {
      conversationList[index] = pollConversation;
    }
    pagedListController.itemList = conversationList;
    rebuildConversationList.value = !rebuildConversationList.value;
  }

  void updateEditedConversation(Conversation editedConversation) {
    List<Conversation> conversationList =
        pagedListController.itemList ?? <Conversation>[];
    int index = conversationList
        .indexWhere((element) => element.id == editedConversation.id);
    if (index != -1) {
      conversationList[index].isEdited = editedConversation.isEdited;
      conversationList[index].lastUpdated = editedConversation.lastUpdated;
      conversationList[index].answer = editedConversation.answer;
    }
    pagedListController.itemList = conversationList;
    rebuildConversationList.value = !rebuildConversationList.value;
  }

  void updateDeletedConversation(DeleteConversationResponse response) {
    List<Conversation> conversationList =
        pagedListController.itemList ?? <Conversation>[];
    int index = conversationList.indexWhere(
        (element) => element.id == response.conversations!.first.id);
    if (index != -1) {
      conversationList[index].deletedByUserId = currentUser.id;
    }
    pagedListController.itemList = conversationList;
    scrollController.animateTo(
      scrollController.position.pixels + 10,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
    );
    rebuildConversationList.value = !rebuildConversationList.value;
  }

  @override
  Widget build(BuildContext context) {
    // conversationBloc = BlocProvider.of<ConversationBloc>(context);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: WillPopScope(
        onWillPop: () async {
          debugPrint(router.location);
          conversationBloc.add(
            MarkReadChatroomEvent(chatroomId: widget.chatroomId),
          );
          BlocProvider.of<HomeBloc>(context).add(UpdateHomeEvent());
          router.pop();
          return false;
        },
        child: BlocProvider(
          create: (context) => PollBloc(),
          child: Scaffold(
            backgroundColor: Colors.white,
            floatingActionButton: showScrollButton
                ? Padding(
                    padding: EdgeInsets.only(bottom: 12.h),
                    child: Container(
                      height: 32.sp,
                      width: 32.sp,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.sp),
                        color: LMTheme.buttonColor,
                        boxShadow: [
                          BoxShadow(
                            offset: const Offset(0, 4),
                            blurRadius: 25,
                            color: blackColor.withOpacity(0.3),
                          )
                        ],
                      ),
                      child: Center(
                        child: IconButton(
                          iconSize: 18.sp,
                          onPressed: () {
                            _scrollToBottom();
                          },
                          icon: Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.white,
                            size: 18.sp,
                          ),
                        ),
                      ),
                    ),
                  )
                : null,
            body: SafeArea(
              bottom: false,
              left: false,
              right: false,
              child: BlocConsumer<ChatroomBloc, ChatroomState>(
                listener: (context, state) {
                  if (state is ChatroomLoaded) {
                    chatroom = state.getChatroomResponse.chatroom!;
                    lastConversationId =
                        state.getChatroomResponse.lastConversationId ?? 0;
                    chatActionBloc?.add(
                      NewConversation(
                        chatroomId: chatroom!.id,
                        conversationId: lastConversationId,
                      ),
                    );
                    LMAnalytics.get().track(
                      AnalyticsKeys.chatroomOpened,
                      {
                        'chatroom_id': chatroom!.id,
                        'community_id': chatroom!.communityId,
                        'chatroom_type': chatroom!.type,
                        'source': 'home_feed',
                      },
                    );
                  }
                },
                builder: (context, state) {
                  // return const SkeletonChatList();
                  if (state is ChatroomLoading) {
                    return const SkeletonChatPage();
                  }

                  if (state is ChatroomLoaded) {
                    var pagedListView = ValueListenableBuilder(
                      valueListenable: rebuildConversationList,
                      builder: (context, _, __) {
                        return BlocConsumer<ConversationBloc,
                            ConversationState>(
                          bloc: conversationBloc,
                          listener: (context, state) =>
                              updatePagingControllers(state),
                          builder: (context, state) {
                            return PagedListView(
                              pagingController: pagedListController,
                              scrollController: scrollController,
                              physics: const ClampingScrollPhysics(),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              reverse: true,
                              scrollDirection: Axis.vertical,
                              builderDelegate:
                                  PagedChildBuilderDelegate<Conversation>(
                                noItemsFoundIndicatorBuilder: (context) =>
                                    const SizedBox(
                                  height: 10,
                                ),
                                firstPageProgressIndicatorBuilder: (context) =>
                                    const SkeletonChatList(),
                                newPageProgressIndicatorBuilder: (context) =>
                                    Padding(
                                  padding: EdgeInsets.symmetric(vertical: 1.h),
                                  child: const Column(
                                    children: [
                                      SkeletonChatBubble(isSent: true),
                                      SkeletonChatBubble(isSent: false),
                                      SkeletonChatBubble(isSent: true),
                                    ],
                                  ),
                                ),
                                animateTransitions: true,
                                transitionDuration:
                                    const Duration(milliseconds: 500),
                                itemBuilder: (context, item, index) {
                                  if (item.isTimeStamp != null &&
                                          item.isTimeStamp! ||
                                      item.state != null &&
                                          (item.state != 0 &&
                                              item.state != 10)) {
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: item.isTimeStamp == null ||
                                                  !item.isTimeStamp!
                                              ? 70.w
                                              : 35.w,
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 5),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 5,
                                            vertical: 5,
                                          ),
                                          decoration: BoxDecoration(
                                            color: whiteColor.withOpacity(0.5),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          alignment: Alignment.center,
                                          child: Text(
                                            TaggingHelper.extractStateMessage(
                                                item.answer),
                                            textAlign: TextAlign.center,
                                            style: LMTheme.medium.copyWith(
                                              fontSize: 9.sp,
                                            ),
                                          ),
                                        )
                                      ],
                                    );
                                  }
                                  // item.

                                  return ChatBubble(
                                    key: Key(item.id.toString()),
                                    userMeta: userMeta,
                                    onEdit: (conversation) {
                                      if (chatActionBloc == null) {
                                        return;
                                      }
                                      chatActionBloc?.add(
                                        EditingConversation(
                                          chatroomId: chatroom!.id,
                                          conversationId: conversation.id,
                                          editConversation: conversation,
                                        ),
                                      );
                                    },
                                    onReply: (replyingTo) {
                                      if (chatActionBloc == null) {
                                        return;
                                      }
                                      chatActionBloc?.add(
                                        ReplyConversation(
                                          chatroomId: chatroom!.id,
                                          conversationId: item.id,
                                          replyConversation: replyingTo,
                                        ),
                                      );
                                    },
                                    replyToConversation:
                                        item.replyConversationObject,
                                    chatroom: chatroom!,
                                    conversation: item,
                                    sender: userMeta[
                                            item.userId ?? item.memberId] ??
                                        item.member!,
                                    mediaFiles: mediaFiles,
                                    conversationAttachments:
                                        conversationAttachmentsMeta
                                                .containsKey(item.id.toString())
                                            ? conversationAttachmentsMeta[
                                                '${item.id}']
                                            : conversationAttachmentsMeta[
                                                item.temporaryId],
                                    replyConversationAttachments:
                                        item.replyId != null
                                            ? conversationAttachmentsMeta
                                                    .containsKey(
                                                        item.replyId.toString())
                                                ? conversationAttachmentsMeta[
                                                    item.replyId.toString()]
                                                : null
                                            : null,
                                    isSelected: (isSelected) {
                                      if (isSelected) {
                                        selectedConversations.add(item);
                                      } else {
                                        selectedConversations.remove(item);
                                      }
                                    },
                                    onLongPress: (conversation) {
                                      _startSelection(conversation);
                                    },
                                  );
                                },
                              ),
                            );
                          },
                        );
                      },
                    );

                    return Column(
                      children: [
                        Container(
                          decoration:
                              BoxDecoration(color: whiteColor, boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 10,
                              offset: const Offset(0, 10),
                            )
                          ]),
                          child: Column(
                            children: <Widget>[
                              verticalPaddingMedium,
                              BlocBuilder(
                                bloc: chatActionBloc,
                                builder: (context, childState) {
                                  if (childState is ConversationToolBarState) {
                                    return Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 2.w),
                                      child: Row(
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              _clearSelection();
                                              chatActionBloc!.add(
                                                  RemoveConversationToolBar());
                                            },
                                            icon: Icon(
                                              Icons.close,
                                              size: 16.sp,
                                              color: LMTheme.buttonColor,
                                            ),
                                          ),
                                          SizedBox(width: 2.w),
                                          Text(
                                            childState
                                                .selectedConversation.length
                                                .toString(),
                                            style: LMTheme.medium.copyWith(
                                              fontSize: 12.sp,
                                            ),
                                          ),
                                          const Spacer(),
                                          Row(
                                            children: [
                                              childState.selectedConversation
                                                          .length ==
                                                      1
                                                  ? IconButton(
                                                      onPressed: () {
                                                        if (chatActionBloc ==
                                                            null) {
                                                          return;
                                                        }
                                                        chatActionBloc?.add(
                                                          ReplyConversation(
                                                            chatroomId:
                                                                chatroom!.id,
                                                            conversationId:
                                                                childState
                                                                    .selectedConversation
                                                                    .first
                                                                    .id,
                                                            replyConversation:
                                                                childState
                                                                    .selectedConversation
                                                                    .first,
                                                          ),
                                                        );
                                                      },
                                                      icon: Icon(
                                                        Icons.reply,
                                                        size: 16.sp,
                                                        color:
                                                            LMTheme.buttonColor,
                                                      ),
                                                    )
                                                  : const SizedBox(),
                                              IconButton(
                                                onPressed: () {
                                                  if (childState
                                                          .selectedConversation
                                                          .length ==
                                                      1) {
                                                    Clipboard.setData(
                                                      ClipboardData(
                                                        text: TaggingHelper
                                                                .convertRouteToTag(
                                                                    childState
                                                                        .selectedConversation
                                                                        .first
                                                                        .answer) ??
                                                            '',
                                                      ),
                                                    ).then((value) {
                                                      Fluttertoast.showToast(
                                                          msg:
                                                              "Copied to clipboard");
                                                    });
                                                  } else {
                                                    List<String> answerList =
                                                        childState
                                                            .selectedConversation
                                                            .map((e) {
                                                      String name =
                                                          userMeta[e.userId]!
                                                              .name;
                                                      String timeStamp =
                                                          "[${e.date}, ${e.createdAt}]";
                                                      String text = TaggingHelper
                                                              .convertRouteToTag(
                                                                  e.answer) ??
                                                          '';
                                                      return "$timeStamp $name: $text";
                                                    }).toList();
                                                    Clipboard.setData(
                                                      ClipboardData(
                                                        text: answerList
                                                            .join('\n'),
                                                      ),
                                                    ).then((value) {
                                                      Fluttertoast.showToast(
                                                          msg:
                                                              "Copied to clipboard");
                                                    });
                                                  }
                                                  chatActionBloc!.add(
                                                      RemoveConversationToolBar());
                                                },
                                                icon: Icon(
                                                  Icons.copy,
                                                  size: 16.sp,
                                                  color: LMTheme.buttonColor,
                                                ),
                                              ),
                                              checkEditPermissions(childState
                                                          .selectedConversation
                                                          .first) &&
                                                      childState
                                                              .selectedConversation
                                                              .length ==
                                                          1
                                                  ? IconButton(
                                                      onPressed: () {
                                                        if (chatActionBloc ==
                                                            null) {
                                                          return;
                                                        }
                                                        chatActionBloc?.add(
                                                          EditingConversation(
                                                            chatroomId:
                                                                chatroom!.id,
                                                            conversationId:
                                                                childState
                                                                    .selectedConversation
                                                                    .first
                                                                    .id,
                                                            editConversation:
                                                                childState
                                                                    .selectedConversation
                                                                    .first,
                                                          ),
                                                        );
                                                      },
                                                      icon: Icon(
                                                        Icons.edit,
                                                        size: 16.sp,
                                                        color:
                                                            LMTheme.buttonColor,
                                                      ),
                                                    )
                                                  : const SizedBox(),
                                              checkDeletePermissions(childState
                                                          .selectedConversation
                                                          .first) &&
                                                      childState
                                                              .selectedConversation
                                                              .length ==
                                                          1
                                                  ? IconButton(
                                                      onPressed: () {
                                                        if (chatActionBloc ==
                                                            null) {
                                                          return;
                                                        }
                                                        DeleteConversationRequest
                                                            request =
                                                            (DeleteConversationRequestBuilder()
                                                                  ..conversationIds([
                                                                    childState
                                                                        .selectedConversation
                                                                        .first
                                                                        .id
                                                                  ])
                                                                  ..reason(
                                                                      "Delete"))
                                                                .build();
                                                        chatActionBloc!.add(
                                                          DeleteConversation(
                                                              request),
                                                        );
                                                      },
                                                      icon: Icon(
                                                        Icons.delete,
                                                        size: 16.sp,
                                                        color:
                                                            LMTheme.buttonColor,
                                                      ),
                                                    )
                                                  : const SizedBox()
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  } else {
                                    return Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 4.w,
                                        vertical: 0.8.h,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Visibility(
                                            visible: !widget.isRoot,
                                            child: bb.BackButton(
                                              onTap: () {
                                                BlocProvider.of<HomeBloc>(
                                                        context)
                                                    .add(UpdateHomeEvent());
                                              },
                                            ),
                                          ),
                                          SizedBox(width: 4.w),
                                          PictureOrInitial(
                                            fallbackText: chatroom!.header,
                                            imageUrl:
                                                chatroom?.chatroomImageUrl,
                                            size: 30.sp,
                                            fontSize: 14.sp,
                                          ),
                                          SizedBox(width: 4.w),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  chatroom!.header,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style:
                                                      LMTheme.medium.copyWith(
                                                    fontSize: 11.sp,
                                                  ),
                                                ),
                                                verticalPaddingSmall,
                                                Text(
                                                  '${chatroom!.participantCount} participants',
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style:
                                                      LMTheme.regular.copyWith(
                                                    fontSize: 9.sp,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          horizontalPaddingMedium,
                                          ChatroomMenu(
                                            chatroom: chatroom!,
                                            chatroomActions: state
                                                .getChatroomResponse
                                                .chatroomActions!,
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                },
                              ),
                              verticalPaddingMedium,
                            ],
                          ),
                        ),
                        Expanded(
                          child: Portal(
                            child: Container(
                              color: greyColor.withOpacity(0.2),
                              child: pagedListView,
                            ),
                          ),
                        ),
                        BlocConsumer(
                          bloc: chatActionBloc,
                          listener: (context, state) {
                            if (state is LocalConversation) {
                              addLocalConversationToPagedList(
                                  state.conversation);
                            }
                            if (state is ConversationEdited) {
                              updateEditedConversation(
                                  state.editConversationResponse.conversation!);
                            }
                            if (state is ConversationDelete) {
                              updateDeletedConversation(
                                  state.deleteConversationResponse);
                            }
                            if (state is ConversationPosted) {
                              addConversationToPagedList(
                                state.postConversationResponse.conversation!,
                              );
                            } else if (state is MultiMediaConversationLoading) {
                              if (!userMeta.containsKey(currentUser.id)) {
                                userMeta[currentUser.id] = currentUser;
                              }
                              mediaFiles[state.postConversation.temporaryId!] =
                                  state.mediaFiles;

                              List<Conversation> conversationList =
                                  pagedListController.itemList ??
                                      <Conversation>[];

                              conversationList.insert(
                                  0, state.postConversation);

                              rebuildConversationList.value =
                                  !rebuildConversationList.value;
                            } else if (state is MultiMediaConversationPosted) {
                              addMultiMediaConversation(
                                state,
                              );
                            }
                            if (state is UpdatedPollConversation) {
                              updatePollConversation(state.response);
                            }
                            if (state is UpdateConversation) {
                              if (state.response.id != lastConversationId) {
                                addConversationToPagedList(
                                  state.response,
                                );
                                lastConversationId = state.response.id;
                              }
                            }
                            if (state is ReplyConversationState) {
                              rebuildChatBar.value = !rebuildChatBar.value;
                            }
                            if (state is EditConversationState) {
                              rebuildChatBar.value = !rebuildChatBar.value;
                            }
                          },
                          builder: (context, state) {
                            return ValueListenableBuilder(
                              valueListenable: rebuildChatBar,
                              builder: (context, _, __) {
                                if (state is EditConversationState) {
                                  return Container(
                                    color: greyColor.withOpacity(0.2),
                                    child: SafeArea(
                                      top: false,
                                      bottom: true,
                                      child: ChatBar(
                                        chatroom: chatroom!,
                                        focusNode: focusNode,
                                        editConversation:
                                            state.editConversation,
                                        scrollToBottom: _scrollToBottom,
                                        userMeta: userMeta,
                                      ),
                                    ),
                                  );
                                }
                                if (state is ReplyConversationState) {
                                  return Container(
                                    color: greyColor.withOpacity(0.2),
                                    child: SafeArea(
                                      top: false,
                                      bottom: true,
                                      child: ChatBar(
                                        chatroom: chatroom!,
                                        focusNode: focusNode,
                                        replyToConversation: state.conversation,
                                        replyConversationAttachments:
                                            conversationAttachmentsMeta
                                                    .containsKey(state
                                                        .conversation.id
                                                        .toString())
                                                ? conversationAttachmentsMeta[
                                                    '${state.conversation.id}']
                                                : null,
                                        scrollToBottom: _scrollToBottom,
                                        userMeta: userMeta,
                                      ),
                                    ),
                                  );
                                }
                                return Container(
                                  color: greyColor.withOpacity(0.2),
                                  child: SafeArea(
                                    top: false,
                                    bottom: state is ConversationToolBarState &&
                                            state.showReactionKeyboard
                                        ? false
                                        : true,
                                    child: ChatBar(
                                      chatroom: chatroom!,
                                      focusNode: focusNode,
                                      scrollToBottom: _scrollToBottom,
                                      userMeta: userMeta,
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                        BlocBuilder(
                            bloc: chatActionBloc,
                            builder: (context, state) {
                              if (state is ConversationToolBarState &&
                                  state.showReactionKeyboard) {
                                return Container(
                                  color: const Color(0xFFF2F2F2),
                                  child: SafeArea(
                                    bottom: true,
                                    child: flutterEmojiPicker(
                                      TextEditingController(),
                                      chatActionBloc!,
                                      state.selectedConversation.first,
                                      currentUser,
                                      chatroom!,
                                    ),
                                  ),
                                );
                              }
                              return const SizedBox();
                            }),
                      ],
                    );
                  }
                  return Container(
                    color: greyColor.withOpacity(0.2),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _clearSelection() {
    selectedConversations.clear();
    showConversationActions.value = false;
    // rebuildConversationList.value = !rebuildConversationList.value;
  }

  void _startSelection(Conversation conversation) {
    // showConversationActions.value = true;
  }
}
