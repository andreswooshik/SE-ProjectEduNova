# EduNova – Innovating Access to Quality Education

[![Flutter CI](https://github.com/andreswooshik/SE-ProjectEduNova/workflows/Flutter%20CI/badge.svg)](https://github.com/andreswooshik/SE-ProjectEduNova/actions)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

**EduNova** is a mobile application project designed in Figma and developed using Flutter. The platform provides students and teachers with access to curated learning resources, collaboration spaces, and partnership contributions. The project supports SDG 4 (Quality Education) by promoting inclusive and equitable education, and SDG 17 (Partnership for the Goals) by connecting schools, NGOs, and institutions to share resources and knowledge.

## 📚 Documentation

- **[Developer Guide](DEVELOPER_GUIDE.md)** - Comprehensive guide for developers
- **[Contributing Guidelines](CONTRIBUTING.md)** - How to contribute to the project
- **[Security Best Practices](SECURITY.md)** - Security guidelines and best practices
- **[Testing Guide](TESTING_GUIDE.md)** - Testing procedures and guidelines
- **[Implementation Summary](IMPLEMENTATION_SUMMARY_PHASE_1-3.md)** - Backend implementation details
- **[Role-Based Authentication](ROLE_BASED_AUTH_IMPLEMENTATION.md)** - Authentication system documentation

## Team Members

| Name                     | Contribution                               |
| ------------------------ | ------------------------------------------ |
| Dela Cerna, Reiner Seldon | (UI/UX Design Lead)*                |
| Ebuña, Ralf Andre        | (Flutter Development Lead)*         |
| Lumicday, John Brendan   | (Documentation & Content Planning) |

## ✨ Features

### Current Features
- **Role-Based Authentication**: Automatic role detection for students and teachers
- **Student Dashboard**: Access to courses, modules, and learning resources
- **Teacher Portal**: Course creation, module management, and resource uploads
- **Module System**: Organized learning content with file attachments
- **File Management**: Upload and manage educational resources (PDF, PPT, DOCX, etc.)
- **Secure Storage**: Password hashing with bcrypt
- **Clean Architecture**: SOLID principles and dependency injection

### Upcoming Features
- Backend database integration
- Real-time collaboration features
- Discussion forums
- Advanced analytics
- Mobile notifications

## Objectives

### Main Goal
To design and develop a user-friendly mobile prototype that provides an accessible platform for quality resources, fostering collaboration among learners, teachers, and partner organizations while enhancing learning opportunities and promoting inclusive, quality education.

### Specific Objectives
- Create wireframes and high-fidelity UI screens in Figma.
- Develop a working mobile prototype in Flutter with navigation and UI components.
- Provide a resource-sharing hub where students and teachers can access materials.
- Enable discussion forums and mentorship sections for collaborative learning.
- Build a knowledge-sharing hub for students and teachers.

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (>=3.0.0 <4.0.0)
- Dart SDK (comes with Flutter)
- Android Studio or VS Code with Flutter extensions
- Git

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/andreswooshik/SE-ProjectEduNova.git
   cd SE-ProjectEduNova
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Quick Test

Try these test accounts to explore the app:

**Student Account:**
- Email: `student@gmail.com`
- Password: `password123`

**Teacher Account:**
- Email: `teacher@university.edu`
- Password: `password123`

## 🏗️ Architecture

The project follows **Clean Architecture** principles with clear separation of concerns:

```
lib/
├── core/           # Constants, utilities, validators
├── models/         # Data models
├── services/       # Business logic services
├── repositories/   # Data access layer
├── providers/      # Riverpod state management
├── screens/        # UI screens
└── widgets/        # Reusable widgets
```

### Key Technologies
- **State Management**: Riverpod 3.x
- **Local Storage**: SharedPreferences
- **Authentication**: Custom with bcrypt
- **File Handling**: file_picker, path_provider

## Scope

### In-Scope Features
*   **User Roles:** Students, Teachers, Partners.
*   **Mobile App Navigation:** Login, dashboard, modules.
*   **Digital Library:** A hub for learning resources.
*   **Interactive Forums:** Areas for discussions and Q&A.
*   **Clickable Prototype:** A functional prototype built with Figma and Flutter.

### Out-of-Scope Features
*   Backend database integration (planned for future).
*   Web-based version (the focus is on the mobile app).

## Technologies & Tools

*   **UI/UX Design:** Figma
*   **App Development:** Flutter & Dart
*   **State Management:** Riverpod
*   **Documentation:** Markdown, Google Drive / Docs
*   **CI/CD:** GitHub Actions
*   **Version Control:** Git & GitHub

## 🧪 Testing

Run tests with:
```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run analysis
flutter analyze

# Format code
dart format .
```

## 🤝 Contributing

We welcome contributions! Please read our [Contributing Guidelines](CONTRIBUTING.md) before submitting pull requests.

### Quick Contribution Steps
1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'feat: add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 🔒 Security

For security best practices and reporting vulnerabilities, please see [SECURITY.md](SECURITY.md).

## Project Timeline

| Milestone                               | Dates                      |
| --------------------------------------- | -------------------------- |
| Requirement Gathering and Research      | September 16 - September 29 |
| Feasibility Study and Planning          | September 30 - October 6   |
| Database and Content Planning           | October 7 - October 20     |
| Wireframing and UI/UX Design in Figma   | October 21 - November 3    |
| Flutter Prototype Development           | November 4 - November 17   |
| Testing, Evaluation, and Documentation  | November 18 - December 1   |

## 📄 License

This project is part of an academic initiative. Please contact the team for licensing information.

## 📞 Contact

For questions, suggestions, or issues, please:
- Open an issue on GitHub
- Contact the development team
- Check our documentation

## 🙏 Acknowledgments

- All contributors and team members
- Flutter and Dart communities
- Educational institutions supporting this initiative

---

**Developed with ❤️ for quality education**