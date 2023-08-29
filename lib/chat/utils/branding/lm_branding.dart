import 'package:flutter/material.dart';
import 'package:likeminds_flutter_sample/chat/utils/branding/lm_fonts.dart';
import 'package:likeminds_flutter_sample/chat/utils/constants/ui_constants.dart';

class LMBranding {
  // Singleton instance
  static LMBranding? _instance;
  static LMBranding get instance => _instance ??= LMBranding._internal();

  // Branding required fields
  Color? _headerColor;
  Color? _buttonColor;
  Color? _textLinkColor;

  // Branding optional fields
  LMFonts? _fonts;

  // Private constructor
  LMBranding._internal();

  // Initialize
  LMBranding initialize({
    Color? headerColor,
    Color? buttonColor,
    Color? textLinkColor,
    LMFonts? fonts,
  }) {
    if (headerColor == null || buttonColor == null || textLinkColor == null) {
      _setDefaults();
    } else {
      _headerColor = headerColor;
      _buttonColor = buttonColor;
      _textLinkColor = textLinkColor;
    }

    if (fonts != null) {
      _fonts = fonts;
    } else {
      _fonts = LMFonts.instance.initialize();
    }

    return this;
  }

  void _setDefaults() {
    _headerColor = kPrimaryColor;
    _buttonColor = kPrimaryColor;
    _textLinkColor = kPrimaryColor;
  }

  // Getters
  Color get headerColor => instance._headerColor!;
  Color get buttonColor => instance._buttonColor!;
  Color get textLinkColor => instance._textLinkColor!;
  LMFonts get fonts => instance._fonts!;
}
