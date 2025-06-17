import 'package:flutter/material.dart';
import '../routes/app_routes.dart';
import '../services/navigation_service.dart';

class MainNavigation extends StatefulWidget {
  final Widget child;
  final int currentIndex;

  const MainNavigation({
    super.key,
    required this.child,
    required this.currentIndex,
  });

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EasyLingo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              NavigationService.navigateTo(AppRoutes.learningGoals);
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              NavigationService.navigateTo(AppRoutes.settings);
            },
          ),
        ],
      ),
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: widget.currentIndex,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.translate),
            label: 'Translate',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Learn',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Community',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        onTap: (index) {
          switch (index) {
            case 0:
              NavigationService.navigateToReplacement(AppRoutes.translation);
              break;
            case 1:
              NavigationService.navigateToReplacement(AppRoutes.learn);
              break;
            case 2:
              NavigationService.navigateToReplacement(AppRoutes.community);
              break;
            case 3:
              NavigationService.navigateToReplacement(AppRoutes.profile);
              break;
          }
        },
      ),
    );
  }
} 