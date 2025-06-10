import 'package:flutter_bloc/flutter_bloc.dart';
import 'translation_event.dart';
import 'translation_state.dart';

class TranslationBloc extends Bloc<TranslationEvent, TranslationState> {
  TranslationBloc() : super(TranslationInitial()) {
    on<TranslateText>((event, emit) async {
      emit(TranslationLoading());
      await Future.delayed(const Duration(seconds: 1)); // Simulate translation
      emit(TranslationSuccess("Translated: ${event.input}"));
    });
  }
}
