part of 'participants_bloc.dart';

abstract class ParticipantsEvent extends Equatable {
  const ParticipantsEvent();

  @override
  List<Object> get props => [];
}

class GetParticipants extends ParticipantsEvent {
  final GetParticipantsRequest getParticipantsRequest;

  const GetParticipants({required this.getParticipantsRequest});

  @override
  List<Object> get props => [getParticipantsRequest.toJson()];
}
