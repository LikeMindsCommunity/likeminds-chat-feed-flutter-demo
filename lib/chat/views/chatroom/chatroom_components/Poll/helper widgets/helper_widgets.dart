import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:likeminds_chat_fl/likeminds_chat_fl.dart';
import 'package:likeminds_flutter_sample/chat/utils/branding/theme.dart';
import 'package:likeminds_flutter_sample/chat/utils/imports.dart';
import 'package:likeminds_flutter_sample/chat/views/chatroom/chatroom_components/Poll/constants/string_constant.dart';
import 'package:likeminds_flutter_sample/chat/widgets/picture_or_initial.dart';

Widget getDropDownText(String text, MainAxisAlignment mainAxisAlignment) {
  return Row(
    mainAxisAlignment: mainAxisAlignment,
    children: [
      Container(
        decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: kGrey3Color, width: 1.5))),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(text,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: LMTheme.medium),
            kHorizontalPaddingLarge,
            const Icon(
              Icons.arrow_drop_down,
              color: kBlackColor,
            ),
          ],
        ),
      ),
    ],
  );
}

// This function is used to get a text field with a label
Widget getOptionsTile(TextEditingController textEditingController,
    TextStyle? subHeaderStyle, String hintText,
    {bool enabled = true, Color? textColor}) {
  return AbsorbPointer(
    absorbing: !enabled,
    child: TextFormField(
      controller: textEditingController,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.only(top: 10),
        hintStyle: subHeaderStyle?.copyWith(
          color: kGreyColor,
        ),
        hintText: hintText,
        border: InputBorder.none,
      ),
    ),
  );
}

// This function is used to get a toggle button with text
Widget getToggleButtonWithText({
  required bool status,
  required Widget text,
  Color? enabledColor,
  Function(bool)? onChanged,
}) {
  return SizedBox(
    width: 90.w,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          child: text,
        ),
        kHorizontalPaddingMedium,
        Switch(
          value: status,
          onChanged: onChanged,
          activeColor: enabledColor,
        )
      ],
    ),
  );
}

// This function is used to get a text button with a background color
Widget getTextButton({
  required String text,
  Color? backgroundColor,
  double? width,
  TextStyle? textStyle,
  EdgeInsets? padding,
  double? borderRadius,
  BoxBorder? border,
  Function()? onTap,
  Alignment? alignment,
  TextAlign textAlign = TextAlign.left,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: padding,
      alignment: alignment,
      width: width,
      decoration: BoxDecoration(
        color: backgroundColor,
        border: border,
        borderRadius:
            borderRadius == null ? null : BorderRadius.circular(borderRadius),
      ),
      child: Text(
        text,
        style: textStyle,
        textAlign: textAlign,
      ),
    ),
  );
}

Widget getSubmitButton({
  required String text,
  Color? backgroundColor,
  Color? enabledColor,
  double? width,
  TextStyle? textStyle,
  EdgeInsets? padding,
  double? borderRadius,
  BoxBorder? border,
  Function()? onTap,
  required Widget iconWidget,
  Alignment? alignment,
  TextAlign textAlign = TextAlign.left,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: padding,
      alignment: alignment,
      width: width,
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: border,
        borderRadius:
            borderRadius == null ? null : BorderRadius.circular(borderRadius),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          iconWidget,
          kHorizontalPaddingMedium,
          Text(
            text,
            style: textStyle,
            textAlign: textAlign,
          ),
        ],
      ),
    ),
  );
}

Widget getVotingType(int optionsCount, Function onTypeSelect,
    Function onNumVotesSelect, String? votingType, String? numVotes) {
  CustomPopupMenuController voteTypeController = CustomPopupMenuController();
  CustomPopupMenuController numVotesController = CustomPopupMenuController();
  List<String> noOfSelectableVotes = List.generate(optionsCount + 1, (index) {
    return numOfVotes[index];
  });
  return SizedBox(
    width: 90.w,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(PollCreationStringConstants.votingTypeText,
            style: LMTheme.medium.copyWith(color: kGrey3Color)),
        kVerticalPaddingMedium,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: PopupMenuButton(
                onSelected: (value) => onTypeSelect(value),
                itemBuilder: (context) => usersCanVoteForList
                    .map(
                      (e) => PopupMenuItem(
                        value: e,
                        child: ListTile(
                          title: Text(e),
                        ),
                      ),
                    )
                    .toList(),
                child: getDropDownText(votingType ?? usersCanVoteForList[0],
                    MainAxisAlignment.start),
              ),
            ),
            const Text("="),
            Expanded(
              child: PopupMenuButton(
                onSelected: (value) => onNumVotesSelect(value),
                itemBuilder: (context) => noOfSelectableVotes
                    .map(
                      (e) => PopupMenuItem(
                        value: e,
                        child: ListTile(
                          title: Text(e),
                        ),
                      ),
                    )
                    .toList(),
                child: getDropDownText(
                    numVotes ?? numOfVotes[0], MainAxisAlignment.end),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

// This function is used to convert DateTime object into string in the format dd-MM-yy
String formatDate(DateTime dateTime) {
  return DateFormat("dd-MM-yyyy").format(dateTime);
}

String getMonthFromInt(int month) {
  switch (month) {
    case 1:
      return "Jan";
    case 2:
      return "Feb";
    case 3:
      return "Mar";
    case 4:
      return "Apr";
    case 5:
      return "May";
    case 6:
      return "Jun";
    case 7:
      return "Jul";
    case 8:
      return "Aug";
    case 9:
      return "Sep";
    case 10:
      return "Oct";
    case 11:
      return "Nov";
    case 12:
      return "Dec";
    default:
      return "";
  }
}

String formatStringFromDateTime(DateTime dateTime) {
  return "${dateTime.day} ${getMonthFromInt(dateTime.month)} ${dateTime.year} at ${DateFormat("hh:mm").format(dateTime)}";
}

// This function is used to convert TimeOfDay object into string in the format HH:mm
String formatTime(TimeOfDay timeOfDay) {
  String hour = timeOfDay.hour.toString().padLeft(2, '0');
  String minute = timeOfDay.minute.toString().padLeft(2, '0');
  return "$hour:$minute";
}

Widget getPollResultTile(User user) {
  return Container(
    width: 100.w,
    margin: const EdgeInsets.only(top: 10.0),
    padding: const EdgeInsets.symmetric(
      horizontal: 20.0,
    ),
    child: Row(
      children: <Widget>[
        PictureOrInitial(
          fallbackText: user.name,
          imageUrl: user.imageUrl,
          backgroundColor: LMTheme.buttonColor,
          size: 15.w,
        ),
        kHorizontalPaddingLarge,
        Expanded(
          child: Container(
            height: 15.w,
            decoration: const BoxDecoration(
                border:
                    Border(bottom: BorderSide(color: kGreyColor, width: 0.5))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  user.name,
                  style: LMTheme.medium,
                ),
                kVerticalPaddingMedium,
                Text(
                  user.memberSince ?? '',
                  style: LMTheme.medium.copyWith(color: kGreyColor),
                ),
              ],
            ),
          ),
        )
      ],
    ),
  );
}
