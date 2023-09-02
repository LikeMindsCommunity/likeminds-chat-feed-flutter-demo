import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:likeminds_chat_fl/likeminds_chat_fl.dart';
import 'package:likeminds_flutter_sample/chat/navigation/router.dart';
import 'package:likeminds_flutter_sample/chat/service/likeminds_service.dart';
import 'package:likeminds_flutter_sample/chat/service/service_locator.dart';
import 'package:likeminds_flutter_sample/chat/utils/branding/theme.dart';
import 'package:likeminds_flutter_sample/chat/utils/imports.dart';
import 'package:overlay_support/overlay_support.dart';

/// This class handles all the notification related logic
/// It registers the device for notifications in the SDK
/// It handles the notification when it is received and shows it
/// It routes the notification to the appropriate screen
/// Since this is a singleton class, it is initialized on the client side
class LMNotificationHandler {
  late final String deviceId;
  late final String fcmToken;
  int? memberId;

  static LMNotificationHandler? _instance;
  static LMNotificationHandler get instance =>
      _instance ??= LMNotificationHandler._();

  LMNotificationHandler._();

  /// Initialize the notification handler
  /// This is called from the client side
  /// It initializes the [fcmToken] and the [deviceId]
  void init({
    required String deviceId,
    required String fcmToken,
  }) {
    this.deviceId = deviceId;
    this.fcmToken = fcmToken;
  }

  /// Register the device for notifications
  /// This is called from the client side
  /// It calls the [registerDevice] method of the [LikeMindsService]
  /// It initializes the [memberId] which is used to route the notification
  /// If the registration is successful, it prints success message
  void registerDevice(int memberId) async {
    RegisterDeviceRequest request = RegisterDeviceRequest(
      token: fcmToken,
      memberId: memberId,
      deviceId: deviceId,
    );
    this.memberId = memberId;
    final response = await locator<LikeMindsService>().registerDevice(request);
    if (response.success) {
      debugPrint("Device registered for notifications successfully");
    } else {
      throw Exception("Device registration for notification failed");
    }
  }

  /// Handle the notification when it is received
  /// This is called from the client side when notification [message] is received
  /// and is needed to be handled, i.e. shown and routed to the appropriate screen
  Future<void> handleNotification(RemoteMessage message, bool show) async {
    debugPrint("--- Notification received in LEVEL 2 ---");
    message.toMap().forEach((key, value) {
      debugPrint("$key: $value");
      if (key == "data") {
        message.data.forEach((key, value) {
          debugPrint("$key: $value");
        });
      }
    });

    // First, check if the message contains a data payload.
    if (show && message.data.isNotEmpty) {
      //Add LM check for showing LM notifications
      showNotification(message);
    } else if (message.data.isNotEmpty) {
      // Second, extract the notification data and routes to the appropriate screen
      routeNotification(message);
    }
  }

  void routeNotification(RemoteMessage message) async {
    Map<String, String> queryParams = {};
    String host = "";

    // Only notifications with data payload are handled
    if (message.data.isNotEmpty) {
      final Map<String, dynamic> notifData = message.data;
      final String category = notifData["category"];
      final String route = notifData["route"]!;

      // If the notification is a feed notification, extract the route params
      if (category.toString().toLowerCase() == "chat room") {
        final Uri routeUri = Uri.parse(route);
        final Map<String, String> routeParams =
            routeUri.hasQuery ? routeUri.queryParameters : {};
        final String routeHost = routeUri.host;
        host = routeHost;
        debugPrint("The route host is $routeHost");
        queryParams.addAll(routeParams);
        queryParams.forEach((key, value) {
          debugPrint("$key: $value");
        });
      }
    }

    if (host == "collabcard") {
      final path = "/chatroom/${queryParams["collabcard_id"]}/";
      router.push(path);
    }
  }

  /// Show a simple notification using overlay package
  /// This is a dismissable notification shown on the top of the screen
  /// It is shown when the notification is received in foreground
  void showNotification(RemoteMessage message) {
    if (message.data.isNotEmpty) {
      showSimpleNotification(
        GestureDetector(
          onTap: () {
            routeNotification(message);
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                message.data["title"],
                style: LMTheme.medium.copyWith(
                  fontSize: 11.sp,
                  color: LMTheme.headerColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                message.data["sub_title"],
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: LMTheme.regular.copyWith(
                  fontSize: 9.sp,
                ),
              ),
            ],
          ),
        ),
        background: Colors.white,
        duration: const Duration(seconds: 3),
        leading: Icon(
          Icons.notifications,
          color: LMTheme.buttonColor,
          size: 24.sp,
        ),
        trailing: Icon(
          Icons.swipe_right_outlined,
          color: Colors.grey.shade400,
          size: 18.sp,
        ),
        position: NotificationPosition.top,
        slideDismissDirection: DismissDirection.horizontal,
      );
    }
  }
}
