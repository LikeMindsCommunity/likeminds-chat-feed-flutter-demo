import 'package:likeminds_chat_fl/likeminds_chat_fl.dart';

class ConversationMessageState {
  static const int normal = 0;
  static const int firstMessage = 1;
  static const int memberJoinedOpenChatroom = 2;
  static const int memberLeftOpenChatroom = 3;
  static const int memberAddedToChatroom = 7;
  static const int memberLeftSecretChatroom = 8;
  static const int memberRemovedFromChatroom = 9;
  static const int poll = 10;
  static const int allMembersAdded = 11;
  static const int topicChanged = 12;
}

void filterOutStateMessage(List<Conversation> conversationList) {
  conversationList.removeWhere((element) {
    return element.state != null &&
        (element.state == ConversationMessageState.memberJoinedOpenChatroom ||
            element.state == ConversationMessageState.memberLeftOpenChatroom ||
            element.state == ConversationMessageState.memberLeftSecretChatroom);
  });
}

bool stateMessage(Conversation conversation) {
  if (conversation.state == ConversationMessageState.memberJoinedOpenChatroom ||
      conversation.state == ConversationMessageState.memberLeftOpenChatroom ||
      conversation.state == ConversationMessageState.memberLeftSecretChatroom) {
    return false;
  } else {
    return true;
  }
}
