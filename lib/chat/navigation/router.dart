// GoRouter configuration
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:likeminds_chat_fl/likeminds_chat_fl.dart';
import 'package:likeminds_flutter_sample/chat/service/media_service.dart';
import 'package:likeminds_flutter_sample/chat/utils/branding/theme.dart';
import 'package:likeminds_flutter_sample/chat/utils/ui_utils.dart';
import 'package:likeminds_flutter_sample/chat/views/chatroom/bloc/chatroom_bloc.dart';
import 'package:likeminds_flutter_sample/chat/views/chatroom/bloc/participants_bloc/participants_bloc.dart';
import 'package:likeminds_flutter_sample/chat/views/chatroom/chatroom_components/Poll/helper%20widgets/poll_result.dart';
import 'package:likeminds_flutter_sample/chat/views/chatroom/chatroom_page.dart';
import 'package:likeminds_flutter_sample/chat/views/chatroom/views/chatroom_participants_page.dart';
import 'package:likeminds_flutter_sample/chat/views/conversation/bloc/conversation_bloc.dart';
import 'package:likeminds_flutter_sample/chat/views/media/media_forwarding.dart';
import 'package:likeminds_flutter_sample/chat/views/media/media_preview.dart';
import 'package:likeminds_flutter_sample/chat/views/explore/bloc/explore_bloc.dart';
import 'package:likeminds_flutter_sample/chat/views/explore/explore_page.dart';
import 'package:likeminds_flutter_sample/chat/views/home/home_page.dart';
import 'package:likeminds_flutter_sample/chat/views/profile/bloc/profile_bloc.dart';
import 'package:likeminds_flutter_sample/chat/views/profile/profile_page.dart';
import 'package:sizer/sizer.dart';

const startRoute = '/';
const homeRoute = '/home';
const chatRoute = '/chatroom/:id';
const participantsRoute = '/participants';
const exploreRoute = '/explore';
const profileRoute = '/profile';
const moderationRoute = '/moderation';
const mediaForwardRoute = '/media_forward/:chatroomId';
const mediaPreviewRoute = '/media_preview';
const pollResultRoute = '/poll_result';

final router = GoRouter(
  initialLocation: "/",
  routes: [
    GoRoute(
        path: startRoute,
        builder: (context, state) {
          return const HomePage();
        }),
    GoRoute(
        path: chatRoute,
        builder: (context, state) {
          return MultiBlocProvider(
            providers: [
              BlocProvider<ChatroomBloc>(
                create: (context) => ChatroomBloc()
                  ..add(
                    InitChatroomEvent((GetChatroomRequestBuilder()
                          ..chatroomId(int.parse(state.params['id'] ?? "0")))
                        .build()),
                  ),
              ),
              BlocProvider<ConversationBloc>(
                create: (context) => ConversationBloc(),
              ),
            ],
            child: ChatroomPage(
              chatroomId: int.parse(state.params['id'] ?? "0"),
              isRoot: state.queryParams['isRoot']?.toBoolean() ?? false,
            ),
          );
        }),
    GoRoute(
      path: exploreRoute,
      builder: (context, state) => BlocProvider(
        create: (context) => ExploreBloc()..add(InitExploreEvent()),
        child: const ExplorePage(),
      ),
    ),
    GoRoute(
      path: profileRoute,
      builder: (context, state) => BlocProvider(
        create: (context) => ProfileBloc()..add(InitProfileEvent()),
        child: const ProfilePage(),
      ),
    ),
    GoRoute(
      path: participantsRoute,
      builder: (context, state) => BlocProvider<ParticipantsBloc>(
        create: (context) => ParticipantsBloc(),
        child: ChatroomParticipantsPage(
          chatroom: state.extra as ChatRoom,
        ),
      ),
    ),
    GoRoute(
      path: mediaForwardRoute,
      name: "media_forward",
      builder: (context, state) => MediaForward(
        media: state.extra as List<Media>,
        chatroomId: int.parse(state.params['chatroomId']!),
      ),
    ),
    GoRoute(
      path: mediaPreviewRoute,
      name: "media_preview",
      builder: (context, state) => MediaPreview(
        conversationAttachments: (state.extra as List<dynamic>)[0],
        chatroom: (state.extra as List<dynamic>)[1],
        conversation: (state.extra as List<dynamic>)[2],
        userMeta: (state.extra as List<dynamic>)[3],
      ),
    ),
    GoRoute(
      path: pollResultRoute,
      name: "poll_result",
      builder: (context, state) =>
          PollResult(pollConversation: state.extra as Conversation),
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    backgroundColor: LMTheme.headerColor,
    body: Center(
      child: Text(
        "An error occurred\nTry again later",
        style: LMTheme.medium.copyWith(
          color: Colors.white,
          fontSize: 24.sp,
        ),
      ),
    ),
  ),
);
