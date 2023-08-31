import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:likeminds_feed/likeminds_feed.dart';
import 'package:likeminds_chat_fl/likeminds_chat_fl.dart' as chatSDK;
import 'package:likeminds_feed_ui_fl/likeminds_feed_ui_fl.dart';
import 'package:likeminds_flutter_sample/chat/likeminds_chat_mm_fl.dart';
import 'package:likeminds_flutter_sample/chat/utils/branding/lm_branding.dart';
import 'package:likeminds_flutter_sample/chat/views/home/bloc/home_bloc.dart';
import 'package:likeminds_flutter_sample/chat/views/home/home_page.dart';
import 'package:likeminds_flutter_sample/feed/likeminds_flutter_feed_sample.dart';

import 'package:likeminds_flutter_sample/feed/services/likeminds_service.dart'
    as feed;
import 'package:likeminds_flutter_sample/chat/service/likeminds_service.dart'
    as chat;
import 'package:likeminds_flutter_sample/feed/services/service_locator.dart'
    as feedService;
import 'package:likeminds_flutter_sample/chat/service/service_locator.dart'
    as chatService;
import 'package:likeminds_flutter_sample/feed/utils/color_utils.dart';
import 'package:likeminds_flutter_sample/feed/utils/constants/ui_constants.dart';
import 'package:likeminds_flutter_sample/feed/utils/hot_restart_controller.dart';
import 'package:likeminds_flutter_sample/feed/utils/utils.dart';
import 'package:likeminds_flutter_sample/feed/views/universal_feed_page.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:likeminds_flutter_sample/chat/utils/local_preference/local_prefs.dart'
    as chatPrefs;
import 'package:restart_app/restart_app.dart';

class SettingsScreen extends StatefulWidget {
  Function universalFeedRefreshCallback;
  SettingsScreen({Key? key, required this.universalFeedRefreshCallback})
      : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController userIdController = TextEditingController();
  final TextEditingController apiKeyController = TextEditingController();
  String existingApiKey = '';
  String existingUserName = '';
  String existingUserId = '';
  Color? selectedColor = userSelectedColor;

  // create some values
  Color pickerColor = Color(0xff443a49);

// ValueChanged<Color> callback
  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    updateTextControllers();
  }

  @override
  void didUpdateWidget(covariant SettingsScreen oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    updateTextControllers();
  }

  void updateTextControllers() {
    User user = UserLocalPreference.instance.fetchUserData();
    existingApiKey = UserLocalPreference.instance.fetchApiKey() ?? '';
    existingUserName = user.name;
    existingUserId = user.sdkClientInfo!.userUniqueId;
  }

  @override
  void dispose() {
    nameController.dispose();
    userIdController.dispose();
    apiKeyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    updateTextControllers();
    return Scaffold(
      backgroundColor: userSelectedColor ?? kPrimaryColor,
      appBar: AppBar(
        backgroundColor: userSelectedColor ?? kPrimaryColor,
        elevation: 0,
        title: const LMTextView(
            text: "Sample App Settings",
            textStyle: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
            )),
      ),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            kVerticalPaddingXLarge,
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: LMTextView(
                  text: "Name*",
                  textStyle: TextStyle(color: kWhiteColor, fontSize: 14)),
            ),
            kVerticalPaddingMedium,
            Container(
              clipBehavior: Clip.hardEdge,
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(8.0)),
              child: LMTextInput(
                backgroundColor: kWhiteColor,
                controller: nameController,
                hintText: "Sachin Gakkhar",
                hintStyle: const TextStyle(
                    color: kBlueGreyColor,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400),
              ),
            ),
            kVerticalPaddingXLarge,
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: LMTextView(
                  text: "User ID*",
                  textStyle: TextStyle(color: kWhiteColor, fontSize: 14)),
            ),
            kVerticalPaddingMedium,
            Container(
              clipBehavior: Clip.hardEdge,
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(8.0)),
              child: LMTextInput(
                backgroundColor: kWhiteColor,
                controller: userIdController,
                hintText: "123456",
                hintStyle: const TextStyle(
                    color: kBlueGreyColor,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400),
              ),
            ),
            kVerticalPaddingXLarge,
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: LMTextView(
                  text: "New API Key (optional)",
                  textStyle: TextStyle(color: kWhiteColor, fontSize: 14)),
            ),
            kVerticalPaddingMedium,
            Container(
              clipBehavior: Clip.hardEdge,
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(8.0)),
              child: LMTextInput(
                backgroundColor: kWhiteColor,
                controller: apiKeyController,
                hintText: "Enter new API key",
                hintStyle: const TextStyle(
                    color: kBlueGreyColor,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400),
              ),
            ),
            kVerticalPaddingLarge,
            kVerticalPaddingLarge,
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: LMTextView(
                  text:
                      "If no credentials are provided, the app will run with the default credentials of Bot user in your community",
                  textAlign: TextAlign.center,
                  textStyle: TextStyle(color: kWhiteColor, fontSize: 12)),
            ),
            kVerticalPaddingLarge,
            kVerticalPaddingLarge,
            const Align(
              alignment: Alignment.center,
              child: LMTextView(
                text: "Branding",
                textAlign: TextAlign.center,
                textStyle: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: kWhiteColor,
                ),
              ),
            ),
            kVerticalPaddingXLarge,
            Align(
              alignment: Alignment.center,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.zero,
                  itemCount: brandingColorOptions.length + 1,
                  itemBuilder: (context, index) => GestureDetector(
                    onTap: () {
                      if (brandingColorOptions.length == index) {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Pick a color!'),
                            content: SingleChildScrollView(
                              child: ColorPicker(
                                color: selectedColor!,
                                onColorChanged: changeColor,
                              ),
                              // Use Material color picker:
                              //
                              // child: MaterialPicker(
                              //   pickerColor: pickerColor,
                              //   onColorChanged: changeColor,
                              //   showLabel: true, // only on portrait mode
                              // ),
                              //
                              // Use Block color picker:
                              //
                              // child: BlockPicker(
                              //   pickerColor: currentColor,
                              //   onColorChanged: changeColor,
                              // ),
                              //
                              // child: MultipleChoiceBlockPicker(
                              //   pickerColors: currentColors,
                              //   onColorsChanged: changeColors,
                              // ),
                            ),
                            actions: <Widget>[
                              ElevatedButton(
                                child: const Text('Got it'),
                                onPressed: () {
                                  setState(() => selectedColor = pickerColor);
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          ),
                        );
                      } else {
                        setState(() {
                          selectedColor = brandingColorOptions[index];
                        });
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 20),
                      decoration: BoxDecoration(
                          border: Border.all(color: kWhiteColor, width: 1),
                          borderRadius: BorderRadius.circular(1),
                          color: brandingColorOptions.length == index
                              ? Colors.white
                              : brandingColorOptions[index]),
                      width: 40,
                      height: 40,
                      child: brandingColorOptions.length == index
                          ? const Icon(
                              Icons.add,
                              color: Colors.black,
                            )
                          : compareColors(
                                  selectedColor, brandingColorOptions[index])
                              ? const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                )
                              : const SizedBox(),
                    ),
                  ),
                ),
              ),
            ),
            kVerticalPaddingLarge,
            kVerticalPaddingLarge,
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: LMTextButton(
                backgroundColor: kWhiteColor,
                borderRadius: 8,
                height: 48,
                onTap: () async {
                  bool isApiKeyChanged = false;
                  userSelectedColor = selectedColor;
                  LMBranding.instance.initialize(
                    headerColor: userSelectedColor,
                    buttonColor: userSelectedColor,
                    textLinkColor: Colors.black,
                  );
                  String enteredUserName = nameController.text.trim();
                  String enteredUserId = userIdController.text.trim();
                  String enteredApiKey = apiKeyController.text.trim();
                  if ((enteredUserName.isNotEmpty && enteredUserId.isEmpty) ||
                      (enteredUserId.isNotEmpty && enteredUserName.isEmpty)) {
                    toast("Please enter both user name and id");
                    return;
                  }
                  if (enteredUserName.isNotEmpty && enteredUserId.isNotEmpty) {
                    chatSDK.LMResponse logoutResponse = await chatService
                        .locator<chat.LikeMindsService>()
                        .logout((chatSDK.LogoutRequestBuilder()).build());

                    await UserLocalPreference.instance.clearLocalPrefs();
                    if (enteredApiKey.isNotEmpty) {
                      existingApiKey = enteredApiKey;
                      LMFeed.setupFeed(apiKey: enteredApiKey);
                      LMChat.setupLMChat(apiKey: enteredApiKey);
                      await UserLocalPreference.instance.storeApiKey(
                          enteredApiKey.isEmpty ? '' : enteredApiKey.trim());
                      isApiKeyChanged = true;
                    }

                    await UserLocalPreference.instance
                        .storeUserName(enteredUserName);
                    await UserLocalPreference.instance
                        .storeUserId(enteredUserId);
                    InitiateUserResponse response = await feedService
                        .locator<feed.LikeMindsService>()
                        .initiateUser((InitiateUserRequestBuilder()
                              ..apiKey(existingApiKey)
                              ..userId(enteredUserId)
                              ..userName(enteredUserName)
                              ..isGuest(false))
                            .build());
                    await LMChat.initiateUser(
                      userId: existingApiKey,
                      userName: enteredUserName,
                    );
                    // chatSDK.LMResponse chatResponse = await chatService
                    //     .locator<chat.LikeMindsService>()
                    //     .initiateUser((chatSDK.InitiateUserRequestBuilder()
                    //           ..apiKey(existingApiKey)
                    //           ..userId(enteredUserId)
                    //           ..userName(enteredUserName)
                    //           ..isGuest(false))
                    //         .build());
                  }
                  Navigator.pop(context);
                  HotRestartController.performHotRestart(context);
                  widget.universalFeedRefreshCallback();
                },
                text: LMTextView(
                  text: "Submit",
                  textStyle: TextStyle(
                    color: userSelectedColor ?? kPrimaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            kVerticalPaddingMedium,
          ],
        ),
      ),
    );
  }
}