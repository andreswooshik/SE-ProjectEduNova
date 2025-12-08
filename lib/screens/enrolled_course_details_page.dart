import 'package:flutter/material.dart';

class EnrolledCourseDetailsPage extends StatefulWidget {
  final String courseTitle;
  final String instructor;
  final Color accentColor;

  const EnrolledCourseDetailsPage({
    Key? key,
    required this.courseTitle,
    required this.instructor,
    required this.accentColor,
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
              decoration: BoxDecoration(
                color: widget.accentColor.withValues(alpha: 0.15),
              ),
              child: Center(
                child: Icon(
                  Icons.lock,
                  size: 80,
                  color: widget.accentColor,
                ),
              ),
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
                  Text(
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
                      // Navigate to Announcements
                    },
                  ),
                  const SizedBox(height: 16),

                  // Modules
                  _buildMenuItem(
                    icon: Icons.layers_outlined,
                    label: 'Modules',
                    onTap: () {
                      // Navigate to Modules
                    },
                  ),
                  const SizedBox(height: 16),

                  // Assignments / Quizzes
                  _buildMenuItem(
                    icon: Icons.assignment_outlined,
                    label: 'Assignments / Quizzes',
                    onTap: () {
                      // Navigate to Assignments
                    },
                  ),
                  const SizedBox(height: 16),

                  // Downloads
                  _buildMenuItem(
                    icon: Icons.download_outlined,
                    label: 'Downloads',
                    onTap: () {
                      // Navigate to Downloads
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
            Icon(
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
