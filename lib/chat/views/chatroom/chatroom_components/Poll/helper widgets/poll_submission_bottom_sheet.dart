import 'package:likeminds_flutter_sample/chat/utils/branding/theme.dart';
import 'package:likeminds_flutter_sample/chat/utils/imports.dart';
import 'package:likeminds_flutter_sample/chat/views/chatroom/chatroom_components/Poll/constants/string_constant.dart';
import 'package:likeminds_flutter_sample/chat/views/chatroom/chatroom_components/Poll/helper%20widgets/helper_widgets.dart';

class PollSubmissionBottomSheet extends StatelessWidget {
  final String expiryTime;
  const PollSubmissionBottomSheet({Key? key, required this.expiryTime})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.w,
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      decoration: const BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(10.0),
        ),
      ),
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          children: <Widget>[
            verticalPaddingLarge,
            verticalPaddingLarge,
            Icon(
              Icons.check_circle,
              color: LMTheme.buttonColor,
              size: 45.sp,
            ),
            verticalPaddingLarge,
            Text(
              PollBubbleStringConstants.voteSubmissionSuccess,
              style: LMTheme.medium.copyWith(fontSize: 10.sp),
            ),
            verticalPaddingLarge,
            Text(
              PollBubbleStringConstants.voteSubmissionSuccessDescription,
              textAlign: TextAlign.center,
              style: LMTheme.regular.copyWith(
                color: grey3Color,
                fontSize: 10.sp,
              ),
            ),
            verticalPaddingLarge,
            Text(
              PollBubbleStringConstants.resultWillBeAnnounced,
              textAlign: TextAlign.center,
              style: LMTheme.medium.copyWith(
                color: LMTheme.buttonColor,
                fontSize: 10.sp,
              ),
            ),
            Text(
              expiryTime,
              textAlign: TextAlign.center,
              style: LMTheme.medium.copyWith(
                color: LMTheme.buttonColor,
                fontSize: 10.sp,
              ),
            ),
            verticalPaddingLarge,
            verticalPaddingLarge,
            getTextButton(
              text: "Continue",
              borderRadius: 15.0,
              padding: const EdgeInsets.symmetric(
                vertical: 10.0,
                horizontal: 40.0,
              ),
              onTap: () => Navigator.pop(context),
              backgroundColor: LMTheme.buttonColor,
              textAlign: TextAlign.center,
              textStyle: LMTheme.medium.copyWith(
                fontSize: 10.sp,
                color: whiteColor,
              ),
            ),
            verticalPaddingLarge,
            verticalPaddingLarge,
            verticalPaddingLarge,
          ],
        ),
      ),
    );
  }
}
