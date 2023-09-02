import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:likeminds_feed/likeminds_feed.dart';
import 'package:likeminds_feed_ui_fl/likeminds_feed_ui_fl.dart';
import 'package:likeminds_flutter_sample/chat/utils/branding/lm_branding.dart';
import 'package:likeminds_flutter_sample/feed/services/likeminds_service.dart';
import 'package:likeminds_flutter_sample/feed/services/service_locator.dart';

import 'package:likeminds_flutter_sample/feed/utils/color_utils.dart';
import 'package:likeminds_flutter_sample/feed/utils/constants/ui_constants.dart';
import 'package:likeminds_flutter_sample/feed/utils/utils.dart';
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
  }

  void updateTextControllers() {
    User user = UserLocalPreference.instance.fetchUserData();
    existingApiKey = UserLocalPreference.instance.fetchApiKey() ?? '';
    existingUserName = user.name;
    existingUserId = user.sdkClientInfo!.userUniqueId;
    if (existingUserName.isNotEmpty) {
      nameController.text = existingUserName;
    }
    if (existingUserId.isNotEmpty) {
      userIdController.text = existingUserId;
    }
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
    return Scaffold(
      backgroundColor: userSelectedColor ?? primaryColor,
      appBar: AppBar(
        backgroundColor: userSelectedColor ?? primaryColor,
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
            verticalPaddingXLarge,
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: LMTextView(
                  text: "Name*",
                  textStyle: TextStyle(color: whiteColor, fontSize: 14)),
            ),
            verticalPaddingMedium,
            Container(
              clipBehavior: Clip.hardEdge,
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(8.0)),
              child: LMTextInput(
                backgroundColor: whiteColor,
                controller: nameController,
                hintText: "Sachin Gakkhar",
                hintStyle: const TextStyle(
                    color: kBlueGreyColor,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400),
              ),
            ),
            verticalPaddingXLarge,
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: LMTextView(
                  text: "User ID*",
                  textStyle: TextStyle(color: whiteColor, fontSize: 14)),
            ),
            verticalPaddingMedium,
            Container(
              clipBehavior: Clip.hardEdge,
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(8.0)),
              child: LMTextInput(
                backgroundColor: whiteColor,
                controller: userIdController,
                hintText: "123456",
                hintStyle: const TextStyle(
                    color: kBlueGreyColor,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400),
              ),
            ),
            verticalPaddingXLarge,
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: LMTextView(
                  text: "New API Key (optional)",
                  textStyle: TextStyle(color: whiteColor, fontSize: 14)),
            ),
            verticalPaddingMedium,
            Container(
              clipBehavior: Clip.hardEdge,
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(8.0)),
              child: LMTextInput(
                backgroundColor: whiteColor,
                controller: apiKeyController,
                hintText: "Enter new API key",
                hintStyle: const TextStyle(
                    color: kBlueGreyColor,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400),
              ),
            ),
            verticalPaddingLarge,
            verticalPaddingLarge,
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: LMTextView(
                  text:
                      "If no credentials are provided, the app will run with the default credentials of Bot user in your community",
                  textAlign: TextAlign.center,
                  textStyle: TextStyle(color: whiteColor, fontSize: 12)),
            ),
            verticalPaddingLarge,
            verticalPaddingLarge,
            const Align(
              alignment: Alignment.center,
              child: LMTextView(
                text: "Branding",
                textAlign: TextAlign.center,
                textStyle: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: whiteColor,
                ),
              ),
            ),
            verticalPaddingXLarge,
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
                          border: Border.all(color: whiteColor, width: 1),
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
            verticalPaddingLarge,
            verticalPaddingLarge,
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: LMTextButton(
                backgroundColor: whiteColor,
                borderRadius: 8,
                height: 48,
                onTap: () async {
                  userSelectedColor = selectedColor;
                  LMBranding.instance.initialize(
                    headerColor: userSelectedColor,
                    buttonColor: userSelectedColor,
                    textLinkColor: Colors.black,
                  );
                  String enteredUserName = nameController.text.trim();
                  String enteredUserId = userIdController.text.trim();
                  String enteredApiKey = apiKeyController.text.trim();

                  await UserLocalPreference.instance.clearLocalPrefs();
                  if (enteredApiKey.isNotEmpty) {
                    existingApiKey = enteredApiKey;

                    await UserLocalPreference.instance.storeApiKey(
                        enteredApiKey.isEmpty ? '' : enteredApiKey.trim());
                  } else {
                    await UserLocalPreference.instance
                        .storeApiKey(existingApiKey);
                  }

                  if (enteredUserName.isEmpty && enteredUserId.isEmpty) {
                    enteredUserName = existingUserName;
                    enteredUserId = existingUserId;
                  } else if (enteredUserName.isEmpty &&
                      enteredUserId.isNotEmpty) {
                    enteredUserName = 'Test User';
                  } else if (enteredUserId.isEmpty &&
                      enteredUserName.isNotEmpty) {
                    InitiateUserResponse response =
                        await locator<LikeMindsService>().initiateUser(
                            (InitiateUserRequestBuilder()
                                  ..userName(enteredUserName))
                                .build());
                    if (response.success) {
                      enteredUserId = response
                              .initiateUser!.user.sdkClientInfo?.userUniqueId ??
                          response.initiateUser!.user.userUniqueId;
                    }
                  }

                  await UserLocalPreference.instance
                      .storeUserName(enteredUserName);

                  await UserLocalPreference.instance.storeUserId(enteredUserId);

                  await UserLocalPreference.instance
                      .storeAppColor(userSelectedColor!.value);

                  Restart.restartApp();
                },
                text: LMTextView(
                  text: "Submit",
                  textStyle: TextStyle(
                    color: userSelectedColor ?? primaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            verticalPaddingMedium,
          ],
        ),
      ),
    );
  }
}
