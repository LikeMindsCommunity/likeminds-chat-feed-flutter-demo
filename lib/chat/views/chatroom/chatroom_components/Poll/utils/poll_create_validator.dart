import 'package:fluttertoast/fluttertoast.dart';
import 'package:likeminds_flutter_sample/chat/utils/imports.dart';
import 'package:likeminds_flutter_sample/chat/views/chatroom/chatroom_components/Poll/constants/string_constant.dart';

class PollCreateValidator {
  static bool enableSubmitButton(String title, int optionCount) {
    if (title.isNotEmpty && optionCount >= 2) {
      return true;
    }
    return false;
  }

  static bool validatePollQuestion(String value) {
    if (value.isEmpty) {
      Fluttertoast.showToast(msg: PollCreationStringConstants.pollTitleError);
      return false;
    }
    return true;
  }

  static bool validatePollOption(List<TextEditingController> options) {
    Set<String> optionsSet = {};
    for (TextEditingController option in options) {
      if (option.text.isNotEmpty) {
        if (optionsSet.contains(option.text)) {
          Fluttertoast.showToast(
              msg: PollCreationStringConstants.duplicateOptionsError);
          return false;
        }
        optionsSet.add(option.text);
      } else {
        Fluttertoast.showToast(
            msg: PollCreationStringConstants.enterPollOptionError);
        return false;
      }
    }
    return true;
  }

  static bool validateExpiryDate(String value) {
    if (value.isEmpty) {
      Fluttertoast.showToast(msg: PollCreationStringConstants.pollExpiryError);
      return false;
    }
    return true;
  }

  static bool validatePollSheet(String pollQuestion,
      List<TextEditingController> options, String expiryDate) {
    bool isPollQuestionValid = validatePollQuestion(pollQuestion);
    if (!isPollQuestionValid) return false;
    bool isPollOptionValid = validatePollOption(options);
    if (!isPollOptionValid) return false;
    bool isExpiryDateValid = validateExpiryDate(expiryDate);
    if (!isExpiryDateValid) return false;
    return true;
  }

  static bool validateAddPollOption(String value) {
    if (value.isEmpty) {
      return false;
    }
    return true;
  }
}
