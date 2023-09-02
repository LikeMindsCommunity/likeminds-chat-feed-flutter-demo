import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:likeminds_chat_fl/likeminds_chat_fl.dart';
import 'package:likeminds_flutter_sample/chat/navigation/router.dart';
import 'package:likeminds_flutter_sample/chat/service/likeminds_service.dart';
import 'package:likeminds_flutter_sample/chat/service/service_locator.dart';
import 'package:likeminds_flutter_sample/chat/utils/branding/theme.dart';
import 'package:likeminds_flutter_sample/chat/utils/imports.dart';
import 'package:likeminds_flutter_sample/chat/utils/realtime/realtime.dart';
import 'package:likeminds_flutter_sample/chat/utils/simple_bloc_observer.dart';
import 'package:likeminds_flutter_sample/chat/views/explore/bloc/explore_bloc.dart';
import 'package:likeminds_flutter_sample/chat/views/explore/explore_components/explore_item.dart';
import 'package:likeminds_flutter_sample/chat/views/explore/space_enum.dart';
import 'package:likeminds_flutter_sample/chat/widgets/bloc_error.dart';
import 'package:likeminds_flutter_sample/chat/widgets/page_skeleton.dart';
import 'package:likeminds_flutter_sample/chat/widgets/spinner.dart';
import 'package:likeminds_flutter_sample/chat/widgets/back_button.dart' as bb;

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  late Spaces _spaces;
  PagingController<int, ChatRoom> exploreFeedPagingController =
      PagingController<int, ChatRoom>(firstPageKey: 1);
  CustomPopupMenuController _controller = CustomPopupMenuController();
  ValueNotifier<bool> rebuildSpaces = ValueNotifier(false);
  ValueNotifier<bool> rebuildPin = ValueNotifier(false);
  ExploreBloc? exploreBloc;
  bool pinnedChatroom = false;
  int pinnedChatroomCount = 0;
  int _page = 1;

  @override
  void initState() {
    super.initState();
    Bloc.observer = SimpleBlocObserver();
    _spaces = Spaces.newest;
    exploreBloc = ExploreBloc();
    exploreBloc!.add(
      GetExplore(
        getExploreFeedRequest: (GetExploreFeedRequestBuilder()
              ..orderType(mapSpacesToInt())
              ..page(_page)
              ..pinned(pinnedChatroom))
            .build(),
      ),
    );
    _addPaginationListener();
  }

  int mapSpacesToInt() {
    switch (_spaces) {
      case Spaces.newest:
        return 0;
      case Spaces.active:
        return 1;
      case Spaces.mostMessages:
        return 2;
      case Spaces.mostParticipants:
        return 3;
    }
  }

  void refreshExploreFeed() {
    _page = 1;
    exploreFeedPagingController.itemList?.clear();
    exploreBloc?.add(
      GetExplore(
        getExploreFeedRequest: (GetExploreFeedRequestBuilder()
              ..orderType(mapSpacesToInt())
              ..page(_page)
              ..pinned(pinnedChatroom))
            .build(),
      ),
    );
  }

  _addPaginationListener() {
    exploreFeedPagingController.addPageRequestListener(
      (pageKey) {
        exploreBloc?.add(
          GetExplore(
            getExploreFeedRequest: (GetExploreFeedRequestBuilder()
                  ..orderType(mapSpacesToInt())
                  ..page(pageKey)
                  ..pinned(pinnedChatroom))
                .build(),
          ),
        );
      },
    );
  }

  String getStateSpace() {
    switch (_spaces) {
      case Spaces.newest:
        return "Newest";
      case Spaces.active:
        return "Recently Active";
      case Spaces.mostParticipants:
        return "Most Participants";
      case Spaces.mostMessages:
        return "Most Messages";
    }
  }

  Future onChoosingModal(context) => showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ListTile(
                  title: const Text("Newest"),
                  onTap: () {
                    _spaces = Spaces.newest;
                    rebuildSpaces.value = !rebuildSpaces.value;
                    refreshExploreFeed();
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: const Text("Recently Active"),
                  onTap: () {
                    _spaces = Spaces.active;
                    rebuildSpaces.value = !rebuildSpaces.value;
                    refreshExploreFeed();
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: const Text("Most Participants"),
                  onTap: () {
                    _spaces = Spaces.mostParticipants;
                    rebuildSpaces.value = !rebuildSpaces.value;
                    refreshExploreFeed();
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: const Text("Most Messages"),
                  onTap: () {
                    _spaces = Spaces.mostMessages;
                    rebuildSpaces.value = !rebuildSpaces.value;
                    refreshExploreFeed();
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        },
      );

  void markRead(int chatroomId, {bool toast = false}) async {
    final response = await locator<LikeMindsService>().markReadChatroom(
      (MarkReadChatroomRequestBuilder()..chatroomId(chatroomId)).build(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PageSkeleton(
      appBarChildren: [
        const bb.BackButton(),
        const SizedBox(width: 24),
        Text(
          "Explore Chatrooms",
          style: LMTheme.medium.copyWith(fontSize: 13.sp),
        ),
        const Spacer(),
      ],
      bodyChildren: [
        verticalPaddingSmall,
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomPopupMenu(
              pressType: PressType.singleClick,
              controller: _controller,
              showArrow: false,
              menuBuilder: () => Container(
                width: 50.w,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ListTile(
                      title: Text(
                        "Newest",
                        style: LMTheme.medium,
                      ),
                      onTap: () {
                        _controller.hideMenu();
                        _spaces = Spaces.newest;
                        rebuildSpaces.value = !rebuildSpaces.value;
                        refreshExploreFeed();
                      },
                    ),
                    ListTile(
                      title: Text(
                        "Recently Active",
                        style: LMTheme.medium,
                      ),
                      onTap: () {
                        _controller.hideMenu();
                        _spaces = Spaces.active;
                        rebuildSpaces.value = !rebuildSpaces.value;
                        refreshExploreFeed();
                      },
                    ),
                    ListTile(
                      title: Text(
                        "Most Participants",
                        style: LMTheme.medium,
                      ),
                      onTap: () {
                        _controller.hideMenu();
                        _spaces = Spaces.mostParticipants;
                        rebuildSpaces.value = !rebuildSpaces.value;
                        refreshExploreFeed();
                      },
                    ),
                    ListTile(
                      title: Text(
                        "Most Messages",
                        style: LMTheme.medium,
                      ),
                      onTap: () {
                        _controller.hideMenu();
                        _spaces = Spaces.mostMessages;
                        rebuildSpaces.value = !rebuildSpaces.value;
                        refreshExploreFeed();
                      },
                    ),
                  ],
                ),
              ),
              child: ValueListenableBuilder(
                  valueListenable: rebuildSpaces,
                  builder: (context, _, __) {
                    return Row(
                      children: [
                        Text(
                          getStateSpace(),
                          style: GoogleFonts.montserrat(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.arrow_downward,
                          size: 28,
                        ),
                      ],
                    );
                  }),
            ),
            const Spacer(),
            ValueListenableBuilder(
              valueListenable: rebuildPin,
              builder: (context, _, __) {
                return pinnedChatroomCount <= 3
                    ? const SizedBox()
                    : GestureDetector(
                        onTap: () {
                          pinnedChatroom = !pinnedChatroom;
                          rebuildPin.value = !rebuildPin.value;
                          refreshExploreFeed();
                          debugPrint("Pin button tapped");
                        },
                        child: pinnedChatroom
                            ? Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 5.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  border: Border.all(
                                    color: LMTheme.buttonColor,
                                  ),
                                ),
                                child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Container(
                                        height: 18.sp,
                                        width: 18.sp,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: LMTheme.buttonColor,
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.push_pin,
                                          size: 10.sp,
                                          color: LMTheme.buttonColor,
                                        ),
                                      ),
                                      horizontalPaddingSmall,
                                      Text(
                                        'Pinned',
                                        style: LMTheme.medium.copyWith(
                                            color: LMTheme.buttonColor),
                                      ),
                                      horizontalPaddingSmall,
                                      SizedBox(
                                        height: 18.sp,
                                        width: 18.sp,
                                        child: Icon(
                                          CupertinoIcons.xmark,
                                          size: 12.sp,
                                          color: LMTheme.buttonColor,
                                        ),
                                      ),
                                    ]),
                              )
                            : Container(
                                height: 18.sp,
                                width: 18.sp,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: dargreyColor,
                                  ),
                                ),
                                child: Icon(
                                  Icons.push_pin,
                                  size: 10.sp,
                                  color: dargreyColor,
                                ),
                              ),
                      );
              },
            ),
          ],
        ),
        verticalPaddingXLarge,
        Expanded(
          child: BlocConsumer<ExploreBloc, ExploreState>(
            bloc: exploreBloc,
            buildWhen: (previous, current) {
              if (current is ExploreLoading && _page != 1) {
                return false;
              }
              return true;
            },
            listener: (context, state) {
              if (state is ExploreLoaded) {
                pinnedChatroomCount =
                    state.getExploreFeedResponse.pinnedChatroomCount ?? 0;
                _page++;
                if (state.getExploreFeedResponse.chatrooms!.isEmpty) {
                  exploreFeedPagingController.appendLastPage([]);
                } else {
                  exploreFeedPagingController.appendPage(
                    state.getExploreFeedResponse.chatrooms!,
                    _page,
                  );
                }
                rebuildPin.value = !rebuildPin.value;
              } else if (state is ExploreError) {
                exploreFeedPagingController.error = state.errorMessage;
              }
            },
            builder: (context, state) {
              if (state is ExploreLoading) {
                return const Center(child: Spinner());
              }

              if (state is ExploreLoaded) {
                return PagedListView(
                  pagingController: exploreFeedPagingController,
                  padding: EdgeInsets.zero,
                  physics: const ClampingScrollPhysics(),
                  builderDelegate: PagedChildBuilderDelegate<ChatRoom>(
                    noItemsFoundIndicatorBuilder: (context) => Center(
                        child: Text(
                      "Opps, no chatrooms found!",
                      style: LMTheme.medium,
                    )),
                    itemBuilder: (context, item, index) => ExploreItem(
                      chatroom: item,
                      refresh: () => refresh(),
                      onTap: () {
                        LMRealtime.instance.chatroomId = item.id;
                        router.push("/chatroom/${item.id}");
                        markRead(item.id);
                      },
                    ),
                  ),
                );
              } else if (state is ExploreError) {
                return Center(
                  child: Text(state.errorMessage),
                );
              }
              return const BlocError();
            },
          ),
        ),
      ],
    );
  }

  void refresh() => setState(() {});
}
