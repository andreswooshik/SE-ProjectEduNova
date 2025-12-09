import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../core/constants/app_constants.dart';
import '../models/user.dart';
import '../models/course.dart';
import '../models/course_analytics.dart';
import '../services/course_service.dart';
import '../widgets/course_analytics_widgets.dart';
import 'settings_page.dart';
import 'notifications_page.dart';
import 'teacher_course_detail_page.dart';
import 'create_edit_course_page.dart';

/// Teacher Dashboard Page - Only accessible by users with teacher role
/// Single Responsibility Principle: Handles only teacher dashboard UI
class TeacherDashboardPage extends ConsumerStatefulWidget {
  const TeacherDashboardPage({Key? key}) : super(key: key);

  @override
  ConsumerState<TeacherDashboardPage> createState() => _TeacherDashboardPageState();
}

class _TeacherDashboardPageState extends ConsumerState<TeacherDashboardPage> {
  final List<String> categories = ['All', 'Web', 'Cryptography', 'Design', 'Video'];
  String selectedCategory = 'All';
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  CourseSortOption _sortOption = CourseSortOption.dateNewest;
  bool _showFilters = false;
  final _courseService = CourseService();

  @override
  void initState() {
    super.initState();
    // Generate mock analytics data
    CourseService.generateMockData('teacher1');
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Course> get _filteredCourses {
    var courses = List<Course>.from(teacherCourses);
    
    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      courses = courses.where((course) {
        return course.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            course.description.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    }
    
    // Apply category filter
    if (selectedCategory != 'All') {
      courses = courses.where((course) {
        return course.title.toLowerCase().contains(selectedCategory.toLowerCase());
      }).toList();
    }
    
    // Apply sorting
    courses = _courseService.sortCourses(courses, _sortOption);
    
    return courses;
  }

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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateEditCoursePage(
                teacherId: teacher.id,
              ),
            ),
          );
          if (result == true) {
            setState(() {}); // Refresh the list
          }
        },
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context, teacher),
                const SizedBox(height: 20),
                QuickStatsWidget(
                  totalCourses: teacherCourses.length,
                  totalStudents: 189,
                  pendingGrades: 23,
                  avgRating: 4.7,
                ),
                const SizedBox(height: 24),
                _buildSearchBar(),
                const SizedBox(height: 16),
                _buildFilterSortBar(),
                const SizedBox(height: 20),
                if (_showFilters) ...[
                  _buildCategoryChips(),
                  const SizedBox(height: 20),
                ],
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
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
        decoration: InputDecoration(
          hintText: 'Search courses...',
          hintStyle: const TextStyle(color: Colors.grey),
          border: InputBorder.none,
          icon: const Icon(Icons.search, color: Colors.grey),
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, color: Colors.grey),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _searchQuery = '';
                    });
                  },
                )
              : null,
        ),
      ),
    );
  }

  Widget _buildFilterSortBar() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              setState(() {
                _showFilters = !_showFilters;
              });
            },
            icon: Icon(
              _showFilters ? Icons.filter_list_off : Icons.filter_list,
              size: 20,
            ),
            label: Text(_showFilters ? 'Hide Filters' : 'Show Filters'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              side: BorderSide(color: Colors.grey[300]!),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: _showSortOptions,
            icon: const Icon(Icons.sort, size: 20),
            label: const Text('Sort'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              side: BorderSide(color: Colors.grey[300]!),
            ),
          ),
        ),
      ],
    );
  }

  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Sort By',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildSortOption('Title (A-Z)', CourseSortOption.titleAsc),
              _buildSortOption('Title (Z-A)', CourseSortOption.titleDesc),
              _buildSortOption('Newest First', CourseSortOption.dateNewest),
              _buildSortOption('Oldest First', CourseSortOption.dateOldest),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSortOption(String label, CourseSortOption option) {
    final isSelected = _sortOption == option;
    return ListTile(
      title: Text(label),
      trailing: isSelected
          ? Icon(Icons.check, color: Theme.of(context).primaryColor)
          : null,
      onTap: () {
        setState(() {
          _sortOption = option;
        });
        Navigator.pop(context);
      },
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
    final courses = _filteredCourses;
    
    if (courses.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            children: [
              Icon(Icons.search_off, size: 64, color: Colors.grey[300]),
              const SizedBox(height: 16),
              Text(
                'No courses found',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    }
    
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.75,
      ),
      itemCount: courses.length,
      itemBuilder: (context, index) {
        return _buildCourseCard(courses[index]);
      },
    );
  }

  Widget _buildCourseCard(Course course) {
    return Dismissible(
      key: Key(course.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        return await _showCourseActions(course);
      },
      background: Container(
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white, size: 32),
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TeacherCourseDetailPage(course: course),
            ),
          );
        },
        onLongPress: () => _showCourseActions(course),
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
      ),
    );
  }

  Future<bool?> _showCourseActions(Course course) async {
    return await showModalBottomSheet<bool>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                course.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              _buildActionTile(
                icon: Icons.edit,
                title: 'Edit Course',
                color: Colors.blue,
                onTap: () async {
                  Navigator.pop(context);
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreateEditCoursePage(
                        course: course,
                        teacherId: course.teacherId,
                      ),
                    ),
                  );
                  if (result == true) {
                    setState(() {});
                  }
                },
              ),
              _buildActionTile(
                icon: Icons.analytics,
                title: 'View Analytics',
                color: Colors.green,
                onTap: () {
                  Navigator.pop(context);
                  _showAnalytics(course);
                },
              ),
              _buildActionTile(
                icon: Icons.people,
                title: 'View Students',
                color: Colors.orange,
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Student list coming soon!')),
                  );
                },
              ),
              _buildActionTile(
                icon: Icons.share,
                title: 'Share Course',
                color: Colors.purple,
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Share link copied!')),
                  );
                },
              ),
              _buildActionTile(
                icon: Icons.delete,
                title: 'Delete Course',
                color: Colors.red,
                onTap: () async {
                  Navigator.pop(context);
                  final confirm = await _confirmDelete(course);
                  if (confirm == true) {
                    await _courseService.deleteCourse(course.id);
                    setState(() {
                      teacherCourses.removeWhere((c) => c.id == course.id);
                    });
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Course deleted successfully'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: color),
      ),
      title: Text(title),
      onTap: onTap,
    );
  }

  Future<bool?> _confirmDelete(Course course) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Course'),
        content: Text('Are you sure you want to delete "${course.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showAnalytics(Course course) async {
    final analytics = await _courseService.getCourseAnalytics(course.id);
    if (analytics != null && mounted) {
      showDialog(
        context: context,
        builder: (context) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  course.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                CourseAnalyticsCard(analytics: analytics),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  child: const Text('Close', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      );
    }
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
