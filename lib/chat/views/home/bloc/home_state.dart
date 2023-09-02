part of 'home_bloc.dart';

@immutable
abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class RefreshHomeState extends HomeState {}

class HomeLoaded extends HomeState {
  int page;
  // final List<ChatItem> chats;
  final GetHomeFeedResponse response;

  HomeLoaded({required this.response, required this.page});
}

class UpdateHomeFeed extends HomeState {
  final GetHomeFeedResponse response;

  UpdateHomeFeed({required this.response});
}

class UpdatedHomeFeed extends HomeState {}

class RealTimeUpdate extends HomeState {
  final int chatroomId;
  final int conversationId;

  RealTimeUpdate({required this.chatroomId, required this.conversationId});
}

class HomeError extends HomeState {
  final String message;

  HomeError(this.message);
}
