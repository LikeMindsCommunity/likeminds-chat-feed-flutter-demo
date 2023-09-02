import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:likeminds_chat_fl/likeminds_chat_fl.dart';
import 'package:likeminds_flutter_sample/chat/navigation/router.dart';
import 'package:likeminds_flutter_sample/chat/service/likeminds_service.dart';
import 'package:likeminds_flutter_sample/chat/service/service_locator.dart';
import 'package:likeminds_flutter_sample/chat/utils/branding/lm_branding.dart';
import 'package:likeminds_flutter_sample/feed/utils/local_preference/user_local_preference.dart'
    as feed;

import 'package:likeminds_flutter_sample/chat/utils/constants/ui_constants.dart';
import 'package:likeminds_flutter_sample/chat/utils/credentials/firebase_credentials.dart';
import 'package:likeminds_flutter_sample/chat/utils/local_preference/local_prefs.dart';
import 'package:likeminds_flutter_sample/chat/utils/notifications/notification_handler.dart';
import 'package:likeminds_flutter_sample/chat/utils/realtime/realtime.dart';
import 'package:likeminds_flutter_sample/chat/views/chatroom/bloc/chat_action_bloc/chat_action_bloc.dart';

import 'package:likeminds_flutter_sample/chat/views/home/bloc/home_bloc.dart';
import 'package:likeminds_flutter_sample/chat/views/media/bloc/media_bloc.dart';
import 'package:likeminds_flutter_sample/chat/widgets/spinner.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:sizer/sizer.dart';

const bool isDebug = bool.fromEnvironment('DEBUG');

class LMChat extends StatefulWidget {
  final String _userId;
  final String _userName;
  // ignore: unused_field
  final String? _domain;
  final int? _defaultChatroom;

  LMChat._internal(
    this._userId,
    this._userName,
    this._domain,
    this._defaultChatroom,
  ) {
    debugPrint('LMChat initialized');
  }

  static LMChat? _instance;
  static LMChat instance({required LMChatBuilder builder}) {
    return LMChat._internal(
      builder.getUserId!,
      builder.getUserName!,
      builder.getDomain,
      builder.getDefaultChatroom,
    );
  }

  static void setupLMChat({
    required String apiKey,
    LMSDKCallback? lmCallBack,
  }) {
    setupChat(
      apiKey: apiKey,
      lmCallBack: lmCallBack,
    );
  }

  static Future<InitiateUser> initiateUser({
    String? userId,
    String? userName,
  }) async {
    final response = await locator<LikeMindsService>()
        .initiateUser((InitiateUserRequestBuilder()
              ..userId((userId ?? _instance?._userId)!)
              ..userName((userName ?? _instance?._userName)!))
            .build());
    final initiateUser = response.data!.initiateUser!;

    final isCm = await locator<LikeMindsService>().getMemberState();
    await UserLocalPreference.instance.storeMemberRights(isCm.data);
    await UserLocalPreference.instance.storeUserData(initiateUser.user);
    await UserLocalPreference.instance
        .storeCommunityData(initiateUser.community);

    return initiateUser;
  }

  @override
  State<LMChat> createState() => _LMChatState();
}

class _LMChatState extends State<LMChat> {
  User? user;
  String? userId;
  String? userName;
  String? apiKey;
  Future<InitiateUser>? intiateUserFuture;
  @override
  void initState() {
    super.initState();
    firebase();
    updateUserDetails();
    intiateUserFuture = LMChat.initiateUser(userId: userId, userName: userName);
  }

  @override
  void didUpdateWidget(LMChat oldWidget) {
    super.didUpdateWidget(oldWidget);
    updateUserDetails();
    intiateUserFuture =
        LMChat.initiateUser(userId: userId ?? "", userName: userName);
  }

  //
  /*
 * Fetches the user details from local storage
 * updates the userid, userName and apiKey
 * if the user details are present in local storage
 */
  void updateUserDetails() {
    String? localUserId = feed.UserLocalPreference.instance.fetchUserId();
    // userId = isProd ? CredsProd.botId : CredsDev.botId;
    String? localUserName = feed.UserLocalPreference.instance.fetchUserName();
    userName = widget._userName ?? "Test username";
    if (localUserId != null && localUserId.isNotEmpty) {
      userId = localUserId;
    }
    if (localUserName != null && localUserName.isNotEmpty) {
      userName = localUserName;
    }
    apiKey = feed.UserLocalPreference.instance.fetchApiKey();
  }

  // Initialises firebase for push notifications
  firebase() async {
    try {
      final clientFirebase = Firebase.app();
      final ourFirebase = await Firebase.initializeApp(
        name: 'likeminds_chat',
        options: !isDebug
            ?
            //Prod Firebase options
            Platform.isIOS
                ? FirebaseOptions(
                    apiKey: FbCredsProd.fbApiKey,
                    appId: FbCredsProd.fbAppIdIOS,
                    messagingSenderId: FbCredsProd.fbMessagingSenderId,
                    projectId: FbCredsProd.fbProjectId,
                    databaseURL: FbCredsProd.fbDatabaseUrl,
                  )
                : FirebaseOptions(
                    apiKey: FbCredsProd.fbApiKey,
                    appId: FbCredsProd.fbAppIdAN,
                    messagingSenderId: FbCredsProd.fbMessagingSenderId,
                    projectId: FbCredsProd.fbProjectId,
                    databaseURL: FbCredsProd.fbDatabaseUrl,
                  )
            //Beta Firebase options
            : Platform.isIOS
                ? FirebaseOptions(
                    apiKey: FbCredsDev.fbApiKey,
                    appId: FbCredsDev.fbAppIdIOS,
                    messagingSenderId: FbCredsDev.fbMessagingSenderId,
                    projectId: FbCredsDev.fbProjectId,
                    databaseURL: FbCredsDev.fbDatabaseUrl,
                  )
                : FirebaseOptions(
                    apiKey: FbCredsDev.fbApiKey,
                    appId: FbCredsDev.fbAppIdIOS,
                    messagingSenderId: FbCredsDev.fbMessagingSenderId,
                    projectId: FbCredsDev.fbProjectId,
                    databaseURL: FbCredsDev.fbDatabaseUrl,
                  ),
      );
      debugPrint("Client Firebase - ${clientFirebase.options.appId}");
      debugPrint("Our Firebase - ${ourFirebase.options.appId}");
    } on FirebaseException catch (e) {
      debugPrint("Make sure you have initialized firebase, ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    router.go("/");
    return OverlaySupport.global(
      toastTheme: ToastThemeData(
        textColor: whiteColor,
        background: blackColor,
        alignment: Alignment.bottomCenter,
      ),
      child: Sizer(
        builder: ((context, orientation, deviceType) {
          return MultiBlocProvider(
            providers: [
              BlocProvider<ChatActionBloc>(
                create: (context) => ChatActionBloc(),
              ),
              BlocProvider<HomeBloc>(
                create: (context) => HomeBloc(),
              ),
              BlocProvider(
                create: (context) => MediaBloc(),
              )
            ],
            child: FutureBuilder(
              future: intiateUserFuture,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final user = snapshot.data!.user;
                  LMNotificationHandler.instance.registerDevice(user.id);
                  if (widget._defaultChatroom != null) {
                    LMRealtime.instance.chatroomId = widget._defaultChatroom!;
                    // router.
                    return MaterialApp.router(
                      routerConfig: router
                        ..go(
                            '/chatroom/${widget._defaultChatroom}?isRoot=true'),
                      debugShowCheckedModeBanner: false,
                    );
                  }

                  return MaterialApp.router(
                    routerConfig: router,
                    debugShowCheckedModeBanner: false,
                  );
                }
                return Container(
                  color: whiteColor,
                  child: Spinner(
                    color: LMBranding.instance.headerColor,
                  ),
                );
              },
            ),
          );
        }),
      ),
    );
  }
}

class LMChatBuilder {
  String? _userId;
  String? _userName;
  String? _domain;
  int? _defaultChatroom;

  LMChatBuilder();

  void userId(String userId) => _userId = userId;
  void userName(String userName) => _userName = userName;
  void domain(String domain) => _domain = domain;
  void defaultChatroom(int? defaultChatroomId) =>
      _defaultChatroom = defaultChatroomId;

  String? get getUserId => _userId;
  String? get getUserName => _userName;
  String? get getDomain => _domain;
  int? get getDefaultChatroom => _defaultChatroom;
}
