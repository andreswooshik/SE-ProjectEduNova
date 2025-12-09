// This is a basic Flutter widget test for EduNova app.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:edunova_app/main.dart';

void main() {
  testWidgets('EduNova app smoke test - Welcome page loads', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: EduNovaApp()));

    // Verify that the app starts with EduNova branding
    expect(find.text('EduNova'), findsOneWidget);
    
    // Verify the welcome page or logo is displayed
    expect(find.byType(Scaffold), findsWidgets);
  });

  testWidgets('App uses correct theme colors', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: EduNovaApp()));
    
    // Verify the app is using MaterialApp
    final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
    
    // Check that primary color is set correctly
    expect(materialApp.theme?.primaryColor, equals(const Color(0xFF6A4C93)));
  });
}
