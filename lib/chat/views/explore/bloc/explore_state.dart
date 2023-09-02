part of 'explore_bloc.dart';

abstract class ExploreState {}

class ExploreInitial extends ExploreState {}

class ExploreLoading extends ExploreState {}

class ExploreError extends ExploreState {
  final String errorMessage;

  ExploreError(this.errorMessage);
}

class ExploreLoaded extends ExploreState {
  final GetExploreFeedResponse getExploreFeedResponse;

  ExploreLoaded(this.getExploreFeedResponse);
}
