import 'package:flutter/material.dart';

class AnnouncementDetailPage extends StatelessWidget {
  final String courseTitle;
  final String announcementTitle;
  final Color accentColor;

  const AnnouncementDetailPage({
    Key? key,
    required this.courseTitle,
    required this.announcementTitle,
    required this.accentColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get announcement details based on title
    final details = _getAnnouncementDetails(announcementTitle);

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
                  Text(
                    announcementTitle,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Overview Section
                  if (details['overview'] != null) ...[
                    const Text(
                      'Overview:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      details['overview']!,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade700,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Tools List Section
                  if (details['toolsList'] != null) ...[
                    ...List.generate(
                      (details['toolsList'] as List<String>).length,
                      (index) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            Text(
                              '• ',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade700,
                              ),
                            ),
                            Text(
                              (details['toolsList'] as List<String>)[index],
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Tasks Section
                  if (details['tasks'] != null) ...[
                    const Text(
                      'Tasks:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...List.generate(
                      (details['tasks'] as List<String>).length,
                      (index) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 12, top: 2),
                              child: Text(
                                '${index + 1}.',
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                (details['tasks'] as List<String>)[index],
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey.shade700,
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Instructions Section
                  if (details['instructions'] != null) ...[
                    const Text(
                      'Instructions:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...List.generate(
                      (details['instructions'] as List<String>).length,
                      (index) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 12, top: 2),
                              child: Text(
                                '${index + 1}.',
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                (details['instructions']
                                    as List<String>)[index],
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey.shade700,
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Deadline Section
                  if (details['deadline'] != null) ...[
                    RichText(
                      text: TextSpan(
                        children: [
                          const TextSpan(
                            text: 'Deadline: ',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          TextSpan(
                            text: details['deadline']!,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Note Section
                  if (details['note'] != null) ...[
                    RichText(
                      text: TextSpan(
                        children: [
                          const TextSpan(
                            text: 'Note: ',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          TextSpan(
                            text: details['note']!,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade700,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Reminder Section
                  if (details['reminder'] != null) ...[
                    const Text(
                      'Reminder:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      details['reminder']!,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade700,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Image Section
                  if (details['imageUrl'] != null) ...[
                    Container(
                      width: double.infinity,
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.image,
                          size: 60,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Reply Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle reply
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF003366),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Reply',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
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

  Map<String, dynamic> _getAnnouncementDetails(String title) {
    final Map<String, Map<String, dynamic>> details = {
      'Network Security Deep Dive': {
        'overview':
            'Explore basic network defenses (firewalls, IDS/IPS) and check traffic for possible attacks.',
        'tasks': [
          'Watch: Network Security Deep Dive (20 mins)',
          'Read: Network Security Basics (PDF)',
          'Analyze: Download the PCAP → check for scans/suspicious packets using Wireshark',
          'Submit: Short report (findings + screenshots)',
        ],
        'deadline': 'Nov 28, 2025 - 11:59 PM',
        'note': 'Individual work only. Contact instructor if PCAP won\'t open.',
        'imageUrl': 'assets/network_diagram.png',
      },
      'Announcements': {
        'overview':
            'Please download the required PenTest tools for our next activity:',
        'toolsList': [
          'Nmap',
          'Wireshark',
          'Burp Suite Community',
          'OWASP ZAP',
        ],
        'instructions': [
          'Go to the "Download Tools" section in LMS.',
          'Choose your OS (Windows/Mac/Linux).',
          'Follow the install guides provided.',
          'Test if each tool opens properly.',
        ],
        'reminder': 'Tools must be installed before our next lab session.',
      },
      'Log File Investigation Challenge': {
        'overview':
            'Learn how to analyze and interpret system log files to detect security incidents and anomalies.',
        'tasks': [
          'Watch: Log Analysis Fundamentals (15 mins)',
          'Read: Common Log File Formats',
          'Analyze: Download sample logs and identify suspicious entries',
          'Submit: Investigation report with findings',
        ],
        'deadline': 'Nov 30, 2025 - 11:59 PM',
        'note':
            'Use provided log analysis tools. Ask instructor for assistance.',
      },
      'Introduction to Penetration Testing': {
        'overview':
            'Get started with ethical penetration testing concepts and basic methodologies.',
        'tasks': [
          'Watch: Intro to Pen Testing (25 mins)',
          'Read: Pen Testing Framework Overview',
          'Practice: Complete basic vulnerability scan exercise',
          'Submit: Summary of findings',
        ],
        'deadline': 'Dec 2, 2025 - 11:59 PM',
        'note':
            'Only use provided test environments. Do not perform testing on external systems.',
      },
      'Understanding Firewalls & IDS/IPS': {
        'overview':
            'Deep dive into firewall technologies and intrusion detection/prevention systems.',
        'tasks': [
          'Watch: Firewall Concepts (30 mins)',
          'Read: IDS/IPS Comparison Guide',
          'Lab: Configure basic firewall rules',
          'Submit: Configuration screenshots',
        ],
        'deadline': 'Dec 5, 2025 - 11:59 PM',
        'note':
            'Use the virtual lab environment provided. Do not modify production systems.',
      },
      'Notes on Cryptography Essentials': {
        'overview':
            'Essential cryptography concepts for securing data and communications.',
        'tasks': [
          'Read: Cryptography Fundamentals (PDF)',
          'Watch: Encryption Methods Overview (25 mins)',
          'Practice: Implement basic encryption algorithms',
          'Submit: Code implementation with documentation',
        ],
        'deadline': 'Dec 3, 2025 - 11:59 PM',
        'note': 'Focus on symmetric and asymmetric encryption.',
      },
      'PenTest Tools Download Instructions': {
        'overview':
            'Please download the required PenTest tools for our next activity:',
        'toolsList': [
          'Nmap',
          'Wireshark',
          'Burp Suite Community',
          'OWASP ZAP',
        ],
        'instructions': [
          'Go to the "Download Tools" section in LMS.',
          'Choose your OS (Windows/Mac/Linux).',
          'Follow the install guides provided.',
          'Test if each tool opens properly.',
        ],
        'reminder': 'Tools must be installed before our next lab session.',
      },
    };

    return details[title] ??
        {
          'overview': 'No details available for this announcement.',
        };
  }
}
