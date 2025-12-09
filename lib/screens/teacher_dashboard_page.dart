import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../core/constants/app_constants.dart';
import '../models/user.dart';
import '../models/course.dart';
import 'settings_page.dart';
import 'notifications_page.dart';
import 'teacher_course_detail_page.dart';

/// Teacher Dashboard Page - Only accessible by users with teacher role
/// Single Responsibility Principle: Handles only teacher dashboard UI
class TeacherDashboardPage extends ConsumerStatefulWidget {
  const TeacherDashboardPage({Key? key}) : super(key: key);

  @override
  ConsumerState<TeacherDashboardPage> createState() => _TeacherDashboardPageState();
}

class _TeacherDashboardPageState extends ConsumerState<TeacherDashboardPage> {
  final List<String> categories = ['Web', 'Cryptography', 'Figma'];
  String selectedCategory = 'Web';

  // Sample courses data for the teacher
  final List<Course> teacherCourses = [
    Course(
      id: '1',
      title: 'Graphic Design',
      description: 'Learn the fundamentals of graphic design including typography, color theory, and layout principles.',
      teacherId: 'teacher1',
      instructor: 'By Kenneth Coppock',
      progress: '45% Done',
      thumbnailAsset: 'assets/images/graphic_design.jpg',
      accentColor: Colors.pink,
    ),
    Course(
      id: '2',
      title: 'Wireframing',
      description: 'Master the art of wireframing and prototyping for web and mobile applications.',
      teacherId: 'teacher1',
      instructor: 'By Shivalo Alo',
      progress: '45% Done',
      thumbnailAsset: 'assets/images/wireframing.jpg',
      accentColor: Colors.grey,
    ),
    Course(
      id: '3',
      title: 'Website Design',
      description: 'Complete guide to modern website design with hands-on projects.',
      teacherId: 'teacher1',
      instructor: 'By Dwayne Wade',
      progress: '45% Done',
      thumbnailAsset: 'assets/images/website_design.jpg',
      accentColor: Colors.orange,
    ),
    Course(
      id: '4',
      title: 'Video Editing',
      description: 'Professional video editing techniques and workflows.',
      teacherId: 'teacher1',
      instructor: 'By Ammar Cruz',
      progress: '45% Done',
      thumbnailAsset: 'assets/images/video_editing.jpg',
      accentColor: Colors.purple,
    ),
    Course(
      id: '5',
      title: 'Cybersecurity',
      description: 'Comprehensive cybersecurity fundamentals covering threat analysis, network security, and best practices.',
      teacherId: 'teacher1',
      instructor: 'By Syed Hasnain',
      progress: '45% Done',
      thumbnailAsset: 'assets/images/cybersecurity.jpg',
      accentColor: Colors.blue,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final user = authState.user;

    // Role-based access control
    if (user == null || user.role != UserRole.teacher) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lock, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              const Text(
                'Access Denied',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'This page is only accessible to teachers.',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      );
    }

    final teacher = user as Teacher;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context, teacher),
                const SizedBox(height: 24),
                _buildSearchBar(),
                const SizedBox(height: 20),
                _buildCategoryChips(),
                const SizedBox(height: 24),
                _buildCoursesHeader(),
                const SizedBox(height: 16),
                _buildCoursesGrid(),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildHeader(BuildContext context, Teacher teacher) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
                children: [
                  const TextSpan(text: 'Welcome, '),
                  TextSpan(
                    text: 'Teacher',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.settings_outlined, size: 28),
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
              icon: const Icon(Icons.notifications_outlined, size: 28),
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
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: const TextField(
        decoration: InputDecoration(
          hintText: 'Search Here',
          hintStyle: TextStyle(color: Colors.grey),
          border: InputBorder.none,
          icon: Icon(Icons.search, color: Colors.grey),
          contentPadding: EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }

  Widget _buildCategoryChips() {
    return Row(
      children: categories.map((category) {
        final isSelected = category == selectedCategory;
        return Padding(
          padding: const EdgeInsets.only(right: 12),
          child: ChoiceChip(
            label: Text(category),
            selected: isSelected,
            onSelected: (selected) {
              setState(() {
                selectedCategory = category;
              });
            },
            backgroundColor: Colors.white,
            selectedColor: Theme.of(context).primaryColor.withOpacity(0.1),
            labelStyle: TextStyle(
              color: isSelected ? Theme.of(context).primaryColor : Colors.black,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
            side: BorderSide(
              color: isSelected
                  ? Theme.of(context).primaryColor
                  : Colors.grey[300]!,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCoursesHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Courses',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextButton(
          onPressed: () {
            // Navigate to all courses
          },
          child: const Text(
            'See All',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCoursesGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.75,
      ),
      itemCount: teacherCourses.length,
      itemBuilder: (context, index) {
        return _buildCourseCard(teacherCourses[index]);
      },
    );
  }

  Widget _buildCourseCard(Course course) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TeacherCourseDetailPage(course: course),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Course thumbnail
            Container(
              height: 120,
              decoration: BoxDecoration(
                color: course.accentColor?.withOpacity(0.1) ?? Colors.grey[200],
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
              ),
              child: Center(
                child: Icon(
                  _getCourseIcon(course.title),
                  size: 48,
                  color: course.accentColor ?? Colors.grey,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 14, color: Colors.amber),
                      const Icon(Icons.star, size: 14, color: Colors.amber),
                      const Icon(Icons.star, size: 14, color: Colors.amber),
                      const Icon(Icons.star, size: 14, color: Colors.amber),
                      const Icon(Icons.star, size: 14, color: Colors.amber),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    course.instructor ?? 'By Instructor',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Progress bar
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LinearProgressIndicator(
                        value: 0.45,
                        backgroundColor: Colors.grey[200],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).primaryColor,
                        ),
                        minHeight: 4,
                        borderRadius: BorderRadius.circular(2),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        course.progress ?? '45% Done',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getCourseIcon(String title) {
    if (title.toLowerCase().contains('design')) {
      return Icons.brush;
    } else if (title.toLowerCase().contains('video')) {
      return Icons.videocam;
    } else if (title.toLowerCase().contains('website') || title.toLowerCase().contains('web')) {
      return Icons.web;
    } else if (title.toLowerCase().contains('wireframe')) {
      return Icons.dashboard_customize;
    } else if (title.toLowerCase().contains('cybersecurity') || title.toLowerCase().contains('security')) {
      return Icons.security;
    }
    return Icons.school;
  }

  Widget _buildBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        currentIndex: 0,
        elevation: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message_outlined),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: '',
          ),
        ],
      ),
    );
  }
}
