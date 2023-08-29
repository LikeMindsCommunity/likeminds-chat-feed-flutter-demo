import 'package:likeminds_chat_fl/likeminds_chat_fl.dart';
import 'package:likeminds_flutter_sample/chat/utils/branding/theme.dart';
import 'package:likeminds_flutter_sample/chat/utils/imports.dart';
import 'package:likeminds_flutter_sample/chat/utils/utils.dart';
import 'package:likeminds_flutter_sample/chat/views/chatroom/chatroom_components/Poll/constants/string_constant.dart';
import 'package:likeminds_flutter_sample/chat/views/chatroom/chatroom_components/Poll/helper%20widgets/helper_widgets.dart';

class PollEndTile extends StatelessWidget {
  final Conversation pollConversation;
  const PollEndTile({
    Key? key,
    required this.pollConversation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime endTime =
        DateTime.fromMillisecondsSinceEpoch(pollConversation.poll!.expiryTime!);

    return SizedBox(
      width: 60.w,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: LMTheme.buttonColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.bar_chart_rounded,
              color: kWhiteColor,
              size: 8.sp,
            ),
          ),
          getTextButton(
            text: isPollEnded(endTime)
                ? PollBubbleStringConstants.pollEnded
                : "Ends in ${getExpiryTimeString(endTime)}",
            textStyle: LMTheme.medium.copyWith(
              color: kWhiteColor,
              fontSize: 8.sp,
            ),
            backgroundColor:
                isPollEnded(endTime) ? Colors.red : LMTheme.buttonColor,
            borderRadius: 10.w,
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            onTap: null,
          ),
        ],
      ),
    );
  }
}
