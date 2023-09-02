part of 'profile_bloc.dart';

@immutable
abstract class ProfileEvent {}

class InitProfileEvent extends ProfileEvent {}

class ReportProfileEvent extends ProfileEvent {}

class BlockProfileEvent extends ProfileEvent {}

class UnBlockProfileEvent extends ProfileEvent {}

class EditProfileEvent extends ProfileEvent {}

class UploadPhotoEvent extends ProfileEvent {}
