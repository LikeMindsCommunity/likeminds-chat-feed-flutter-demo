import 'package:flutter/material.dart';
import 'package:likeminds_feed/likeminds_feed.dart';
import 'package:likeminds_feed_ui_fl/likeminds_feed_ui_fl.dart';
import 'package:likeminds_flutter_sample/feed/services/likeminds_service.dart';
import 'package:likeminds_flutter_sample/feed/services/service_locator.dart';
import 'package:likeminds_flutter_sample/feed/utils/constants/ui_constants.dart';

// TODO: Customisation
class LMUserTile extends StatelessWidget {
  final User user;
  final LMTextView? titleText;
  final LMTextView? subText;
  final double? imageSize;
  const LMUserTile({
    Key? key,
    this.titleText,
    this.imageSize,
    required this.user,
    this.subText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        LMProfilePicture(
          size: imageSize ?? 50,
          fallbackText: user.name,
          onTap: () {
            if (user.sdkClientInfo != null) {
              locator<LikeMindsService>()
                  .routeToProfile(user.sdkClientInfo!.userUniqueId);
            }
          },
          imageUrl: user.imageUrl,
        ),
        kHorizontalPaddingLarge,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              titleText ??
                  LMTextView(
                    text: user.name,
                    textStyle: const TextStyle(
                      fontSize: kFontMedium,
                      color: kGrey1Color,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              kVerticalPaddingMedium,
              subText ?? const SizedBox(),
            ],
          ),
        ),
      ],
    );
  }
}
