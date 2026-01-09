import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:task_flow/my_app.dart';

void main() {
  group('MyApp Widget Tests', () {
    testWidgets('MyApp builds successfully', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      // Verify the app builds without errors
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('MyApp has correct title', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      final MaterialApp app = tester.widget(find.byType(MaterialApp));
      expect(app.title, 'Task Flow');
    });

    testWidgets('MyApp has debug banner disabled', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      final MaterialApp app = tester.widget(find.byType(MaterialApp));
      expect(app.debugShowCheckedModeBanner, false);
    });

    testWidgets('MyApp uses Material 3', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      final MaterialApp app = tester.widget(find.byType(MaterialApp));
      expect(app.theme?.useMaterial3, true);
    });

    testWidgets('MyApp has dark theme', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      final MaterialApp app = tester.widget(find.byType(MaterialApp));
      expect(app.theme?.brightness, Brightness.dark);
    });
  });
}
