import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../routes/app_routes.dart';
import '../services/navigation_service.dart';
import '../services/translation_service.dart';
import '../widgets/main_navigation.dart';

class TranslationScreen extends StatefulWidget {
  static const String routeName = AppRoutes.translation;

  const TranslationScreen({super.key});

  @override
  State<TranslationScreen> createState() => _TranslationScreenState();
}

class _TranslationScreenState extends State<TranslationScreen> {
  final _textController = TextEditingController();
  final _translationService = TranslationService();
  
  String _fromLanguage = 'en';
  String _toLanguage = 'es';
  String _translatedText = '';
  bool _isTranslating = false;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _translateText() async {
    if (_textController.text.trim().isEmpty) return;

    setState(() {
      _isTranslating = true;
      _translatedText = '';
    });

    try {
      final result = await _translationService.translateText(
        text: _textController.text.trim(),
        fromLanguage: _fromLanguage,
        toLanguage: _toLanguage,
      );
      
      setState(() {
        _translatedText = result.translatedText;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Translation failed: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isTranslating = false);
      }
    }
  }

  void _swapLanguages() {
    setState(() {
      final temp = _fromLanguage;
      _fromLanguage = _toLanguage;
      _toLanguage = temp;
      
      // Swap text too if there's a translation
      if (_translatedText.isNotEmpty) {
        final tempText = _textController.text;
        _textController.text = _translatedText;
        _translatedText = tempText;
      }
    });
  }

  void _copyToClipboard() {
    if (_translatedText.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: _translatedText));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Translation copied to clipboard'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _saveAsFlashcard() async {
    if (_translatedText.isNotEmpty && _textController.text.trim().isNotEmpty) {
      try {
        final result = TranslationResult(
          originalText: _textController.text.trim(),
          translatedText: _translatedText,
          fromLanguage: _fromLanguage,
          toLanguage: _toLanguage,
          timestamp: DateTime.now(),
        );
        
        await _translationService.saveAsFlashcard(result);
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Saved as flashcard!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to save flashcard: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

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
                    _buildLanguageSelector(
                      TranslationService.languages[_fromLanguage] ?? 'English',
                      true,
                    ),
                    IconButton(
                      icon: const Icon(Icons.swap_horiz),
                      onPressed: _swapLanguages,
                    ),
                    _buildLanguageSelector(
                      TranslationService.languages[_toLanguage] ?? 'Spanish',
                      false,
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Text Input
                Stack(
                  children: [
                    TextField(
                      controller: _textController,
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
                  onPressed: _isTranslating ? null : _translateText,
                  icon: _isTranslating 
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.translate),
                  label: Text(_isTranslating ? 'Translating...' : 'Translate'),
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
                      Text(
                        _translatedText.isEmpty 
                          ? 'Your translation will appear here'
                          : _translatedText,
                        style: TextStyle(
                          fontSize: 16,
                          color: _translatedText.isEmpty ? Colors.grey : Colors.black,
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
                      onPressed: _translatedText.isEmpty ? null : _saveAsFlashcard,
                      icon: const Icon(Icons.save, size: 20),
                      label: const Text('Save to Flashcards'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                      ),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton.icon(
                      onPressed: _translatedText.isEmpty ? null : _copyToClipboard,
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

  Widget _buildLanguageSelector(String language, bool isFromLanguage) {
    return GestureDetector(
      onTap: () => _showLanguageSelector(isFromLanguage),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(language),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }

  void _showLanguageSelector(bool isFromLanguage) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isFromLanguage ? 'Select source language' : 'Select target language',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: TranslationService.languages.length,
                  itemBuilder: (context, index) {
                    final entry = TranslationService.languages.entries.elementAt(index);
                    final code = entry.key;
                    final name = entry.value;
                    
                    return ListTile(
                      title: Text(name),
                      onTap: () {
                        setState(() {
                          if (isFromLanguage) {
                            _fromLanguage = code;
                          } else {
                            _toLanguage = code;
                          }
                        });
                        Navigator.of(context).pop();
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
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
