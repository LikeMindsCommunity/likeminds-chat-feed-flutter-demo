part of 'conversation_bloc.dart';

abstract class ConversationEvent extends Equatable {}

class GetConversation extends ConversationEvent {
  final GetConversationRequest getConversationRequest;

  GetConversation({
    required this.getConversationRequest,
  });

  @override
  List<Object> get props => [];
}

class ChatroomDetailsEvent extends ConversationEvent {
  @override
  List<Object> get props => [];
}

class ReloadChatroomEvent extends ConversationEvent {
  @override
  List<Object> get props => [];
}

class MarkReadChatroomEvent extends ConversationEvent {
  final int chatroomId;

  MarkReadChatroomEvent({required this.chatroomId});

  @override
  List<Object> get props => [chatroomId];
}

class UpdateChatroomEvent extends ConversationEvent {
  final int id;

  UpdateChatroomEvent({required this.id});

  @override
  List<Object> get props => [
        id,
      ];
}
