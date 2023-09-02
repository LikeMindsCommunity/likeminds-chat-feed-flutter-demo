import 'package:flutter/material.dart';
import 'package:likeminds_flutter_sample/chat/utils/branding/lm_branding.dart';

class BigButton extends StatelessWidget {
  final String text;
  final double width;
  final Function()? onTap;
  final Color? color;

  const BigButton({
    super.key,
    required this.text,
    required this.width,
    this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        width: width,
        height: 48,
        decoration: BoxDecoration(
          color: color ?? LMBranding.instance.buttonColor,
          borderRadius: BorderRadius.circular(width / 16),
        ),
        child: Center(
          child: Text(
            text,
            style: LMBranding.instance.fonts.regular.copyWith(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ));
  }
}
