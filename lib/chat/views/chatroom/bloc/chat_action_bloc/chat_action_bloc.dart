import 'package:firebase_database/firebase_database.dart';
import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:likeminds_chat_fl/likeminds_chat_fl.dart';
import 'package:likeminds_flutter_sample/chat/likeminds_chat_mm_fl.dart';
import 'package:likeminds_flutter_sample/chat/service/likeminds_service.dart';
import 'package:likeminds_flutter_sample/chat/service/service_locator.dart';
import 'package:likeminds_flutter_sample/chat/utils/local_preference/local_prefs.dart';
import 'package:likeminds_flutter_sample/chat/utils/realtime/realtime.dart';
import 'package:likeminds_flutter_sample/chat/service/media_service.dart';
import 'package:likeminds_flutter_sample/chat/views/chatroom/chatroom_components/Poll/constants/string_constant.dart';
import 'package:likeminds_flutter_sample/chat/views/media/widget/media_helper_widget.dart';

part 'chat_action_event.dart';
part 'chat_action_state.dart';

class ChatActionBloc extends Bloc<ChatActionEvent, ChatActionState> {
  MediaService mediaService = MediaService(!isDebug);
  final DatabaseReference realTime = LMRealtime.instance.chatroom();
  int? lastConversationId;

  ChatActionBloc() : super(ConversationInitial()) {
    on<NewConversation>(
      (event, emit) {
        int chatroomId = event.chatroomId;
        lastConversationId = event.conversationId;

        realTime.onValue.listen(
          (event) {
            if (event.snapshot.value != null) {
              final response = event.snapshot.value as Map;
              final conversationId =
                  int.parse(response["collabcard"]["answer_id"]);
              if (lastConversationId != null &&
                  conversationId != lastConversationId) {
                add(UpdateConversationList(
                  chatroomId: chatroomId,
                  conversationId: conversationId,
                ));
              }
            }
          },
        );
      },
    );
    on<PostPollConversation>((event, emit) async {
      try {
        User user = UserLocalPreference.instance.fetchUserData();
        DateTime currentDate = DateTime.now();
        Conversation conversation = Conversation(
          answer: event.postPollConversationRequest.text,
          allowAddOption: event.postPollConversationRequest.allowAddOption,
          expiryTime: event.postPollConversationRequest.expiryTime,
          isAnonymous: event.postPollConversationRequest.isAnonymous,
          multipleSelectState:
              event.postPollConversationRequest.multipleSelectNo,
          pollAnswerText: event.postPollConversationRequest.text,
          pollType: event.postPollConversationRequest.pollType,
          pollTypeText: "",
          submitTypeText: "",
          chatroomId: event.postPollConversationRequest.chatroomId,
          createdAt: "",
          header: "",
          date: "${currentDate.day} ${currentDate.month} ${currentDate.year}",
          attachmentCount: 0,
          hasFiles: false,
          member: user,
          state: 10,
          temporaryId: event.postPollConversationRequest.temporaryId,
          poll: PollInfoData(
            allowAddOption: event.postPollConversationRequest.allowAddOption,
            expiryTime: event.postPollConversationRequest.expiryTime,
            isAnonymous: event.postPollConversationRequest.isAnonymous,
            isPollSubmitted: false,
            multipleSelectNum:
                event.postPollConversationRequest.multipleSelectNo,
            multipleSelectState:
                event.postPollConversationRequest.multipleSelectNo,
            pollAnswerText: "Be the first to vote",
            pollType: event.postPollConversationRequest.pollType,
            pollTypeText: event.postPollConversationRequest.pollType == 0
                ? PollBubbleStringConstants.instantPoll
                : PollBubbleStringConstants.deferredPoll,
            submitTypeText: event.postPollConversationRequest.isAnonymous
                ? PollBubbleStringConstants.isAnonymousPoll
                : PollBubbleStringConstants.isNotAnonymousPoll,
            toShowResult: false,
            pollViewDataList: event.postPollConversationRequest.polls
                .map(
                  (e) => PollViewData(
                    text: e.text,
                    isSelected: false,
                    chatroomId: event.postPollConversationRequest.chatroomId,
                    count: 0,
                    noVotes: 0,
                    percentage: 0,
                  ),
                )
                .toList(),
          ),
          id: 1,
        );
        emit(LocalConversation(conversation));
        LMResponse response = await locator<LikeMindsService>()
            .postPollConversation(event.postPollConversationRequest);

        if (response.success) {
          if (response.data!.success) {
            emit(ConversationPosted(response.data!));
          } else {
            emit(
              ChatActionError(
                response.data!.errorMessage!,
                event.postPollConversationRequest.temporaryId,
              ),
            );
          }
        } else {
          emit(
            ChatActionError(
              response.errorMessage!,
              event.postPollConversationRequest.temporaryId,
            ),
          );
        }
      } catch (e) {
        emit(
          ChatActionError(
            "An error occurred",
            event.postPollConversationRequest.temporaryId,
          ),
        );
      }
    });
    on<UpdatePollConversation>((event, emit) async {
      int maxTimestamp = DateTime.now().millisecondsSinceEpoch;

      final response = await locator<LikeMindsService>()
          .getConversation((GetConversationRequestBuilder()
                ..chatroomId(event.chatroomId)
                ..minTimestamp(0)
                ..maxTimestamp(maxTimestamp * 1000)
                ..isLocalDB(false)
                ..page(1)
                ..pageSize(200)
                ..conversationId(event.conversationId))
              .build());
      if (response.success) {
        Conversation realTimeConversation =
            response.data!.conversationData!.first;
        if (response.data!.conversationMeta != null &&
            realTimeConversation.replyId != null) {
          Conversation? replyConversationObject = response
              .data!.conversationMeta![realTimeConversation.replyId.toString()];
          realTimeConversation.replyConversationObject =
              replyConversationObject;
        }
        emit(
          UpdatedPollConversation(
            response: realTimeConversation,
          ),
        );
      }
    });
    on<UpdateConversationList>(
      (event, emit) async {
        if (lastConversationId != null &&
            event.conversationId != lastConversationId) {
          int maxTimestamp = DateTime.now().millisecondsSinceEpoch;
          final response = await locator<LikeMindsService>()
              .getConversation((GetConversationRequestBuilder()
                    ..chatroomId(event.chatroomId)
                    ..minTimestamp(0)
                    ..maxTimestamp(maxTimestamp * 1000)
                    ..isLocalDB(false)
                    ..page(1)
                    ..pageSize(200)
                    ..conversationId(event.conversationId))
                  .build());
          if (response.success) {
            Conversation realTimeConversation =
                response.data!.conversationData!.first;
            if (response.data!.conversationMeta != null &&
                realTimeConversation.replyId != null) {
              Conversation? replyConversationObject = response.data!
                  .conversationMeta![realTimeConversation.replyId.toString()];
              realTimeConversation.replyConversationObject =
                  replyConversationObject;
            }
            emit(
              UpdateConversation(
                response: realTimeConversation,
              ),
            );

            lastConversationId = event.conversationId;
          }
        }
      },
    );
    on<PostConversation>((event, emit) async {
      await mapPostConversationFunction(
        event,
        emit,
      );
    });
    on<PostMultiMediaConversation>(
      (event, emit) async {
        await mapPostMultiMediaConversation(
          event,
          emit,
        );
      },
    );
    on<EditConversation>(
      (event, emit) async {
        await mapEditConversation(
          event,
          emit,
        );
      },
    );
    on<EditingConversation>(
      (event, emit) async {
        emit(RemoveConversationToolBarState());
        emit(EditConversationState(
          chatroomId: event.chatroomId,
          conversationId: event.conversationId,
          editConversation: event.editConversation,
        ));
      },
    );
    on<EditRemove>(
      (event, emit) {
        emit(EditRemoveState());
        emit(RemoveConversationToolBarState());
      },
    );
    on<ReplyConversation>(
      (event, emit) async {
        emit(RemoveConversationToolBarState());
        emit(
          ReplyConversationState(
            chatroomId: event.chatroomId,
            conversationId: event.conversationId,
            conversation: event.replyConversation,
          ),
        );
      },
    );
    on<ReplyRemove>(
      (event, emit) {
        emit(ReplyRemoveState());
        emit(RemoveConversationToolBarState());
      },
    );
    on<DeleteConversation>(
      (event, emit) async {
        emit(RemoveConversationToolBarState());
        final response = await locator<LikeMindsService>()
            .deleteConversation((DeleteConversationRequestBuilder()
                  ..conversationIds(
                      event.deleteConversationRequest.conversationIds)
                  ..reason("Delete"))
                .build());
        if (response.success) {
          emit(ConversationDelete(response.data!));
        } else {
          emit(ConversationDeleteError(
              response.errorMessage ?? 'An error occured'));
        }
      },
    );
    on<ConversationToolBar>(
      (event, emit) {
        emit(ConversationToolBarState(
          selectedConversation: event.selectedConversation,
          showReactionBar: event.showReactionBar,
          showReactionKeyboard: event.showReactionKeyboard,
        ));
      },
    );
    on<RemoveConversationToolBar>(
        (event, emit) => emit(RemoveConversationToolBarState()));
    on<PutReaction>(
      (event, emit) async {
        emit(RemoveConversationToolBarState());
        emit(PutReactionState(event.putReactionRequest));
        LMResponse response = await locator<LikeMindsService>()
            .putReaction(event.putReactionRequest);
        if (!response.success) {
          emit(PutReactionError(
            response.errorMessage ?? 'An error occured',
            event.putReactionRequest,
          ));
        }
      },
    );
    on<DeleteReaction>(
      (event, emit) async {
        emit(RemoveConversationToolBarState());
        emit(DeleteReactionState(event.deleteReactionRequest));
        LMResponse response = await locator<LikeMindsService>()
            .deleteReaction(event.deleteReactionRequest);
        if (!response.success) {
          emit(DeleteReactionError(
            response.errorMessage ?? 'An error occured',
            event.deleteReactionRequest,
          ));
        }
      },
    );
  }

  mapEditConversation(
      EditConversation event, Emitter<ChatActionState> emit) async {
    emit(EditRemoveState());
    try {
      LMResponse<EditConversationResponse> response =
          await locator<LikeMindsService>().editConversation(
        event.editConversationRequest,
      );

      if (response.success) {
        if (response.data!.success) {
          Conversation conversation = response.data!.conversation!;
          if (conversation.replyId != null ||
              conversation.replyConversation != null) {
            conversation.replyConversationObject = event.replyConversation;
          }
          emit(
            ConversationEdited(response.data!),
          );
        } else {
          emit(
            ChatActionError(
              response.data!.errorMessage!,
              event.editConversationRequest.conversationId.toString(),
            ),
          );
          return false;
        }
      } else {
        emit(
          ChatActionError(
            response.errorMessage!,
            event.editConversationRequest.conversationId.toString(),
          ),
        );
        return false;
      }
    } catch (e) {
      emit(
        ChatActionError(
          "An error occurred while editing the message",
          event.editConversationRequest.conversationId.toString(),
        ),
      );
      return false;
    }
  }

  mapPostMultiMediaConversation(
    PostMultiMediaConversation event,
    Emitter<ChatActionState> emit,
  ) async {
    try {
      DateTime dateTime = DateTime.now();
      User user = UserLocalPreference.instance.fetchUserData();
      Conversation conversation = Conversation(
        answer: event.postConversationRequest.text,
        chatroomId: event.postConversationRequest.chatroomId,
        createdAt: "",
        state: 0,
        header: "",
        date: "${dateTime.day} ${dateTime.month} ${dateTime.year}",
        replyId: event.postConversationRequest.replyId,
        attachmentCount: event.postConversationRequest.attachmentCount,
        hasFiles: event.postConversationRequest.hasFiles,
        member: user,
        temporaryId: event.postConversationRequest.temporaryId,
        id: 1,
      );
      emit(
        MultiMediaConversationLoading(
          conversation,
          event.mediaFiles,
        ),
      );
      LMResponse<PostConversationResponse> response =
          await locator<LikeMindsService>().postConversation(
        event.postConversationRequest,
      );

      if (response.success) {
        PostConversationResponse postConversationResponse = response.data!;
        if (postConversationResponse.success) {
          List<Media> fileLink = [];
          int length = event.mediaFiles.length;
          for (int i = 0; i < length; i++) {
            Media media = event.mediaFiles[i];
            String? url = await mediaService.uploadFile(
              media.mediaFile!,
              event.postConversationRequest.chatroomId,
              postConversationResponse.conversation!.id,
            );
            String? thumbnailUrl;
            if (media.mediaType == MediaType.video) {
              // If the thumbnail file is not present in media object
              // then generate the thumbnail and upload it to the server
              if (media.thumbnailFile == null) {
                await getVideoThumbnail(media);
              }
              thumbnailUrl = await mediaService.uploadFile(
                media.thumbnailFile!,
                event.postConversationRequest.chatroomId,
                postConversationResponse.conversation!.id,
              );
            }

            if (url == null) {
              throw 'Error uploading file';
            } else {
              String attachmentType = mapMediaTypeToString(media.mediaType);
              PutMediaRequest putMediaRequest = (PutMediaRequestBuilder()
                    ..conversationId(postConversationResponse.conversation!.id)
                    ..filesCount(length)
                    ..index(i)
                    ..height(media.height)
                    ..width(media.width)
                    ..meta({
                      'size': media.size,
                      'number_of_page': media.pageCount,
                    })
                    ..type(attachmentType)
                    ..thumbnailUrl(thumbnailUrl)
                    ..url(url))
                  .build();
              LMResponse<PutMediaResponse> uploadFileResponse =
                  await locator<LikeMindsService>()
                      .putMultimedia(putMediaRequest);
              if (!uploadFileResponse.success) {
                emit(
                  MultiMediaConversationError(
                    uploadFileResponse.errorMessage!,
                    event.postConversationRequest.temporaryId,
                  ),
                );
              } else {
                if (!uploadFileResponse.data!.success) {
                  emit(
                    MultiMediaConversationError(
                      uploadFileResponse.data!.errorMessage!,
                      event.postConversationRequest.temporaryId,
                    ),
                  );
                } else {
                  Media mediaItem = Media.fromJson(putMediaRequest.toJson());
                  mediaItem.mediaFile = media.mediaFile;
                  mediaItem.thumbnailFile = media.thumbnailFile;
                  fileLink.add(mediaItem);
                }
              }
            }
          }
          lastConversationId = response.data!.conversation!.id;
          emit(
            MultiMediaConversationPosted(
              postConversationResponse,
              fileLink,
            ),
          );
        } else {
          emit(
            MultiMediaConversationError(
              postConversationResponse.errorMessage!,
              event.postConversationRequest.temporaryId,
            ),
          );
        }
      } else {
        emit(
          MultiMediaConversationError(
            response.errorMessage!,
            event.postConversationRequest.temporaryId,
          ),
        );
        return false;
      }
    } catch (e) {
      emit(
        ChatActionError(
          "An error occurred",
          event.postConversationRequest.temporaryId,
        ),
      );
      return false;
    }
  }

  mapPostPollConversation(
      PostPollConversation event, Emitter<ChatActionState> emit) async {
    try {
      LMResponse<PostConversationResponse> response =
          await locator<LikeMindsService>().postPollConversation(
        event.postPollConversationRequest,
      );
      if (response.success) {
        if (response.data!.success) {
          emit(ConversationPosted(response.data!));
        } else {
          emit(
            ChatActionError(
              response.data!.errorMessage!,
              event.postPollConversationRequest.temporaryId,
            ),
          );
          return false;
        }
      } else {
        emit(
          ChatActionError(
            response.errorMessage!,
            event.postPollConversationRequest.temporaryId,
          ),
        );
        return false;
      }
    } catch (e) {
      emit(
        ChatActionError(
          "An error occurred",
          event.postPollConversationRequest.temporaryId,
        ),
      );
      return false;
    }
  }
}

mapPostConversationFunction(
    PostConversation event, Emitter<ChatActionState> emit) async {
  try {
    DateTime dateTime = DateTime.now();
    User user = UserLocalPreference.instance.fetchUserData();
    Conversation conversation = Conversation(
      answer: event.postConversationRequest.text,
      chatroomId: event.postConversationRequest.chatroomId,
      createdAt: "",
      header: "",
      date: "${dateTime.day} ${dateTime.month} ${dateTime.year}",
      replyId: event.postConversationRequest.replyId,
      attachmentCount: event.postConversationRequest.attachmentCount,
      replyConversationObject: event.replyConversation,
      hasFiles: event.postConversationRequest.hasFiles,
      member: user,
      state: 0,
      temporaryId: event.postConversationRequest.temporaryId,
      id: 1,
    );
    emit(LocalConversation(conversation));
    LMResponse<PostConversationResponse> response =
        await locator<LikeMindsService>().postConversation(
      event.postConversationRequest,
    );

    if (response.success) {
      if (response.data!.success) {
        Conversation conversation = response.data!.conversation!;
        if (conversation.replyId != null ||
            conversation.replyConversation != null) {
          conversation.replyConversationObject = event.replyConversation;
        }
        emit(ConversationPosted(response.data!));
      } else {
        emit(
          ChatActionError(
            response.data!.errorMessage!,
            event.postConversationRequest.temporaryId,
          ),
        );
        return false;
      }
    } else {
      emit(
        ChatActionError(
          response.errorMessage!,
          event.postConversationRequest.temporaryId,
        ),
      );
      return false;
    }
  } catch (e) {
    emit(
      ChatActionError(
        "An error occurred",
        event.postConversationRequest.temporaryId,
      ),
    );
    return false;
  }
}
