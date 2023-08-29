import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:likeminds_chat_fl/likeminds_chat_fl.dart';
import 'package:likeminds_flutter_sample/chat/utils/branding/lm_fonts.dart';
import 'package:likeminds_flutter_sample/packages/expandable_text/expandable_text.dart';
import 'package:likeminds_flutter_sample/chat/utils/branding/theme.dart';
import 'package:likeminds_flutter_sample/chat/utils/chatroom/conversation_utils.dart';
import 'package:likeminds_flutter_sample/chat/utils/imports.dart';
import 'package:likeminds_flutter_sample/chat/utils/local_preference/local_prefs.dart';
import 'package:likeminds_flutter_sample/chat/service/media_service.dart';
import 'package:likeminds_flutter_sample/chat/views/chatroom/bloc/chat_action_bloc/chat_action_bloc.dart';
import 'package:likeminds_flutter_sample/chat/views/chatroom/chatroom_components/Poll/poll_bubble.dart';
import 'package:likeminds_flutter_sample/chat/views/chatroom/chatroom_components/Reaction/reaction_bar.dart';
import 'package:likeminds_flutter_sample/chat/views/chatroom/chatroom_components/Reaction/reaction_bottom_sheet.dart';
import 'package:likeminds_flutter_sample/chat/views/chatroom/helper/reaction_helper.dart';

import 'package:likeminds_flutter_sample/chat/views/media/document/document_preview_factory.dart';
import 'package:likeminds_flutter_sample/chat/views/media/widget/media_helper_widget.dart';
import 'package:likeminds_flutter_sample/chat/widgets/bubble_triangle.dart';
import 'package:likeminds_flutter_sample/chat/widgets/picture_or_initial.dart';
import 'package:likeminds_flutter_sample/chat/widgets/spinner.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:swipe_to_action/swipe_to_action.dart';
import '../../media/media_utils.dart';

class ChatBubble extends StatefulWidget {
  final Conversation conversation;
  final Conversation? replyToConversation;
  final ChatRoom chatroom;
  final User sender;
  final Map<int, User?> userMeta;
  final Map<String, List<Media>> mediaFiles;
  final List<Media>? conversationAttachments;
  final List<Media>? replyConversationAttachments;
  final Function(Conversation replyingTo) onReply;
  final Function(Conversation editConversation) onEdit;
  final Function(Conversation conversation) onLongPress;
  final ValueChanged<bool> isSelected;

  const ChatBubble({
    super.key,
    required this.chatroom,
    required this.conversation,
    this.replyToConversation,
    required this.sender,
    required this.mediaFiles,
    this.conversationAttachments,
    this.replyConversationAttachments,
    required this.onReply,
    required this.onLongPress,
    required this.isSelected,
    required this.userMeta,
    required this.onEdit,
  });

  @override
  State<ChatBubble> createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  late final EmojiParser emojiParser;
  Map<int, User?>? userMeta;
  bool? isSent;
  Conversation? conversation;
  Conversation? replyToConversation;
  Map<String, List<Media>>? mediaFiles;
  List<Media>? conversationAttachments;
  List<Media>? replyConversationAttachments;
  ValueNotifier<bool> rebuildReactionsBar = ValueNotifier(false);
  bool isSelected = false;
  bool isDeleted = false;
  bool isEdited = false;
  final ValueNotifier<bool> _isSelected = ValueNotifier(false);
  final User loggedInUser = UserLocalPreference.instance.fetchUserData();
  Map<String, List<Reaction>> mappedReactions = {};
  final MemberStateResponse isCm =
      UserLocalPreference.instance.fetchMemberRights();
  ChatActionBloc? chatActionBloc;
  Offset? chatBubbleOffset;
  final GlobalKey _chatBubbleKey = GlobalKey();
  CustomPopupMenuController reactionBarController = CustomPopupMenuController();

  @override
  void initState() {
    super.initState();
    emojiParser = EmojiParser();
  }

  @override
  void dispose() {
    _isSelected.dispose();
    super.dispose();
  }

  void setupConversation() {
    isSent = widget.sender.id == loggedInUser.id;
    conversation = widget.conversation;
    replyToConversation = widget.replyToConversation;
    isDeleted = conversation!.deletedByUserId != null;
    isEdited = conversation!.isEdited ?? false;
    mediaFiles = widget.mediaFiles;
    conversationAttachments = widget.conversationAttachments;
    replyConversationAttachments = widget.replyConversationAttachments;
    if (conversation!.conversationReactions != null) {
      mappedReactions =
          convertListToMapReaction(conversation!.conversationReactions!);
    }
  }

  void addReaction(Reaction reaction) {
    if (conversation!.hasReactions == null ||
        conversation!.hasReactions == false ||
        conversation!.conversationReactions == null) {
      conversation!.hasReactions = true;
      conversation!.conversationReactions = [reaction];
      mappedReactions =
          convertListToMapReaction(conversation!.conversationReactions!);
      setState(() {});
    } else {
      int index = conversation!.conversationReactions!
          .indexWhere((element) => element.userId == loggedInUser.id);
      if (index != -1) {
        Reaction? oldReaction = conversation!.conversationReactions![index];
        if (mappedReactions.containsKey(oldReaction.reaction)) {
          mappedReactions[oldReaction.reaction]!.remove(oldReaction);
          if (mappedReactions[oldReaction.reaction]!.isEmpty) {
            mappedReactions.remove(oldReaction.reaction);
          }
        }
        conversation!.conversationReactions!.remove(oldReaction);
      }
      conversation!.conversationReactions!.add(reaction);
      if (mappedReactions.containsKey(reaction.reaction)) {
        mappedReactions[reaction.reaction]?.add(reaction);
      } else {
        mappedReactions[reaction.reaction] = [reaction];
      }
    }
    rebuildReactionsBar.value = !rebuildReactionsBar.value;
  }

  void removeReaction(Reaction reaction) {
    if (conversation!.conversationReactions != null) {
      conversation!.conversationReactions!
          .removeWhere((item) => item.userId == reaction.userId);
      mappedReactions =
          convertListToMapReaction(conversation!.conversationReactions!);
      rebuildReactionsBar.value = !rebuildReactionsBar.value;
      if (conversation!.conversationReactions!.isEmpty) {
        conversation!.hasReactions = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    chatActionBloc = BlocProvider.of<ChatActionBloc>(context);
    setupConversation();
    if (!isSent! &&
        conversation?.hasFiles != null &&
        conversation!.hasFiles! &&
        conversation?.attachmentsUploaded != null &&
        !conversation!.attachmentsUploaded!) {
      return const SizedBox.shrink();
    }
    userMeta = widget.userMeta;
    return BlocListener(
      bloc: chatActionBloc,
      listener: (context, state) {
        if (state is ConversationToolBarState) {
          if (state.selectedConversation.length == 1) {
            if (state.selectedConversation.first.id == conversation!.id) {
              isSelected = true;
              if (state.showReactionBar) {
                if (!reactionBarController.menuIsShowing) {
                  reactionBarController.showMenu();
                }
              } else {
                if (reactionBarController.menuIsShowing) {
                  reactionBarController.hideMenu();
                }
              }
              _isSelected.value = !_isSelected.value;
            } else if (state.selectedConversation.first.id !=
                conversation!.id) {
              if (isSelected == true) {
                isSelected = false;
                _isSelected.value = !_isSelected.value;
              }
              if (reactionBarController.menuIsShowing) {
                reactionBarController.hideMenu();
              }
            }
          } else {}
        }
        if (state is RemoveConversationToolBarState) {
          isSelected = false;
          if (reactionBarController.menuIsShowing) {
            reactionBarController.hideMenu();
          }
          _isSelected.value = !_isSelected.value;
        }
        if (state is PutReactionState &&
            state.putReactionRequest.conversationId == conversation!.id) {
          Reaction addedReaction = Reaction(
            chatroomId: widget.chatroom.id,
            conversationId: conversation!.id,
            reaction: state.putReactionRequest.reaction,
            userId: loggedInUser.id,
          );
          if (!userMeta!.containsKey(loggedInUser.id)) {
            userMeta![loggedInUser.id] = loggedInUser;
          }
          addReaction(addedReaction);
        }
        if (state is PutReactionError &&
            state.putReactionRequest.conversationId == conversation!.id) {
          toast(state.errorMessage);
          Reaction addedReaction = Reaction(
            chatroomId: widget.chatroom.id,
            conversationId: conversation!.id,
            reaction: state.putReactionRequest.reaction,
            userId: loggedInUser.id,
          );
          removeReaction(addedReaction);
        }
        if (state is DeleteReactionState &&
            state.deleteReactionRequest.conversationId == conversation!.id) {
          Reaction deletedReaction = Reaction(
            chatroomId: widget.chatroom.id,
            conversationId: conversation!.id,
            reaction: state.deleteReactionRequest.reaction,
            userId: loggedInUser.id,
          );
          removeReaction(deletedReaction);
        }
        if (state is DeleteReactionError &&
            state.deleteReactionRequest.conversationId == conversation!.id) {
          toast(state.errorMessage);
          Reaction deletedReaction = Reaction(
            chatroomId: widget.chatroom.id,
            conversationId: conversation!.id,
            reaction: state.deleteReactionRequest.reaction,
            userId: loggedInUser.id,
          );
          addReaction(deletedReaction);
        }
      },
      child: Stack(
        children: [
          Column(
            key: _chatBubbleKey,
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment:
                isSent! ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: <Widget>[
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onDoubleTap: () {
                  if (isDeleted) {
                    return;
                  }
                  isSelected = true;
                  _isSelected.value = !_isSelected.value;
                  chatActionBloc!.add(
                    ConversationToolBar(
                      selectedConversation: [conversation!],
                    ),
                  );
                },
                onLongPress: () {
                  if (isDeleted) {
                    return;
                  }
                  isSelected = true;
                  _isSelected.value = !_isSelected.value;
                  // _reactionController.showMenu();
                  chatActionBloc!.add(
                    ConversationToolBar(
                      selectedConversation: [conversation!],
                    ),
                  );
                },
                onTap: () {
                  if (chatActionBloc!.state is ConversationToolBarState) {
                    ConversationToolBarState state =
                        chatActionBloc!.state as ConversationToolBarState;
                    List<Conversation> selectedConversation =
                        state.selectedConversation;
                    if (selectedConversation.contains(conversation!)) {
                      selectedConversation.remove(conversation!);
                      isSelected = false;
                      _isSelected.value = !_isSelected.value;
                    } else {
                      selectedConversation.add(conversation!);
                      isSelected = true;
                      _isSelected.value = !_isSelected.value;
                    }
                    if (selectedConversation.isEmpty) {
                      chatActionBloc!.add(RemoveConversationToolBar());
                    } else {
                      chatActionBloc!.add(ConversationToolBar(
                        selectedConversation: selectedConversation,
                        showReactionBar: selectedConversation.length > 1
                            ? false
                            : state.showReactionBar,
                        showReactionKeyboard: state.showReactionKeyboard,
                      ));
                    }
                  }
                },
                child: ValueListenableBuilder(
                  valueListenable: _isSelected,
                  builder:
                      (BuildContext context, dynamic value, Widget? child) {
                    return Container(
                      color: isSelected
                          ? LMTheme.buttonColor.withOpacity(0.2)
                          : Colors.transparent,
                      child: child,
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Swipeable(
                      dismissThresholds: const {SwipeDirection.startToEnd: 0.2},
                      movementDuration: const Duration(milliseconds: 50),
                      key: ValueKey(conversation!.id),
                      onSwipe: (direction) {
                        chatActionBloc!.add(ReplyConversation(
                            conversationId: conversation!.id,
                            chatroomId: widget.chatroom.id,
                            replyConversation: conversation!));
                      },
                      background: Padding(
                        padding: EdgeInsets.only(
                          left: 2.w,
                          right: 2.w,
                          top: 0.2.h,
                          bottom: 0.2.h,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.reply_outlined,
                              color: LMTheme.buttonColor,
                              size: 18.sp,
                            ),
                          ],
                        ),
                      ),
                      direction: SwipeDirection.startToEnd,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              right: isSent! ? 2.5.w : 0,
                              // vertical: 0.5..h,
                            ),
                            child: Row(
                              mainAxisAlignment: isSent!
                                  ? MainAxisAlignment.end
                                  : MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                !isSent!
                                    ? PictureOrInitial(
                                        fallbackText: widget.sender.name,
                                        imageUrl: widget.sender.imageUrl,
                                        size: 32.sp,
                                        fontSize: 14.sp,
                                      )
                                    : const SizedBox(),
                                const SizedBox(width: 6),
                                !isSent!
                                    ? Transform(
                                        alignment: Alignment.center,
                                        transform: Matrix4.rotationY(3.14),
                                        child: CustomPaint(
                                          painter: BubbleTriangle(),
                                        ),
                                      )
                                    : const SizedBox(),
                                mapStateToBubble(conversation!.state!),
                                isSent!
                                    ? CustomPaint(
                                        painter: BubbleTriangle(),
                                      )
                                    : const SizedBox(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              ValueListenableBuilder(
                  valueListenable: rebuildReactionsBar,
                  builder: (context, _, __) {
                    List<String> keys = mappedReactions.keys.toList();
                    return ((conversation!.hasReactions ?? false) &&
                            (conversation!.conversationReactions != null &&
                                conversation!
                                    .conversationReactions!.isNotEmpty))
                        ? Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            margin: EdgeInsets.only(
                              left: isSent! ? 0 : 32,
                            ),
                            child: GestureDetector(
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  backgroundColor: Colors.transparent,
                                  elevation: 5,
                                  useSafeArea: true,
                                  builder: (context) => ReactionBottomSheet(
                                    mappedReactions: mappedReactions,
                                    userMeta: userMeta,
                                    currentUser: loggedInUser,
                                    chatActionBloc: chatActionBloc!,
                                    conversation: conversation!,
                                  ),
                                );
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  keys.length >= 2
                                      ? Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 3),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(10.0)),
                                          child: Text(
                                              '${keys[1]} ${mappedReactions[keys[1]]!.length}'),
                                        )
                                      : const SizedBox(),
                                  keys.length >= 3
                                      ? Container(
                                          margin:
                                              const EdgeInsets.only(left: 4.0),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 3),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(10.0)),
                                          child: Text(
                                              '${keys[2]} ${mappedReactions[keys[2]]!.length}'),
                                        )
                                      : const SizedBox(),
                                  kHorizontalPaddingSmall,
                                  keys.length > 3
                                      ? Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 3),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(
                                              10.0,
                                            ),
                                          ),
                                          child: const Text('...'),
                                        )
                                      : const SizedBox(),
                                ],
                              ),
                            ),
                          )
                        : const SizedBox();
                  })
            ],
          ),
          IgnorePointer(
            child: SizedBox(
              height: getHeightOfWidget(_chatBubbleKey),
              child: CustomPopupMenu(
                pressType: PressType.longPress,
                controller: reactionBarController,
                enablePassEvent: true,
                verticalMargin: -5,
                arrowColor: kWhiteColor,
                barrierColor: Colors.transparent,
                menuBuilder: () => ReactionBar(
                  chatroom: widget.chatroom,
                  conversation: conversation!,
                  replyToConversation: replyToConversation,
                  loggedinUser: loggedInUser,
                ),
                child: const SizedBox(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container _getReplyConversation() {
    if (replyToConversation == null) {
      return Container();
    }
    return Container(
      color: kGreyColor.withOpacity(0.1),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: 6.h,
            width: 1.w,
            color: LMTheme.buttonColor,
          ),
          kHorizontalPaddingMedium,
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 6),
                Text(
                  replyToConversation?.member?.name ??
                      userMeta?[replyToConversation?.userId]?.name ??
                      '',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: LMTheme.medium.copyWith(
                    color: kPrimaryColor,
                    fontSize: 9.sp,
                  ),
                ),
                kVerticalPaddingXSmall,
                SizedBox(
                  width: 35.w,
                  child: getChatItemAttachmentTile(
                      replyConversationAttachments ?? [], replyToConversation!),
                ),
                const SizedBox(height: 6),
              ],
            ),
          ),
          kHorizontalPaddingMedium,
        ],
      ),
    );
  }

  void refresh() {
    setState(() {});
  }

  Widget mapStateToBubble(int state) {
    if (state == 10) {
      return Container(
          constraints: BoxConstraints(
            minHeight: 4.h,
            minWidth: 10.w,
            maxWidth: 60.w,
          ),
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Column(
            crossAxisAlignment:
                isSent! ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              isDeleted
                  ? conversation!.deletedByUserId == conversation!.userId
                      ? Text(
                          conversation!.userId == loggedInUser.id
                              ? 'You deleted this message'
                              : "This message was deleted",
                          style: LMFonts.instance.regular.copyWith(
                            fontSize: 9.sp,
                            fontStyle: FontStyle.italic,
                          ),
                        )
                      : Text(
                          "This message was deleted by the Community Manager",
                          style: LMFonts.instance.regular.copyWith(
                            fontSize: 9.sp,
                            fontStyle: FontStyle.italic,
                          ),
                        )
                  : PollBubble(
                      pollConversation: conversation!,
                      chatroomId: widget.chatroom.id,
                    ),
              const SizedBox(height: 8),
              ((widget.conversation.hasFiles == null ||
                          !widget.conversation.hasFiles!) ||
                      (widget.conversation.attachmentsUploaded != null &&
                          widget.conversation.attachmentsUploaded!))
                  ? Text(
                      "${isEdited ? 'Edited  ' : ''}${widget.conversation.createdAt}",
                      style: LMFonts.instance.regular.copyWith(
                        fontSize: 8.sp,
                        color: kGreyColor,
                      ),
                    )
                  : Icon(
                      Icons.timer_outlined,
                      size: 8.sp,
                    ),
            ],
          ));
    } else {
      return Container(
        constraints: BoxConstraints(
          minHeight: 4.h,
          minWidth: 10.w,
          maxWidth: 60.w,
        ),
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Column(
          crossAxisAlignment:
              isSent! ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Visibility(
              visible: replyToConversation != null && !isDeleted,
              maintainState: true,
              maintainSize: false,
              child: _getReplyConversation(),
            ),
            replyToConversation != null
                ? const SizedBox(height: 8)
                : const SizedBox(),
            isSent!
                ? const SizedBox()
                : Text(
                    widget.sender.name,
                    style: LMFonts.instance.medium.copyWith(
                      fontSize: 10.sp,
                      color: isSent!
                          ? Colors.black.withOpacity(0.6)
                          : LMTheme.headerColor,
                    ),
                  ),
            isSent! ? const SizedBox() : const SizedBox(height: 6),
            isDeleted
                ? conversation!.deletedByUserId == conversation!.userId
                    ? Text(
                        conversation!.userId == loggedInUser.id
                            ? 'You deleted this message'
                            : "This message was deleted",
                        style: LMFonts.instance.regular.copyWith(
                          fontSize: 9.sp,
                          fontStyle: FontStyle.italic,
                        ),
                      )
                    : Text(
                        "This message was deleted by the Community Manager",
                        style: LMFonts.instance.regular.copyWith(
                          fontSize: 9.sp,
                          fontStyle: FontStyle.italic,
                        ),
                      )
                : replyToConversation != null
                    ? Align(alignment: Alignment.topLeft, child: getContent())
                    : getContent(),
            const SizedBox(height: 8),
            ((widget.conversation.hasFiles == null ||
                        !widget.conversation.hasFiles!) ||
                    (widget.conversation.attachmentsUploaded != null &&
                        widget.conversation.attachmentsUploaded!))
                ? Text(
                    "${isEdited ? 'Edited  ' : ''}${widget.conversation.createdAt}",
                    style: LMFonts.instance.regular.copyWith(
                      fontSize: 8.sp,
                      color: kGreyColor,
                    ),
                  )
                : Icon(
                    Icons.timer_outlined,
                    size: 8.sp,
                  ),
          ],
        ),
      );
    }
  }

  Widget getContent() {
    Widget expandableText = ExpandableText(
      widget.conversation.answer,
      expandText: "see more",
      linkStyle: LMTheme.regular.copyWith(
        color: LMTheme.textLinkColor,
        fontSize: 9.sp,
      ),
      textAlign: TextAlign.left,
      style: LMTheme.regular.copyWith(
        fontSize: 9.sp,
      ),
    );
    // if no media is attached to the conversation
    // return text message
    if (widget.conversation.hasFiles == null ||
        !widget.conversation.hasFiles!) {
      return expandableText;
    } else if (widget.conversation.attachmentsUploaded == null ||
        !widget.conversation.attachmentsUploaded!) {
      // If conversation has media but not uploaded yet
      // show local files
      if (widget.mediaFiles[widget.conversation.temporaryId] == null ||
          widget.mediaFiles[widget.conversation.temporaryId]!.isEmpty) {
        return expandableText;
      }
      Widget mediaWidget;
      if (widget.mediaFiles[widget.conversation.temporaryId]!.first.mediaType ==
              MediaType.photo ||
          widget.mediaFiles[widget.conversation.temporaryId]!.first.mediaType ==
              MediaType.video) {
        mediaWidget = getImageFileMessage(
            context, widget.mediaFiles[widget.conversation.temporaryId]!);
      } else if (widget
              .mediaFiles[widget.conversation.temporaryId]!.first.mediaType ==
          MediaType.document) {
        mediaWidget = documentPreviewFactory(
            widget.mediaFiles[widget.conversation.temporaryId]!);
      } else {
        mediaWidget = const SizedBox();
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              mediaWidget,
              const Positioned(
                top: 0,
                bottom: 0,
                left: 0,
                right: 0,
                child: Spinner(),
              )
            ],
          ),
          widget.conversation.answer.isEmpty
              ? const SizedBox.shrink()
              : kVerticalPaddingXSmall,
          widget.conversation.answer.isEmpty
              ? const SizedBox.shrink()
              : expandableText,
        ],
      );
    } else if (widget.conversation.attachmentsUploaded != null ||
        widget.conversation.attachmentsUploaded!) {
      // If conversation has media and uploaded
      // show uploaded files
      if (conversationAttachments == null) {
        return expandableText;
      }

      Widget mediaWidget;
      if (conversationAttachments!.first.mediaType == MediaType.photo ||
          conversationAttachments!.first.mediaType == MediaType.video) {
        mediaWidget = getImageMessage(
          context,
          conversationAttachments!,
          widget.chatroom,
          conversation!,
          userMeta!,
        );
      } else if (conversationAttachments!.first.mediaType ==
          MediaType.document) {
        mediaWidget = documentPreviewFactory(conversationAttachments!);
      } else {
        mediaWidget = const SizedBox();
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          mediaWidget,
          conversation!.answer.isEmpty
              ? const SizedBox.shrink()
              : kVerticalPaddingXSmall,
          conversation!.answer.isEmpty
              ? const SizedBox.shrink()
              : expandableText,
        ],
      );
    }
    return const SizedBox();
  }
}

/// Code or conversation actions
