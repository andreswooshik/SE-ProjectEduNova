# Security Best Practices for EduNova

This document outlines security best practices for developing and maintaining the EduNova application.

## Table of Contents

- [Authentication & Authorization](#authentication--authorization)
- [Data Storage](#data-storage)
- [Input Validation](#input-validation)
- [File Handling](#file-handling)
- [API Security](#api-security)
- [Dependency Management](#dependency-management)
- [Code Security](#code-security)

## Authentication & Authorization

### Password Security

✅ **DO:**
- Use strong password hashing (bcrypt is already implemented)
- Enforce minimum password length (currently 6 characters - **Note:** This is below industry standard of 8-12 characters and should be increased in future versions)
- Validate passwords contain letters and numbers (optional complexity check available)
- Never log or display passwords in plain text
- Implement password strength indicators in UI

**Current Implementation Note:** The minimum password length is set to 6 characters for user convenience during the prototype phase. For production release, this should be increased to at least 8 characters with mandatory complexity requirements (letters, numbers, and special characters).

❌ **DON'T:**
- Store passwords in plain text
- Send passwords in URLs or query parameters
- Use weak hashing algorithms (MD5, SHA1)
- Allow common passwords (e.g., "password123")

### Session Management

✅ **DO:**
- Clear user sessions on sign out
- Implement session timeouts
- Validate user roles on every protected action
- Use secure storage for session tokens

❌ **DON'T:**
- Store sensitive data in SharedPreferences without encryption
- Share session tokens across different apps
- Keep indefinite session lifetimes

### Role-Based Access Control

✅ **DO:**
- Validate user roles server-side (when backend is added)
- Check permissions before displaying sensitive UI
- Log authorization failures
- Use the principle of least privilege

**Example:**
```dart
// Good: Check role before allowing action
if (user?.role == UserRole.teacher) {
  // Allow teacher-specific action
} else {
  // Show access denied
}
```

## Data Storage

### Local Storage

✅ **DO:**
- Use SharedPreferences for non-sensitive data only
- Implement encryption for sensitive data (when needed)
- Clear cache on sign out
- Validate data integrity when reading

❌ **DON'T:**
- Store API keys or secrets in the app
- Store unencrypted personal information
- Trust data from storage without validation

### File Storage

✅ **DO:**
- Validate file types before saving
- Enforce file size limits (current: 50MB)
- Sanitize file names to prevent path traversal
- Store files in app-specific directories
- Clean up orphaned files regularly

❌ **DON'T:**
- Allow unrestricted file uploads
- Trust file extensions for type detection
- Store files in publicly accessible directories

**Example:**
```dart
// Good: Validate and sanitize
final extension = path.extension(fileName);
if (!allowedExtensions.contains(extension)) {
  throw Exception('Invalid file type');
}
final sanitizedName = fileName.replaceAll(RegExp(r'[<>:"/\\|?*]'), '_');
```

## Input Validation

### Form Validation

✅ **DO:**
- Validate all user inputs
- Use the FormValidators utility class
- Implement client-side and server-side validation
- Provide clear error messages
- Sanitize inputs before processing

❌ **DON'T:**
- Trust any user input
- Allow SQL injection (avoid raw SQL queries)
- Accept unvalidated URLs or email addresses
- Process unsanitized HTML

**Example:**
```dart
// Good: Validate before processing
final emailError = FormValidators.validateEmail(emailController.text);
if (emailError != null) {
  // Show error to user
  return;
}
```

### Injection Prevention

✅ **DO:**
- Use parameterized queries (when database is added)
- Escape special characters in file paths
- Validate URL schemes (http/https only)
- Use proper encoding for different contexts

❌ **DON'T:**
- Concatenate user input into queries
- Use `eval()` or similar dynamic code execution
- Trust user-provided file paths

## File Handling

### Upload Security

✅ **DO:**
- Validate file types using MIME detection
- Enforce file size limits
- Generate unique file names (timestamp-based)
- Scan files for malware (when backend is added)
- Implement upload rate limiting

❌ **DON'T:**
- Trust client-provided MIME types
- Allow executable file uploads
- Use original file names without sanitization
- Skip file size validation

**Example:**
```dart
// Good: Comprehensive file validation
if (fileSize > maxFileSizeBytes) {
  throw Exception('File too large');
}
if (!isValidFileType(fileName, allowedTypes)) {
  throw Exception('Invalid file type');
}
```

### Download Security

✅ **DO:**
- Validate file paths before serving
- Check user permissions for file access
- Use content-disposition headers (when backend is added)
- Log file access

❌ **DON'T:**
- Allow directory traversal (../ in paths)
- Serve files without authentication
- Expose internal file paths to users

## API Security

### Future Backend Integration

When adding a backend, implement:

✅ **DO:**
- Use HTTPS for all API calls
- Implement API authentication (JWT, OAuth)
- Rate limit API endpoints
- Validate and sanitize API inputs
- Use API versioning
- Implement CORS properly
- Log API access and errors

❌ **DON'T:**
- Send sensitive data in GET requests
- Store API keys in client code
- Trust any API response without validation
- Use deprecated API endpoints

## Dependency Management

### Package Security

✅ **DO:**
- Keep dependencies up to date
- Review package security advisories
- Use specific version numbers
- Audit third-party packages before adding
- Remove unused dependencies

❌ **DON'T:**
- Use packages with known vulnerabilities
- Blindly update to latest versions without testing
- Add unnecessary dependencies
- Use packages without recent maintenance

**Check for vulnerabilities:**
```bash
dart pub outdated
flutter pub upgrade
```

### Current Dependencies to Monitor

Key packages in use:
- `flutter_riverpod`: State management
- `shared_preferences`: Local storage
- `crypto`: Cryptographic functions
- `bcrypt`: Password hashing
- `file_picker`: File selection
- `path_provider`: File paths

## Code Security

### Error Handling

✅ **DO:**
- Use try-catch blocks for error-prone operations
- Log errors securely (use ErrorHandler utility)
- Show user-friendly error messages
- Never expose stack traces to users

❌ **DON'T:**
- Expose internal error details to users
- Ignore exceptions silently
- Log sensitive data in error messages

**Example:**
```dart
// Good: Secure error handling
try {
  await sensitiveOperation();
} catch (e, stackTrace) {
  ErrorHandler.logError('Operation failed', e, stackTrace: stackTrace);
  showUserMessage(ErrorHandler.getUserFriendlyMessage(e));
}
```

### Code Practices

✅ **DO:**
- Use const constructors where possible
- Follow SOLID principles
- Implement proper null safety
- Use interfaces for dependency injection
- Comment security-critical code

❌ **DON'T:**
- Use print() for logging (use debugPrint or ErrorHandler)
- Hard-code secrets or API keys
- Disable security checks for convenience
- Leave TODO comments for security issues

### Sensitive Data

✅ **DO:**
- Clear sensitive data from memory after use
- Avoid logging sensitive information
- Use secure channels for data transmission
- Implement data retention policies

❌ **DON'T:**
- Store sensitive data longer than necessary
- Log passwords, tokens, or personal data
- Include sensitive data in error messages
- Commit sensitive data to version control

## Security Checklist

Before each release:

- [ ] All dependencies are up to date
- [ ] No hard-coded secrets in code
- [ ] Input validation implemented for all forms
- [ ] File upload restrictions enforced
- [ ] Error messages don't expose sensitive info
- [ ] Role-based access control working correctly
- [ ] Password requirements enforced
- [ ] Unused debug code removed
- [ ] No print() statements in production code
- [ ] All TODOs for security issues resolved

## Reporting Security Issues

If you discover a security vulnerability:

1. **DO NOT** open a public issue
2. Email the maintainers directly
3. Provide detailed information about the vulnerability
4. Allow time for the issue to be patched before public disclosure

## Resources

- [OWASP Mobile Security Testing Guide](https://owasp.org/www-project-mobile-security-testing-guide/)
- [Flutter Security Best Practices](https://flutter.dev/docs/security)
- [Dart Security Guidelines](https://dart.dev/guides/security)

---

**Remember:** Security is everyone's responsibility. When in doubt, ask for a security review!
