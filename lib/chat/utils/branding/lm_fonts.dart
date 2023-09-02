import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LMFonts {
  // Singleton instance
  static LMFonts? _instance;
  static LMFonts get instance => _instance ??= LMFonts._internal();

  // Private constructor
  LMFonts._internal();

  // Fonts required fields
  TextStyle? _regular;
  TextStyle? _medium;
  TextStyle? _bold;

  TextStyle get regular => instance._regular!;
  TextStyle get medium => instance._medium!;
  TextStyle get bold => instance._bold!;

  LMFonts initialize({
    TextStyle? regular,
    TextStyle? medium,
    TextStyle? bold,
  }) {
    if (regular == null || medium == null || bold == null) {
      _setDefaults();
    } else {
      _regular = regular;
      _medium = medium;
      _bold = bold;
    }
    return this;
  }

  void _setDefaults() {
    _regular = GoogleFonts.roboto(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: Colors.black,
    );
    _medium = GoogleFonts.roboto(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: Colors.black,
    );
    _bold = GoogleFonts.roboto(
      fontSize: 14,
      fontWeight: FontWeight.w700,
      color: Colors.black,
    );
  }
}
