import 'package:flutter/material.dart';
import 'package:likeminds_flutter_sample/chat/utils/branding/theme.dart';
import 'package:likeminds_flutter_sample/chat/utils/imports.dart';

class LMCustomDialog extends StatelessWidget {
  final String title;
  final String content;
  final String actionText;
  final Function() onActionPressed;
  final bool showCancel;

  const LMCustomDialog({
    Key? key,
    required this.title,
    required this.content,
    required this.actionText,
    required this.onActionPressed,
    this.showCancel = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title,
        style: LMTheme.bold.copyWith(fontSize: 10.sp),
      ),
      content: Text(
        content,
        style: LMTheme.regular.copyWith(fontSize: 9.sp),
      ),
      actions: [
        showCancel
            ? TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "Cancel",
                  style: LMTheme.bold.copyWith(color: kGrey3Color),
                ),
              )
            : const SizedBox(),
        TextButton(
          onPressed: () async {
            Navigator.pop(context);
            onActionPressed();
          },
          child: Text(
            actionText,
            style: LMTheme.bold.copyWith(
              color: LMTheme.buttonColor,
            ),
          ),
        ),
      ],
    );
  }
}
