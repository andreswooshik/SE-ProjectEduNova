import 'package:flutter/material.dart';

void main() {
  runApp(const EduNovaApp());
}

class EduNovaApp extends StatelessWidget {
  const EduNovaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
