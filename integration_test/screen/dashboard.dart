import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class DashboardScreenTest {
  const DashboardScreenTest(this.tester);

  final WidgetTester tester;

  Future<void> clickLogoText() async {
    await tester.pumpAndSettle();
    final iconText = find.byType(IconButton).first;
    await tester.tap(iconText);
    await tester.pumpAndSettle(const Duration(seconds: 2));
  }
}
