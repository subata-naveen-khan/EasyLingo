import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TranslationService {
  static const String _baseUrl = 'https://translate.googleapis.com/translate_a/single';
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Available languages
  static const Map<String, String> languages = {
    'en': 'English',
    'es': 'Spanish',
    'fr': 'French',
    'de': 'German',
    'it': 'Italian',
    'pt': 'Portuguese',
    'ru': 'Russian',
    'ja': 'Japanese',
    'ko': 'Korean',
    'zh': 'Chinese (Simplified)',
    'ar': 'Arabic',
    'hi': 'Hindi',
  };

  // Translate text using Google Translate API (free version)
  Future<TranslationResult> translateText({
    required String text,
    required String fromLanguage,
    required String toLanguage,
  }) async {
    try {
      final encodedText = Uri.encodeComponent(text);
      final url = '$_baseUrl?client=gtx&sl=$fromLanguage&tl=$toLanguage&dt=t&q=$encodedText';
      
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        final translatedText = decoded[0][0][0] as String;
        
        final result = TranslationResult(
          originalText: text,
          translatedText: translatedText,
          fromLanguage: fromLanguage,
          toLanguage: toLanguage,
          timestamp: DateTime.now(),
        );

        // Save translation to user's history if logged in
        await _saveTranslationToHistory(result);
        
        return result;
      } else {
        throw Exception('Translation failed with status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Translation error: $e');
    }
  }

  // Detect language of text
  Future<String> detectLanguage(String text) async {
    try {
      final encodedText = Uri.encodeComponent(text);
      final url = '$_baseUrl?client=gtx&sl=auto&tl=en&dt=t&q=$encodedText';
      
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        return decoded[2] as String? ?? 'en'; // Return detected language or default to English
      } else {
        return 'en'; // Default to English if detection fails
      }
    } catch (e) {
      return 'en'; // Default to English if error occurs
    }
  }

  // Save translation to user's Firestore history
  Future<void> _saveTranslationToHistory(TranslationResult result) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('translations')
            .add(result.toMap());
      }
    } catch (e) {
      print('Error saving translation to history: $e');
    }
  }

  // Get user's translation history
  Future<List<TranslationResult>> getTranslationHistory() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return [];

      final querySnapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('translations')
          .orderBy('timestamp', descending: true)
          .limit(50)
          .get();

      return querySnapshot.docs
          .map((doc) => TranslationResult.fromMap(doc.data()))
          .toList();
    } catch (e) {
      print('Error getting translation history: $e');
      return [];
    }
  }

  // Save translation as flashcard
  Future<void> saveAsFlashcard(TranslationResult translation) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('User not logged in');

      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('flashcards')
          .add({
        'front': translation.originalText,
        'back': translation.translatedText,
        'fromLanguage': translation.fromLanguage,
        'toLanguage': translation.toLanguage,
        'createdAt': FieldValue.serverTimestamp(),
        'reviewCount': 0,
        'lastReviewed': null,
        'difficulty': 'easy',
      });
    } catch (e) {
      throw Exception('Failed to save flashcard: $e');
    }
  }

  // Clear translation history
  Future<void> clearTranslationHistory() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      final batch = _firestore.batch();
      final querySnapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('translations')
          .get();

      for (final doc in querySnapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
    } catch (e) {
      print('Error clearing translation history: $e');
    }
  }
}

class TranslationResult {
  final String originalText;
  final String translatedText;
  final String fromLanguage;
  final String toLanguage;
  final DateTime timestamp;

  TranslationResult({
    required this.originalText,
    required this.translatedText,
    required this.fromLanguage,
    required this.toLanguage,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'originalText': originalText,
      'translatedText': translatedText,
      'fromLanguage': fromLanguage,
      'toLanguage': toLanguage,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }

  factory TranslationResult.fromMap(Map<String, dynamic> map) {
    return TranslationResult(
      originalText: map['originalText'] ?? '',
      translatedText: map['translatedText'] ?? '',
      fromLanguage: map['fromLanguage'] ?? 'en',
      toLanguage: map['toLanguage'] ?? 'en',
      timestamp: (map['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
} 