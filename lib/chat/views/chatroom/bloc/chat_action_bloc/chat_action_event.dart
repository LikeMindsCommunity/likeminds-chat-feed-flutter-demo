part of 'chat_action_bloc.dart';

abstract class ChatActionEvent extends Equatable {}

class PostConversation extends ChatActionEvent {
  final PostConversationRequest postConversationRequest;
  final Conversation? replyConversation;

  PostConversation(this.postConversationRequest, {this.replyConversation});

  @override
  List<Object> get props => [
        postConversationRequest,
      ];
}

class EditConversation extends ChatActionEvent {
  final EditConversationRequest editConversationRequest;
  final Conversation? replyConversation;

  EditConversation(this.editConversationRequest, {this.replyConversation});

  @override
  List<Object> get props => [
        editConversationRequest,
      ];
}

class EditingConversation extends ChatActionEvent {
  final int conversationId;
  final int chatroomId;
  final Conversation editConversation;

  EditingConversation({
    required this.conversationId,
    required this.chatroomId,
    required this.editConversation,
  });

  @override
  List<Object> get props => [
        conversationId,
        chatroomId,
        editConversation,
      ];
}

class EditRemove extends ChatActionEvent {
  @override
  List<Object> get props => [];
}

class DeleteConversation extends ChatActionEvent {
  final DeleteConversationRequest deleteConversationRequest;

  DeleteConversation(this.deleteConversationRequest);

  @override
  List<Object> get props => [
        deleteConversationRequest,
      ];
}

class PostMultiMediaConversation extends ChatActionEvent {
  final PostConversationRequest postConversationRequest;
  final List<Media> mediaFiles;

  PostMultiMediaConversation(
    this.postConversationRequest,
    this.mediaFiles,
  );

  @override
  List<Object> get props => [
        postConversationRequest,
        mediaFiles,
      ];
}

class NewConversation extends ChatActionEvent {
  final int chatroomId;
  final int conversationId;

  NewConversation({
    required this.chatroomId,
    required this.conversationId,
  });

  @override
  List<Object> get props => [
        chatroomId,
        conversationId,
      ];
}

class UpdateConversationList extends ChatActionEvent {
  final int conversationId;
  final int chatroomId;

  UpdateConversationList({
    required this.conversationId,
    required this.chatroomId,
  });

  @override
  List<Object> get props => [
        conversationId,
        chatroomId,
      ];
}

class UpdatePollConversation extends ChatActionEvent {
  final int conversationId;
  final int chatroomId;

  UpdatePollConversation({
    required this.conversationId,
    required this.chatroomId,
  });

  @override
  List<Object> get props => [
        conversationId,
        chatroomId,
      ];
}

class PutReaction extends ChatActionEvent {
  final PutReactionRequest putReactionRequest;

  PutReaction({required this.putReactionRequest});

  @override
  List<Object> get props => [
        putReactionRequest.toJson(),
      ];
}

class DeleteReaction extends ChatActionEvent {
  final DeleteReactionRequest deleteReactionRequest;

  DeleteReaction({required this.deleteReactionRequest});

  @override
  List<Object> get props => [
        deleteReactionRequest.toJson(),
      ];
}

class ReplyConversation extends ChatActionEvent {
  final int conversationId;
  final int chatroomId;
  final Conversation replyConversation;

  ReplyConversation({
    required this.conversationId,
    required this.chatroomId,
    required this.replyConversation,
  });

  @override
  List<Object> get props => [
        conversationId,
        chatroomId,
        replyConversation,
      ];
}

class ReplyRemove extends ChatActionEvent {
  final String stateTime = DateTime.now().toString();
  @override
  List<Object> get props => [stateTime];
}

class ConversationToolBar extends ChatActionEvent {
  final List<Conversation> selectedConversation;
  final bool showReactionKeyboard;
  final bool showReactionBar;
  final String eventTime = DateTime.now().toString();

  ConversationToolBar({
    required this.selectedConversation,
    this.showReactionBar = true,
    this.showReactionKeyboard = false,
  });

  @override
  List<Object> get props =>
      [selectedConversation, showReactionKeyboard, eventTime];
}

class RemoveConversationToolBar extends ChatActionEvent {
  // To remove the conversation tool bar from the chatroom
  final String timeChecker = DateTime.now().toString();
  @override
  List<Object> get props => [timeChecker];
}

class PostPollConversation extends ChatActionEvent {
  final PostPollConversationRequest postPollConversationRequest;

  PostPollConversation(this.postPollConversationRequest);
  @override
  List<Object> get props => [postPollConversationRequest];
}
