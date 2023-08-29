import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:likeminds_chat_fl/likeminds_chat_fl.dart';
import 'package:likeminds_flutter_sample/chat/service/likeminds_service.dart';
import 'package:likeminds_flutter_sample/chat/service/service_locator.dart';
import 'package:likeminds_flutter_sample/chat/views/explore/models/space_model.dart';

part 'explore_event.dart';
part 'explore_state.dart';

class ExploreBloc extends Bloc<ExploreEvent, ExploreState> {
  ExploreBloc() : super(ExploreInitial()) {
    on<ExploreEvent>((event, emit) async {
      if (event is InitExploreEvent) {
        emit(ExploreLoading());
      } else if (event is GetExplore) {
        emit(ExploreLoading());
        LMResponse response = await locator<LikeMindsService>()
            .getExploreFeed(event.getExploreFeedRequest);
        if (response.success) {
          GetExploreFeedResponse getExploreFeedResponse =
              response.data as GetExploreFeedResponse;
          if (getExploreFeedResponse.success) {
            emit(ExploreLoaded(getExploreFeedResponse));
          } else {
            emit(ExploreError(getExploreFeedResponse.errorMessage!));
          }
        } else {
          emit(ExploreError(response.errorMessage!));
        }
      } else if (event is PinSpaceEvent) {
        emit(ExploreLoading());
      }
    });
  }

  List<SpaceModel> getData() {
    List<SpaceModel> spaces = [];

    for (int i = 0; i < 10; i++) {
      spaces.add(SpaceModel(
        name: 'MM Space $i',
        description:
            'Description $i Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
        imageUrl: 'https://picsum.photos/400/400',
        id: '$i',
        isPinned: false,
        members: (i * 5),
        messages: i * 5,
      ));
    }

    return spaces;
  }
}
