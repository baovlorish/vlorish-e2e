import 'dart:math';

import 'package:burgundy_budgeting_app/core/navigator_manager.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/label.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/appbar_item.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/button_item.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/input_item.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/home_screen/home_screen.dart';
import 'package:burgundy_budgeting_app/ui/screen/profile_overview/profile_overview_page.dart';
import 'package:burgundy_budgeting_app/ui/screen/profile_overview/profile_overview_state.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/avatar_widget.dart';
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
            ('Verify-' + context + '-' + 'Personal Budget Title is visible'));
    await htExpect(tester, find.text('Annual'), findsOneWidget,
        reason: ('Verify-' + context + '-' + 'Annual text is visible'));
    await htExpect(tester, find.text('CATEGORY'), findsOneWidget,
        reason: ('Verify-' + context + '-' + 'Category text is visible'));
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

  Future<void> clickMonthly(WidgetTester tester, {String context = ''}) async {
    await tester.pumpAndSettle(const Duration(seconds: 2));
    final btnForgotPass = find.text('Monthly').first;
    await tapSomething(
        tester, btnForgotPass, addContext(context, 'Click on btn Monthly'));
    await tester.pumpAndSettle();
  }

  Future<void> verifyBudgetMonthlyPage(WidgetTester tester,
      {String context = ''}) async {
    await tester.pumpAndSettle(const Duration(seconds: 30));
    await htExpect(tester, find.text('TOTAL PLANNED'), findsOneWidget,
        reason: ('Verify-' + context + '- Text Total Planned is visible'));
    await htExpect(tester, find.text('TOTAL SPENT'), findsOneWidget,
        reason: ('Verify-' + context + '- Text Total Spent is visible'));
    await htExpect(tester, find.text('TOTAL UNCATEGORIZED'), findsOneWidget,
        reason:
            ('Verify-' + context + '- Text Total Uncategorized is visible'));
    await tester.pumpAndSettle();
  }

  Future<void> clickAandTIconCards(WidgetTester tester,
      {String context = ''}) async {
    await tester.pumpAndSettle();
    final iconText = find.byType(AppBarItem).at(1);
    await tapSomething(tester, iconText,
        addContext(context, 'Click on btn Accounts & Transactions'));
    await tester.pumpAndSettle(const Duration(seconds: 2));
  }

  Future<void> verifyAccountsTransactionsPage(WidgetTester tester,
      {String context = ''}) async {
    await tester.pumpAndSettle(const Duration(seconds: 15));
    await htExpect(tester, find.text('Accounts & Transactions'), findsOneWidget,
        reason: ('Verify-' +
            context +
            '- Text Accounts & Transactions Title is visible'));
    await htExpect(tester, find.text('Top Merchants'), findsOneWidget,
        reason: ('Verify-' + context + '- Text Top Merchants is visible'));
    await htExpect(tester, find.text('Top Transactions'), findsOneWidget,
        reason: ('Verify-' + context + '- Text Top Transactions is visible'));
    await tester.pumpAndSettle();
  }

  Future<void> clickDebtTab(WidgetTester tester, {String context = ''}) async {
    await tester.pumpAndSettle();
    final debtTab = find.byType(Image).at(2);
    await tapSomething(
        tester, debtTab, addContext(context, 'Click on btn Debt Tab'));
    await tester.pumpAndSettle(const Duration(seconds: 2));
  }

  Future<void> verifyDebtsPage(WidgetTester tester,
      {String context = ''}) async {
    await tester.pumpAndSettle(const Duration(seconds: 15));
    await htExpect(tester, find.text('Debt Payoff'), findsOneWidget,
        reason: ('Verify-' + context + '- Text Debt Playoff Title is visible'));
    await htExpect(tester, find.text('Debts overview'), findsOneWidget,
        reason: ('Verify-' + context + '- Text Debts overview is visible'));
    await htExpect(tester, find.text('Total debts'), findsOneWidget,
        reason: ('Verify-' + context + '- Text Total debts is visible'));
    await tester.pumpAndSettle();
  }

  Future<void> clickGoalsTab(WidgetTester tester, {String context = ''}) async {
    await tester.pumpAndSettle();
    final debtTab = find.byType(Image).at(4);
    await tapSomething(
        tester, debtTab, addContext(context, 'Click on btn Goals Tab'));
    await tester.pumpAndSettle(const Duration(seconds: 2));
  }

  Future<void> verifyGoalsPage(WidgetTester tester,
      {String context = ''}) async {
    await tester.pumpAndSettle(const Duration(seconds: 15));
    await htExpect(tester, find.text('Archived Goals'), findsOneWidget,
        reason: ('Verify-' + context + '- Text Archived Goals is visible'));
    await htExpect(tester, find.text('Add a Goal'), findsOneWidget,
        reason: ('Verify-' + context + '- Text Add a Goal is visible'));
    await tester.pumpAndSettle();
  }

  Future<void> clickTaxTab(WidgetTester tester, {String context = ''}) async {
    await tester.pumpAndSettle();
    final debtTab = find.byType(Image).at(5);
    await tapSomething(
        tester, debtTab, addContext(context, 'Click on btn Tax Tab'));
    await tester.pumpAndSettle(const Duration(seconds: 2));
  }

  Future<void> verifyTaxPage(WidgetTester tester, {String context = ''}) async {
    await tester.pumpAndSettle(const Duration(seconds: 15));
    final finder = find.byType(Title).last;
    final titleWidget = tester.firstWidget<Title>(finder);
    expect(titleWidget.title, 'Calculate your taxes');
    await tester.pumpAndSettle();
  }

  Future<void> clickInvesTab(WidgetTester tester, {String context = ''}) async {
    await tester.pumpAndSettle(const Duration(seconds: 20));
    final debtTab = find.byType(Image).at(6);
    await tapSomething(
        tester, debtTab, addContext(context, 'Click on btn clickInvesTab Tab'));
    await tester.pumpAndSettle(const Duration(seconds: 2));
  }

  Future<void> verifyInvestPage(WidgetTester tester,
      {String context = ''}) async {
    await tester.pumpAndSettle(const Duration(seconds: 2));
    final finder = find.byType(Title).last;
    final titleWidget = tester.firstWidget<Title>(finder);
    expect(titleWidget.title, 'Investments');
    await htExpect(tester, titleWidget.title, 'Investments',
        reason: ('Verify-' + context + '- Investments title page is visible'));
    await tester.pumpAndSettle();
  }

  Future<void> clickRetirementTab(WidgetTester tester,
      {String context = ''}) async {
    await tester.pumpAndSettle(const Duration(seconds: 20));
    final retirementtTab = find.text('Retirement');
    await tapSomething(tester, retirementtTab,
        addContext(context, 'Click on btn clickInvesTab Tab'));
    await tester.pumpAndSettle(const Duration(seconds: 2));
  }

  Future<void> verifyRetirementPage(WidgetTester tester,
      {String context = ''}) async {
    await tester.pumpAndSettle(const Duration(seconds: 15));
    // final finder = find.text('Here, you can link or manually add and keep track of your retirement assets of all types');
    await htExpect(
        tester,
        find.text(
            'Here, you can link or manually add and keep track of your retirement assets of all types. It\'s important to separate your traditional and Roth assets as it would have important tax considerations.'),
        findsOneWidget,
        reason: ('Verify-' + context + '- Text on Retirement page is visible'));
    await tester.pumpAndSettle();
  }

  Future<void> clickProfileIcon(WidgetTester tester,
      {String context = ''}) async {
    await tester.pumpAndSettle(const Duration(seconds: 15));
    print(find.byType(AvatarWidget).toString());
    final avatar = find.byType(AvatarWidget).first;
    await tapSomething(
        tester, avatar, addContext(context, 'Click on btn avatar'));
    await tester.pumpAndSettle(const Duration(seconds: 2));
  }

  Future<void> verifyProfilePage(WidgetTester tester,
      {String context = ''}) async {
    await tester.pumpAndSettle(const Duration(seconds: 2));
    final finder = find.byType(Title).last;
    final titleWidget = tester.firstWidget<Title>(finder);
    await htExpect(tester, titleWidget.title, 'Profile Overview',
        reason:
            ('Verify-' + context + '- Profile Overview title page is visible'));
    await tester.pumpAndSettle();
  }
}
