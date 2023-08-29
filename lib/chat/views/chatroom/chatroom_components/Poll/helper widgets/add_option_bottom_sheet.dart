import 'package:flutter/cupertino.dart';
import 'package:likeminds_flutter_sample/chat/utils/branding/theme.dart';
import 'package:likeminds_flutter_sample/chat/utils/imports.dart';
import 'package:likeminds_flutter_sample/chat/views/chatroom/chatroom_components/Poll/constants/string_constant.dart';
import 'package:likeminds_flutter_sample/chat/views/chatroom/chatroom_components/Poll/helper%20widgets/helper_widgets.dart';
import 'package:likeminds_flutter_sample/chat/views/chatroom/chatroom_components/Poll/utils/poll_create_validator.dart';

class AddPollOptionBottomSheet extends StatefulWidget {
  final Function(String) onOptionAdded;
  const AddPollOptionBottomSheet({
    Key? key,
    required this.onOptionAdded,
  }) : super(key: key);

  @override
  State<AddPollOptionBottomSheet> createState() =>
      _AddPollOptionBottomSheetState();
}

class _AddPollOptionBottomSheetState extends State<AddPollOptionBottomSheet> {
  TextEditingController optionEditingController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    optionEditingController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    optionEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minHeight: 40.h,
      ),
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 25.0,
          right: 25.0),
      decoration: const BoxDecoration(
        color: kWhiteColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(10.0),
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              kVerticalPaddingLarge,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    PollBubbleStringConstants.addNewPollOption,
                    style: LMTheme.medium,
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(CupertinoIcons.xmark),
                    ),
                  ),
                ],
              ),
              kVerticalPaddingMedium,
              Text(
                PollBubbleStringConstants.addNewPollOptionDescription,
                style: LMTheme.medium.copyWith(
                  color: kGreyColor,
                  fontSize: 10.sp,
                ),
              ),
              kVerticalPaddingLarge,
              kVerticalPaddingLarge,
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                decoration: BoxDecoration(
                    border: Border.all(
                      color: LMTheme.buttonColor,
                      width: 1.3,
                    ),
                    borderRadius: BorderRadius.circular(10.0)),
                child: getOptionsTile(
                  optionEditingController,
                  null,
                  PollBubbleStringConstants.typeNewOption,
                ),
              ),
              kVerticalPaddingLarge,
              kVerticalPaddingLarge,
              Align(
                alignment: Alignment.center,
                child: getTextButton(
                  text: "Post",
                  backgroundColor: PollCreateValidator.validateAddPollOption(
                          optionEditingController.text)
                      ? LMTheme.buttonColor
                      : kLightGreyColor,
                  onTap: () {
                    if (PollCreateValidator.validateAddPollOption(
                        optionEditingController.text)) {
                      widget.onOptionAdded(optionEditingController.text);
                      Navigator.pop(context);
                    } else {
                      return;
                    }
                  },
                  borderRadius: 20,
                  padding: EdgeInsets.symmetric(
                    horizontal: 15.w,
                    vertical: 2.w,
                  ),
                  textStyle: LMTheme.medium.copyWith(
                    color: kWhiteColor,
                    fontSize: 13.sp,
                  ),
                ),
              ),
              kVerticalPaddingLarge,
            ],
          ),
        ),
      ),
    );
  }
}
