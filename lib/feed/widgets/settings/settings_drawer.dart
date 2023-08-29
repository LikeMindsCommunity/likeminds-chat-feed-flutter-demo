import 'package:flutter/material.dart';
import 'package:likeminds_feed/likeminds_feed.dart';
import 'package:likeminds_feed_ui_fl/likeminds_feed_ui_fl.dart';
import 'package:likeminds_flutter_sample/feed/utils/constants/ui_constants.dart';
import 'package:likeminds_flutter_sample/feed/utils/utils.dart';
import 'package:likeminds_flutter_sample/feed/views/settings/settings_screen.dart';
import 'package:likeminds_flutter_sample/feed/widgets/user_tile_widget.dart';

class SettingsDrawer extends StatefulWidget {
  Function universalFeedRefreshCallback;
  SettingsDrawer({
    Key? key,
    required this.universalFeedRefreshCallback,
  }) : super(key: key);

  @override
  State<SettingsDrawer> createState() => _SettingsDrawerState();
}

class _SettingsDrawerState extends State<SettingsDrawer> {
  @override
  Widget build(BuildContext context) {
    User user = UserLocalPreference.instance.fetchUserData();
    Size screenSize = MediaQuery.of(context).size;
    return Drawer(
      width: 300,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 142,
            color: Colors.black87,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.only(left: 20),
                  child: LMUserTile(
                    user: user,
                    titleText: LMTextView(
                      text: user.name,
                      textStyle: const TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                kVerticalPaddingLarge,
              ],
            ),
          ),
          kVerticalPaddingXLarge,
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: LMTextView(
                text: "Settings", textStyle: TextStyle(color: kGrey2Color)),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return SettingsScreen(
                      universalFeedRefreshCallback:
                          widget.universalFeedRefreshCallback,
                    );
                  },
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: kGrey2Color,
                    width: 0.2,
                  ),
                ),
              ),
              child: const Row(children: <Widget>[
                Icon(Icons.settings_outlined, color: kGray1Color),
                kHorizontalPaddingLarge,
                LMTextView(
                  text: "Settings",
                  textStyle: TextStyle(
                    color: kGray1Color,
                    fontSize: 15,
                  ),
                ),
              ]),
            ),
          ),
          const Spacer(),
          kVerticalPaddingLarge,
          const SafeArea(
            top: false,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: LMTextView(
                text: "Powered by LikeMinds",
                textStyle: TextStyle(color: kGrey3Color),
              ),
            ),
          ),
          kVerticalPaddingLarge,
        ],
      ),
    );
  }
}
