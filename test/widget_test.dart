// Basic smoke test for UniSphere app.

import 'package:flutter_test/flutter_test.dart';

import 'package:unisphere/main.dart';

void main() {
  testWidgets('App renders landing screen', (WidgetTester tester) async {
    await tester.pumpWidget(const UniSphereApp());
    await tester.pumpAndSettle();

    // Verify landing screen renders app name.
    expect(find.text('UniSphere'), findsOneWidget);
  });
}
