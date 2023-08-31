import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:likeminds_chat_fl/likeminds_chat_fl.dart';
import 'package:likeminds_feed_ui_fl/likeminds_feed_ui_fl.dart';
import 'package:likeminds_flutter_sample/chat/utils/branding/theme.dart';
import 'package:likeminds_flutter_sample/chat/utils/imports.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:likeminds_flutter_sample/chat/utils/local_preference/local_prefs.dart';
import 'package:likeminds_flutter_sample/chat/views/home/bloc/home_bloc.dart';
import 'package:likeminds_flutter_sample/chat/views/home/home_components/chat_item.dart';
import 'package:likeminds_flutter_sample/chat/views/home/home_components/explore_spaces_bar.dart';
import 'package:likeminds_flutter_sample/chat/views/home/home_components/skeleton_list.dart';
import 'package:likeminds_flutter_sample/chat/widgets/picture_or_initial.dart';
import 'package:likeminds_flutter_sample/feed/widgets/settings/settings_drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static refreshHomePage(BuildContext context) {
    final _HomePageState? state =
        context.findAncestorStateOfType<_HomePageState>();
    state?.clearAndUpdateHomePage();
  }

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  // String? communityName;
  String? userName;
  User? user;
  HomeBloc? homeBloc;
  ValueNotifier<bool> rebuildPagedList = ValueNotifier(false);
  ValueNotifier<bool> rebuildHomePage = ValueNotifier(false);
  PagingController<int, ChatItem> homeFeedPagingController =
      PagingController(firstPageKey: 1);

  int _pageKey = 1;

  @override
  void initState() {
    super.initState();

    UserLocalPreference userLocalPreference = UserLocalPreference.instance;
    userName = userLocalPreference.fetchUserData().name;
    // communityName = userLocalPreference.fetchCommunityData()["community_name"];
    homeBloc = BlocProvider.of<HomeBloc>(context);
    homeBloc!.add(
      InitHomeEvent(
        page: _pageKey,
      ),
    );
    _addPaginationListener();
  }

  _addPaginationListener() {
    homeFeedPagingController.addPageRequestListener(
      (pageKey) {
        homeBloc!.add(
          InitHomeEvent(
            page: pageKey,
          ),
        );
      },
    );
  }

  updatePagingControllers(HomeState state) {
    if (state is RefreshHomeState) {
      clearAndUpdateHomePage();
    }
    if (state is HomeLoaded) {
      if (state.page == 1) {
        homeFeedPagingController.itemList = [];
      }
      List<ChatItem> chatItems = getChats(context, state.response);
      _pageKey++;
      if (state.response.chatroomsData == null ||
          state.response.chatroomsData!.isEmpty ||
          state.response.chatroomsData!.length < 50) {
        homeFeedPagingController.appendLastPage(chatItems);
      } else {
        homeFeedPagingController.appendPage(chatItems, _pageKey);
      }
    } else if (state is UpdateHomeFeed) {
      List<ChatItem> chatItems = getChats(context, state.response);
      _pageKey = 2;
      homeFeedPagingController.nextPageKey = _pageKey;
      homeFeedPagingController.itemList = chatItems;
    }
  }

  void refresh() => homeFeedPagingController.refresh();

  // This function clears the paging controller
  // whenever user uses pull to refresh on feedroom screen
  void clearPagingController() {
    /* Clearing paging controller while changing the
     event to prevent duplication of list */
    if (homeFeedPagingController.itemList != null) {
      homeFeedPagingController.itemList!.clear();
    }
    _pageKey = 1;
  }

  void clearAndUpdateHomePage() async {
    rebuildHomePage.value = !rebuildHomePage.value;
    refresh();
    clearPagingController();
    homeBloc!.add(
      InitHomeEvent(
        page: _pageKey,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: rebuildHomePage,
      builder: (context, _, __) => Scaffold(
        key: scaffoldKey,
        drawer: SettingsDrawer(
            universalFeedRefreshCallback: clearAndUpdateHomePage),
        appBar: AppBar(
          backgroundColor: kWhiteColor,
          centerTitle: false,
          leading: GestureDetector(
            onTap: () {
              scaffoldKey.currentState?.openDrawer();
            },
            child: const LMIcon(
              type: LMIconType.icon,
              icon: Icons.menu,
              size: 24,
              color: Colors.black,
            ),
          ),
          title: GestureDetector(
            child: const LMTextView(
              text: "LikeMinds Sample",
              textAlign: TextAlign.start,
              textStyle: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          elevation: 1,
        ),
        body: Column(
          children: [
            ExploreSpacesBar(backgroundColor: LMTheme.buttonColor),
            Expanded(
              child: BlocConsumer<HomeBloc, HomeState>(
                bloc: homeBloc,
                listener: (context, state) {
                  updatePagingControllers(state);
                },
                buildWhen: (previous, current) {
                  if (previous is HomeLoaded && current is HomeLoading) {
                    return false;
                  } else if (previous is UpdateHomeFeed &&
                      current is HomeLoading) {
                    return false;
                  }
                  return true;
                },
                builder: (context, state) {
                  if (state is HomeLoading) {
                    return const SkeletonChatList();
                  } else if (state is HomeError) {
                    return Center(
                      child: Text(state.message),
                    );
                  } else if (state is HomeLoaded ||
                      state is UpdateHomeFeed ||
                      state is UpdatedHomeFeed) {
                    return SafeArea(
                      top: false,
                      child: ValueListenableBuilder(
                          valueListenable: rebuildPagedList,
                          builder: (context, _, __) {
                            return PagedListView<int, ChatItem>(
                              pagingController: homeFeedPagingController,
                              padding: EdgeInsets.zero,
                              physics: const ClampingScrollPhysics(),
                              builderDelegate:
                                  PagedChildBuilderDelegate<ChatItem>(
                                newPageProgressIndicatorBuilder: (_) =>
                                    const SizedBox(),
                                noItemsFoundIndicatorBuilder: (context) =>
                                    const SizedBox(),
                                itemBuilder: (context, item, index) {
                                  return item;
                                },
                              ),
                            );
                          }),
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<ChatItem> getChats(BuildContext context, GetHomeFeedResponse response) {
    List<ChatItem> chats = [];
    final List<ChatRoom> chatrooms = response.chatroomsData ?? [];
    final Map<String, Conversation> lastConversations =
        response.conversationMeta ?? {};
    final Map<int, User> userMeta = response.userMeta ?? {};

    for (int i = 0; i < chatrooms.length; i++) {
      final Conversation conversation =
          lastConversations[chatrooms[i].lastConversationId.toString()]!;
      chats.add(
        ChatItem(
          chatroom: chatrooms[i],
          conversation: conversation,
          attachmentsMeta: response
                  .conversationAttachmentsMeta?[conversation.id.toString()] ??
              [],
          user: userMeta[conversation.member?.id ?? conversation.userId],
        ),
      );
    }

    return chats;
  }
}

Widget getShimmer() => Shimmer.fromColors(
      baseColor: Colors.grey.shade200,
      highlightColor: Colors.grey.shade300,
      period: const Duration(seconds: 2),
      direction: ShimmerDirection.ltr,
      child: Padding(
        padding: const EdgeInsets.only(
          bottom: 12,
        ),
        child: Container(
          height: 16,
          width: 32.w,
          color: kWhiteColor,
        ),
      ),
    );
