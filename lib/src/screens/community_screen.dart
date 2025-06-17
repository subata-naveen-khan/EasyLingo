import 'package:flutter/material.dart';
import '../routes/app_routes.dart';
import '../services/navigation_service.dart';
import '../widgets/main_navigation.dart';

class CommunityScreen extends StatelessWidget {
  static const String routeName = AppRoutes.community;

  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MainNavigation(
      currentIndex: 2,
      child: Column(
        children: [
          // Search and Filter Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search discussions...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.filter_list),
                  onPressed: () {
                    // TODO: implement filter
                  },
                ),
              ],
            ),
          ),

          // Categories
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _buildCategoryChip('All', true),
                _buildCategoryChip('Questions', false),
                _buildCategoryChip('Discussions', false),
                _buildCategoryChip('Resources', false),
                _buildCategoryChip('Announcements', false),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Posts List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: 10,
              itemBuilder: (context, index) {
                return _buildPostCard(
                  'How to improve pronunciation?',
                  'How can I practice my Spanish pronounciation? Any tips or resources?',
                  'John Doe',
                  '2 hours ago',
                  15,
                  5,
                );
              },
            ),
          ),

          // Create Post Button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: FloatingActionButton.extended(
              onPressed: () {
                NavigationService.navigateTo(AppRoutes.createPost);
              },
              icon: const Icon(Icons.add),
              label: const Text('Create Post'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String label, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (bool selected) {
          // TODO: implement category sel
        },
      ),
    );
  }

  Widget _buildPostCard(
    String title,
    String content,
    String author,
    String time,
    int likes,
    int comments,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          NavigationService.navigateTo(AppRoutes.communityPost);
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    child: Icon(Icons.person),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        author,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        time,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                content,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.thumb_up_outlined),
                    onPressed: () {
                      // TODO: implement like
                    },
                  ),
                  Text('$likes'),
                  const SizedBox(width: 16),
                  IconButton(
                    icon: const Icon(Icons.comment_outlined),
                    onPressed: () {
                      // TODO: implement comment
                    },
                  ),
                  Text('$comments'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
} 