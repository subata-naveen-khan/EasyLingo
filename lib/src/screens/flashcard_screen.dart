import 'package:easylingo/src/widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import '../routes/app_routes.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class Flashcard {
  final int id;
  final String frontText;
  final String backText;
  final String category;
  final int difficultyLevel;

  Flashcard({
    required this.id,
    required this.frontText,
    required this.backText,
    required this.category,
    required this.difficultyLevel,
  });

  factory Flashcard.fromJson(Map<String, dynamic> json) {
    return Flashcard(
      id: json['ID'],
      frontText: json['FRONT_TEXT'],
      backText: json['BACK_TEXT'],
      category: json['CATEGORY'],
      difficultyLevel: json['DIFFICULTY_LEVEL'],
    );
  }
}

class FlashcardScreen extends StatefulWidget {
  static const String routeName = AppRoutes.flashcards;
  const FlashcardScreen({super.key});

  @override
  State<FlashcardScreen> createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends State<FlashcardScreen> {
  List<Flashcard> flashcards = [];
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    fetchFlashcards();
  }

  Future<void> fetchFlashcards() async {
    try {
      print('Attempting to fetch flashcards...');
      final response = await http.get(
        Uri.parse('http://10.0.2.2:3001/api/flashcards'),
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw TimeoutException('The request timed out');
        },
      );
      
      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          flashcards = data.map((json) => Flashcard.fromJson(json)).toList();
          isLoading = false;
        });
      } else {
        setState(() {
          error = 'Failed to load flashcards: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching flashcards: $e');
      setState(() {
        error = 'Error connecting to server: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Flashcards'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: implement search functionality
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // TODO: implement filtering options
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : error != null
              ? Center(child: Text(error!, style: const TextStyle(color: Colors.red)))
              : ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: flashcards.length,
                  itemBuilder: (context, index) {
                    final flashcard = flashcards[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 16.0),
                      child: ListTile(
                        title: Text(flashcard.frontText),
                        subtitle: Text(flashcard.backText),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                // TODO: Navigate to edit flashcard screen
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                // TODO: Show delete confirmation dialog
                              },
                            ),
                          ],
                        ),
                        onTap: () {
                          // TODO: Navigate to flashcard detail view
                        },
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Navigate to create flashcard screen
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 1),
    );
  }
}