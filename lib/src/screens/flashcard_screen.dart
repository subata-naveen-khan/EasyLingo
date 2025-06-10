import 'package:easylingo/src/widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';

class FlashcardScreen extends StatelessWidget {
  static const String routeName = '/flashcards';
  const FlashcardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flashcards'),
      ),
      body: const Center(
        child: Text('Flashcard Screen'),
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: 1)
    );
  }
}