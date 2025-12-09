# Testing Guide for Role-Based Authentication

## Quick Start Testing

### Test 1: Register as Student
1. Open the app and navigate to Sign Up
2. Enter:
   - Name: `John Doe`
   - Email: `john.doe@gmail.com` (regular email)
   - School: `Example University`
   - Password: `password123`
3. Click Sign Up
4. **Expected**: Account created as STUDENT
5. Sign in with the same credentials
6. **Expected**: Navigate to Student Dashboard

### Test 2: Register as Teacher (Email Domain)
1. Open the app and navigate to Sign Up
2. Enter:
   - Name: `Jane Smith`
   - Email: `jane.smith@school.edu` (educational domain)
   - School: `Example School`
   - Password: `teacher123`
3. Click Sign Up
4. **Expected**: Account created as TEACHER
5. Sign in with the same credentials
6. **Expected**: Navigate to Teacher Dashboard (Teacher Portal)

### Test 3: Register as Teacher (Keyword)
1. Open the app and navigate to Sign Up
2. Enter:
   - Name: `Bob Johnson`
   - Email: `teacher.bob@example.com` (contains 'teacher' keyword)
   - School: `Example College`
   - Password: `teacher456`
3. Click Sign Up
4. **Expected**: Account created as TEACHER
5. Sign in with the same credentials
6. **Expected**: Navigate to Teacher Dashboard

### Test 4: Access Control
1. Register and sign in as a STUDENT
2. Try to manually navigate to Teacher Dashboard (if possible)
3. **Expected**: See "Access Denied" message
4. **Expected**: Cannot access teacher-only features

## Comprehensive Test Cases

### Email Detection Tests

| Email | Expected Role | Reason |
|-------|--------------|--------|
| `student@gmail.com` | Student | Regular email |
| `teacher@school.edu` | Teacher | .edu domain |
| `faculty@university.edu.ph` | Teacher | .edu.ph domain |
| `staff@college.ac.uk` | Teacher | .ac.uk domain |
| `admin@government.gov` | Teacher | .gov domain |
| `instructor123@example.com` | Teacher | 'instructor' keyword |
| `professor.smith@anywhere.com` | Teacher | 'professor' keyword |
| `faculty.jones@test.org` | Teacher | 'faculty' keyword + .org domain |
| `john.doe@yahoo.com` | Student | Regular email |
| `learner@outlook.com` | Student | Regular email |

### Navigation Tests

| User Role | Expected Dashboard | Expected Features |
|-----------|-------------------|-------------------|
| Student | Student Dashboard | Browse courses, Enroll, View progress |
| Teacher | Teacher Dashboard | Create course, Grade, Manage students |
| Admin | Main Navigation | Admin features (if implemented) |

### Access Control Tests

| Scenario | Expected Behavior |
|----------|------------------|
| Student tries to access Teacher Dashboard | Access Denied screen shown |
| Teacher accesses Teacher Dashboard | Full access granted |
| Unauthenticated user | Redirect to sign in |

## Manual Testing Steps

### Complete Flow Test
1. **Sign Up as Student**
   - Use email: `teststudent@gmail.com`
   - Complete registration
   - Verify redirect to sign in

2. **Sign In as Student**
   - Enter student credentials
   - Verify navigation to Student Dashboard
   - Check student features are accessible

3. **Sign Out**
   - Navigate to settings
   - Sign out

4. **Sign Up as Teacher**
   - Use email: `testteacher@school.edu`
   - Complete registration
   - Verify redirect to sign in

5. **Sign In as Teacher**
   - Enter teacher credentials
   - Verify navigation to Teacher Dashboard
   - Check teacher features are visible

6. **Verify Teacher Dashboard Content**
   - Welcome card with name and school
   - Employee ID displayed
   - Quick Actions: Create Course, Grade Submissions, etc.
   - Classes section
   - Upcoming section

7. **Sign Out and Test Again**
   - Sign out as teacher
   - Sign in as student
   - Verify student dashboard appears

## Edge Cases to Test

### Email Validation
- [ ] Empty email field
- [ ] Invalid email format
- [ ] Duplicate email registration
- [ ] Case sensitivity in email domains

### Role Detection Edge Cases
- [ ] Email with multiple keywords: `teacher.professor@school.edu`
- [ ] Email with partial keyword: `myteacher@gmail.com` (should NOT be teacher)
- [ ] Mixed case domains: `User@School.EDU` (should work)
- [ ] Email with spaces (should be trimmed)

### Authentication Edge Cases
- [ ] Wrong password
- [ ] Non-existent email
- [ ] Sign in before completing registration
- [ ] Multiple sign-in attempts

### Navigation Edge Cases
- [ ] Sign in, sign out, sign in again
- [ ] Switch between student and teacher accounts
- [ ] Deep linking to protected routes

## Expected Results Summary

### Student Account
```
✓ Registration with regular email
✓ Automatic STUDENT role assignment
✓ Navigation to Student Dashboard
✓ Access to student features only
✓ Cannot access Teacher Dashboard
```

### Teacher Account
```
✓ Registration with educational email OR teacher keyword
✓ Automatic TEACHER role assignment
✓ Navigation to Teacher Dashboard
✓ Access to teacher features
✓ See employee ID and institution info
✓ Quick actions for teachers
```

## Debugging Tips

### Check Role Assignment
Add this to see the detected role during registration:
```dart
print('Detected role: ${emailRoleDetector.detectRole(email)}');
```

### Check Current User
Add this to verify the signed-in user:
```dart
final user = ref.read(authProvider).user;
print('User: ${user?.fullName}, Role: ${user?.role}');
```

### Check Navigation
Add this before navigation:
```dart
print('Navigating to: ${user?.role == UserRole.teacher ? "Teacher" : "Student"} Dashboard');
```

## Common Issues and Solutions

### Issue: Teacher registered as Student
**Solution**: Check email domain/keyword matches patterns in `EmailRoleDetectorService`

### Issue: Navigation not working
**Solution**: Verify role-based navigation logic in `sign_in_page.dart`

### Issue: Access denied for teacher
**Solution**: Check role validation in `teacher_dashboard_page.dart`

### Issue: Registration fails
**Solution**: Check auth provider error messages and storage service

## Testing Checklist

- [ ] Student registration with regular email
- [ ] Student sign in and navigation
- [ ] Teacher registration with .edu email
- [ ] Teacher registration with teacher keyword
- [ ] Teacher sign in and navigation
- [ ] Role-based dashboard rendering
- [ ] Access control on Teacher Dashboard
- [ ] Sign out functionality
- [ ] Multiple account switching
- [ ] Error handling for invalid credentials
- [ ] Form validation
- [ ] School field requirement

## Performance Testing

- [ ] Registration response time < 2 seconds
- [ ] Sign in response time < 1 second
- [ ] Role detection is instant
- [ ] Dashboard loads smoothly
- [ ] No lag in navigation

## Security Testing

- [ ] Passwords are hashed
- [ ] Roles cannot be manually changed
- [ ] Teacher dashboard validates role
- [ ] Unauthorized access is blocked
- [ ] Session persistence works correctly
