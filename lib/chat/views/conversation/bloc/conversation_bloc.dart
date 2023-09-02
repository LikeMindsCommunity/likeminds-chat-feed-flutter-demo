import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:likeminds_chat_fl/likeminds_chat_fl.dart';
import 'package:likeminds_flutter_sample/chat/service/likeminds_service.dart';
import 'package:likeminds_flutter_sample/chat/service/service_locator.dart';

part 'conversation_event.dart';
part 'conversation_state.dart';

class ConversationBloc extends Bloc<ConversationEvent, ConversationState> {
  ConversationBloc() : super(ConversationInitial()) {
    on<ConversationEvent>((event, emit) async {
      if (event is GetConversation) {
        if (event.getConversationRequest.page > 1) {
          emit(ConversationPaginationLoading());
        } else {
          emit(ConversationLoading());
        } //Perform logic
        LMResponse response = await locator<LikeMindsService>()
            .getConversation(event.getConversationRequest);
        if (response.success) {
          GetConversationResponse conversationResponse = response.data;
          conversationResponse.conversationData!.forEach((element) {
            element.member = conversationResponse
                .userMeta?[element.userId ?? element.memberId];
          });
          conversationResponse.conversationData!.forEach((element) {
            String? replyId = element.replyId == null
                ? element.replyConversation?.toString()
                : element.replyId.toString();
            element.replyConversationObject =
                conversationResponse.conversationMeta?[replyId];
            element.replyConversationObject?.member =
                conversationResponse.userMeta?[
                    element.replyConversationObject?.userId ??
                        element.replyConversationObject?.memberId];
          });
          emit(
            ConversationLoaded(conversationResponse),
          );
        } else {
          emit(
            ConversationError(response.errorMessage!),
          );
        }
      }
      if (event is MarkReadChatroomEvent) {
        // ignore: unused_local_variable
        LMResponse response = await locator<LikeMindsService>()
            .markReadChatroom((MarkReadChatroomRequestBuilder()
                  ..chatroomId(event.chatroomId))
                .build());
      }
    });
  }
}
