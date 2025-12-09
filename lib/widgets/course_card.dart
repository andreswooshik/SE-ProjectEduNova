import 'package:flutter/material.dart';
import '../models/course.dart';
import '../screens/course_details_page.dart';
import '../screens/enrolled_course_details_page.dart';

/// A reusable card widget for displaying course information.
/// 
/// This widget follows the Single Responsibility Principle by focusing
/// solely on course card presentation and navigation.
/// 
/// IMPORTANT: Always passes the complete Course object (not just title or ID)
/// to CourseDetailsPage to ensure all course data is available and enrollment
/// uses the correct course.id for identification.
class CourseCard extends StatelessWidget {
  /// The complete course object to display
  final Course course;
  
  /// Optional custom tap handler. If null, navigates to appropriate page
  final VoidCallback? onTap;
  
  /// Whether the user is enrolled in this course
  /// If true, navigates to EnrolledCourseDetailsPage
  /// If false, navigates to CourseDetailsPage
  final bool isEnrolled;

  const CourseCard({
    Key? key,
    required this.course,
    this.onTap,
    this.isEnrolled = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ??
          () {
            if (isEnrolled) {
              // Navigate to enrolled course details page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EnrolledCourseDetailsPage(
                    courseTitle: course.title,
                    instructor: course.instructor ?? 'Unknown Instructor',
                    accentColor: course.accentColor ?? Colors.blue,
                  ),
                ),
              );
            } else {
              // Navigate to course details, passing the complete course object
              // This ensures CourseDetailsPage has access to course.id for enrollment
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CourseDetailsPage(
                    course: course,
                  ),
                ),
              );
            }
          },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: _buildImage(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    course.instructor ?? 'Unknown Instructor',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      ...List.generate(5, (index) {
                        return const Icon(Icons.star,
                            size: 12, color: Colors.blue);
                      }),
                      const SizedBox(width: 8),
                      Text(
                        course.progress ?? '0%',
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: LinearProgressIndicator(
                      value: _getProgressValue(),
                      minHeight: 4,
                      backgroundColor: Colors.grey.shade300,
                      valueColor: AlwaysStoppedAnimation<Color>(
                          course.accentColor ?? Colors.blue),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    // Priority: assetImage > imageUrl > fallback
    if (course.thumbnailAsset != null) {
      return Image.asset(
        course.thumbnailAsset!,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _buildFallback(),
      );
    }

    if (course.thumbnailUrl != null) {
      return Image.network(
        course.thumbnailUrl!,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return _buildLoadingIndicator();
        },
        errorBuilder: (context, error, stackTrace) => _buildFallback(),
      );
    }

    return _buildFallback();
  }

  Widget _buildFallback() {
    final accentColor = course.accentColor ?? Colors.blue;
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: accentColor.withValues(alpha: 0.15),
      ),
      child: Center(
        child: Icon(
          Icons.school_outlined,
          size: 48,
          color: accentColor.withValues(alpha: 0.5),
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    final accentColor = course.accentColor ?? Colors.blue;
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: accentColor.withValues(alpha: 0.1),
      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(accentColor),
          strokeWidth: 2,
        ),
      ),
    );
  }

  double _getProgressValue() {
    final progress = course.progress ?? '0%';
    final progressValue = double.tryParse(progress.replaceAll('%', '')) ?? 0;
    return progressValue / 100;
  }
}
