import 'package:flutter/material.dart';
import 'module_resource_detail_page.dart';

/// Course Module Page - Shows all modules and their resources
class CourseModulePage extends StatelessWidget {
  final String courseId;
  final String courseTitle;

  const CourseModulePage({
    Key? key,
    required this.courseId,
    required this.courseTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Sample modules data
    final modules = [
      {
        'id': '1',
        'title': 'Module 1: Introduction to $courseTitle',
        'description': 'Learn the fundamentals and basic concepts',
        'resources': [
          {'title': 'Cybersecurity Basics (PDF)', 'type': 'pdf'},
          {'title': 'Common Cyber Threats Guide (PDF)', 'type': 'pdf'},
          {'title': 'CIA Triad Explained (PDF)', 'type': 'pdf'},
          {'title': 'Security Terms Quick Sheet (PDF)', 'type': 'pdf'},
          {'title': 'CIA Triad in Real Life – Article', 'type': 'article'},
          {'title': 'Cyber Threat Examples Pack (.zip)', 'type': 'zip'},
        ],
      },
      {
        'id': '2',
        'title': 'Module 2: Networking Basics for $courseTitle',
        'description': 'Understanding network protocols and security',
        'resources': [
          {'title': 'OSI Model & TCP/IP Overview', 'type': 'pdf'},
          {'title': 'IP Addressing & Ports', 'type': 'pdf'},
          {
            'title': 'Common Network Protocols (HTTP, DNS, FTP, SSH)',
            'type': 'pdf'
          },
          {'title': 'How Hackers Exploit Networks', 'type': 'video'},
        ],
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCourseInfo(),
                    const SizedBox(height: 24),
                    ...modules
                        .map((module) => _buildModuleCard(context, module))
                        .toList(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      height: 200,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(
            'https://images.unsplash.com/photo-1550751827-4bd374c3f58b?w=800',
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withOpacity(0.6),
              Colors.black.withOpacity(0.3),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.arrow_back, size: 24),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCourseInfo() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            courseTitle,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'By Syed Hasnain',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Lorem ipsum dolor sit amet consectetur. Nec eget accumsan molestie proin. Integer rhoncus vitae nisi natoque ac mus tellus scelerisque gravida. Consectetur aliquet sit at diam. Augue eu mauris suspendisse adipiscing nibh. Nibh lorem id suspendisse nulla leo hendrerit. Erat tortor commodo quam fames et molestie...',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              height: 1.6,
            ),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () {},
            child: const Text('Read More'),
          ),
        ],
      ),
    );
  }

  Widget _buildModuleCard(BuildContext context, Map<String, dynamic> module) {
    final resources = module['resources'] as List<Map<String, String>>;

    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Module Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.folder_outlined,
                    color: Theme.of(context).primaryColor,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    module['title'] as String,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Icon(Icons.keyboard_arrow_down, size: 24),
              ],
            ),
          ),
          // Resources List
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: resources.length,
            separatorBuilder: (context, index) => Divider(
              height: 1,
              color: Colors.grey[200],
            ),
            itemBuilder: (context, index) {
              final resource = resources[index];
              return _buildResourceItem(context, resource);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildResourceItem(
      BuildContext context, Map<String, String> resource) {
    final type = resource['type']!;
    IconData icon;
    Color iconColor;

    switch (type) {
      case 'pdf':
        icon = Icons.picture_as_pdf_outlined;
        iconColor = Colors.red;
        break;
      case 'zip':
        icon = Icons.folder_zip_outlined;
        iconColor = Colors.orange;
        break;
      case 'article':
        icon = Icons.article_outlined;
        iconColor = Colors.green;
        break;
      case 'video':
        icon = Icons.play_circle_outline;
        iconColor = Colors.purple;
        break;
      default:
        icon = Icons.description_outlined;
        iconColor = Colors.blue;
    }

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ModuleResourceDetailPage(
              title: resource['title']!,
              type: type,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                resource['title']!,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey[400], size: 24),
          ],
        ),
      ),
    );
  }
}
