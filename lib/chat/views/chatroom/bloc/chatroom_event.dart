part of 'chatroom_bloc.dart';

@immutable
abstract class ChatroomEvent extends Equatable {}

class InitChatroomEvent extends ChatroomEvent {
  final GetChatroomRequest chatroomRequest;

  InitChatroomEvent(this.chatroomRequest);

  @override
  List<Object> get props => [
        chatroomRequest,
      ];
}

class ChatroomDetailsEvent extends ChatroomEvent {
  @override
  List<Object> get props => [];
}

class ReloadChatroomEvent extends ChatroomEvent {
  @override
  List<Object> get props => [];
}
