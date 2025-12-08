import 'package:flutter/material.dart';

class CourseDetailsPage extends StatefulWidget {
  final String courseTitle;
  final String instructor;
  final Color accentColor;

  const CourseDetailsPage({
    Key? key,
    required this.courseTitle,
    required this.instructor,
    required this.accentColor,
  }) : super(key: key);

  @override
  State<CourseDetailsPage> createState() => _CourseDetailsPageState();
}

class _CourseDetailsPageState extends State<CourseDetailsPage> {
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
            // Course Image/Header
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: widget.accentColor.withValues(alpha: 0.15),
              ),
              child: Center(
                child: Icon(
                  Icons.play_circle_filled,
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
                  // Tabs
                  Row(
                    children: [
                      _buildTab('Overview', 0),
                      _buildTab('Lessons', 1),
                      _buildTab('Reviews', 2),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Tab Content
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
    return Column(
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
        const SizedBox(height: 8),

        // Rating
        Row(
          children: [
            ...List.generate(5, (index) {
              return const Icon(Icons.star, size: 16, color: Colors.blue);
            }),
          ],
        ),
        const SizedBox(height: 16),

        // Description
        const Text(
          'Lorem ipsum dolor sit amet consectetur. Nec eget accumsan molestie proin. Integer rhoncus vitae nisl nattoque ac mus tellus scelerisque gravida. Consectetur aliquet sit at diam. Augue eu mauris suspendisse adipiscing nibh. Nibh lorem id eu suspendisse nulla leo hendrerit. Erat tortor commodo quam fames et molestie.',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey,
            height: 1.6,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Read More',
          style: TextStyle(
            fontSize: 14,
            color: Colors.blue,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 24),

        // Course Info Cards
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
                    Icon(
                      Icons.play_lesson,
                      color: Colors.blue,
                      size: 32,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '80+ Lectures',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Icon(
                      Icons.card_membership,
                      color: Colors.blue,
                      size: 32,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Certificate',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Icon(
                      Icons.schedule,
                      color: Colors.blue,
                      size: 32,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '8 Weeks',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Skills Section
        const Text(
          'Skills',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
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

        // Enroll Button
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF003366),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'GET ENROLL',
              style: TextStyle(
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

  Widget _buildLessonsTab() {
    return StatefulBuilder(
      builder: (context, setState) {
        List<Map<String, dynamic>> chapters = [
          {
            'title': 'Chapter 1 : What is Graphics Designing?',
            'isExpanded': true,
            'lessons': [
              {
                'icon': Icons.play_circle,
                'text': 'Lorem ipsum dolor sit amet consectetur.'
              },
              {
                'icon': Icons.description,
                'text': 'Lorem ipsum dolor sit amet consectetur.'
              },
              {
                'icon': Icons.play_circle,
                'text': 'Lorem ipsum dolor sit amet consectetur.'
              },
              {
                'icon': Icons.description,
                'text': 'Lorem ipsum dolor sit amet consectetur.'
              },
            ]
          },
          {
            'title': 'Chapter 2 : What is Logo Designing?',
            'isExpanded': false,
            'lessons': [
              {
                'icon': Icons.play_circle,
                'text': 'Lorem ipsum dolor sit amet consectetur.'
              },
              {
                'icon': Icons.description,
                'text': 'Lorem ipsum dolor sit amet consectetur.'
              },
            ]
          },
          {
            'title': 'Chapter 3 : What is Poster Designing?',
            'isExpanded': false,
            'lessons': [
              {
                'icon': Icons.play_circle,
                'text': 'Lorem ipsum dolor sit amet consectetur.'
              },
              {
                'icon': Icons.description,
                'text': 'Lorem ipsum dolor sit amet consectetur.'
              },
            ]
          },
          {
            'title': 'Chapter 4 : What is Picture Editing?',
            'isExpanded': false,
            'lessons': [
              {
                'icon': Icons.play_circle,
                'text': 'Lorem ipsum dolor sit amet consectetur.'
              },
            ]
          },
        ];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: chapters.length,
              itemBuilder: (context, chapterIndex) {
                return Column(
                  children: [
                    // Chapter Header
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          chapters[chapterIndex]['isExpanded'] =
                              !chapters[chapterIndex]['isExpanded'];
                        });
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                chapters[chapterIndex]['title'],
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Icon(
                              chapters[chapterIndex]['isExpanded']
                                  ? Icons.expand_less
                                  : Icons.expand_more,
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Lessons for this chapter
                    if (chapters[chapterIndex]['isExpanded'])
                      ...List.generate(
                        chapters[chapterIndex]['lessons'].length,
                        (lessonIndex) {
                          var lesson =
                              chapters[chapterIndex]['lessons'][lessonIndex];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.blue.withValues(alpha: 0.08),
                              border: Border.all(
                                  color: Colors.blue.withValues(alpha: 0.2)),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  lesson['icon'],
                                  color: Colors.blue,
                                  size: 24,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    lesson['text'],
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),

                    const SizedBox(height: 16),
                  ],
                );
              },
            ),
            const SizedBox(height: 24),

            // Enroll Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF003366),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'GET ENROLL',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildReviewsTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Student Reviews',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 3,
          itemBuilder: (context, index) {
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.grey.shade300,
                        child: Text('${index + 1}'),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Student ${index + 1}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                            Row(
                              children: [
                                ...List.generate(5, (starIndex) {
                                  return const Icon(Icons.star,
                                      size: 14, color: Colors.blue);
                                }),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Great course! Very comprehensive and well explained.',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildSkillChip(String skill) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        skill,
        style: const TextStyle(
          fontSize: 12,
          color: Colors.black,
        ),
      ),
    );
  }
}
