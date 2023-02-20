import 'dart:io';
import './lib/test_lib_common.dart';
import './lib/test_lib_const.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:burgundy_budgeting_app/main.dart' as app;
import 'package:path_provider/path_provider.dart';
import 'screen/dashboard.dart';
import 'screen/signin.dart';
import 'screen/budget.dart';

const String testDescription = 'Personal Budget';
void main() async {
  SignInScreenTest signInScreen;
  DashboardScreenTest dashboardScreen;
  BudgetScreenTest personalBudgetScreen;
  await htTestInit(description: testDescription);
  group('Personal Budget', () {
    testWidgets('Personal Budget test', (tester, [String? context]) async {
      await app.main();
      signInScreen = SignInScreenTest(tester);
      dashboardScreen = DashboardScreenTest(tester);
      personalBudgetScreen = BudgetScreenTest(tester);
      context = context ?? '';

      try {
        await htLogdDirect(
            'BAR_T121 User is redirected on Budget Monthly flow page after clicking on “Monthly” button',
            '',
            'STARTED');
        await dashboardScreen.clickLogoText();
        await signInScreen.inputEmailAndPassword(
            'baoq+1@vlorish.com', 'Test@1234', tester,
            context: context);
        await signInScreen.clickLoginButton(tester, context: context);
        await personalBudgetScreen.verifyPersonalBudgetPage(tester);
        await personalBudgetScreen.clickMonthly(tester);
        await personalBudgetScreen.verifyBudgetMonthlyPage(tester);
        await htLogd(
            tester,
            'BAR_T121 User is redirected on Budget Monthly flow page after clicking on “Monthly” button',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Error BAR_T121 User is redirected on Budget Monthly flow page after clicking on “Monthly” button',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'BAR_T122 Check that the user is redirected on Annual Actual page after clicking on “Actual” button on the top',
            '',
            'STARTED');
        await dashboardScreen.clickLogoText();
        await personalBudgetScreen.verifyPersonalBudgetPage(tester);
        await personalBudgetScreen.clickBudgetTab('Difference', tester);
        await personalBudgetScreen.clickBudgetTab('Actual', tester);
        await personalBudgetScreen.verifyShowActualPage('Actual', tester);
        await htLogd(
            tester,
            'BAR_T122 Check that the user is redirected on Annual Actual page after clicking on “Actual” button on the top',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Error BAR_T122 Check that the user is redirected on Annual Actual page after clicking on “Actual” button on the top',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'BAR_T123 Check that the user is redirected on Annual Difference page after clicking on “Difference” button on the top',
            '',
            'STARTED');
        await dashboardScreen.clickLogoText();
        await personalBudgetScreen.verifyPersonalBudgetPage(tester);
        await personalBudgetScreen.clickBudgetTab('Difference', tester);
        await personalBudgetScreen.verifyShowDifferencePage(
            'Difference', tester);
        await htLogd(
            tester,
            'BAR_T123 Check that the user is redirected on Annual Difference page after clicking on “Difference” button on the top',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Error BAR_T123 Check that the user is redirected on Annual Difference page after clicking on “Difference” button on the top',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'BAR_T125 User is redirected on Debts flow page after clicking on “Debts” tab',
            '',
            'STARTED');
        await personalBudgetScreen.clickBudgetTab(btnDebt, tester);
        await personalBudgetScreen.verifyDebtsPage(tester);
        await htLogd(
            tester,
            'BAR_T125 User is redirected on Debts flow page after clicking on “Debts” tab',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Error BAR_T125 User is redirected on Debts flow page after clicking on “Debts” tab',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'BAR_T126 User is redirected on Goals flow page after clicking on “Goals” tab',
            '',
            'STARTED');
        await personalBudgetScreen.clickBudgetTab(btnGoals, tester);
        await personalBudgetScreen.verifyGoalsPage(tester);
        await htLogd(
            tester,
            'BAR_T126 User is redirected on Goals flow page after clicking on “Goals” tab',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Error BAR_T126 User is redirected on Goals flow page after clicking on “Goals” tab',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'BAR_T127 User is redirected on Tax flow page after clicking on “Tax” tab',
            '',
            'STARTED');
        await personalBudgetScreen.clickBudgetTab(btnTax, tester);
        await personalBudgetScreen.verifyTaxPage(tester);
        await htLogd(
            tester,
            'BAR_T127 User is redirected on Tax flow page after clicking on “Tax” tab',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Error BAR_T127 User is redirected on Tax flow page after clicking on “Tax” tab',
            '',
            'FINISHED');
      }
    });
  });
}