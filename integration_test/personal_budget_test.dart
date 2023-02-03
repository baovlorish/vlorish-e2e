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
import 'screen/personalBudget.dart';

const String testDescription = 'Personal Budget';
void main() async {
  SignInScreenTest signInScreen;
  DashboardScreenTest dashboardScreen;
  PersonalBudgetScreenTest personalBudgetScreen;
  await htTestInit(description: testDescription);
  group('Personal Budget', () {
    testWidgets('Personal Budget test', (tester, [String? context]) async {
      await app.main();
      signInScreen = SignInScreenTest(tester);
      dashboardScreen = DashboardScreenTest(tester);
      personalBudgetScreen = PersonalBudgetScreenTest(tester);
      context = context ?? '';

      try {
        await htLogdDirect(
            'BAR_T121 User is redirected on Budget Monthly flow page after clicking on “Monthly” button',
            '',
            'STARTED');
        await dashboardScreen.clickLogoText();
        await signInScreen.inputEmailAndPassword(
            'farah.ali1021@gmail.com', 'Hello@1234', tester,
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
            'BAR_T125 User is redirected on Debts flow page after clicking on “Debts” tab',
            '',
            'STARTED');
        await personalBudgetScreen.clickDebtTab(tester);
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
        await personalBudgetScreen.clickGoalsTab(tester);
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
        await personalBudgetScreen.clickTaxTab(tester);
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

      try {
        await htLogdDirect(
            'BAR_T128 User is redirected on Investments flow page after clicking on “Investments” tab',
            '',
            'STARTED');
        await personalBudgetScreen.clickInvesTab(tester);
        await personalBudgetScreen.verifyInvestPage(tester);
        await htLogd(
            tester,
            'BAR_T128 User is redirected on Investments flow page after clicking on “Investments” tab',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Error BAR_T128 User is redirected on Investments flow page after clicking on “Investments” tab',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'BAR_T132 User is redirected on Profile flow page after clicking on Profile icon',
            '',
            'STARTED');
        await personalBudgetScreen.clickProfileIcon(tester);
        await personalBudgetScreen.verifyProfilePage(tester);
        await htLogd(
            tester,
            'BAR_T132 User is redirected on Profile flow page after clicking on Profile icon',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Error BAR_T132 User is redirected on Profile flow page after clicking on Profile icon',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'BAR_T124 Check that the user is redirected on Accounts&Transactions page after clicking on “A&T” icon (cards)',
            '',
            'STARTED');
        await dashboardScreen.clickLogoText();
        // await personalBudgetScreen.clickAandTIconCards(tester);
        // await personalBudgetScreen.verifyAccountsTransactionsPage(tester);
        await htLogd(
            tester,
            'BAR_T124 Check that the user is redirected on Accounts&Transactions page after clicking on “A&T” icon (cards)',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Error BAR_T14 Check that the user is redirected on Accounts&Transactions page after clicking on “A&T” icon (cards)',
            '',
            'FINISHED');
      }
    });
  });
}
