import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../models/course.dart';
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
    final courses = [
      Course(
        id: '1',
        title: 'Graphic Design',
        description: 'Learn the fundamentals of graphic design',
        teacherId: 'teacher_1',
        instructor: 'By Kendrick Capusco',
        progress: '45%',
        accentColor: Colors.blue,
        thumbnailAsset: 'assets/images/graphDesign.png',
      ),
      Course(
        id: '2',
        title: 'Wireframing',
        description: 'Master wireframing techniques',
        teacherId: 'teacher_2',
        instructor: 'By Shoaib Atto',
        progress: '45%',
        accentColor: const Color.fromARGB(255, 180, 41, 134),
        thumbnailAsset: 'assets/images/wireframe.png',
      ),
      Course(
        id: '3',
        title: 'Website Design',
        description: 'Create beautiful websites',
        teacherId: 'teacher_3',
        instructor: 'By Dwayne Wade',
        progress: '45%',
        accentColor: Colors.orange,
        thumbnailAsset: 'assets/images/webDesign.png',
      ),
      Course(
        id: '4',
        title: 'Video Editing',
        description: 'Professional video editing skills',
        teacherId: 'teacher_4',
        instructor: 'By Ammer Cruz',
        progress: '45%',
        accentColor: Colors.black,
        thumbnailAsset: 'assets/images/VideoEditing.png',
      ),
      Course(
        id: '5',
        title: 'Cybersecurity',
        description: 'Secure systems and networks',
        teacherId: 'teacher_5',
        instructor: 'By John Anderson',
        progress: '45%',
        accentColor: Colors.purple,
        thumbnailAsset: 'assets/images/cybersec.png',
      ),
      Course(
        id: '6',
        title: 'MySql Basics',
        description: 'Database fundamentals',
        teacherId: 'teacher_6',
        instructor: 'By Sarah Johnson',
        progress: '45%',
        accentColor: Colors.green,
        thumbnailAsset: 'assets/images/sql.png',
      ),
      Course(
        id: '7',
        title: 'Flutter Development',
        description: 'Build mobile apps with Flutter',
        teacherId: 'teacher_7',
        instructor: 'By Adhz Formentera',
        progress: '45%',
        accentColor: Colors.blue,
        thumbnailAsset: 'assets/images/flutter.jpg',
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.75,
      ),
      itemCount: courses.length,
      itemBuilder: (context, index) {
        final course = courses[index];
        return CourseCard(
          title: course.title,
          instructor: course.instructor ?? 'Unknown Instructor',
          progress: course.progress ?? '0%',
          accentColor: course.accentColor ?? Colors.grey,
          assetImage: course.thumbnailAsset,
          imageUrl: course.thumbnailUrl,
        );
      },
    );
  }
}
