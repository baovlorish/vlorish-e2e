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
import 'screen/budgetCategories.dart';
import 'screen/profile.dart';

const String testDescription = 'Personal Budget';
void main() async {
  SignInScreenTest signInScreen;
  DashboardScreenTest dashboardScreen;
  BudgetScreenTest personalBudgetScreen;
  BudgetCategoryScreenTest personalBudgetCategoryScreen;
  ProfileScreenTest profileScreen;
  await htTestInit(description: testDescription);
  group('Personal Budget', () {
    testWidgets('Personal Budget test', (tester, [String? context]) async {
      await app.main();
      signInScreen = SignInScreenTest(tester);
      dashboardScreen = DashboardScreenTest(tester);
      personalBudgetScreen = BudgetScreenTest(tester);
      personalBudgetCategoryScreen = BudgetCategoryScreenTest(tester);
      profileScreen = ProfileScreenTest(tester);
      context = context ?? '';

      await dashboardScreen.clickLogoText();
      await signInScreen.inputEmailAndPassword(emailLogin, passLogin, tester);
      await signInScreen.clickLoginButton(tester, context: context);
      await personalBudgetScreen.verifyPersonalBudgetPage(tester);

      try {
        await htLogdDirect(
            'BAR_T123 Check that the user is redirected on Annual Difference page after clicking on “Difference” button on the top',
            '',
            'STARTED');
        await personalBudgetScreen.clickDifferenceTab(tester);
        await personalBudgetScreen.verifyShowDifferencePage(
            btnDifference, tester);
        await htLogd(
            tester,
            'BAR_T123 Check that the user is redirected on Annual Difference page after clicking on “Difference” button on the top',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Failed BAR_T123 Check that the user is redirected on Annual Difference page after clicking on “Difference” button on the top',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'BAR_T128 User is redirected on Investments flow page after clicking on “Investments” tab',
            '',
            'STARTED');
        await dashboardScreen.clickProfileIcon(tester);
        await personalBudgetScreen.clickPersonalTab(tester);
        await personalBudgetScreen.clickSideMenu(btnInvestments, tester);
        await personalBudgetScreen.verifyInvestmentsPage(tester);
        await htLogd(
            tester,
            'BAR_T128 User is redirected on Investments flow page after clicking on “Investments” tab',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Failed BAR_T128 User is redirected on Investments flow page after clicking on “Investments” tab',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'BAR_T129 User is redirected on Retirement flow page after clicking on “Retirement” tab',
            '',
            'STARTED');
        await dashboardScreen.clickProfileIcon(tester);
        await personalBudgetScreen.clickPersonalTab(tester);
        await personalBudgetScreen.clickSideMenu(btnInvestments, tester);
        await personalBudgetScreen.verifyInvestmentsPage(tester);
        await personalBudgetScreen.clickRetirementTab(tester);
        await personalBudgetScreen.verifyRetirementPage(tester);
        await htLogd(
            tester,
            'BAR_T129 User is redirected on Retirement flow page after clicking on “Retirement” tab',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Failed BAR_T129 User is redirected on Retirement flow page after clicking on “Retirement” tab',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'BAR_T167 Business Budget - User is redirected on Available Annually tab button after clicking on “Difference” button',
            '',
            'STARTED');
        await dashboardScreen.clickProfileIcon(tester);
        await personalBudgetScreen.clickBusinessTab(tester);
        await personalBudgetScreen.verifyBusinessBudgetPage(tester);
        await personalBudgetScreen.clickDifferenceTab(tester);
        await personalBudgetScreen.verifyShowDifferencePage(
            btnDifference, tester);
        await htLogd(
            tester,
            'BAR_T167 User is redirected on Available Annually tab button after clicking on “Difference” button',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Failed BAR-T167 User is redirected on Available Annually tab button after clicking on “Difference” button',
            '',
            'FINISHED');
      }
    });
  });
}
