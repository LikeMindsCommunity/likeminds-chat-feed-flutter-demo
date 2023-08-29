import 'package:flutter/foundation.dart';
import 'package:likeminds_chat_fl/likeminds_chat_fl.dart';

class LMAnalytics {
  static LMAnalytics? _instance;
  static LMAnalytics get() => _instance ??= LMAnalytics._();

  LMSDKCallback? sdkCallback;

  LMAnalytics._();

  void initialize() {
    sdkCallback =
        DIService.getIt.isRegistered<LMSDKCallback>(instanceName: "LMCallback")
            ? DIService.getIt.get<LMSDKCallback>(
                instanceName: "LMCallback",
              )
            : null;
    debugPrint("Analytics initialized");
  }

  void logEvent(String eventKey, Map<String, dynamic> propertiesMap) {
    debugPrint('Event: $eventKey');
    debugPrint('Params: $propertiesMap');
  }

  void track(String eventKey, Map<String, dynamic> propertiesMap) {
    logEvent(eventKey, propertiesMap);
    sdkCallback?.eventFiredCallback(eventKey, propertiesMap);
  }
}

class AnalyticsKeys {
  static const String chatroomCreationStarted = 'Chatroom creation started';
  static const String chatroomCreationCompleted = 'Chatroom creation completed';
  static const String chatroomRenamed = 'Chatroom renamed';
  static const String chatroomMuted = 'Chatroom muted';
  static const String chatroomDeleted = 'Chatroom deleted';
  static const String chatroomReported = 'Chatroom reported';
  static const String chatroomFollowed = 'Chatroom followed';
  static const String chatroomUnfollowed = 'Chatroom unfollowed';
  static const String chatroomResponded = 'Chatroom responded';
  static const String chatroomOpened = 'Chatroom opened';
  static const String viewChatroomParticipants = 'View Chatroom participants';
  static const String viewCommunity = 'View community';
  static const String chatroomCreationError = 'Chatroom creation error';
  static const String attachmentUploadedError = 'Attachment uploaded error';
  static const String messageSendingError = 'Message sending error';
  static const String followBeforeLogin = 'Follow before login';
  static const String autoFollowEnabled = 'Auto follow enabled';
  static const String attachmentsUploaded = 'Attachments uploaded';
  static const String imageViewed = 'Image viewed';
  static const String markChatroomActive = 'Mark chatroom active';
  static const String markChatroomInActive = 'Mark chatroom inactive';
  static const String chatroomSharingStarted = 'Chatroom sharing started';
  static const String userTagsSomeone = 'User tags someone';
  static const String groupTagged = 'Group tagged';
  static const String eventAttended = 'Event attended';
  static const String scrollUpToView = 'Scroll up to view';
  static const String chatroomCreated = 'Chatroom created';
  static const String participantsAdded = 'Participants added';
  static const String chatroomAccessRestricted = 'Chatroom access restricted';
  static const String videoPlayed = 'Video played';
  static const String audioPlayed = 'Audio played';
  static const String chatLinkClicked = 'Chat link clicked';
  static const String notificationPageOpened = 'Notification page opened';
  static const String notificationRemoved = 'Notification removed';
  static const String notificationMuted = 'Notification muted';
  static const String aboutSectionViewed = 'About section viewed';
  static const String postSectionViewed = 'Post section viewed';
  static const String activitySectionViewed = 'Activity section viewed';
  static const String savedPostViewed = 'Saved post viewed';
  static const String postCreationStarted = 'Post creation started';
  static const String clickedOnAttachment = 'Clicked on Attachment';
  static const String userTaggedInPost = 'User tagged in a post';
}
