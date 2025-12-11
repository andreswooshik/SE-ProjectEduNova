import 'package:flutter/material.dart';
import '../services/database_service.dart';
import '../models/course.dart';
import '../models/user.dart';
import '../core/constants/app_constants.dart';

/// Database Test Page - Use this to verify database functionality
class DatabaseTestPage extends StatefulWidget {
  const DatabaseTestPage({Key? key}) : super(key: key);

  @override
  State<DatabaseTestPage> createState() => _DatabaseTestPageState();
}

class _DatabaseTestPageState extends State<DatabaseTestPage> {
  final DatabaseService _dbService = DatabaseService.instance();
  List<Course> _courses = [];
  List<User> _users = [];
  bool _isLoading = true;
  String _statusMessage = 'Loading...';

  @override
  void initState() {
    super.initState();
    _loadDatabaseData();
  }

  Future<void> _loadDatabaseData() async {
    setState(() {
      _isLoading = true;
      _statusMessage = 'Loading database...';
    });

    try {
      final courses = await _dbService.fetchAllCourses();
      final users = await _dbService.fetchAllUsers();

      setState(() {
        _courses = courses;
        _users = users;
        _isLoading = false;
        _statusMessage = 'Database loaded successfully!';
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _statusMessage = 'Error loading database: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Database Test'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadDatabaseData,
            tooltip: 'Reload Data',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status Card
                  Card(
                    color:
                        _courses.isNotEmpty ? Colors.green[50] : Colors.red[50],
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                _courses.isNotEmpty
                                    ? Icons.check_circle
                                    : Icons.error,
                                color: _courses.isNotEmpty
                                    ? Colors.green
                                    : Colors.red,
                                size: 32,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _statusMessage,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Database Status: ${_courses.isNotEmpty ? "Working ✓" : "Empty ✗"}',
                                      style: TextStyle(
                                        color: Colors.grey[700],
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Users Section
                  Text(
                    'Users (${_users.length})',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (_users.isEmpty)
                    const Card(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Text('No users found in database'),
                      ),
                    )
                  else
                    ..._users.map((user) => Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: user.role == UserRole.teacher
                                  ? Colors.blue
                                  : Colors.green,
                              child: Icon(
                                user.role == UserRole.teacher
                                    ? Icons.school
                                    : Icons.person,
                                color: Colors.white,
                              ),
                            ),
                            title: Text('${user.firstName} ${user.lastName}'),
                            subtitle:
                                Text('${user.email}\nRole: ${user.role.name}'),
                            isThreeLine: true,
                            trailing: Text(
                              'ID: ${user.id}',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                          ),
                        )),

                  const SizedBox(height: 24),

                  // Courses Section
                  Text(
                    'Courses (${_courses.length})',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (_courses.isEmpty)
                    const Card(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Text('No courses found in database'),
                      ),
                    )
                  else
                    ..._courses.map((course) => Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            leading: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: course.accentColor ?? Colors.blue,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.book,
                                color: Colors.white,
                              ),
                            ),
                            title: Text(course.title),
                            subtitle: Text(
                              'Instructor: ${course.instructor ?? "N/A"}\n'
                              'ID: ${course.id}',
                            ),
                            isThreeLine: true,
                          ),
                        )),
                ],
              ),
            ),
    );
  }
}
