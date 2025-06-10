abstract class TranslationState {}

class TranslationInitial extends TranslationState {}

class TranslationLoading extends TranslationState {}

class TranslationSuccess extends TranslationState {
  final String result;
  TranslationSuccess(this.result);
}

class TranslationFailure extends TranslationState {
  final String error;
  TranslationFailure(this.error);
}
