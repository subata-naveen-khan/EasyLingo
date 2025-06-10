import 'package:flutter/material.dart';

class TranslationInput extends StatelessWidget {
  const TranslationInput({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          decoration: const InputDecoration(
            labelText: 'Enter text',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            // dispatch translation event here
          },
          child: const Text('Translate'),
        ),
      ],
    );
  }
}
