part of 'home_bloc.dart';

@immutable
abstract class HomeEvent extends Equatable {}

class InitHomeEvent extends HomeEvent {
  final int page;

  InitHomeEvent({required this.page});

  @override
  List<Object?> get props => [page];
}

class GetHomeFeedPage extends HomeEvent {
  @override
  List<Object?> get props => [];
}

class RefreshHomePage extends HomeEvent {
  @override
  List<Object?> get props => [];
}

class ReloadHomeEvent extends HomeEvent {
  final GetHomeFeedResponse response;

  ReloadHomeEvent({required this.response});
  @override
  List<Object?> get props => [response];
}

class UpdateHomeEvent extends HomeEvent {
  UpdateHomeEvent();
  @override
  List<Object?> get props => [];
}
