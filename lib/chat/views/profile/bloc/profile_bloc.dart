import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitial()) {
    //Event state mapping
    on<InitProfileEvent>((event, emit) async {
      emit(ProfileLoading());
      await Future.delayed(const Duration(seconds: 2), () {
        emit(ProfileLoaded());
      });
    });

    on<ReportProfileEvent>((event, emit) {});
  }
}
