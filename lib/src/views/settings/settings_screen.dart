import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:likeminds_feed/likeminds_feed.dart';
import 'package:likeminds_feed_ui_fl/likeminds_feed_ui_fl.dart';
import 'package:likeminds_flutter_feed_sample/likeminds_flutter_feed_sample.dart';
import 'package:likeminds_flutter_feed_sample/src/services/likeminds_service.dart';
import 'package:likeminds_flutter_feed_sample/src/utils/color_utils.dart';
import 'package:likeminds_flutter_feed_sample/src/utils/constants/ui_constants.dart';
import 'package:likeminds_flutter_feed_sample/src/utils/hot_restart_controller.dart';
import 'package:likeminds_flutter_feed_sample/src/utils/utils.dart';
import 'package:likeminds_flutter_feed_sample/src/views/universal_feed_page.dart';
import 'package:overlay_support/overlay_support.dart';
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
                  userSelectedColor = selectedColor;
                  if (nameController.text.isNotEmpty &&
                      userIdController.text.isNotEmpty) {
                    bool isApiKeyChanged = false;

                    await locator<LikeMindsService>()
                        .logout(LogoutRequestBuilder().build());
                    await UserLocalPreference.instance.clearLocalPrefs();
                    if (apiKeyController.text.isNotEmpty) {
                      existingApiKey = apiKeyController.text;
                      LMFeed.setupFeed(apiKey: apiKeyController.text);
                      await UserLocalPreference.instance.storeApiKey(
                          apiKeyController.text.isEmpty
                              ? ''
                              : apiKeyController.text);
                      isApiKeyChanged = true;
                    }
                    if (nameController.text.isNotEmpty &&
                        userIdController.text.isNotEmpty) {
                      await UserLocalPreference.instance
                          .storeUserName(nameController.text);
                      await UserLocalPreference.instance
                          .storeUserId(userIdController.text);
                      InitiateUserResponse response =
                          await locator<LikeMindsService>()
                              .initiateUser((InitiateUserRequestBuilder()
                                    ..apiKey(existingApiKey)
                                    ..userId(userIdController.text)
                                    ..userName(nameController.text)
                                    ..isGuest(false))
                                  .build());
                      if (response.success) {
                        await UserLocalPreference.instance
                            .storeUserDataFromInitiateUserResponse(response);
                      } else {
                        toast(response.errorMessage ?? 'An error occurred');
                        return;
                      }
                    } else {
                      toast("Please enter name and user id");
                      return;
                    }
                    if (isApiKeyChanged) {
                      widget.universalFeedRefreshCallback();
                    }
                  }
                  Navigator.pop(context);
                  HotRestartController.performHotRestart(context);
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
