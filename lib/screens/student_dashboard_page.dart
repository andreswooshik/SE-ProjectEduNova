import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../widgets/category_chip.dart';
import '../widgets/course_card.dart';
import '../widgets/custom_search_bar.dart';
import 'settings_page.dart';
import 'notifications_page.dart';

class StudentDashboardPage extends ConsumerWidget {
  const StudentDashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final userName = authState.user?.firstName ?? 'Student';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context, userName),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomSearchBar(),
            const SizedBox(height: 24),
            _buildCategories(),
            const SizedBox(height: 24),
            _buildCoursesHeader(),
            const SizedBox(height: 16),
            _buildCoursesGrid(context),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, String userName) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Text(
        'Welcome, $userName',
        style: const TextStyle(
          color: Colors.black,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.settings_outlined, color: Colors.black),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SettingsPage(),
              ),
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.notifications_outlined, color: Colors.black),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const NotificationsPage(),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildCategories() {
    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: const [
          CategoryChip(label: 'Web', isSelected: true),
          SizedBox(width: 12),
          CategoryChip(label: 'Cryptography', isSelected: false),
          SizedBox(width: 12),
          CategoryChip(label: 'Figma', isSelected: false),
        ],
      ),
    );
  }

  Widget _buildCoursesHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Courses',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        TextButton(
          onPressed: () {},
          child: const Text(
            'See All',
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildCoursesGrid(BuildContext context) {
    // In a real app, this data would come from a provider
    final courses = [
      {
        'title': 'Graphic Design',
        'instructor': 'By Kendrick Capusco',
        'progress': '45%',
        'color': Colors.blue,
      },
      {
        'title': 'Wireframing',
        'instructor': 'By Shoaib Atto',
        'progress': '45%',
        'color': const Color.fromARGB(255, 180, 41, 134),
      },
      {
        'title': 'Website Design',
        'instructor': 'By Dwayne Wade',
        'progress': '45%',
        'color': Colors.orange,
      },
      {
        'title': 'Video Editing',
        'instructor': 'By Ammer Cruz',
        'progress': '45%',
        'color': Colors.black,
      },
      {
        'title': 'Cybersecurity',
        'instructor': 'By John Anderson',
        'progress': '45%',
        'color': Colors.purple,
      },
      {
        'title': 'MySql Basics',
        'instructor': 'By Sarah Johnson',
        'progress': '45%',
        'color': Colors.green,
      },
      {
        'title': 'Flutter Development',
        'instructor': 'By Adhz Formentera',
        'progress': '45%',
        'color': Colors.blue,
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
      ),
      itemCount: courses.length,
      itemBuilder: (context, index) {
        final course = courses[index];
        return CourseCard(
          title: course['title'] as String,
          instructor: course['instructor'] as String,
          progress: course['progress'] as String,
          accentColor: course['color'] as Color,
        );
      },
    );
  }
}
