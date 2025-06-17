import 'package:flutter/material.dart';
import '../routes/app_routes.dart';
import '../services/navigation_service.dart';
import '../widgets/main_navigation.dart';

class ProfileScreen extends StatelessWidget {
  static const String routeName = AppRoutes.profile;

  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MainNavigation(
      currentIndex: 3,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Profile Header
            const CircleAvatar(
              radius: 50,
              child: Icon(Icons.person, size: 50),
            ),
            const SizedBox(height: 16),
            const Text(
              'Guest User',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Not signed in',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 24),

            // Profile Options
            _buildProfileSection(
              'Account',
              [
                _buildProfileTile(
                  'Sign In',
                  Icons.login,
                  () => NavigationService.navigateTo(AppRoutes.login),
                ),
                _buildProfileTile(
                  'Create Account',
                  Icons.person_add,
                  () => NavigationService.navigateTo(AppRoutes.register),
                ),
              ],
            ),
            const SizedBox(height: 16),

            _buildProfileSection(
              'Settings',
              [
                _buildProfileTile(
                  'Language',
                  Icons.language,
                  () {
                    // TODO: implement language settings
                  },
                ),
                _buildProfileTile(
                  'Notifications',
                  Icons.notifications,
                  () {
                    // TODO: implement notification settings
                  },
                ),
                _buildProfileTile(
                  'App Settings',
                  Icons.settings,
                  () => NavigationService.navigateTo(AppRoutes.settings),
                ),
              ],
            ),
            const SizedBox(height: 16),

            _buildProfileSection(
              'About',
              [
                _buildProfileTile(
                  'Help & Support',
                  Icons.help,
                  () {
                    // TODO: implement help & support
                  },
                ),
                _buildProfileTile(
                  'Privacy Policy',
                  Icons.privacy_tip,
                  () {
                    // TODO: implement privacy policy
                  },
                ),
                _buildProfileTile(
                  'Terms of Service',
                  Icons.description,
                  () {
                    // TODO: implement terms of service
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
        ),
        Card(
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildProfileTile(
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}