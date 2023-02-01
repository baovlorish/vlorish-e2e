import 'dart:math';

import 'package:burgundy_budgeting_app/ui/atomic/molecula/appbar_item.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/button_item.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/input_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../lib/test_lib_common.dart';

class PersonalBudgetScreenTest {
  const PersonalBudgetScreenTest(this.tester);

  final WidgetTester tester;

  Future<void> verifyPersonalBudgetPage(WidgetTester tester,
      {String context = ''}) async {
    await tester.pumpAndSettle(const Duration(seconds: 45));
    await htExpect(tester, find.text('Personal Budget'), findsOneWidget,
        reason:
            ("Verify-" + context + "-" + 'Personal Budget Title is visible'));
    await htExpect(tester, find.text('Annual'), findsOneWidget,
        reason: ("Verify-" + context + "-" + 'Annual text is visible'));
    await htExpect(tester, find.text('CATEGORY'), findsOneWidget,
        reason: ("Verify-" + context + "-" + 'Category text is visible'));
    await tester.pumpAndSettle();
  }

  Future<void> clickLogoutButton(WidgetTester tester,
      {String context = ''}) async {
    await tester.pumpAndSettle();
    final iconText = find.byType(AppBarItem).at(5);
    await tapSomething(
        tester, iconText, addContext(context, 'Click on btn Logout'));
    await tester.pumpAndSettle(const Duration(seconds: 2));
  }
}
