part of 'chatroom_bloc.dart';

@immutable
abstract class ChatroomState extends Equatable {}

class ChatroomInitial extends ChatroomState {
  @override
  List<Object> get props => [];
}

class ChatroomLoading extends ChatroomState {
  @override
  List<Object> get props => [];
}

class ChatroomLoaded extends ChatroomState {
  final GetChatroomResponse getChatroomResponse;

  ChatroomLoaded({required this.getChatroomResponse});

  @override
  List<Object> get props => [getChatroomResponse];
}

class ChatroomError extends ChatroomState {
  final String message;

  ChatroomError(this.message);

  @override
  List<Object> get props => [message];
}

class ChatroomReport extends ChatroomState {
  final String message;

  ChatroomReport(this.message);

  @override
  List<Object> get props => [message];
}
