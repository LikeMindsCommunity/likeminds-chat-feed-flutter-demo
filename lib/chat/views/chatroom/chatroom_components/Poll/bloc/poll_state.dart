part of 'poll_bloc.dart';

class PollState extends Equatable {
  @override
  List<Object?> get props => [];
}

class PollInitial extends PollState {
  @override
  List<Object?> get props => [];
}

class PollUsers extends PollState {
  final GetPollUsersResponse getPollUsersResponse;

  PollUsers({
    required this.getPollUsersResponse,
  });

  @override
  List<Object?> get props => [
        getPollUsersResponse,
      ];
}

class PollUsersLoading extends PollState {
  final GetPollUsersRequest getPollUsersRequest;

  PollUsersLoading({
    required this.getPollUsersRequest,
  });

  @override
  List<Object?> get props => [
        getPollUsersRequest,
      ];
}

class PollUsersError extends PollState {
  final String errorMessage;
  final GetPollUsersRequest getPollUsersRequest;

  PollUsersError({
    required this.errorMessage,
    required this.getPollUsersRequest,
  });

  @override
  List<Object?> get props => [
        errorMessage,
        getPollUsersRequest,
      ];
}

class SubmittedPoll extends PollState {
  final SubmitPollResponse submitPollResponse;
  final int conversationId;

  SubmittedPoll({
    required this.submitPollResponse,
    required this.conversationId,
  });

  @override
  List<Object?> get props => [
        submitPollResponse,
        conversationId,
      ];
}

class UpdatedPoll extends PollState {
  final GetConversationResponse getConversationResponse;
  final int conversationId;

  UpdatedPoll({
    required this.getConversationResponse,
    required this.conversationId,
  });

  @override
  List<Object?> get props => [
        getConversationResponse,
        conversationId,
      ];
}

class PollSubmitError extends PollState {
  final String errorMessage;
  final SubmitPollRequest submitPollRequest;

  PollSubmitError({
    required this.errorMessage,
    required this.submitPollRequest,
  });

  @override
  List<Object?> get props => [
        errorMessage,
        submitPollRequest,
      ];
}

class PollOptionAdded extends PollState {
  final AddPollOptionResponse addPollOptionResponse;
  final int conversationId;

  PollOptionAdded({
    required this.addPollOptionResponse,
    required this.conversationId,
  });

  @override
  List<Object?> get props => [
        addPollOptionResponse,
        conversationId,
      ];
}

class PollOptionError extends PollState {
  final String errorMessage;
  final AddPollOptionRequest addPollOptionRequest;
  final int conversationId;

  PollOptionError({
    required this.errorMessage,
    required this.addPollOptionRequest,
    required this.conversationId,
  });

  @override
  List<Object?> get props => [
        errorMessage,
        addPollOptionRequest,
        conversationId,
      ];
}

class EditingPollSubmission extends PollState {
  final int time = DateTime.now().millisecondsSinceEpoch;
  EditingPollSubmission();

  @override
  List<Object?> get props => [time];
}
