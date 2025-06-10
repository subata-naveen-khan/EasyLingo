import 'package:easylingo/src/widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import '../widgets/translation_input.dart';

class HomeScreen extends StatelessWidget {
  static const String routeName = '/home';
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EasyLingo'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.mic_none,
                    size: 80,
                    color: Colors.deepPurpleAccent,
                  ),
                  SizedBox(width: 16),
                  Icon(
                    Icons.camera_alt_outlined,
                    size: 80,
                    color: Colors.deepPurpleAccent,
                  )
                ],
              ),
            ),
            SizedBox(height: 16),
            TranslationInput(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: 0),
    );
  }
}
