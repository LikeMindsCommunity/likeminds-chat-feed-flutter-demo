import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:likeminds_chat_fl/likeminds_chat_fl.dart';

import 'package:likeminds_flutter_sample/chat/utils/analytics/analytics.dart';
import 'package:likeminds_flutter_sample/chat/utils/branding/lm_fonts.dart';
import 'package:likeminds_flutter_sample/chat/utils/branding/theme.dart';
import 'package:likeminds_flutter_sample/chat/utils/imports.dart';
import 'package:likeminds_flutter_sample/chat/utils/ui_utils.dart';
import 'package:likeminds_flutter_sample/chat/views/chatroom/bloc/participants_bloc/participants_bloc.dart';

import 'package:likeminds_flutter_sample/chat/widgets/back_button.dart' as bb;
import 'package:likeminds_flutter_sample/chat/widgets/picture_or_initial.dart';

class ChatroomParticipantsPage extends StatefulWidget {
  final ChatRoom chatroom;
  const ChatroomParticipantsPage({super.key, required this.chatroom});

  @override
  State<ChatroomParticipantsPage> createState() =>
      _ChatroomParticipantsPageState();
}

class _ChatroomParticipantsPageState extends State<ChatroomParticipantsPage> {
  ParticipantsBloc? participantsBloc;
  FocusNode focusNode = FocusNode();
  String? searchTerm;
  final ValueNotifier<bool> rebuildSearchBar = ValueNotifier<bool>(false);
  final TextEditingController _searchController = TextEditingController();
  final PagingController<int, User> _pagingController =
      PagingController(firstPageKey: 1);
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    participantsBloc = ParticipantsBloc();
    participantsBloc!.add(
      GetParticipants(
        getParticipantsRequest: (GetParticipantsRequestBuilder()
              ..chatroomId(widget.chatroom.id)
              ..page(1)
              ..pageSize(10)
              ..search(searchTerm)
              ..isSecret(widget.chatroom.isSecret ?? false))
            .build(),
      ),
    );
    _addPaginationListener();
  }

  @override
  void dispose() {
    participantsBloc?.close();
    focusNode.dispose();
    _searchController.dispose();
    rebuildSearchBar.dispose();
    _pagingController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  int _page = 1;

  _addPaginationListener() {
    _pagingController.addPageRequestListener(
      (pageKey) {
        participantsBloc!.add(
          GetParticipants(
            getParticipantsRequest: (GetParticipantsRequestBuilder()
                  ..chatroomId(widget.chatroom.id)
                  ..page(pageKey)
                  ..pageSize(10)
                  ..search(searchTerm)
                  ..isSecret(widget.chatroom.isSecret ?? false))
                .build(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            ValueListenableBuilder(
              valueListenable: rebuildSearchBar,
              builder: (context, _, __) {
                return Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 4.w,
                    vertical: 2.h,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      rebuildSearchBar.value
                          ? const bb.BackButton()
                          : const SizedBox(),
                      rebuildSearchBar.value
                          ? kHorizontalPaddingXLarge
                          : const SizedBox(),
                      rebuildSearchBar.value
                          ? Expanded(
                              child: TextField(
                                focusNode: focusNode,
                                keyboardType: TextInputType.text,
                                textCapitalization: TextCapitalization.words,
                                controller: _searchController,
                                onChanged: (value) {
                                  if (_debounce?.isActive ?? false) {
                                    _debounce?.cancel();
                                  }
                                  _debounce = Timer(
                                    const Duration(milliseconds: 500),
                                    () {
                                      searchTerm = value;
                                      _page = 1;
                                      _pagingController.nextPageKey = 2;
                                      _pagingController.itemList = <User>[];
                                      participantsBloc!.add(
                                        GetParticipants(
                                          getParticipantsRequest:
                                              (GetParticipantsRequestBuilder()
                                                    ..chatroomId(
                                                        widget.chatroom.id)
                                                    ..page(1)
                                                    ..pageSize(10)
                                                    ..search(searchTerm)
                                                    ..isSecret(widget.chatroom
                                                            .isSecret ??
                                                        false))
                                                  .build(),
                                        ),
                                      );
                                    },
                                  );
                                },
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Search...",
                                  hintStyle: LMFonts.instance.regular.copyWith(
                                    color: kDarkGreyColor,
                                    fontSize: 12.sp,
                                  ),
                                ),
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const bb.BackButton(),
                                kHorizontalPaddingXLarge,
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Participants",
                                      style: LMFonts.instance.bold.copyWith(
                                        fontSize: 12.sp,
                                      ),
                                    ),
                                    kVerticalPaddingSmall,
                                    Text(
                                      "${widget.chatroom.participantCount ?? '--'} participants",
                                      style: LMFonts.instance.regular,
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 32),
                              ],
                            ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          if (rebuildSearchBar.value) {
                            searchTerm = null;
                            _searchController.clear();
                            _page = 1;
                            _pagingController.nextPageKey = 2;
                            _pagingController.itemList = <User>[];
                            participantsBloc!.add(
                              GetParticipants(
                                getParticipantsRequest:
                                    (GetParticipantsRequestBuilder()
                                          ..chatroomId(widget.chatroom.id)
                                          ..page(1)
                                          ..pageSize(10)
                                          ..search(searchTerm)
                                          ..isSecret(widget.chatroom.isSecret ??
                                              false))
                                        .build(),
                              ),
                            );
                          } else {
                            if (focusNode.canRequestFocus) {
                              focusNode.requestFocus();
                            }
                          }
                          rebuildSearchBar.value = !rebuildSearchBar.value;
                        },
                        child: Icon(
                          rebuildSearchBar.value
                              ? CupertinoIcons.xmark
                              : Icons.search,
                          size: 20.sp,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            Expanded(
              child: BlocConsumer(
                  bloc: participantsBloc,
                  listener: (context, state) {
                    if (state is ParticipantsLoaded) {
                      _page++;
                      if (state.getParticipantsResponse.participants!.isEmpty) {
                        _pagingController.appendLastPage(
                          state.getParticipantsResponse.participants!,
                        );
                      } else {
                        _pagingController.appendPage(
                          state.getParticipantsResponse.participants!,
                          _page,
                        );
                      }
                    } else if (state is ParticipantsError) {
                      _pagingController.error = state.message;
                    }
                  },
                  buildWhen: (prev, curr) {
                    if (curr is ParticipantsPaginationLoading) {
                      return false;
                    }
                    return true;
                  },
                  builder: (context, state) {
                    if (state is ParticipantsLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (state is ParticipantsLoaded) {
                      LMAnalytics.get()
                          .logEvent(AnalyticsKeys.viewChatroomParticipants, {
                        'chatroom_id': widget.chatroom.id,
                        'community_id': widget.chatroom.communityId,
                        'source': 'chatroom_overflow_menu',
                      });
                      return Column(
                        children: [
                          const SizedBox(height: 8),
                          Expanded(child: _buildParticipantsList()),
                        ],
                      );
                    } else if (state is ParticipantsError) {
                      return Center(
                        child: Text(state.message),
                      );
                    }
                    return const SizedBox();
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildParticipantsList() {
    return PagedListView(
      padding: EdgeInsets.zero,
      pagingController: _pagingController,
      physics: const ClampingScrollPhysics(),
      builderDelegate: PagedChildBuilderDelegate<User>(
        itemBuilder: (context, item, index) {
          return ParticipantItem(
            participant: item,
          );
        },
      ),
    );
  }
}

class ParticipantItem extends StatelessWidget {
  final User participant;
  final LMBranding lmBranding = LMBranding.instance;

  ParticipantItem({super.key, required this.participant});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: getWidth(context),
        height: 8.h,
        padding: EdgeInsets.symmetric(horizontal: 6.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            PictureOrInitial(
              fallbackText: participant.name,
              imageUrl: participant.imageUrl,
              size: 32.sp,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                participant.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: LMTheme.medium.copyWith(
                  fontSize: 12.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
