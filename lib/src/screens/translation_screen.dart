import 'package:flutter/material.dart';
import '../routes/app_routes.dart';
import '../services/navigation_service.dart';
import '../widgets/main_navigation.dart';

class TranslationScreen extends StatelessWidget {
  static const String routeName = AppRoutes.translation;

  const TranslationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MainNavigation(
      currentIndex: 0,
      child: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Language Selection
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildLanguageSelector('English'),
                    IconButton(
                      icon: const Icon(Icons.swap_horiz),
                      onPressed: () {
                        // TODO: implement language swap
                      },
                    ),
                    _buildLanguageSelector('Spanish'),
                  ],
                ),
                const SizedBox(height: 32),

                // Text Input
                Stack(
                  children: [
                    TextField(
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: 'Enter text to translate',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.only(
                          left: 16,
                          right: 16,
                          top: 16,
                          bottom: 16,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.camera_alt, size: 24),
                            onPressed: () => NavigationService.navigateTo(
                                AppRoutes.cameraTranslation),
                            tooltip: 'Camera',
                            padding: const EdgeInsets.all(4),
                            constraints: const BoxConstraints(),
                          ),
                          IconButton(
                            icon: const Icon(Icons.mic, size: 24),
                            onPressed: () {
                              // TODO: implement voice input
                            },
                            tooltip: 'Voice',
                            padding: const EdgeInsets.all(4),
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Translate Button
                ElevatedButton.icon(
                  onPressed: () {
                    // TODO: implement translation
                  },
                  icon: const Icon(Icons.translate),
                  label: const Text('Translate'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 12),
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                ),
                const SizedBox(height: 16),

                // Translation Result
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Translation',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.volume_up),
                            onPressed: () => NavigationService.navigateTo(
                                AppRoutes.textToSpeech),
                            tooltip: 'Text to Speech',
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Your translation will appear here',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Action Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        // TODO: implement save to flashcards
                      },
                      icon: const Icon(Icons.save, size: 20),
                      label: const Text('Save to Flashcards'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                      ),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        // TODO: implement copy to clipboard
                      },
                      icon: const Icon(Icons.copy, size: 20),
                      label: const Text('Copy'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageSelector(String language) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Text(language),
          const Icon(Icons.arrow_drop_down),
        ],
      ),
    );
  }

  // Widget _buildOptionButton(
  //   BuildContext context,
  //   String label,
  //   IconData icon,
  //   VoidCallback onPressed,
  // ) {
  //   return Column(
  //     mainAxisSize: MainAxisSize.min,
  //     children: [
  //       IconButton(
  //         icon: Icon(icon, size: 24),
  //         onPressed: onPressed,
  //         iconSize: 24,
  //         padding: const EdgeInsets.all(8),
  //         constraints: const BoxConstraints(),
  //       ),
  //       Text(
  //         label,
  //         style: const TextStyle(fontSize: 12),
  //       ),
  //     ],
  //   );
  // }
}
