part of 'poll_bloc.dart';

class PollEvents extends Equatable {
  @override
  List<Object?> get props => [];
}

class SubmitPoll extends PollEvents {
  final SubmitPollRequest submitPollRequest;

  SubmitPoll({
    required this.submitPollRequest,
  });

  @override
  List<Object?> get props => [submitPollRequest];
}

class UpdatePoll extends PollEvents {
  final GetConversationRequest getConversationRequest;

  UpdatePoll({
    required this.getConversationRequest,
  });

  @override
  List<Object?> get props => [getConversationRequest];
}

class GetPollUsers extends PollEvents {
  final GetPollUsersRequest getPollUsersRequest;

  GetPollUsers({
    required this.getPollUsersRequest,
  });

  @override
  List<Object?> get props => [getPollUsersRequest];
}

class AddPollOption extends PollEvents {
  final AddPollOptionRequest addPollOptionRequest;

  AddPollOption(
    this.addPollOptionRequest,
  );

  @override
  List<Object?> get props => [
        addPollOptionRequest,
      ];
}

class EditPollSubmittion extends PollEvents {
  final int time = DateTime.now().millisecondsSinceEpoch;
  EditPollSubmittion();

  @override
  List<Object?> get props => [time];
}
