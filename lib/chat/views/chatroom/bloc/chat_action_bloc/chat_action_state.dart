part of 'chat_action_bloc.dart';

abstract class ChatActionState extends Equatable {}

class ConversationInitial extends ChatActionState {
  @override
  List<Object> get props => [];
}

class ChatActionError extends ChatActionState {
  final String temporaryId;
  final String errorMessage;

  ChatActionError(this.errorMessage, this.temporaryId);

  @override
  List<Object> get props => [
        temporaryId,
        errorMessage,
      ];
}

class LocalConversation extends ChatActionState {
  final Conversation conversation;

  LocalConversation(this.conversation);

  @override
  List<Object> get props => [
        conversation,
      ];
}

class ConversationPosted extends ChatActionState {
  final PostConversationResponse postConversationResponse;

  ConversationPosted(
    this.postConversationResponse,
  );

  @override
  List<Object> get props => [
        postConversationResponse,
      ];
}

// Used to update conversation with the latest data
class UpdateConversation extends ChatActionState {
  final Conversation response;

  UpdateConversation({
    required this.response,
  });

  @override
  List<Object> get props => [
        response,
      ];
}

// Used to update poll with the latest data
class UpdatedPollConversation extends ChatActionState {
  final Conversation response;

  UpdatedPollConversation({
    required this.response,
  });

  @override
  List<Object> get props => [
        response,
      ];
}

// Updates a conversation with the latest data
class ConversationEdited extends ChatActionState {
  final EditConversationResponse editConversationResponse;

  ConversationEdited(
    this.editConversationResponse,
  );

  @override
  List<Object> get props => [
        editConversationResponse,
      ];
}

// Deletes a conversation from the conversation list
class ConversationDelete extends ChatActionState {
  final DeleteConversationResponse deleteConversationResponse;

  ConversationDelete(
    this.deleteConversationResponse,
  );

  @override
  List<Object> get props => [
        deleteConversationResponse,
      ];
}

// Notifies the UI about error while deleting a conversation
class ConversationDeleteError extends ChatActionState {
  final String errorMessage;

  ConversationDeleteError(this.errorMessage);

  @override
  List<Object> get props => [
        errorMessage,
      ];
}

class MultiMediaConversationLoading extends ChatActionState {
  final Conversation postConversation;
  final List<Media> mediaFiles;

  MultiMediaConversationLoading(
    this.postConversation,
    this.mediaFiles,
  );

  @override
  List<Object> get props => [
        mediaFiles,
      ];
}

class MultiMediaConversationPosted extends ChatActionState {
  final PostConversationResponse postConversationResponse;
  final List<Media> putMediaResponse;

  MultiMediaConversationPosted(
    this.postConversationResponse,
    this.putMediaResponse,
  );

  @override
  List<Object> get props => [
        postConversationResponse,
        putMediaResponse,
      ];
}

class MultiMediaConversationError extends ChatActionState {
  final String errorMessage;
  final String temporaryId;

  MultiMediaConversationError(
    this.errorMessage,
    this.temporaryId,
  );

  @override
  List<Object> get props => [
        errorMessage,
        temporaryId,
      ];
}

class ReplyConversationState extends ChatActionState {
  final int chatroomId;
  final int conversationId;
  final Conversation conversation;

  ReplyConversationState({
    required this.chatroomId,
    required this.conversationId,
    required this.conversation,
  });

  @override
  List<Object> get props => [
        chatroomId,
        conversationId,
      ];
}

class ReplyRemoveState extends ChatActionState {
  final String stateTime = DateTime.now().toString();
  @override
  List<Object> get props => [stateTime];
}

class EditConversationState extends ChatActionState {
  final int chatroomId;
  final int conversationId;
  final Conversation editConversation;

  EditConversationState({
    required this.chatroomId,
    required this.conversationId,
    required this.editConversation,
  });

  @override
  List<Object> get props => [
        chatroomId,
        conversationId,
        editConversation.toEntity().toJson(),
      ];
}

class EditRemoveState extends ChatActionState {
  final String stateTime = DateTime.now().toString();
  @override
  List<Object> get props => [stateTime];
}

class ConversationToolBarState extends ChatActionState {
  final List<Conversation> selectedConversation;
  final Conversation? replyConversation;
  final bool showReactionKeyboard;
  final bool showReactionBar;
  final String stateTime = DateTime.now().toString();

  ConversationToolBarState(
      {required this.selectedConversation,
      this.replyConversation,
      this.showReactionBar = true,
      required this.showReactionKeyboard});

  @override
  List<Object> get props =>
      [selectedConversation, showReactionKeyboard, stateTime];
}

class PutReactionState extends ChatActionState {
  final PutReactionRequest putReactionRequest;

  PutReactionState(this.putReactionRequest);

  @override
  List<Object> get props => [putReactionRequest.toJson()];
}

class PutReactionError extends ChatActionState {
  final String errorMessage;
  final PutReactionRequest putReactionRequest;

  PutReactionError(this.errorMessage, this.putReactionRequest);

  @override
  List<Object> get props => [errorMessage, putReactionRequest.toJson()];
}

class DeleteReactionState extends ChatActionState {
  final DeleteReactionRequest deleteReactionRequest;

  DeleteReactionState(this.deleteReactionRequest);

  @override
  List<Object> get props => [deleteReactionRequest.toJson()];
}

class DeleteReactionError extends ChatActionState {
  final String errorMessage;
  final DeleteReactionRequest deleteReactionRequest;

  DeleteReactionError(this.errorMessage, this.deleteReactionRequest);

  @override
  List<Object> get props => [errorMessage, deleteReactionRequest.toJson()];
}

class RemoveConversationToolBarState extends ChatActionState {
  final String stateTime = DateTime.now().toString();
  @override
  List<Object> get props => [stateTime];
}
