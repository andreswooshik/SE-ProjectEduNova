import 'package:flutter/material.dart';
import 'module_detail_page.dart';

class ModulesPage extends StatelessWidget {
  final String courseTitle;
  final Color accentColor;

  const ModulesPage({
    Key? key,
    required this.courseTitle,
    required this.accentColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get modules based on course
    final List<Map<String, dynamic>> modules = _getModulesByCourse(courseTitle);

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
                  // Chapter Title
                  const Text(
                    'Chapter 1',
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

                  // Modules List
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: modules.length,
                    itemBuilder: (context, index) {
                      final module = modules[index];
                      return _buildModuleCard(
                        title: module['title']!,
                        topics: module['topics'] as List<String>,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ModuleDetailPage(
                                courseTitle: courseTitle,
                                moduleTitle: module['title']!,
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

  Widget _buildModuleCard({
    required String title,
    required List<String> topics,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Module Title
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey,
                  size: 16,
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Module Folder Icon and Topics
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.folder_outlined,
                  color: accentColor,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(
                      topics.length,
                      (index) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            Text(
                              '• ',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                topics[index],
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Divider
            const SizedBox(height: 16),
            Divider(
              color: Colors.grey.shade300,
              height: 1,
            ),
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _getModulesByCourse(String courseName) {
    final Map<String, List<Map<String, dynamic>>> courseModules = {
      'Cybersecurity': [
        {
          'title': 'Module 1: Introduction to Cybersecurity',
          'topics': [
            'What is Cybersecurity?',
            'Types of Cyber Threats (Malware, Phishing, Social Engineering)',
            'CIA Triad (Confidentiality, Integrity, Availability)',
            'Basic Security Terminology',
          ],
        },
        {
          'title': 'Module 2: Networking Basics for Cybersecurity',
          'topics': [
            'OSI Model & TCP/IP Overview',
            'IP Addressing & Ports',
            'Common Network Protocols (HTTP, DNS, FTP, SSH)',
            'How Hackers Exploit Networks',
          ],
        },
        {
          'title': 'Module 3: Network Security',
          'topics': [
            'Firewalls, IDS/IPS',
            'Secure Network Design',
            'Common Network Attacks (DoS, MITM, ARP Spoofing)',
            'Wireshark Basics + Packet Inspection',
          ],
        },
        {
          'title': 'Module 4: Malware & Attack Techniques',
          'topics': [
            'Firewalls, IDS/IPS',
            'Secure Network Design',
            'Common Network Attacks (DoS, MITM, ARP Spoofing)',
            'Wireshark Basics + Packet Inspection',
          ],
        },
        {
          'title': 'Module 5: Vulnerability Assessment',
          'topics': [
            'What is a Vulnerability?',
            'Scanning Tools (Nmap, Nessus, OpenVAS)',
            'Interpreting Scan Results',
            'Patch & Risk Management Basics',
          ],
        },
      ],
      'Graphic Design': [
        {
          'title': 'Module 1: Design Fundamentals',
          'topics': [
            'Color Theory Basics',
            'Typography Principles',
            'Composition & Layout',
            'Visual Hierarchy',
          ],
        },
        {
          'title': 'Module 2: Design Tools',
          'topics': [
            'Adobe Creative Suite Overview',
            'Photoshop Essentials',
            'Illustrator Basics',
            'InDesign Introduction',
          ],
        },
        {
          'title': 'Module 3: Brand Identity',
          'topics': [
            'Logo Design Principles',
            'Brand Guidelines',
            'Business Card Design',
            'Brand Portfolio',
          ],
        },
      ],
      'Web Design': [
        {
          'title': 'Module 1: Web Design Fundamentals',
          'topics': [
            'User Interface (UI) Basics',
            'User Experience (UX) Principles',
            'Responsive Design Concepts',
            'Web Design Standards',
          ],
        },
        {
          'title': 'Module 2: HTML & CSS',
          'topics': [
            'HTML Structure',
            'CSS Styling',
            'Box Model',
            'Flexbox & Grid',
          ],
        },
        {
          'title': 'Module 3: Interactive Design',
          'topics': [
            'JavaScript Basics',
            'DOM Manipulation',
            'Event Handling',
            'Creating Animations',
          ],
        },
      ],
      'MySql Basics': [
        {
          'title': 'Module 1: Database Fundamentals',
          'topics': [
            'What is a Database?',
            'Relational Database Concepts',
            'Tables, Rows, and Columns',
            'Primary Keys & Foreign Keys',
          ],
        },
        {
          'title': 'Module 2: SQL Basics',
          'topics': [
            'SELECT Statements',
            'WHERE Clauses',
            'INSERT, UPDATE, DELETE',
            'JOIN Operations',
          ],
        },
        {
          'title': 'Module 3: Advanced Queries',
          'topics': [
            'Aggregation Functions',
            'GROUP BY & HAVING',
            'Subqueries',
            'Indexes & Optimization',
          ],
        },
      ],
    };

    return courseModules[courseName] ?? [];
  }
}
