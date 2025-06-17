import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'routes/app_routes.dart';
import 'screens/translation_screen.dart';
import 'screens/learn_screen.dart';
import 'screens/community_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/flashcard_screen.dart';
import 'settings/settings_controller.dart';
import 'settings/settings_view.dart';
import 'services/navigation_service.dart';

/// The Widget that configures your application.
class EasyLingoApp extends StatelessWidget {
  const EasyLingoApp({
    super.key,
    required this.settingsController,
  });

  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: settingsController,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          navigatorKey: NavigationService.navigatorKey,
          restorationScopeId: 'app',

          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', ''), // English, no country code
          ],
          onGenerateTitle: (BuildContext context) =>
              AppLocalizations.of(context)!.appTitle,

          theme: ThemeData(
            primarySwatch: Colors.blue,
            useMaterial3: true,
          ),
          darkTheme: ThemeData.dark(useMaterial3: true),
          themeMode: settingsController.themeMode,

          onGenerateRoute: (RouteSettings routeSettings) {
            return MaterialPageRoute<void>(
              settings: routeSettings,
              builder: (BuildContext context) {
                switch (routeSettings.name) {
                  case AppRoutes.translation:
                    return const TranslationScreen();
                  case AppRoutes.learn:
                    return const LearnScreen();
                  case AppRoutes.community:
                    return const CommunityScreen();
                  case AppRoutes.profile:
                    return const ProfileScreen();
                  case AppRoutes.settings:
                    return SettingsView(controller: settingsController);
                  case AppRoutes.flashcards:
                    return const FlashcardScreen();
                  default:
                    return const TranslationScreen();
                }
              },
            );
          },
        );
      },
    );
  }
}
