import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:likeminds_chat_fl/likeminds_chat_fl.dart';
import 'package:likeminds_flutter_sample/chat/navigation/router.dart';
import 'package:likeminds_flutter_sample/chat/service/likeminds_service.dart';
import 'package:likeminds_flutter_sample/chat/service/service_locator.dart';
import 'package:likeminds_flutter_sample/chat/utils/branding/lm_branding.dart';

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

class LMChat extends StatelessWidget {
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
    if (builder.getUserId == null && builder.getUserName == null) {
      throw Exception(
        'LMChat builder needs to be initialized with User ID, or User Name',
      );
    } else {
      return _instance ??= LMChat._internal(
        builder.getUserId!,
        builder.getUserName!,
        builder.getDomain,
        builder.getDefaultChatroom,
      );
    }
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
    UserLocalPreference.instance.storeMemberRights(isCm.data);
    UserLocalPreference.instance.storeUserData(initiateUser.user);
    UserLocalPreference.instance.storeCommunityData(initiateUser.community);
    await _instance?.firebase();
    return initiateUser;
  }

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
    return OverlaySupport.global(
      toastTheme: ToastThemeData(
        textColor: kWhiteColor,
        background: kBlackColor,
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
              future: initiateUser(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final user = snapshot.data!.user;
                  LMNotificationHandler.instance.registerDevice(user.id);
                  if (_defaultChatroom != null) {
                    LMRealtime.instance.chatroomId = _defaultChatroom!;
                    // router.
                    return MaterialApp.router(
                      routerConfig: router
                        ..go('/chatroom/$_defaultChatroom?isRoot=true'),
                      debugShowCheckedModeBanner: false,
                    );
                  }

                  return MaterialApp.router(
                    routerConfig: router,
                    debugShowCheckedModeBanner: false,
                  );
                }
                return Container(
                  color: kWhiteColor,
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
