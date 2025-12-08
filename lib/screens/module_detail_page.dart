import 'package:flutter/material.dart';

class ModuleDetailPage extends StatelessWidget {
  final String courseTitle;
  final String moduleTitle;
  final Color accentColor;

  const ModuleDetailPage({
    Key? key,
    required this.courseTitle,
    required this.moduleTitle,
    required this.accentColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get module details based on title
    final details = _getModuleDetails(moduleTitle);

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
                  // Module Title
                  Text(
                    details['displayTitle'] ?? moduleTitle,
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

                  // Definition Section
                  if (details['definition'] != null) ...[
                    const Text(
                      'Definition of Cybersecurity',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      details['definition']!,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade700,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (details['definitionPoints'] != null) ...[
                      ...List.generate(
                        (details['definitionPoints']
                                as List<Map<String, String>>)
                            .length,
                        (index) {
                          final point = (details['definitionPoints']
                              as List<Map<String, String>>)[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  point['title']!,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  point['description']!,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                                if (point['example'] != null) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    'Example: ${point['example']!}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                    const SizedBox(height: 24),
                  ],

                  // Common Cyber Threats Section
                  if (details['commonThreats'] != null) ...[
                    const Text(
                      'Common Cyber Threats',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Students should be familiar with the major categories of digital threats.',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...List.generate(
                      (details['commonThreats'] as List<Map<String, String>>)
                          .length,
                      (index) {
                        final threat = (details['commonThreats']
                            as List<Map<String, String>>)[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    '• ${threat['name']!}',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: Text(
                                  threat['description']!,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Key Security Terminology Section
                  if (details['terminology'] != null) ...[
                    const Text(
                      'Key Security Terminology',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...List.generate(
                      (details['terminology'] as List<Map<String, String>>)
                          .length,
                      (index) {
                        final term = (details['terminology']
                            as List<Map<String, String>>)[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    '• ${term['term']!}',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: Text(
                                  term['definition']!,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Real-World Relevance Section
                  if (details['realWorldRelevance'] != null) ...[
                    const Text(
                      'Real-World Relevance',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      details['realWorldRelevance']!,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade700,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Resources Section
                  if (details['resources'] != null) ...[
                    const Text(
                      'Resources for deeper learning:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...List.generate(
                      (details['resources'] as List<String>).length,
                      (index) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: GestureDetector(
                          onTap: () {},
                          child: Row(
                            children: [
                              Icon(
                                Icons.link,
                                color: accentColor,
                                size: 16,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  (details['resources'] as List<String>)[index],
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.blue,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Topics Covered Section
                  if (details['topicsCovered'] != null) ...[
                    const Text(
                      'Topics Covered:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...List.generate(
                      (details['topicsCovered'] as List<Map<String, dynamic>>)
                          .length,
                      (index) {
                        final topic = (details['topicsCovered']
                            as List<Map<String, dynamic>>)[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                topic['title'],
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                              if (topic['subtopics'] != null) ...[
                                const SizedBox(height: 6),
                                ...List.generate(
                                  (topic['subtopics'] as List<String>).length,
                                  (subIndex) => Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 4, left: 16),
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
                                            (topic['subtopics']
                                                as List<String>)[subIndex],
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
                              ],
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Learning Goals Section
                  if (details['learningGoals'] != null) ...[
                    const Text(
                      'Learning Goals',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'By the end of this module, you should be able to:',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...List.generate(
                      (details['learningGoals'] as List<String>).length,
                      (index) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                                (details['learningGoals']
                                    as List<String>)[index],
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
                    const SizedBox(height: 24),
                  ],

                  // Activity Section
                  if (details['activity'] != null) ...[
                    const Text(
                      'Activity',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...List.generate(
                      (details['activity'] as List<String>).length,
                      (index) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                                (details['activity'] as List<String>)[index],
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
                    const SizedBox(height: 24),
                  ],

                  // Learning Materials Section
                  if (details['learningMaterials'] != null) ...[
                    const Text(
                      'Learning Materials',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...List.generate(
                      (details['learningMaterials']
                              as List<Map<String, String>>)
                          .length,
                      (index) {
                        final material = (details['learningMaterials']
                            as List<Map<String, String>>)[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: GestureDetector(
                            onTap: () {
                              // Handle material tap
                            },
                            child: Row(
                              children: [
                                Icon(
                                  material['type'] == 'file'
                                      ? Icons.description
                                      : Icons.play_circle,
                                  color: accentColor,
                                  size: 20,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    material['title']!,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.blue,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Image Section
                  if (details['image'] != null) ...[
                    Container(
                      width: double.infinity,
                      height: 220,
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Map<String, dynamic> _getModuleDetails(String moduleTitle) {
    final Map<String, Map<String, dynamic>> moduleDetails = {
      'Module 1: Introduction to Cybersecurity': {
        'overview':
            'This module introduces the basic concepts of cybersecurity, common threats, and why security matters in digital systems.',
        'definition':
            'The CIA Triad is the core security model used to guide policies and decision-making.',
        'definitionPoints': [
          {
            'title': '• Confidentiality',
            'description':
                'Ensuring that information is accessible only to authorized individuals.',
            'example': 'Encryption, access controls, authentication.',
          },
          {
            'title': '• Integrity',
            'description':
                'Maintaining the accuracy and trustworthiness of data.',
            'example': 'Hashing, file permissions, version control.',
          },
          {
            'title': '• Availability',
            'description':
                'Ensuring that systems and data are accessible when needed.',
            'example': 'Backup systems, redundancy, DDoS protection.',
          },
        ],
        'commonThreats': [
          {
            'name': 'Malware',
            'description':
                'Software designed to cause harm (e.g., viruses, ransomware, worms).',
          },
          {
            'name': 'Phishing',
            'description':
                'Fraudulent attempts to obtain sensitive information through deception.',
          },
          {
            'name': 'Social Engineering',
            'description':
                'Manipulating individuals into revealing confidential information.',
          },
          {
            'name': 'Insider Threats',
            'description':
                'Risks originating from users within an organization—intentional or accidental.',
          },
          {
            'name': 'Unauthorized Access',
            'description':
                'Attempts to enter systems without permission, often through weak passwords or misconfigurations.',
          },
        ],
        'terminology': [
          {
            'term': 'Threat',
            'definition': '- A potential cause of unwanted impact.',
          },
          {
            'term': 'Vulnerability',
            'definition': '- A weakness that can be exploited.',
          },
          {
            'term': 'Risk',
            'definition':
                '- The likelihood that a threat will exploit a vulnerability.',
          },
          {
            'term': 'Attack Vector',
            'definition': '- The method an attacker uses to gain access.',
          },
          {
            'term': 'Exploit',
            'definition':
                '- Code or techniques used to take advantage of a vulnerability.',
          },
          {
            'term': 'Zero-Day',
            'definition':
                '- A previously unknown vulnerability with no existing fix.',
          },
        ],
        'realWorldRelevance':
            'Cybersecurity incidents continue to rise globally. Data breaches, ransomware attacks, and system outages significantly impact businesses, governments, and individuals. Understanding these foundational concepts prepares students for deeper technical topics in the next modules.',
        'resources': [
          'Cybersecurity Basics by FTD',
          'Cybersecurity Basics by Global InteragencytSecurity',
        ],
        'topicsCovered': [
          {
            'title': 'What is Cybersecurity?',
            'subtopics': null,
          },
          {
            'title': 'CIA Triad (Confidentiality, Integrity, Availability)',
            'subtopics': null,
          },
          {
            'title': 'Types of Cyber Threats',
            'subtopics': [
              'Malware',
              'Phishing',
              'Social Engineering',
              'Insider Threats',
            ],
          },
          {
            'title': 'Basic Security Terms',
            'subtopics': [
              'Threat, Vulnerability, Risk',
              'Attack Vector',
              'Zero-Day',
              'Exploit',
            ],
          },
          {
            'title': 'Real-world Cyber Incidents (Short Examples)',
            'subtopics': null,
          },
        ],
        'learningGoals': [
          'Understand the purpose of cybersecurity',
          'Identify common forms of cyber attacks.',
          'Explain the CIA Triad.',
          'Recognize basic vocabulary used in security.',
        ],
        'activity': [
          'Read: "Cybersecurity Basics" (PDF)',
          'Watch: Intro to Cyber Threats (8-10 mins)',
          'Quick Check: 5-item quiz',
        ],
        'learningMaterials': [
          {
            'type': 'file',
            'title': 'Go to Materials',
          },
          {
            'type': 'file',
            'title': 'Cybersecurity Basic Knowledge',
          },
          {
            'type': 'video',
            'title': 'Fundamentals of Networking Operations',
          },
        ],
        'image': 'assets/networking_fundamentals.png',
      },
      'Module 2: Networking Basics for Cybersecurity': {
        'displayTitle': 'Cybersecurity Basics',
        'overview':
            'Cybersecurity is the discipline focused on protecting information systems—such as networks, devices, applications, and data—from unauthorized access, disruption, or destruction. This module introduces the foundational concepts that guide modern security practices.',
        'definition':
            'The CIA Triad is the core security model used to guide policies and decision-making.',
        'definitionPoints': [
          {
            'title': '• Confidentiality',
            'description':
                'Ensuring that information is accessible only to authorized individuals.',
            'example': 'Encryption, access controls, authentication.',
          },
          {
            'title': '• Integrity',
            'description':
                'Maintaining the accuracy and trustworthiness of data.',
            'example': 'Hashing, file permissions, version control.',
          },
          {
            'title': '• Availability',
            'description':
                'Ensuring that systems and data are accessible when needed.',
            'example': 'Backup systems, redundancy, DDoS protection.',
          },
        ],
        'commonThreats': [
          {
            'name': 'Malware',
            'description':
                'Software designed to cause harm (e.g., viruses, ransomware, worms).',
          },
          {
            'name': 'Phishing',
            'description':
                'Fraudulent attempts to obtain sensitive information through deception.',
          },
          {
            'name': 'Social Engineering',
            'description':
                'Manipulating individuals into revealing confidential information.',
          },
          {
            'name': 'Insider Threats',
            'description':
                'Risks originating from users within an organization—intentional or accidental.',
          },
          {
            'name': 'Unauthorized Access',
            'description':
                'Attempts to enter systems without permission, often through weak passwords or misconfigurations.',
          },
        ],
        'terminology': [
          {
            'term': 'Threat',
            'definition': '- A potential cause of unwanted impact.',
          },
          {
            'term': 'Vulnerability',
            'definition': '- A weakness that can be exploited.',
          },
          {
            'term': 'Risk',
            'definition':
                '- The likelihood that a threat will exploit a vulnerability.',
          },
          {
            'term': 'Attack Vector',
            'definition': '- The method an attacker uses to gain access.',
          },
          {
            'term': 'Exploit',
            'definition':
                '- Code or techniques used to take advantage of a vulnerability.',
          },
          {
            'term': 'Zero-Day',
            'definition':
                '- A previously unknown vulnerability with no existing fix.',
          },
        ],
        'realWorldRelevance':
            'Cybersecurity incidents continue to rise globally. Data breaches, ransomware attacks, and system outages significantly impact businesses, governments, and individuals. Understanding these foundational concepts prepares students for deeper technical topics in the next modules.',
        'resources': [
          'Cybersecurity Basics by FTD',
          'Cybersecurity Basics by Global InteragencytSecurity',
        ],
      },
      'Module 3: Network Security': {
        'overview':
            'Learn about network defense mechanisms including firewalls, IDS/IPS, and secure network design principles.',
        'topicsCovered': [
          {
            'title': 'Firewalls & IDS/IPS',
            'subtopics': null,
          },
          {
            'title': 'Secure Network Design',
            'subtopics': null,
          },
          {
            'title': 'Common Network Attacks',
            'subtopics': [
              'DoS',
              'MITM',
              'ARP Spoofing',
            ],
          },
          {
            'title': 'Wireshark Basics + Packet Inspection',
            'subtopics': null,
          },
        ],
        'learningGoals': [
          'Configure basic firewall rules',
          'Understand IDS/IPS functionality',
          'Identify network attacks',
          'Analyze network traffic.',
        ],
        'activity': [
          'Watch: Network Security Principles (15 mins)',
          'Lab: Configure firewall rules',
          'Lab: Wireshark packet analysis',
        ],
        'learningMaterials': [
          {
            'type': 'file',
            'title': 'Firewall Configuration Guide',
          },
          {
            'type': 'video',
            'title': 'Network Intrusion Detection',
          },
        ],
      },
    };

    return moduleDetails[moduleTitle] ??
        {
          'displayTitle': moduleTitle,
          'overview': 'No details available for this module.',
        };
  }
}
