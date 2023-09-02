import 'dart:collection';

import 'package:likeminds_chat_fl/likeminds_chat_fl.dart';
import 'package:likeminds_flutter_sample/chat/utils/imports.dart';

/*
* This function is used to get the position of a widget using
* the key associated with it 
* return Offset ( x and y coordinates of the widget )
*/
Offset getPositionOfChatBubble(GlobalKey widgetKey) {
  RenderBox? renderBox =
      widgetKey.currentContext?.findRenderObject() as RenderBox?;
  if (renderBox == null) {
    return const Offset(0, 0);
  }

  final Offset offset = renderBox.localToGlobal(Offset.zero);
  return offset;
}

/*
* Calculates the height of a widget using 
* the key associated with it 
*/
double? getHeightOfWidget(GlobalKey widgetKey) {
  RenderBox? renderBox =
      widgetKey.currentContext?.findRenderObject() as RenderBox?;
  if (renderBox == null) {
    return null;
  }
  return renderBox.size.height;
}

/*
* Calculates the width of a widget using 
* the key associated with it 
*/
double? getWidthOfWidget(GlobalKey widgetKey) {
  RenderBox? renderBox =
      widgetKey.currentContext?.findRenderObject() as RenderBox?;
  if (renderBox == null) {
    return null;
  }
  return renderBox.size.width;
}

// Adds a timestamp to the conversation list
List<Conversation>? addTimeStampInConversationList(
    List<Conversation>? conversationList, int communityId) {
  if (conversationList == null) {
    return conversationList;
  }
  LinkedHashMap<String, List<Conversation>> mappedConversations =
      LinkedHashMap<String, List<Conversation>>();

  for (Conversation conversation in conversationList) {
    if (conversation.isTimeStamp == null || !conversation.isTimeStamp!) {
      if (mappedConversations.containsKey(conversation.date)) {
        mappedConversations[conversation.date]!.add(conversation);
      } else {
        mappedConversations[conversation.date!] = <Conversation>[conversation];
      }
    }
  }
  List<Conversation> conversationListWithTimeStamp = <Conversation>[];
  mappedConversations.forEach(
    (key, value) {
      conversationListWithTimeStamp.addAll(value);
      conversationListWithTimeStamp.add(
        Conversation(
          isTimeStamp: true,
          answer: key,
          communityId: communityId,
          chatroomId: 0,
          createdAt: key,
          header: key,
          id: 0,
          pollAnswerText: key,
        ),
      );
    },
  );
  return conversationListWithTimeStamp;
}
