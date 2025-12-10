import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/course.dart';
import '../providers/enrollment_provider.dart';

class CourseDetailsPage extends ConsumerStatefulWidget {
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
    final isEnrolled =
        ref.watch(enrollmentProvider.notifier).isEnrolled(widget.course.id);

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
                  : widget.course.thumbnailUrl != null
                      ? Image.network(
                          widget.course.thumbnailUrl!,
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
                  if (_selectedIndex == 0) _buildOverviewTab(isEnrolled),
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

  Widget _buildOverviewTab(bool isEnrolled) {
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
                  children: const [
                    Icon(Icons.play_lesson, color: Colors.blue, size: 32),
                    SizedBox(height: 8),
                    Text('80+ Lectures',
                        style: TextStyle(fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: const [
                    Icon(Icons.card_membership, color: Colors.blue, size: 32),
                    SizedBox(height: 8),
                    Text('Certificate',
                        style: TextStyle(fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: const [
                    Icon(Icons.schedule, color: Colors.blue, size: 32),
                    SizedBox(height: 8),
                    Text('8 Weeks',
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

  void _handleEnrollment() {
    final enrollmentNotifier = ref.read(enrollmentProvider.notifier);
    final isEnrolled = enrollmentNotifier.isEnrolled(widget.course.id);

    if (isEnrolled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Already enrolled in this course!'),
          backgroundColor: Colors.orange,
        ),
      );
    } else {
      enrollmentNotifier.enrollCourse(widget.course);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Successfully enrolled!'),
          backgroundColor: Colors.green,
        ),
      );
      setState(() {});
    }
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
          ],
        );
      },
    );
  }

  Widget _buildReviewsTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 3,
          itemBuilder: (context, index) {
            List<String> reviewerNames = [
              'Brendan Lumicday',
              'Reiner Dela Cerna',
              'Andres Ebuna',
            ];

            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: Colors.grey.shade300,
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                reviewerNames[index],
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Student',
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: List.generate(5, (starIndex) {
                          return const Icon(
                            Icons.star,
                            size: 16,
                            color: Colors.blue,
                          );
                        }),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Lorem ipsum dolor sit amet consectetur. Euismod turpis tortor sollicitudin et.',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.black87,
                      height: 1.5,
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
      child: Text(skill, style: const TextStyle(fontSize: 12)),
    );
  }
}
