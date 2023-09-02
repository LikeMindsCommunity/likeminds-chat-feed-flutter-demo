part of 'explore_bloc.dart';

abstract class ExploreEvent extends Equatable {}

class InitExploreEvent extends ExploreEvent {
  @override
  List<Object> get props => [];
}

class GetExplore extends ExploreEvent {
  final GetExploreFeedRequest getExploreFeedRequest;

  GetExplore({required this.getExploreFeedRequest});

  @override
  List<Object> get props => [getExploreFeedRequest.toJson()];
}

class RefreshExploreEvent extends ExploreEvent {
  @override
  List<Object> get props => [];
}

class PinSpaceEvent extends ExploreEvent {
  final String spaceId;
  final bool isPinned;

  PinSpaceEvent(this.spaceId, this.isPinned);

  @override
  List<Object> get props => [spaceId, isPinned];
}
