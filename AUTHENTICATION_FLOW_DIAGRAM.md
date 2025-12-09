# Role-Based Authentication Flow Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                         SIGN UP FLOW                             │
└─────────────────────────────────────────────────────────────────┘

User enters:
  • Name
  • Email (e.g., teacher@school.edu OR student@gmail.com)
  • School
  • Password
           ↓
    ┌──────────────┐
    │  SignUpPage  │
    └──────┬───────┘
           ↓
    Calls register() method
           ↓
    ┌──────────────────┐
    │  AuthNotifier    │
    └──────┬───────────┘
           ↓
    Uses EmailRoleDetectorService
           ↓
    ┌────────────────────────────────┐
    │ EmailRoleDetectorService       │
    │ • Checks email domain          │
    │ • Checks keywords              │
    └────────┬───────────────────────┘
             ↓
    ┌────────┴─────────┐
    │                  │
    ↓                  ↓
.edu, .org, etc?   Regular email?
teacher keyword?    
    │                  │
    ↓                  ↓
TEACHER ROLE      STUDENT ROLE
    │                  │
    ↓                  ↓
registerTeacher() registerStudent()
    │                  │
    └────────┬─────────┘
             ↓
    User account created
    Navigate to Sign In


┌─────────────────────────────────────────────────────────────────┐
│                         SIGN IN FLOW                             │
└─────────────────────────────────────────────────────────────────┘

User enters:
  • Email
  • Password
           ↓
    ┌──────────────┐
    │  SignInPage  │
    └──────┬───────┘
           ↓
    Calls signIn() method
           ↓
    ┌──────────────────┐
    │  AuthNotifier    │
    └──────┬───────────┘
           ↓
    Authenticates user
           ↓
    Check user.role
           ↓
    ┌──────┴──────┐
    │             │
    ↓             ↓
UserRole.teacher  UserRole.student
    │             │
    ↓             ↓
┌───────────┐  ┌────────────────┐
│  Teacher  │  │    Student     │
│ Dashboard │  │   Dashboard    │
│           │  │ (via Main Nav) │
│ Features: │  │                │
│ • Create  │  │ Features:      │
│   Course  │  │ • Browse       │
│ • Grade   │  │   Courses      │
│ • Manage  │  │ • Enroll       │
│   Students│  │ • Learn        │
│ • Analytics│  │ • Progress    │
└───────────┘  └────────────────┘


┌─────────────────────────────────────────────────────────────────┐
│                    ACCESS CONTROL                                │
└─────────────────────────────────────────────────────────────────┘

TeacherDashboardPage:
    ↓
Checks user.role == UserRole.teacher
    ↓
┌─────┴──────┐
│            │
↓            ↓
YES          NO
│            │
↓            ↓
Show         Show Access
Dashboard    Denied Screen


┌─────────────────────────────────────────────────────────────────┐
│              SOLID PRINCIPLES IMPLEMENTATION                     │
└─────────────────────────────────────────────────────────────────┘

[S] Single Responsibility
    • EmailRoleDetectorService: Only detects roles
    • AuthNotifier: Only manages auth state
    • TeacherDashboardPage: Only handles teacher UI

[O] Open/Closed
    • Easy to add new domains without modifying service
    • New roles can be added without changing auth logic

[L] Liskov Substitution
    • Student/Teacher can replace User anywhere
    • Navigation works with any User subtype

[I] Interface Segregation
    • IEmailRoleDetector: Clean, focused interface
    • Clients depend only on needed methods

[D] Dependency Inversion
    • AuthNotifier depends on IAuthRepository (abstraction)
    • EmailRoleDetector injected via interface
    • Riverpod provides dependency injection


┌─────────────────────────────────────────────────────────────────┐
│                  TEACHER EMAIL EXAMPLES                          │
└─────────────────────────────────────────────────────────────────┘

✓ TEACHER DETECTED:
    • john.teacher@school.edu        (domain: .edu)
    • faculty@university.edu.ph      (domain: .edu.ph)
    • staff@institution.org          (domain: .org)
    • prof.smith@college.ac.uk       (domain: .ac.uk)
    • instructor@anyschool.com       (keyword: instructor)
    • professor.jones@example.com    (keyword: professor)

✗ STUDENT DETECTED:
    • student@gmail.com              (regular email)
    • john.doe@yahoo.com             (regular email)
    • learner@outlook.com            (regular email)
    • any@hotmail.com                (regular email)
```
