part of 'profile_bloc.dart';

@immutable
abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {}

class ProfileError extends ProfileState {}

class ReportProfile extends ProfileState {}

class EditProfile extends ProfileState {}

class UploadPhoto extends ProfileState {}
