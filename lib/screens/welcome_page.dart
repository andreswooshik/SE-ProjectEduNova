import 'dart:async';
import 'package:flutter/material.dart';
import 'onboarding_page.dart';
import 'database_test_page.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  void initState() {
    super.initState();
    // Navigate to OnboardingPage after 3 seconds
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const OnboardingPage()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: GestureDetector(
          onLongPress: () {
            // Debug feature: Long press to open database test page
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const DatabaseTestPage()),
            );
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              Image.asset(
                'assets/images/logo.png',
                height: 80,
                errorBuilder: (context, error, stackTrace) {
                  // Fallback if image is missing
                  return const Icon(
                    Icons.school,
                    size: 80,
                    color: Color(0xFF003366),
                  );
                },
              ),
              const SizedBox(width: 16),
              // Text
              const Text(
                'EduNova',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF003366), // Dark blue
                  letterSpacing: -1.0,
                ),
              ),
            ],
          ),
        ),
      ),
      // Add small debug indicator in bottom corner
      floatingActionButton: Positioned(
        bottom: 20,
        right: 20,
        child: Container(
          padding: const EdgeInsets.all(4),
          child: Text(
            'Long press logo to test DB',
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey[400],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
    );
  }
}
