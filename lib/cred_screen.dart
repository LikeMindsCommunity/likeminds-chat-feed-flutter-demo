import 'dart:async';

import 'package:likeminds_flutter_sample/chat/likeminds_chat_mm_fl.dart';
import 'package:likeminds_flutter_sample/chat/utils/imports.dart';
import 'package:likeminds_flutter_sample/feed/likeminds_flutter_feed_sample.dart';
import 'package:likeminds_flutter_sample/feed/utils/constants/ui_constants.dart';
import 'package:likeminds_flutter_sample/feed/utils/utils.dart';
import 'package:likeminds_flutter_sample/home_view.dart';
import 'package:likeminds_flutter_sample/likeminds_callback.dart';
import 'package:likeminds_flutter_sample/network_handling.dart';
import 'package:overlay_support/overlay_support.dart';

final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Integration App for UI + SDK package',
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      scaffoldMessengerKey: rootScaffoldMessengerKey,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 70, 102, 246),
          primary: const Color.fromARGB(255, 70, 102, 246),
          secondary: const Color.fromARGB(255, 59, 130, 246),
        ),
        useMaterial3: true,
      ),
      home: new CredScreen(),
    );
  }
}

class CredScreen extends StatefulWidget {
  CredScreen({super.key});

  @override
  State<CredScreen> createState() => _CredScreenState();
}

class _CredScreenState extends State<CredScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _userIdController = TextEditingController();
  StreamSubscription? _streamSubscription;
  LMFeed? lmFeed;
  LMChat? lmChat;
  String? userId;

  @override
  void initState() {
    super.initState();
    NetworkConnectivity networkConnectivity = NetworkConnectivity.instance;
    networkConnectivity.initialise();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _userIdController.dispose();
    _streamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // return lmFeed;
    userId = UserLocalPreference.instance.fetchUserId();
    String? userName = UserLocalPreference.instance.fetchUserName();
    String? apiKey = UserLocalPreference.instance.fetchApiKey();

    // If the local prefs have user id stored
    // Login using that user Id
    // otherwise show the cred screen for login
    if ((userId != null && userId!.isNotEmpty) ||
        (userName != null && userName.isNotEmpty)) {
      userSelectedColor = UserLocalPreference.instance.fetchAppColor();
      LMBranding.instance.initialize(
        headerColor: userSelectedColor,
        buttonColor: userSelectedColor,
        textLinkColor: blackColor,
      );
      lmFeed = LMFeed.instance(
        userId: userId,
        userName: userName == null || userName.isEmpty ? 'Test User' : userName,
        callback: LikeMindsCallback(),
        apiKey: apiKey ?? "",
      );
      LMChatBuilder builder = LMChatBuilder()
        ..domain("")
        ..userId(userId ?? "")
        ..userName(
          userName == null || userName.isEmpty ? 'Test User' : userName,
        );

      lmChat = LMChat.instance(builder: builder);

      return HomeView(chat: lmChat!, feed: lmFeed!);
    } else {
      TextEditingController textEditingController = TextEditingController();
      return Scaffold(
        backgroundColor: Colors.white,
        body: Dialog(
          elevation: 0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(1.0)),
          child: Card(
            color: Colors.white,
            clipBehavior: Clip.hardEdge,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(1.0)),
            elevation: 5,
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.all(30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Text(
                    'Add your name',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16.0,
                      color: Color.fromRGBO(51, 51, 51, 1),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Add your name to continue using this sample app.",
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Color.fromRGBO(102, 102, 102, 1),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          )
                        ]),
                    child: TextField(
                      controller: textEditingController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.topRight,
                    child: TextButton(
                        onPressed: () {
                          if (textEditingController.text.isEmpty) {
                            toast("Please enter your name");
                          } else {
                            userName = textEditingController.text;
                            userSelectedColor =
                                UserLocalPreference.instance.fetchAppColor();
                            LMBranding.instance.initialize(
                              headerColor: userSelectedColor,
                              buttonColor: userSelectedColor,
                              textLinkColor: blackColor,
                            );
                            lmFeed = LMFeed.instance(
                              userId: userId,
                              userName: userName ?? "Test User",
                              callback: LikeMindsCallback(),
                              apiKey: apiKey ?? "",
                            );
                            LMChatBuilder builder = LMChatBuilder()
                              ..domain("")
                              ..userId(userId ?? "")
                              ..userName(
                                userName ?? "Test User",
                              );

                            lmChat = LMChat.instance(
                              builder: builder,
                            );

                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) =>
                                    HomeView(chat: lmChat!, feed: lmFeed!),
                              ),
                            );
                          }
                        },
                        child: const Text(
                          'Submit',
                        )),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    }
  }
}
