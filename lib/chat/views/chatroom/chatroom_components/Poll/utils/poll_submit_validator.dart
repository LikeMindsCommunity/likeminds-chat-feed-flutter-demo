import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:likeminds_chat_fl/likeminds_chat_fl.dart';

import 'package:likeminds_flutter_sample/chat/utils/imports.dart';
import 'package:likeminds_flutter_sample/chat/views/chatroom/chatroom_components/Poll/bloc/poll_bloc.dart';
import 'package:overlay_support/overlay_support.dart';

class PollSubmitValidator {
  static void checkNonMultiStatePoll(BuildContext context,
      PollInfoData pollInfoData, List<PollViewData> selectedOptions) {
    PollBloc pollBloc = BlocProvider.of<PollBloc>(context);
    // multi select state = exactly
    SubmitPollRequest request = (SubmitPollRequestBuilder()
          ..conversationId(pollInfoData.conversationId!)
          ..polls(selectedOptions))
        .build();

    pollBloc.add(SubmitPoll(submitPollRequest: request));
  }

  static bool checkMultiStatePollWithoutMessage(
      PollInfoData pollInfoData, List<PollViewData> selectedOptions) {
    // multi select state = exactly
    if (pollInfoData.multipleSelectState == 0) {
      if (selectedOptions.length == pollInfoData.multipleSelectNum!) {
        return true;
      } else {
        return false;
      }
    }
    // multi select state = at max
    else if (pollInfoData.multipleSelectState == 1) {
      if (selectedOptions.length <= pollInfoData.multipleSelectNum!) {
        return true;
      } else {
        return false;
      }
    }
    // multi select state = at least
    else if (pollInfoData.multipleSelectState == 2) {
      if (selectedOptions.length >= pollInfoData.multipleSelectNum!) {
        return true;
      } else {
        return false;
      }
    }
    return false;
  }

  static bool checkMultiSelectPoll(
      PollInfoData pollInfoData, List<PollViewData> selectedOptions) {
    // multi select state = exactly
    if (pollInfoData.multipleSelectState == 0) {
      if (selectedOptions.length == pollInfoData.multipleSelectNum!) {
        return true;
      } else {
        toast("Please select ${pollInfoData.multipleSelectNum} options");
        return false;
      }
    }
    // multi select state = at max
    else if (pollInfoData.multipleSelectState == 1) {
      if (selectedOptions.length <= pollInfoData.multipleSelectNum!) {
        return true;
      } else {
        toast("Please select ${pollInfoData.multipleSelectNum} options");
        return false;
      }
    }
    // multi select state = at least
    else if (pollInfoData.multipleSelectState == 2) {
      if (selectedOptions.length >= pollInfoData.multipleSelectNum!) {
        return true;
      } else {
        toast(
            "Please select at least ${pollInfoData.multipleSelectNum} options");
        return false;
      }
    }
    return false;
  }
}
