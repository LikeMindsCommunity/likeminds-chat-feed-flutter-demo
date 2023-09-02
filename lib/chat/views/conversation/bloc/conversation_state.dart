part of 'conversation_bloc.dart';

abstract class ConversationState extends Equatable {}

class ConversationInitial extends ConversationState {
  @override
  List<Object> get props => [];
}

class ConversationLoading extends ConversationState {
  @override
  List<Object> get props => [];
}

class ConversationPaginationLoading extends ConversationState {
  @override
  List<Object> get props => [];
}

class ConversationLoaded extends ConversationState {
  final GetConversationResponse getConversationResponse;

  ConversationLoaded(this.getConversationResponse);

  @override
  List<Object> get props => [getConversationResponse];
}

class ConversationError extends ConversationState {
  final String message;

  ConversationError(this.message);

  @override
  List<Object> get props => [message];
}

class ChatroomUpdated extends ConversationState {
  @override
  List<Object> get props => [];
}
