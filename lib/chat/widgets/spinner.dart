import 'package:flutter/material.dart';
import 'package:likeminds_flutter_sample/chat/utils/branding/lm_branding.dart';

class Spinner extends StatelessWidget {
  final Color? color;

  const Spinner({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: color ?? LMBranding.instance.headerColor,
      ),
    );
  }
}
