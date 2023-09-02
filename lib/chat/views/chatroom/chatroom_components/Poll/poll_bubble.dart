import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:likeminds_chat_fl/likeminds_chat_fl.dart';
import 'package:likeminds_flutter_sample/packages/expandable_text/expandable_text.dart';
import 'package:likeminds_flutter_sample/chat/navigation/router.dart';
import 'package:likeminds_flutter_sample/chat/utils/branding/theme.dart';
import 'package:likeminds_flutter_sample/chat/utils/constants/asset_constants.dart';
import 'package:likeminds_flutter_sample/chat/utils/imports.dart';
import 'package:likeminds_flutter_sample/chat/utils/local_preference/local_prefs.dart';
import 'package:likeminds_flutter_sample/chat/utils/utils.dart';
import 'package:likeminds_flutter_sample/chat/views/chatroom/bloc/chat_action_bloc/chat_action_bloc.dart';
import 'package:likeminds_flutter_sample/chat/views/chatroom/chatroom_components/Poll/bloc/poll_bloc.dart';
import 'package:likeminds_flutter_sample/chat/views/chatroom/chatroom_components/Poll/constants/poll_mapping.dart';
import 'package:likeminds_flutter_sample/chat/views/chatroom/chatroom_components/Poll/constants/string_constant.dart';
import 'package:likeminds_flutter_sample/chat/views/chatroom/chatroom_components/Poll/helper%20widgets/add_option_bottom_sheet.dart';
import 'package:likeminds_flutter_sample/chat/views/chatroom/chatroom_components/Poll/helper%20widgets/helper_widgets.dart';
import 'package:likeminds_flutter_sample/chat/views/chatroom/chatroom_components/Poll/helper%20widgets/poll_end_tile.dart';
import 'package:likeminds_flutter_sample/chat/views/chatroom/chatroom_components/Poll/helper%20widgets/poll_header.dart';
import 'package:likeminds_flutter_sample/chat/views/chatroom/chatroom_components/Poll/helper%20widgets/poll_option.dart';
import 'package:likeminds_flutter_sample/chat/views/chatroom/chatroom_components/Poll/helper%20widgets/poll_submission_bottom_sheet.dart';
import 'package:likeminds_flutter_sample/chat/views/chatroom/chatroom_components/Poll/utils/poll_submit_validator.dart';
import 'package:likeminds_flutter_sample/chat/widgets/custom_dialog.dart';
import 'package:overlay_support/overlay_support.dart';

class PollBubble extends StatefulWidget {
  final Conversation pollConversation;
  final int chatroomId;
  const PollBubble(
      {Key? key, required this.pollConversation, required this.chatroomId})
      : super(key: key);

  @override
  State<PollBubble> createState() => _PollBubbleState();
}

class _PollBubbleState extends State<PollBubble> {
  Conversation? pollConversation;
  bool isSubmitted = false;
  bool isEnabled = false;
  List<PollViewData> selectedOptions = [];
  PollBloc? pollBloc;
  ChatActionBloc? chatActionBloc;
  ValueNotifier<bool> pollEnableNotifier = ValueNotifier(false);

  User user = UserLocalPreference.instance.fetchUserData();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pollBloc = BlocProvider.of<PollBloc>(context);
    chatActionBloc = BlocProvider.of<ChatActionBloc>(context);
    initialise();
  }

  @override
  void didUpdateWidget(PollBubble oldWidget) {
    super.didUpdateWidget(oldWidget);
    initialise();
  }

  void initialise() {
    pollConversation = widget.pollConversation;
    selectedOptions = [];
    for (int i = 0; i < pollConversation!.poll!.pollViewDataList!.length; i++) {
      if (pollConversation!.poll!.pollViewDataList![i].isSelected!) {
        isSubmitted = true;
        selectedOptions.add(pollConversation!.poll!.pollViewDataList![i]);
      }
    }
    if (pollConversation!.poll!.multipleSelectState != null &&
        pollConversation!.poll!.multipleSelectNum != null) {
      isEnabled = PollSubmitValidator.checkMultiStatePollWithoutMessage(
          pollConversation!.poll!, selectedOptions);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: pollBloc,
      listener: (context, state) {
        if (state is PollOptionAdded &&
            state.conversationId == pollConversation!.id) {
          int index = pollConversation!.poll!.pollViewDataList!.indexWhere(
              (element) =>
                  element.id == state.addPollOptionResponse.temporaryId);
          pollConversation!.poll!.pollViewDataList![index].id =
              state.addPollOptionResponse.pollViewData!.id;
          pollEnableNotifier.value = !pollEnableNotifier.value;
        }
        if (state is PollOptionError &&
            state.conversationId == pollConversation!.id) {
          toast(state.errorMessage);
          pollConversation!.poll!.pollViewDataList!.removeWhere((element) =>
              element.id == state.addPollOptionRequest.temporaryId);
          pollEnableNotifier.value = !pollEnableNotifier.value;
        }
        if (state is SubmittedPoll &&
            state.conversationId == pollConversation!.id) {
          isSubmitted = true;
          if (pollConversation!.poll!.pollType == 1) {
            showModalBottomSheet(
              context: context,
              backgroundColor: Colors.transparent,
              elevation: 5,
              enableDrag: true,
              useSafeArea: true,
              isScrollControlled: true,
              builder: (context) => PollSubmissionBottomSheet(
                expiryTime: formatStringFromDateTime(
                  DateTime.fromMillisecondsSinceEpoch(
                      pollConversation!.expiryTime!),
                ),
              ),
            );
          }
          chatActionBloc!.add(UpdatePollConversation(
              conversationId: pollConversation!.id,
              chatroomId: widget.chatroomId));
        }
        if (state is PollSubmitError &&
            state.submitPollRequest.conversationId == pollConversation!.id) {
          toast(state.errorMessage);
        }
      },
      child: Container(
        width: 60.w,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Column(
          children: <Widget>[
            PollHeader(
              poll: pollConversation!.poll!,
            ),
            verticalPaddingLarge,
            PollEndTile(pollConversation: pollConversation!),
            verticalPaddingLarge,
            Align(
              alignment: Alignment.topLeft,
              child: ExpandableText(
                pollConversation!.answer,
                expandText: "",
                textAlign: TextAlign.left,
                style: LMTheme.regular.copyWith(fontSize: 9.sp),
              ),
            ),
            pollConversation!.poll!.multipleSelectNum != null &&
                    pollConversation!.multipleSelectState != null
                ? Container(
                    alignment: Alignment.topLeft,
                    margin: const EdgeInsets.only(top: paddingSmall),
                    child: Text(
                      "*Select ${toStringMultiSelectState(pollConversation!.multipleSelectState!)} ${toStringNoOfVotes(pollConversation!.poll!.multipleSelectNum!)}",
                      style: LMTheme.regular
                          .copyWith(fontSize: 9.sp, color: greyColor),
                    ),
                  )
                : const SizedBox(),
            verticalPaddingLarge,
            ValueListenableBuilder(
                valueListenable: pollEnableNotifier,
                builder: (context, _, __) {
                  return PollOptionList(
                    pollConversation: pollConversation!,
                    isSubmitted: isSubmitted,
                    selectedOptions: selectedOptions,
                    onTap: (PollViewData selectedOption) {
                      if (isPollEnded(DateTime.fromMillisecondsSinceEpoch(
                          pollConversation!.poll!.expiryTime!))) {
                        toast("Poll ended, Vote cannot be submitted now");
                        return;
                      }
                      if (isSubmitted &&
                          pollConversation!.poll!.pollType == 0) {
                        return;
                      } else {
                        if (isSubmitted) {
                          pollBloc!.add(EditPollSubmittion());
                        }
                        if (selectedOptions.contains(selectedOption)) {
                          selectedOptions.remove(selectedOption);
                          if (selectedOption.noVotes == null) {
                            selectedOption.noVotes = 0;
                          } else {
                            selectedOption.noVotes =
                                selectedOption.noVotes! - 1;
                          }
                          if (pollConversation!.poll!.multipleSelectState !=
                              null) {
                            isEnabled =
                                PollSubmitValidator.checkMultiSelectPoll(
                                    pollConversation!.poll!, selectedOptions);
                          }
                        } else {
                          if (pollConversation!.poll!.multipleSelectState !=
                                  null &&
                              pollConversation!.poll!.multipleSelectNum !=
                                  null) {
                            if ((pollConversation!.poll!.multipleSelectState ==
                                        0 ||
                                    pollConversation!
                                            .poll!.multipleSelectState ==
                                        1) &&
                                selectedOptions.length ==
                                    pollConversation!.poll!.multipleSelectNum) {
                              toast(
                                  "Please selected only ${pollConversation!.poll!.multipleSelectNum} options");

                              return;
                            } else {
                              if (selectedOption.noVotes == null) {
                                selectedOption.noVotes = 1;
                              } else {
                                selectedOption.noVotes =
                                    selectedOption.noVotes! + 1;
                              }
                              selectedOptions.add(selectedOption);

                              isEnabled =
                                  PollSubmitValidator.checkMultiSelectPoll(
                                      pollConversation!.poll!, selectedOptions);
                            }
                          } else {
                            if (selectedOptions.isNotEmpty) {
                              if (selectedOptions.first.noVotes == null) {
                                selectedOptions.first.noVotes = 0;
                              } else {
                                selectedOptions.first.noVotes =
                                    selectedOptions.first.noVotes! - 1;
                              }
                            }
                            if (selectedOption.noVotes == null) {
                              selectedOption.noVotes = 1;
                            } else {
                              selectedOption.noVotes =
                                  selectedOption.noVotes! + 1;
                            }
                            selectedOptions = [selectedOption];
                            PollSubmitValidator.checkNonMultiStatePoll(context,
                                pollConversation!.poll!, selectedOptions);
                          }
                        }
                      }
                      pollEnableNotifier.value = !pollEnableNotifier.value;
                    },
                  );
                }),
            !isSubmitted &&
                    pollConversation!.poll!.allowAddOption! &&
                    !isPollEnded(DateTime.fromMillisecondsSinceEpoch(
                        pollConversation!.poll!.expiryTime!))
                ? getTextButton(
                    width: 60.w,
                    alignment: Alignment.center,
                    text: PollBubbleStringConstants.addAnOption,
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    borderRadius: 8.0,
                    onTap: () async {
                      await showModalBottomSheet(
                          context: context,
                          backgroundColor: Colors.transparent,
                          elevation: 5,
                          useSafeArea: true,
                          isScrollControlled: true,
                          builder: (context) => AddPollOptionBottomSheet(
                                onOptionAdded: (String value) {
                                  int temporaryId =
                                      DateTime.now().millisecondsSinceEpoch;
                                  PollViewData newPollOption = PollViewData(
                                    text: value,
                                    conversationId: pollConversation!.id,
                                    noVotes: 0,
                                    isSelected: false,
                                    percentage: 0,
                                    id: temporaryId,
                                    memberId: user.id,
                                  );
                                  pollBloc!.add(AddPollOption(
                                      (AddPollOptionRequestBuilder()
                                            ..conversationId(
                                                pollConversation!.id)
                                            ..pollViewData(newPollOption)
                                            ..temporaryId(temporaryId))
                                          .build()));

                                  pollConversation!.poll!.pollViewDataList!.add(
                                    newPollOption,
                                  );
                                  pollEnableNotifier.value =
                                      !pollEnableNotifier.value;
                                },
                              ));
                    },
                    border: Border.all(
                      color: LMTheme.buttonColor,
                      width: 1,
                    ),
                  )
                : const SizedBox(),
            Align(
              alignment: Alignment.topLeft,
              child: TextButton(
                onPressed: pollConversation!.poll!.toShowResult! &&
                        pollConversation!.poll!.isAnonymous != true
                    ? () {
                        router.push(pollResultRoute, extra: pollConversation!);
                      }
                    : () {
                        if (pollConversation!.poll!.isAnonymous == true) {
                          showDialog(
                              context: context,
                              builder: (context) => LMCustomDialog(
                                    title: "Anonymous poll",
                                    showCancel: false,
                                    content:
                                        "This being an anonymous poll, the names of the voters can not be disclosed",
                                    actionText: "Okay",
                                    onActionPressed: () {},
                                  ));
                        }
                      },
                style: ButtonStyle(
                  padding:
                      MaterialStateProperty.all(const EdgeInsets.only(left: 3)),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  pollConversation!.poll!.pollAnswerText!,
                  style: LMTheme.medium.copyWith(
                    color: LMTheme.buttonColor,
                    fontSize: 8.sp,
                  ),
                ),
              ),
            ),
            ValueListenableBuilder(
                valueListenable: pollEnableNotifier,
                builder: (context, _, __) {
                  return !(isSubmitted &&
                              pollConversation!.poll!.pollType == 0) &&
                          pollConversation!.poll!.multipleSelectState != null &&
                          !isPollEnded(DateTime.fromMillisecondsSinceEpoch(
                              pollConversation!.poll!.expiryTime!))
                      ? Align(
                          alignment: Alignment.topLeft,
                          child: getSubmitButton(
                            iconWidget: SvgPicture.asset(
                              isSubmitted &&
                                      pollBloc!.state is! EditingPollSubmission
                                  ? assetPollEditIcon
                                  : assetPollSubmitIcon,
                              color: isEnabled
                                  ? LMTheme.buttonColor
                                  : greyBackgroundColor,
                              height: 12.sp,
                            ),
                            text: isSubmitted &&
                                    pollBloc!.state is! EditingPollSubmission
                                ? "EDIT VOTE"
                                : "SUBMIT VOTE",
                            textStyle: LMTheme.medium.copyWith(
                                color: isEnabled
                                    ? LMTheme.buttonColor
                                    : greyBackgroundColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 9.sp),
                            borderRadius: 24.0,
                            enabledColor: isEnabled
                                ? LMTheme.buttonColor
                                : greyBackgroundColor,
                            border: Border.all(
                              color: isEnabled
                                  ? LMTheme.buttonColor
                                  : greyBackgroundColor,
                              width: 2.0,
                            ),
                            onTap: () async {
                              if (pollBloc!.state is! EditingPollSubmission &&
                                  isSubmitted) {
                                pollBloc!.add(EditPollSubmittion());
                                pollConversation!.poll!.toShowResult = false;
                                isEnabled =
                                    PollSubmitValidator.checkMultiSelectPoll(
                                        pollConversation!.poll!,
                                        selectedOptions);
                                pollEnableNotifier.value =
                                    !pollEnableNotifier.value;
                              } else if (isEnabled &&
                                  (pollBloc!.state is EditingPollSubmission ||
                                      !isSubmitted)) {
                                SubmitPollRequest request =
                                    (SubmitPollRequestBuilder()
                                          ..conversationId(pollConversation!.id)
                                          ..polls(selectedOptions))
                                        .build();
                                pollBloc!.add(
                                    SubmitPoll(submitPollRequest: request));
                                pollEnableNotifier.value =
                                    !pollEnableNotifier.value;
                              }
                            },
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20.0,
                              vertical: 10.0,
                            ),
                          ),
                        )
                      : const SizedBox();
                }),
          ],
        ),
      ),
    );
  }
}
