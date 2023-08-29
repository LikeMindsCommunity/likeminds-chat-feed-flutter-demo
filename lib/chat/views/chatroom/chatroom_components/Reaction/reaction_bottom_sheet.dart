import 'package:likeminds_chat_fl/likeminds_chat_fl.dart';
import 'package:likeminds_flutter_sample/chat/utils/branding/theme.dart';
import 'package:likeminds_flutter_sample/chat/utils/imports.dart';
import 'package:likeminds_flutter_sample/chat/views/chatroom/bloc/chat_action_bloc/chat_action_bloc.dart';
import 'package:likeminds_flutter_sample/chat/widgets/picture_or_initial.dart';

class ReactionBottomSheet extends StatefulWidget {
  final ChatActionBloc chatActionBloc;
  final Map<String, List<Reaction>> mappedReactions;
  final Map<int, User?>? userMeta;
  final User currentUser;
  final Conversation conversation;

  const ReactionBottomSheet({
    Key? key,
    required this.mappedReactions,
    required this.userMeta,
    required this.currentUser,
    required this.chatActionBloc,
    required this.conversation,
  }) : super(key: key);

  @override
  State<ReactionBottomSheet> createState() => _ReactionBottomSheetState();
}

class _ReactionBottomSheetState extends State<ReactionBottomSheet> {
  String selectedKey = 'All';
  Map<String, List<Reaction>>? mappedReactions;
  Map<int, User?>? userMeta;
  User? currentUser;
  ChatActionBloc? chatActionBloc;
  Conversation? conversation;

  // Set data for bottom sheet
  void initialiseBottomSheetData() {
    mappedReactions = widget.mappedReactions;
    userMeta = widget.userMeta;
    currentUser = widget.currentUser;
    chatActionBloc = widget.chatActionBloc;
    conversation = widget.conversation;
  }

  @override
  Widget build(BuildContext context) {
    initialiseBottomSheetData();
    return Container(
      clipBehavior: Clip.none,
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      height: 60.h,
      decoration: const BoxDecoration(
        color: kWhiteColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12.0),
          topRight: Radius.circular(12.0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          kVerticalPaddingXLarge,
          kVerticalPaddingLarge,
          Text(
            'Reactions',
            style: LMTheme.bold,
          ),
          kVerticalPaddingXLarge,
          SizedBox(
            height: 40,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                          color: kGrey3Color.withOpacity(0.2), width: 1),
                    ),
                  ),
                  width: 100.w - 40,
                  height: 40,
                  child: ListView.builder(
                    itemCount: mappedReactions!.keys.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, reactionIndex) => GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedKey =
                              mappedReactions!.keys.elementAt(reactionIndex);
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 5.0),
                        decoration: BoxDecoration(
                            border: selectedKey ==
                                    mappedReactions!.keys
                                        .elementAt(reactionIndex)
                                ? Border(
                                    bottom: BorderSide(
                                      color: LMTheme.buttonColor,
                                      width: 1,
                                    ),
                                  )
                                : null),
                        child: Text(
                          '${mappedReactions!.keys.elementAt(reactionIndex)} (${mappedReactions!.values.elementAt(reactionIndex).length})',
                          style: selectedKey ==
                                  mappedReactions!.keys.elementAt(reactionIndex)
                              ? LMTheme.medium
                                  .copyWith(color: LMTheme.buttonColor)
                              : LMTheme.medium,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          kVerticalPaddingLarge,
          Expanded(
            child: ListView.builder(
              itemCount: mappedReactions![selectedKey]!.length,
              itemBuilder: (context, itemIndex) => Container(
                margin: const EdgeInsets.only(bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        PictureOrInitial(
                            imageUrl: userMeta![mappedReactions![selectedKey]![
                                            itemIndex]
                                        .userId]
                                    ?.imageUrl ??
                                '',
                            fallbackText: userMeta![mappedReactions![
                                            selectedKey]![itemIndex]
                                        .userId]
                                    ?.name ??
                                ''),
                        kHorizontalPaddingLarge,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userMeta![mappedReactions![selectedKey]![
                                              itemIndex]
                                          .userId]
                                      ?.name ??
                                  '',
                              style: LMTheme.bold,
                            ),
                            mappedReactions![selectedKey]![itemIndex].userId ==
                                    currentUser!.id
                                ? GestureDetector(
                                    onTap: () {
                                      chatActionBloc!.add(
                                        DeleteReaction(
                                            deleteReactionRequest:
                                                (DeleteReactionRequestBuilder()
                                                      ..conversationId(
                                                          conversation!.id)
                                                      ..reaction(mappedReactions![
                                                                  selectedKey]![
                                                              itemIndex]
                                                          .reaction))
                                                    .build()),
                                      );
                                      Navigator.pop(context);
                                    },
                                    child: Text('Tap to remove',
                                        style: LMTheme.regular
                                            .copyWith(color: kGrey3Color)),
                                  )
                                : const SizedBox()
                          ],
                        ),
                      ],
                    ),
                    Text(
                      mappedReactions![selectedKey]![itemIndex].reaction,
                      style: LMTheme.bold.copyWith(fontSize: 20.sp),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
