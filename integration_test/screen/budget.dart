import 'dart:math';
import 'package:flutter_test/flutter_test.dart';

// ignore: avoid_relative_lib_imports
import '../lib/test_lib_common.dart';

class BudgetScreenTest {
  const BudgetScreenTest(this.tester);

  final WidgetTester tester;

  Future<void> verifyShowPersonalBudgetPage(WidgetTester tester, {String context = ''}) async {
    await tester.pumpAndSettle(const Duration(seconds: 25));
    await htExpect(tester, find.text('Personal Budget'), findsOneWidget,
        reason: ('Verify-' + context + '-' + 'Personal Budget Title is visible'));
    await htExpect(tester, find.text('Annual'), findsOneWidget,
        reason: ('Verify-' + context + '-' + 'Annual text is visible'));
    await htExpect(tester, find.text('CATEGORY'), findsOneWidget,
        reason: ('Verify-' + context + '-' + 'Category text is visible'));
    await tester.pumpAndSettle();
  }
}
