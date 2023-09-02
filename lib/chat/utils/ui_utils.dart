import 'package:flutter/material.dart';

//Generic method for getting height
double getHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

//Generic method for getting width
double getWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

//Utils method for getting initials of a name (or first letter of every word)
String getInitials(String? name) {
  if (name == null || name == "") {
    return "";
  }
  try {
    List<String> parts = name.split(' '); // Split on whitespace
    if (parts.last.characters.first == "(") {
      // Check if last part is a parantheses
      parts.remove(parts.last); // Remove parantheses
    }
    var initials = parts.map((e) => e.characters.first);
    if (initials.length > 2) {
      initials = initials.toList().sublist(0, 2);
    }
    String initialString = initials
        .reduce((_, e) => _ + e) // Reduce into single string
        .toUpperCase(); // Capitalize
    return initialString;
  } catch (e) {
    return name[0].toUpperCase();
  }
}

/* 
* extention for string to color 
* tries to parse string to int (hex code)
* then converts the hex into Color Object
*/
extension StringColor on String {
  Color? toColor() {
    // if (primaryColor != null) {
    if (int.tryParse(this) != null) {
      return Color(int.tryParse(this)!);
    } else {
      return null;
    }
  }
}

/*
* extention for string to bool
* tries to parse string to bool
* then converts the bool into bool Object
*/
extension StringToBool on String {
  bool toBoolean() {
    return (toLowerCase() == "true" || toLowerCase() == "1")
        ? true
        : (toLowerCase() == "false" || toLowerCase() == "0" ? false : false);
  }
}
