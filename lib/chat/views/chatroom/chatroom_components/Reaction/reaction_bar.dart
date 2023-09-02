import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:likeminds_chat_fl/likeminds_chat_fl.dart';
import 'package:likeminds_flutter_sample/chat/service/likeminds_service.dart';
import 'package:likeminds_flutter_sample/chat/service/service_locator.dart';
import 'package:likeminds_flutter_sample/chat/utils/branding/theme.dart';
import 'package:likeminds_flutter_sample/chat/utils/imports.dart';
import 'package:likeminds_flutter_sample/chat/views/chatroom/bloc/chat_action_bloc/chat_action_bloc.dart';
import 'package:likeminds_flutter_sample/chat/views/chatroom/helper/reaction_helper.dart';
import 'package:overlay_support/overlay_support.dart';

class ReactionBar extends StatelessWidget {
  final ChatRoom chatroom;
  final Conversation conversation;
  final Conversation? replyToConversation;
  final User loggedinUser;

  const ReactionBar({
    Key? key,
    required this.chatroom,
    required this.conversation,
    required this.replyToConversation,
    required this.loggedinUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ChatActionBloc chatActionBloc = BlocProvider.of(context);
    return Align(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
            ),
            width: 90.w,
            height: 50,
            child: getListOfReactions(
              onTap: (String reaction) async {
                if (reaction == 'Add') {
                  chatActionBloc.add(ConversationToolBar(
                    selectedConversation: [conversation],
                    showReactionKeyboard: true,
                    showReactionBar: false,
                  ));
                } else {
                  if (!chatroom.followStatus!) {
                    Future<LMResponse> response = locator<LikeMindsService>()
                        .followChatroom((FollowChatroomRequestBuilder()
                              ..chatroomId(chatroom.id)
                              ..memberId(loggedinUser.id)
                              ..value(true))
                            .build())
                      ..then((value) {
                        if (value.success) {
                          toast("Chatroom joined");
                        }
                      });
                  }
                  PutReactionRequest request = (PutReactionRequestBuilder()
                        ..conversationId(conversation.id)
                        ..reaction(reaction))
                      .build();
                  chatActionBloc.add(PutReaction(putReactionRequest: request));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
