part of 'chat_action_bloc.dart';

abstract class ChatActionEvent extends Equatable {}

/* 
* This event is used to post a conversation
* It takes a PostConversationRequest as a parameter
* and an optional Conversation object to reply to
*/
class PostConversation extends ChatActionEvent {
  final PostConversationRequest postConversationRequest;
  final Conversation? replyConversation;

  PostConversation(this.postConversationRequest, {this.replyConversation});

  @override
  List<Object> get props => [
        postConversationRequest,
      ];
}

/*
* This event is used to edit a conversation
* It takes a EditConversationRequest as a parameter
* and an optional Conversation object to reply to
*/
class EditConversation extends ChatActionEvent {
  final EditConversationRequest editConversationRequest;
  final Conversation? replyConversation;

  EditConversation(this.editConversationRequest, {this.replyConversation});

  @override
  List<Object> get props => [
        editConversationRequest,
      ];
}

/*
* This event is used to notifiy the bloc that the user is 
* currently editing a conversation
*/
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

/*
* This event is used to notifiy the bloc that the user 
* is no longer editing a conversation
*/
class EditRemove extends ChatActionEvent {
  @override
  List<Object> get props => [];
}

/*
* This event is used to delete a conversation
* It takes a DeleteConversationRequest as a parameter
*/
class DeleteConversation extends ChatActionEvent {
  final DeleteConversationRequest deleteConversationRequest;

  DeleteConversation(this.deleteConversationRequest);

  @override
  List<Object> get props => [
        deleteConversationRequest,
      ];
}

/*
* This event is used to post a multi-media conversation
* It takes a PostConversationRequest as a parameter
* and a list of Media objects
*/
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

// This event initiales realtime conversation in Chat Action Bloc
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

// This event notifies the bloc to update the conversation list
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

/* 
* This event notifies the bloc to update the poll conversation
* It takes a UpdatePollConversation as a parameter
*/
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
