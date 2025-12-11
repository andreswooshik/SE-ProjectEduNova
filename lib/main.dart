import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/welcome_page.dart';
import 'services/database_initializer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize database with default data
  print('🔷 Starting database initialization...');
  await DatabaseInitializer.initializeDefaultData();
  print('✅ Database initialization complete!');

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Wrap the app with ProviderScope for Riverpod state management
  runApp(const ProviderScope(child: EduNovaApp()));
}

class EduNovaApp extends StatelessWidget {
  const EduNovaApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EduNova',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF6A4C93),
        scaffoldBackgroundColor: const Color(0xFF7FFFD4),
        fontFamily: 'Roboto',
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF6A4C93),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 15,
          ),
        ),
      ),
      home: const WelcomePage(),
    );
  }
}
