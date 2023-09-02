import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'media_event.dart';
part 'media_state.dart';

class MediaBloc extends Bloc<MediaEvent, MediaState> {
  MediaBloc() : super(MediaInitial()) {
    on<MediaEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
