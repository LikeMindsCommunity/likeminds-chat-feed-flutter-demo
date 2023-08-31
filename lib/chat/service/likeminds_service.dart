import 'package:likeminds_chat_fl/likeminds_chat_fl.dart';
import 'package:likeminds_flutter_sample/chat/utils/local_preference/local_prefs.dart';
import 'package:likeminds_flutter_sample/chat/utils/analytics/analytics.dart';

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

class LikeMindsService implements ILikeMindsService {
  final String apiKey;
  final LMSDKCallback? lmCallBack;
  LMChatClient? client;

  LikeMindsService({
    required this.apiKey,
    this.lmCallBack,
  }) {
    client = (LMChatClientBuilder()
          ..apiKey(apiKey)
          ..sdkCallback(lmCallBack))
        .build();
    LMAnalytics.get().initialize();
  }

  @override
  Future<LMResponse<InitiateUserResponse>> initiateUser(
      InitiateUserRequest request) async {
    UserLocalPreference userLocalPreference = UserLocalPreference.instance;
    await userLocalPreference.initialize();
    final response = await client!.initiateUser(request);
    if (response.success) {
      UserLocalPreference.instance
          .storeUserData(response.data!.initiateUser!.user);
      UserLocalPreference.instance
          .storeCommunityData(response.data!.initiateUser!.community);
    }
    return response;
  }

  @override
  Future<LMResponse<MemberStateResponse>> getMemberState() async {
    final response = await client!.getMemberState();
    if (response.success) {
      await UserLocalPreference.instance.storeMemberRights(response.data);
    }
    return response;
  }

  @override
  Future<LMResponse<LogoutResponse>> logout(LogoutRequest request) {
    return client!.logout(request);
  }

  @override
  Future<LMResponse<GetHomeFeedResponse>> getHomeFeed(
      GetHomeFeedRequest request) {
    return client!.getHomeFeed(request);
  }

  @override
  Future<LMResponse<GetChatroomResponse>> getChatroom(
      GetChatroomRequest request) {
    return client!.getChatroom(request);
  }

  @override
  Future<LMResponse<FollowChatroomResponse>> followChatroom(
      FollowChatroomRequest request) {
    return client!.followChatroom(request);
  }

  @override
  Future<LMResponse<MuteChatroomResponse>> muteChatroom(
      MuteChatroomRequest request) {
    return client!.muteChatroom(request);
  }

  @override
  Future<LMResponse<MarkReadChatroomResponse>> markReadChatroom(
      MarkReadChatroomRequest request) {
    return client!.markReadChatroom(request);
  }

  @override
  Future<LMResponse<ShareChatroomResponse>> shareChatroomUrl(
      ShareChatroomRequest request) {
    return client!.shareChatroomUrl(request);
  }

  @override
  Future<LMResponse<DeleteParticipantResponse>> deleteParticipant(
      DeleteParticipantRequest request) {
    return client!.deleteParticipant(request);
  }

  @override
  Future<LMResponse<SetChatroomTopicResponse>> setChatroomTopic(
      SetChatroomTopicRequest request) {
    return client!.setChatroomTopic(request);
  }

  @override
  Future<LMResponse<GetConversationResponse>> getConversation(
      GetConversationRequest request) {
    return client!.getConversation(request);
  }

  @override
  Future<LMResponse<PostConversationResponse>> postConversation(
      PostConversationRequest request) {
    return client!.postConversation(request);
  }

  @override
  Future<LMResponse<EditConversationResponse>> editConversation(
      EditConversationRequest request) {
    return client!.editConversation(request);
  }

  @override
  Future<LMResponse<DeleteConversationResponse>> deleteConversation(
      DeleteConversationRequest request) {
    return client!.deleteConversation(request);
  }

  @override
  Future<LMResponse<PutMediaResponse>> putMultimedia(PutMediaRequest request) {
    return client!.putMultimedia(request);
  }

  @override
  Future<LMResponse<PutReactionResponse>> putReaction(
      PutReactionRequest request) {
    return client!.putReaction(request);
  }

  @override
  Future<LMResponse<DeleteReactionResponse>> deleteReaction(
      DeleteReactionRequest request) {
    return client!.deleteReaction(request);
  }

  @override
  Future<LMResponse<RegisterDeviceResponse>> registerDevice(
      RegisterDeviceRequest request) {
    return client!.registerDevice(request);
  }

  @override
  Future<LMResponse<GetParticipantsResponse>> getParticipants(
      GetParticipantsRequest request) {
    return client!.getParticipants(request);
  }

  @override
  Future<LMResponse<TagResponseModel>> getTaggingList(TagRequestModel request) {
    return client!.getTaggingList(request);
  }

  @override
  Future<LMResponse<GetExploreFeedResponse>> getExploreFeed(
      GetExploreFeedRequest request) {
    return client!.getExploreFeed(request);
  }

  @override
  Future<LMResponse<GetExploreTabCountResponse>> getExploreTabCount() {
    return client!.getExploreTabCount();
  }

  @override
  Future<LMResponse<GetPollUsersResponse>> getPollUsers(
      GetPollUsersRequest request) {
    return client!.getPollUsers(request);
  }

  @override
  Future<LMResponse<AddPollOptionResponse>> addPollOption(
      AddPollOptionRequest request) {
    return client!.addPollOption(request);
  }

  @override
  Future<LMResponse<SubmitPollResponse>> submitPoll(SubmitPollRequest request) {
    return client!.submitPoll(request);
  }

  @override
  Future<LMResponse<PostConversationResponse>> postPollConversation(
      PostPollConversationRequest request) {
    return client!.postPollConversation(request);
  }
}
