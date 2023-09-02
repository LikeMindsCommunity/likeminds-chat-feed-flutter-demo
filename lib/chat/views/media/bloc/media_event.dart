part of 'media_bloc.dart';

abstract class MediaEvent extends Equatable {
  const MediaEvent();

  @override
  List<Object> get props => [];
}

class InitMediaEvent extends MediaEvent {}

class PickImageEvent extends MediaEvent {}

class OpenCameraEvent extends MediaEvent {}

class UploadImageEvent extends MediaEvent {}
