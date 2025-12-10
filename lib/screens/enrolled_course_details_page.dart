import 'package:flutter/material.dart';
import 'announcements_page.dart';
import 'modules_page.dart';
import 'assignment_quiz_page.dart';

class EnrolledCourseDetailsPage extends StatefulWidget {
  final String courseId;
  final String courseTitle;
  final String instructor;
  final Color accentColor;
  final String? thumbnailAsset;
  final String? thumbnailUrl;

  const EnrolledCourseDetailsPage({
    Key? key,
    required this.courseId,
    required this.courseTitle,
    required this.instructor,
    required this.accentColor,
    this.thumbnailAsset,
    this.thumbnailUrl,
  }) : super(key: key);

  @override
  State<EnrolledCourseDetailsPage> createState() =>
      _EnrolledCourseDetailsPageState();
}

class _EnrolledCourseDetailsPageState extends State<EnrolledCourseDetailsPage> {
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
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Course Image/Header
            Container(
              height: 200,
              width: double.infinity,
              child: widget.thumbnailAsset != null
                  ? Image.asset(
                      widget.thumbnailAsset!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          _buildPlaceholder(),
                    )
                  : widget.thumbnailUrl != null
                      ? Image.network(
                          widget.thumbnailUrl!,
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
                  // Course Title
                  Text(
                    widget.courseTitle,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Instructor
                  Text(
                    'By ${widget.instructor}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Description
                  const Text(
                    'Lorem ipsum dolor sit amet consectetur. Nec eget accumsan molestie proin. Integer rhoncus vitae nisl nattoque ac mus tellus scelerisque gravida. Consectetur aliquet sit at diam. Augue eu mauris suspendisse adipiscing nibh. Nibh lorem id eu suspendisse nulla leo hendrerit. Erat tortor commodo quam fames et molestie.',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Read More',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.blue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Announcements
                  _buildMenuItem(
                    icon: Icons.notifications_active_outlined,
                    label: 'Announcements',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AnnouncementsPage(
                            courseTitle: widget.courseTitle,
                            accentColor: widget.accentColor,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),

                  // Modules
                  _buildMenuItem(
                    icon: Icons.layers_outlined,
                    label: 'Modules',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ModulesPage(
                            courseTitle: widget.courseTitle,
                            accentColor: widget.accentColor,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),

                  // Assignments / Quizzes
                  _buildMenuItem(
                    icon: Icons.assignment_outlined,
                    label: 'Assignments / Quizzes',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AssignmentsQuizzesPage(
                            courseId: widget.courseId,
                            courseName: widget.courseTitle,
                            courseImage: widget.thumbnailAsset,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),

                  // Downloads
                  _buildMenuItem(
                    icon: Icons.download_outlined,
                    label: 'Downloads',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Downloads feature coming soon!'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                  ),
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
      color: widget.accentColor.withValues(alpha: 0.15),
      child: Center(
        child: Icon(
          Icons.school,
          size: 80,
          color: widget.accentColor.withValues(alpha: 0.5),
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: widget.accentColor,
                  size: 24,
                ),
                const SizedBox(width: 16),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}
