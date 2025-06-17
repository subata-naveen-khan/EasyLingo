import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'src/app.dart';
import 'src/settings/settings_controller.dart';
import 'src/settings/settings_service.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> checkBackendHealth() async {
  try {
    final res = await http.get(Uri.parse("http://10.0.2.2:3001/health")); 
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      print("✅ Backend is up: ${data['status']}");
    } else {
      print("❌ Backend error: ${res.statusCode}");
    }
  } catch (e) {
    print("❌ Couldn't reach backend: $e");
  }
}

void main() async {
  final settingsController = SettingsController(SettingsService());  // Set up the SettingsController, which will glue user settings to multiple Flutter Widgets.
  await settingsController.loadSettings();// Load the user's preferred theme while the splash screen is displayed. This prevents a sudden theme change when the app is first displayed.

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await checkBackendHealth(); // Check if the backend is reachable before starting the app.

  // Run the app and pass in the SettingsController. The app listens to the SettingsController for changes, then passes it further down to the SettingsView.
  runApp(EasyLingoApp(settingsController: settingsController));
}
