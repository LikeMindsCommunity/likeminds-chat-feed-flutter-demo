import 'package:likeminds_chat_fl/likeminds_chat_fl.dart';
import 'package:likeminds_flutter_sample/chat/navigation/router.dart';
import 'package:likeminds_flutter_sample/chat/utils/branding/theme.dart';
import 'package:likeminds_flutter_sample/chat/utils/imports.dart';
import 'package:likeminds_flutter_sample/chat/widgets/custom_dialog.dart';

class PollOptionList extends StatefulWidget {
  final Conversation pollConversation;
  final List<PollViewData> selectedOptions;
  final Function(PollViewData) onTap;
  final bool isSubmitted;
  const PollOptionList({
    Key? key,
    required this.pollConversation,
    required this.selectedOptions,
    required this.isSubmitted,
    required this.onTap,
  }) : super(key: key);

  @override
  State<PollOptionList> createState() => _PollOptionListState();
}

class _PollOptionListState extends State<PollOptionList> {
  Conversation? pollConversation;

  @override
  Widget build(BuildContext context) {
    pollConversation = widget.pollConversation;
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemCount: pollConversation!.poll!.pollViewDataList!.length,
      itemBuilder: (context, index) => PollOption(
        selectedOptions: widget.selectedOptions,
        pollViewData: pollConversation!.poll!.pollViewDataList![index],
        pollConversation: pollConversation,
        onTap: widget.onTap,
      ),
    );
  }
}

class PollOption extends StatefulWidget {
  final PollViewData pollViewData;
  final List<PollViewData> selectedOptions;
  final Conversation? pollConversation;
  final Function(PollViewData) onTap;
  const PollOption({
    Key? key,
    required this.pollViewData,
    required this.selectedOptions,
    required this.pollConversation,
    required this.onTap,
  }) : super(key: key);

  @override
  State<PollOption> createState() => _PollOptionState();
}

class _PollOptionState extends State<PollOption> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    isSelected = widget.selectedOptions.contains(widget.pollViewData);
    return InkWell(
      onTap: () {
        widget.onTap(widget.pollViewData);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                clipBehavior: Clip.none,
                height: 45,
                width: widget.pollConversation!.poll!.toShowResult!
                    ? widget.pollViewData.percentage == null
                        ? 0
                        : (widget.pollViewData.percentage! * 60.w) / 100
                    : 0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: widget.pollConversation!.poll!.toShowResult!
                      ? isSelected
                          ? LMTheme.buttonColor.withOpacity(0.3)
                          : grey3Color.withOpacity(0.3)
                      : null,
                ),
              ),
              Container(
                width: 60.w,
                height: 45,
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: isSelected ? LMTheme.buttonColor : greyColor,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 40.w,
                      child: Text(
                        widget.pollViewData.text,
                        style: LMTheme.regular.copyWith(
                          color: greyColor,
                          fontSize: 9.sp,
                        ),
                      ),
                    ),
                    const Spacer(),
                    isSelected
                        ? Icon(
                            Icons.check_circle,
                            color: LMTheme.buttonColor,
                          )
                        : const SizedBox(),
                    horizontalPaddingSmall,
                  ],
                ),
              ),
            ],
          ),
          verticalPaddingXSmall,
          widget.pollConversation!.poll!.toShowResult!
              ? GestureDetector(
                  onTap: () {
                    if (!widget.pollConversation!.poll!.isAnonymous!) {
                      router.push(pollResultRoute,
                          extra: widget.pollConversation!);
                    } else {
                      showDialog(
                          context: context,
                          builder: (context) => LMCustomDialog(
                                title: "Anonymous poll",
                                showCancel: false,
                                content:
                                    "This being an anonymous poll, the names of the voters can not be disclosed",
                                actionText: "Okay",
                                onActionPressed: () {},
                              ));
                    }
                  },
                  child: Text(
                    "${widget.pollViewData.noVotes!} ${widget.pollViewData.noVotes! > 1 ? "votes" : "vote"}",
                    style: LMTheme.medium.copyWith(
                      color: isSelected ? LMTheme.buttonColor : greyColor,
                      fontSize: 8.sp,
                    ),
                  ),
                )
              : const SizedBox(),
          verticalPaddingMedium,
        ],
      ),
    );
  }
}
