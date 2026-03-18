import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:unisphere/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('End-to-End Smoke Test', () {
    testWidgets('App boots up without crashing', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      app.main();

      // Give the app time to initialize Firebase and settle
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Check if a MaterialApp is present, which indicates the core Flutter UI booted up
      expect(find.byType(MaterialApp), findsOneWidget);
    });
  });
}
