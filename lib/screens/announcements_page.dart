import 'package:flutter/material.dart';
import 'announcement_detail_page.dart';

class AnnouncementsPage extends StatelessWidget {
  final String courseTitle;
  final Color accentColor;

  const AnnouncementsPage({
    Key? key,
    required this.courseTitle,
    required this.accentColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Define announcements based on course
    final List<Map<String, String>> announcements =
        _getAnnouncementsByCourse(courseTitle);

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
            // Course Header
            Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.15),
              ),
              child: Center(
                child: Icon(
                  Icons.lock,
                  size: 60,
                  color: accentColor,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  const Text(
                    'Announcements',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Course Name
                  Text(
                    courseTitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Announcements List
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: announcements.length,
                    itemBuilder: (context, index) {
                      final announcement = announcements[index];
                      return _buildAnnouncementItem(
                        title: announcement['title']!,
                        date: announcement['date']!,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AnnouncementDetailPage(
                                courseTitle: courseTitle,
                                announcementTitle: announcement['title']!,
                                accentColor: accentColor,
                              ),
                            ),
                          );
                        },
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

  Widget _buildAnnouncementItem({
    required String title,
    required String date,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.layers_outlined,
                  color: accentColor,
                  size: 24,
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      date,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  List<Map<String, String>> _getAnnouncementsByCourse(String courseName) {
    // Define announcements for each course
    final Map<String, List<Map<String, String>>> courseAnnouncements = {
      'Cybersecurity': [
        {
          'title': 'Network Security Deep Dive',
          'date': 'Last post Nov 24, 2025 at 2:29 AM',
        },
        {
          'title': 'Announcements',
          'date': 'Last post Nov 24, 2025 at 2:29 AM',
        },
        {
          'title': 'Log File Investigation Challenge',
          'date': 'Last post Nov 24, 2025 at 2:29 AM',
        },
        {
          'title': 'Announcements',
          'date': 'Last post Nov 24, 2025 at 2:29 AM',
        },
        {
          'title': 'Announcements',
          'date': 'Last post Nov 24, 2025 at 2:29 AM',
        },
        {
          'title': 'Announcements',
          'date': 'Last post Nov 24, 2025 at 2:29 AM',
        },
        {
          'title': 'Introduction to Penetration Testing',
          'date': 'Last post Nov 24, 2025 at 2:29 AM',
        },
        {
          'title': 'Understanding Firewalls & IDS/IPS',
          'date': 'Last post Nov 24, 2025 at 2:29 AM',
        },
        {
          'title': 'Notes on Cryptography Essentials',
          'date': 'Last post Nov 24, 2025 at 2:29 AM',
        },
        {
          'title': 'PenTest Tools Download Instructions',
          'date': 'Last post Nov 24, 2025 at 2:29 AM',
        },
      ],
      'Graphic Design': [
        {
          'title': 'Design Principles Masterclass',
          'date': 'Last post Nov 23, 2025 at 3:15 AM',
        },
        {
          'title': 'Color Theory Workshop',
          'date': 'Last post Nov 23, 2025 at 3:15 AM',
        },
        {
          'title': 'Typography Tips and Tricks',
          'date': 'Last post Nov 23, 2025 at 3:15 AM',
        },
      ],
      'Web Design': [
        {
          'title': 'Responsive Design Guidelines',
          'date': 'Last post Nov 22, 2025 at 1:45 AM',
        },
        {
          'title': 'CSS Best Practices',
          'date': 'Last post Nov 22, 2025 at 1:45 AM',
        },
      ],
      'MySql Basics': [
        {
          'title': 'Database Design Principles',
          'date': 'Last post Nov 21, 2025 at 4:30 AM',
        },
        {
          'title': 'SQL Query Optimization',
          'date': 'Last post Nov 21, 2025 at 4:30 AM',
        },
      ],
    };

    // Return announcements for the course or empty list
    return courseAnnouncements[courseName] ?? [];
  }
}
