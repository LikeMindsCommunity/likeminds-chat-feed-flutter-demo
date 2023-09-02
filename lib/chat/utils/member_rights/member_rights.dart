import 'package:likeminds_chat_fl/likeminds_chat_fl.dart';

class MemberRightCheck {
  static bool checkRespondRights(MemberStateResponse? memberStateResponse) {
    if (memberStateResponse == null ||
        memberStateResponse.memberRights == null) {
      return true;
    }
    MemberRight? respondRights = memberStateResponse.memberRights
        ?.firstWhere((element) => element.state == 3);
    if (respondRights == null) {
      return true;
    } else {
      return respondRights.isSelected;
    }
  }
}
