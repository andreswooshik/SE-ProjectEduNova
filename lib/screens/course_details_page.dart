import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/course.dart';
import '../providers/enrollment_provider.dart';
import 'enrolled_course_details_page.dart';

/// Course details page that displays comprehensive information about a course
/// and allows students to enroll.
/// 
/// This widget follows the Single Responsibility Principle by focusing solely
/// on displaying course details and handling enrollment actions.
/// 
/// IMPORTANT: This page uses course.id for enrollment operations, NOT course.title.
/// This ensures accurate course identification even when multiple courses have
/// similar titles.
class CourseDetailsPage extends ConsumerStatefulWidget {
  /// The complete course object containing all course information including the unique ID
  final Course course;

  const CourseDetailsPage({
    Key? key,
    required this.course,
  }) : super(key: key);

  @override
  ConsumerState<CourseDetailsPage> createState() => _CourseDetailsPageState();
}

class _CourseDetailsPageState extends ConsumerState<CourseDetailsPage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_border, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Course Image
            Container(
              height: 200,
              width: double.infinity,
              child: widget.course.thumbnailAsset != null
                  ? Image.asset(
                      widget.course.thumbnailAsset!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          _buildPlaceholder(),
                    )
                  : _buildPlaceholder(),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _buildTab('Overview', 0),
                      _buildTab('Lessons', 1),
                      _buildTab('Reviews', 2),
                    ],
                  ),
                  const SizedBox(height: 20),
                  if (_selectedIndex == 0) _buildOverviewTab(),
                  if (_selectedIndex == 1) _buildLessonsTab(),
                  if (_selectedIndex == 2) _buildReviewsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: (widget.course.accentColor ?? Colors.blue).withValues(alpha: 0.15),
      child: Center(
        child: Icon(
          Icons.play_circle_filled,
          size: 80,
          color: widget.course.accentColor ?? Colors.blue,
        ),
      ),
    );
  }

  Widget _buildTab(String label, int index) {
    bool isSelected = _selectedIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedIndex = index),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.black : Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            if (isSelected)
              Container(
                height: 2,
                color: Colors.blue,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewTab() {
    // Check enrollment status using course.id for accurate identification
    // Using course.id instead of course.title prevents issues with duplicate
    // or similar course names
    final isEnrolled =
        ref.watch(enrollmentProvider.notifier).isEnrolled(widget.course.id);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.course.title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          widget.course.instructor ?? 'Unknown Instructor',
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: List.generate(5, (index) {
            return const Icon(Icons.star, size: 16, color: Colors.blue);
          }),
        ),
        const SizedBox(height: 16),
        Text(
          widget.course.description,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
            height: 1.6,
          ),
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    const Icon(Icons.play_lesson, color: Colors.blue, size: 32),
                    const SizedBox(height: 8),
                    const Text('80+ Lectures',
                        style: TextStyle(fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    const Icon(Icons.card_membership,
                        color: Colors.blue, size: 32),
                    const SizedBox(height: 8),
                    const Text('Certificate',
                        style: TextStyle(fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    const Icon(Icons.schedule, color: Colors.blue, size: 32),
                    const SizedBox(height: 8),
                    const Text('8 Weeks',
                        style: TextStyle(fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Skills',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildSkillChip('Adobe'),
            _buildSkillChip('Adobe Photo Shop'),
            _buildSkillChip('Logo'),
            _buildSkillChip('Designing'),
            _buildSkillChip('Poster Design'),
            _buildSkillChip('Figma'),
          ],
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: () => _handleEnrollment(),
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  isEnrolled ? Colors.green : const Color(0xFF003366),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              isEnrolled ? 'ENROLLED' : 'ENROLL NOW',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Handles the enrollment action when the user taps the enroll button.
  /// 
  /// This method:
  /// 1. Checks enrollment status using the unique course.id
  /// 2. Prevents duplicate enrollments
  /// 3. Enrolls the complete course object (not just ID) to maintain full course data
  /// 4. Provides user feedback via SnackBar
  /// 5. Navigates to EnrolledCourseDetailsPage after successful enrollment
  /// 
  /// CRITICAL: Always uses course.id for enrollment operations to ensure
  /// correct course identification.
  void _handleEnrollment() {
    final enrollmentNotifier = ref.read(enrollmentProvider.notifier);
    // Check if already enrolled using course.id (unique identifier)
    final isEnrolled = enrollmentNotifier.isEnrolled(widget.course.id);

    if (isEnrolled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Already enrolled in this course!'),
          backgroundColor: Colors.orange,
        ),
      );
    } else {
      // Enroll the complete course object to preserve all course data
      // The enrollmentProvider will use course.id internally for deduplication
      enrollmentNotifier.enrollCourse(widget.course);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Successfully enrolled!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 1),
        ),
      );
      
      // Navigate to enrolled course details screen after successful enrollment
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => EnrolledCourseDetailsPage(
                courseTitle: widget.course.title,
                instructor: widget.course.instructor ?? 'Unknown Instructor',
                accentColor: widget.course.accentColor ?? Colors.blue,
              ),
            ),
          );
        }
      });
    }
  }

  Widget _buildLessonsTab() {
    // ...existing code...
    return Container(); // Placeholder
  }

  Widget _buildReviewsTab() {
    // ...existing code...
    return Container(); // Placeholder
  }

  Widget _buildSkillChip(String skill) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(skill, style: const TextStyle(fontSize: 12)),
    );
  }
}
