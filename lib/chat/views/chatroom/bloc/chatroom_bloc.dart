import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:likeminds_chat_fl/likeminds_chat_fl.dart';

import 'package:likeminds_flutter_sample/chat/service/likeminds_service.dart';
import 'package:likeminds_flutter_sample/chat/service/service_locator.dart';

part 'chatroom_event.dart';
part 'chatroom_state.dart';

class ChatroomBloc extends Bloc<ChatroomEvent, ChatroomState> {
  ChatroomBloc() : super(ChatroomInitial()) {
    on<ChatroomEvent>((event, emit) async {
      if (event is InitChatroomEvent) {
        emit(ChatroomLoading());
        LMResponse<GetChatroomResponse> getChatroomResponse =
            await locator<LikeMindsService>()
                .getChatroom(event.chatroomRequest);
        emit(ChatroomLoaded(
          getChatroomResponse: getChatroomResponse.data!,
        ));
      }
    });
  }
}
