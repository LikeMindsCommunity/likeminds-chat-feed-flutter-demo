import 'package:equatable/equatable.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:likeminds_chat_fl/likeminds_chat_fl.dart';
import 'package:likeminds_flutter_sample/chat/service/likeminds_service.dart';
import 'package:likeminds_flutter_sample/chat/service/service_locator.dart';
import 'package:likeminds_flutter_sample/chat/utils/realtime/realtime.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    final DatabaseReference realTime = LMRealtime.instance.homeFeed();
    realTime.onValue.listen((event) {
      debugPrint(event.toString());
      add(UpdateHomeEvent());
    });
    on<HomeEvent>(
      (event, emit) async {
        if (event is InitHomeEvent) {
          emit(HomeLoading());

          final response = await locator<LikeMindsService>()
              .getHomeFeed((GetHomeFeedRequestBuilder()
                    ..page(event.page)
                    ..pageSize(50))
                  .build());
          if (response.success) {
            response.data?.conversationMeta?.forEach((key, value) {
              String? userId = value.userId == null
                  ? value.memberId?.toString()
                  : value.userId.toString();
              final user = response.data?.userMeta?[userId];
              value.member = user;
            });

            emit(HomeLoaded(response: response.data!));
          } else {
            HomeError(response.errorMessage!);
          }
        }
        if (event is UpdateHomeEvent) {
          final response = await locator<LikeMindsService>()
              .getHomeFeed((GetHomeFeedRequestBuilder()
                    ..page(1)
                    ..pageSize(50))
                  .build());
          if (response.success) {
            emit(UpdatedHomeFeed());
            response.data?.conversationMeta?.forEach((key, value) {
              String? userId = value.userId == null
                  ? value.memberId?.toString()
                  : value.userId.toString();
              final user = response.data?.userMeta?[userId];
              value.member = user;
            });
            emit(UpdateHomeFeed(response: response.data!));
          } else {
            emit(HomeError(response.errorMessage ?? "An error occured"));
          }
        }
      },
    );
  }
}
