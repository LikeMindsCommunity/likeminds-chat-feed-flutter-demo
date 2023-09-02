part of 'participants_bloc.dart';

abstract class ParticipantsState extends Equatable {
  const ParticipantsState();

  @override
  List<Object> get props => [];
}

class ParticipantsInitial extends ParticipantsState {
  const ParticipantsInitial();
}

class ParticipantsLoading extends ParticipantsState {
  const ParticipantsLoading();
}

class ParticipantsPaginationLoading extends ParticipantsState {
  const ParticipantsPaginationLoading();
}

class ParticipantsLoaded extends ParticipantsState {
  final GetParticipantsResponse getParticipantsResponse;

  const ParticipantsLoaded({required this.getParticipantsResponse});
}

class ParticipantsError extends ParticipantsState {
  final String message;

  const ParticipantsError(this.message);
}
