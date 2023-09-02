import 'package:likeminds_chat_fl/likeminds_chat_fl.dart';

abstract class ILikeMindsService {
  Future<LMResponse<InitiateUserResponse>> initiateUser(
      InitiateUserRequest request);
  Future<LMResponse<MemberStateResponse>> getMemberState();
  Future<LMResponse<LogoutResponse>> logout(LogoutRequest request);
  Future<LMResponse<GetHomeFeedResponse>> getHomeFeed(
      GetHomeFeedRequest request);
  Future<LMResponse<GetChatroomResponse>> getChatroom(
      GetChatroomRequest request);
  Future<LMResponse<FollowChatroomResponse>> followChatroom(
      FollowChatroomRequest request);
  Future<LMResponse<MuteChatroomResponse>> muteChatroom(
      MuteChatroomRequest request);
  Future<LMResponse<MarkReadChatroomResponse>> markReadChatroom(
      MarkReadChatroomRequest request);
  Future<LMResponse<ShareChatroomResponse>> shareChatroomUrl(
      ShareChatroomRequest request);
  Future<LMResponse<SetChatroomTopicResponse>> setChatroomTopic(
      SetChatroomTopicRequest request);
  Future<LMResponse<DeleteParticipantResponse>> deleteParticipant(
      DeleteParticipantRequest request);
  Future<LMResponse<GetConversationResponse>> getConversation(
      GetConversationRequest request);
  Future<LMResponse<PostConversationResponse>> postConversation(
      PostConversationRequest request);
  Future<LMResponse<EditConversationResponse>> editConversation(
      EditConversationRequest request);
  Future<LMResponse<DeleteConversationResponse>> deleteConversation(
      DeleteConversationRequest request);
  Future<LMResponse<PutMediaResponse>> putMultimedia(PutMediaRequest request);
  Future<LMResponse<PutReactionResponse>> putReaction(
      PutReactionRequest request);
  Future<LMResponse<DeleteReactionResponse>> deleteReaction(
      DeleteReactionRequest request);
  Future<LMResponse<RegisterDeviceResponse>> registerDevice(
      RegisterDeviceRequest request);
  Future<LMResponse<GetParticipantsResponse>> getParticipants(
      GetParticipantsRequest request);
  Future<LMResponse<TagResponseModel>> getTaggingList(TagRequestModel request);
  Future<LMResponse<GetExploreFeedResponse>> getExploreFeed(
      GetExploreFeedRequest request);
  Future<LMResponse<GetExploreTabCountResponse>> getExploreTabCount();
  Future<LMResponse<GetPollUsersResponse>> getPollUsers(
      GetPollUsersRequest request);
  Future<LMResponse<AddPollOptionResponse>> addPollOption(
      AddPollOptionRequest request);
  Future<LMResponse<SubmitPollResponse>> submitPoll(SubmitPollRequest request);
  Future<LMResponse<PostConversationResponse>> postPollConversation(
      PostPollConversationRequest request);
}
