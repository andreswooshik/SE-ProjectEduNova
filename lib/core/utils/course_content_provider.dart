/// Course Content Data Provider
/// Single Responsibility: Provides course-specific content (skills, chapters, etc.)
class CourseContentProvider {
  /// Get skills based on course title
  static List<String> getSkillsForCourse(String courseTitle) {
    final title = courseTitle.toLowerCase();
    
    if (title.contains('cybersecurity') || title.contains('security')) {
      return [
        'Network Security',
        'Threat Analysis',
        'Ethical Hacking',
        'CIA Triad',
        'Security Protocols',
        'Risk Management',
      ];
    } else if (title.contains('graphic') && title.contains('design')) {
      return [
        'Adobe',
        'Adobe Photo Shop',
        'Logo',
        'Designing',
        'Poster Design',
        'Figma',
      ];
    } else if (title.contains('web') && title.contains('design')) {
      return [
        'HTML',
        'CSS',
        'JavaScript',
        'Responsive Design',
        'UI/UX',
        'Figma',
      ];
    } else if (title.contains('wireframe')) {
      return [
        'Figma',
        'Sketch',
        'Adobe XD',
        'Prototyping',
        'User Flow',
        'UI Design',
      ];
    } else if (title.contains('video') && title.contains('editing')) {
      return [
        'Adobe Premiere',
        'Final Cut Pro',
        'Color Grading',
        'Audio Mixing',
        'Effects',
        'Storytelling',
      ];
    }
    
    // Default skills
    return [
      'Problem Solving',
      'Critical Thinking',
      'Creativity',
      'Communication',
    ];
  }

  /// Get chapters/lessons based on course title
  static List<Map<String, dynamic>> getChaptersForCourse(String courseTitle) {
    final title = courseTitle.toLowerCase();
    
    if (title.contains('cybersecurity') || title.contains('security')) {
      return [
        {
          'title': 'Chapter 1: Introduction to Cybersecurity',
          'lessons': [
            {'title': 'What is Cybersecurity?', 'type': 'video'},
            {'title': 'Types of Cyber Threats (Malware, Phishing, Social Engineering)', 'type': 'document'},
            {'title': 'CIA Triad (Confidentiality, Integrity, Availability)', 'type': 'video'},
            {'title': 'Basic Security Terminology', 'type': 'document'},
          ],
        },
        {
          'title': 'Chapter 2: Networking Basics for Cybersecurity',
          'lessons': [
            {'title': 'OSI Model & TCP/IP Overview', 'type': 'video'},
            {'title': 'IP Addressing & Ports', 'type': 'document'},
            {'title': 'Common Network Protocols (HTTP, DNS, FTP, SSH)', 'type': 'document'},
            {'title': 'How Hackers Exploit Networks', 'type': 'video'},
          ],
        },
        {
          'title': 'Chapter 3: Threat Detection and Prevention',
          'lessons': [
            {'title': 'Understanding Firewalls and IDS/IPS', 'type': 'video'},
            {'title': 'Antivirus and Anti-malware Solutions', 'type': 'document'},
            {'title': 'Security Best Practices', 'type': 'document'},
          ],
        },
        {
          'title': 'Chapter 4: Cryptography Fundamentals',
          'lessons': [
            {'title': 'Introduction to Encryption', 'type': 'video'},
            {'title': 'Symmetric vs Asymmetric Encryption', 'type': 'document'},
            {'title': 'Hash Functions and Digital Signatures', 'type': 'video'},
          ],
        },
      ];
    } else if (title.contains('graphic') && title.contains('design')) {
      return [
        {
          'title': 'Chapter 1: What is Graphics Designing?',
          'lessons': [
            {'title': 'Introduction to Graphic Design Principles', 'type': 'video'},
            {'title': 'Understanding Color Theory', 'type': 'document'},
            {'title': 'Typography Basics', 'type': 'video'},
            {'title': 'Layout and Composition', 'type': 'document'},
          ],
        },
        {
          'title': 'Chapter 2: What is Logo Designing?',
          'lessons': [
            {'title': 'Logo Design Fundamentals', 'type': 'video'},
            {'title': 'Creating Brand Identity', 'type': 'document'},
            {'title': 'Logo Types and Styles', 'type': 'video'},
          ],
        },
        {
          'title': 'Chapter 3: What is Poster Designing?',
          'lessons': [
            {'title': 'Poster Design Principles', 'type': 'video'},
            {'title': 'Visual Hierarchy in Posters', 'type': 'document'},
          ],
        },
        {
          'title': 'Chapter 4: What is Picture Editing?',
          'lessons': [
            {'title': 'Adobe Photoshop Basics', 'type': 'video'},
            {'title': 'Photo Retouching Techniques', 'type': 'document'},
            {'title': 'Color Correction and Grading', 'type': 'video'},
          ],
        },
      ];
    } else if (title.contains('web') && title.contains('design')) {
      return [
        {
          'title': 'Chapter 1: Introduction to Web Design',
          'lessons': [
            {'title': 'HTML Fundamentals', 'type': 'video'},
            {'title': 'CSS Styling Basics', 'type': 'document'},
            {'title': 'Responsive Design Principles', 'type': 'video'},
          ],
        },
        {
          'title': 'Chapter 2: Advanced Web Design',
          'lessons': [
            {'title': 'JavaScript Interactions', 'type': 'video'},
            {'title': 'UI/UX Best Practices', 'type': 'document'},
          ],
        },
      ];
    } else if (title.contains('wireframe')) {
      return [
        {
          'title': 'Chapter 1: Wireframing Basics',
          'lessons': [
            {'title': 'What is Wireframing?', 'type': 'video'},
            {'title': 'Tools for Wireframing', 'type': 'document'},
            {'title': 'Low-Fidelity vs High-Fidelity', 'type': 'video'},
          ],
        },
        {
          'title': 'Chapter 2: Creating Wireframes',
          'lessons': [
            {'title': 'Mobile Wireframing', 'type': 'video'},
            {'title': 'Web Wireframing', 'type': 'document'},
          ],
        },
      ];
    } else if (title.contains('video') && title.contains('editing')) {
      return [
        {
          'title': 'Chapter 1: Video Editing Basics',
          'lessons': [
            {'title': 'Introduction to Video Editing', 'type': 'video'},
            {'title': 'Timeline and Cuts', 'type': 'document'},
            {'title': 'Transitions and Effects', 'type': 'video'},
          ],
        },
        {
          'title': 'Chapter 2: Advanced Techniques',
          'lessons': [
            {'title': 'Color Grading', 'type': 'video'},
            {'title': 'Audio Editing and Mixing', 'type': 'document'},
          ],
        },
      ];
    }
    
    // Default chapters
    return [
      {
        'title': 'Chapter 1: Introduction',
        'lessons': [
          {'title': 'Getting Started', 'type': 'video'},
          {'title': 'Course Overview', 'type': 'document'},
        ],
      },
    ];
  }

  /// Get instructor name based on course title
  static String getInstructorForCourse(String courseTitle) {
    final title = courseTitle.toLowerCase();
    
    if (title.contains('cybersecurity') || title.contains('security')) {
      return 'Syed Hasnain';
    } else if (title.contains('graphic') && title.contains('design')) {
      return 'Kenneth Coppock';
    } else if (title.contains('wireframe')) {
      return 'Shivalo Alo';
    } else if (title.contains('web') && title.contains('design')) {
      return 'Dwayne Wade';
    } else if (title.contains('video') && title.contains('editing')) {
      return 'Ammar Cruz';
    }
    
    return 'Instructor';
  }
}
