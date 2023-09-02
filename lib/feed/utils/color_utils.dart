import 'package:flutter/material.dart';

bool compareColors(Color? firstColor, Color? secondColor) {
  if (firstColor == null || secondColor == null) {
    return false;
  }
  if (firstColor.alpha == secondColor.alpha &&
      firstColor.red == secondColor.red &&
      firstColor.green == secondColor.green &&
      firstColor.blue == secondColor.blue &&
      firstColor.opacity == secondColor.opacity) {
    return true;
  } else {
    return false;
  }
}
