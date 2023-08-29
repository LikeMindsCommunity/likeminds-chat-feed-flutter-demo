import 'package:likeminds_chat_fl/likeminds_chat_fl.dart';
import 'package:likeminds_flutter_sample/chat/views/chatroom/chatroom_components/Poll/constants/poll_mapping.dart';
import 'package:likeminds_flutter_sample/chat/views/chatroom/chatroom_components/Poll/constants/string_constant.dart';

String getMultiSelectNoString(PollInfoData pollInfoData) {
  return "Select ${toStringMultiSelectState(pollInfoData.multipleSelectState!)} ${numOfVotes[pollInfoData.multipleSelectNum!]}*";
}
