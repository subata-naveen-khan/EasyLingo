abstract class TranslationEvent {}

class TranslateText extends TranslationEvent {
  final String input;
  TranslateText(this.input);
}
