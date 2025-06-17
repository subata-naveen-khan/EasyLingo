import 'package:flutter/material.dart';
import '../routes/app_routes.dart';
import '../services/navigation_service.dart';
import '../widgets/main_navigation.dart';

class LearnScreen extends StatelessWidget {
  static const String routeName = AppRoutes.learn;

  const LearnScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MainNavigation(
      currentIndex: 1,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Learning Progress',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            
            _buildSection(
              'Learning Stats',
              [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildStatCard(
                        'Total Words',
                        '0',
                        Icons.translate,
                        Colors.purple,
                      ),
                      _buildStatCard(
                        'Flashcards',
                        '0',
                        Icons.style,
                        Colors.teal,
                      ),
                      _buildStatCard(
                        'Quizzes Taken',
                        '0',
                        Icons.quiz,
                        Colors.amber,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            _buildSection(
              'Learning Options',
              [
                _buildOptionTile(
                  'Learning Goals',
                  Icons.flag,
                  () => NavigationService.navigateTo(AppRoutes.learningGoals),
                ),
                _buildOptionTile(
                  'My Flashcards',
                  Icons.style,
                  () => NavigationService.navigateTo(AppRoutes.flashcards),
                ),
                _buildOptionTile(
                  'Quiz History',
                  Icons.history,
                  () => NavigationService.navigateTo(AppRoutes.quizzes),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ...children,
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      margin: const EdgeInsets.only(right: 16),
      child: Container(
        width: 120,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionTile(
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
} 