part of 'media_bloc.dart';

abstract class MediaState extends Equatable {
  const MediaState();

  @override
  List<Object> get props => [];
}

class MediaInitial extends MediaState {}

class MediaUploading extends MediaState {}

class MediaUploaded extends MediaState {}
