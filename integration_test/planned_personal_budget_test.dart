import 'dart:io';
import './lib/test_lib_common.dart';
import './lib/test_lib_const.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:burgundy_budgeting_app/main.dart' as app;
import 'package:path_provider/path_provider.dart';
import 'lib/function_common.dart';
import 'screen/dashboard.dart';
import 'screen/signin.dart';
import 'screen/budget.dart';
import 'screen/budgetCategories.dart';
import 'screen/profile.dart';
import 'screen/plannedBudget.dart';

const String testDescription = 'Personal Budget';
void main() async {
  SignInScreenTest signInScreen;
  DashboardScreenTest dashboardScreen;
  BudgetScreenTest personalBudgetScreen;
  PlannedBudgetScreenTest plannedPersonalBudgetScreen;
  ProfileScreenTest profileScreen;
  await htTestInit(description: testDescription);
  group('Personal Budget', () {
    testWidgets('Personal Budget test', (tester, [String? context]) async {
      await app.main();
      signInScreen = SignInScreenTest(tester);
      dashboardScreen = DashboardScreenTest(tester);
      personalBudgetScreen = BudgetScreenTest(tester);
      plannedPersonalBudgetScreen = PlannedBudgetScreenTest(tester);
      profileScreen = ProfileScreenTest(tester);
      context = context ?? '';

      await dashboardScreen.clickLogoText();
      await signInScreen.inputEmailAndPassword(emailLogin, passLogin, tester);
      await signInScreen.clickLoginButton(tester, context: context);
      await personalBudgetScreen.verifyPersonalBudgetPage(tester);

      try {
        await htLogdDirect(
            'BAR_T223 User can enter planned sum in any line by clicking on the necessary cell on "Planned" table',
            '',
            'STARTED');
        await personalBudgetScreen.clickBudgetTab(btnPlanned, tester);
        await personalBudgetScreen.clickCategoryList('Income', tester);
        await plannedPersonalBudgetScreen.inputValuePlannedCell('Other Income', tester);
        await tester.pumpAndSettle(const Duration(seconds: 2));
        await htLogd(
            tester,
            'BAR_T223 User can enter planned sum in any line by clicking on the necessary cell on "Planned" table',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Failed BAR_T223 User can enter planned sum in any line by clicking on the necessary cell on "Planned" table',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'BAR_T226 Check that Total Planned sum is updated automatically if Customer inserts a new value',
            '',
            'STARTED');
        final number = randomInt(999999);
        print('number = number.toString();:----: $number');
        final valueInput = number.toString();
        print('value = number.toString();:----: $valueInput');
        final valueVerify = '\$' + formatted(number);
        print('valueVerify = number.toString();:----: $valueVerify');
        await personalBudgetScreen.clickPersonalTab(tester);
        await personalBudgetScreen.verifyPersonalBudgetPage(tester);
        await personalBudgetScreen.clickBudgetTab(btnPlanned, tester);
        await personalBudgetScreen.clickCategoryList('Housing', tester);
        await plannedPersonalBudgetScreen.inputValue('Mortgage', 0, valueInput, tester);
        await plannedPersonalBudgetScreen.inputValue('Rent', 0, '0', tester);
        await plannedPersonalBudgetScreen.inputValue('Utilities', 0, '0', tester);
        await plannedPersonalBudgetScreen.inputValue('Home Repairs', 0, '0', tester);
        await plannedPersonalBudgetScreen.inputValue('Home Services', 0, '0', tester);
        await plannedPersonalBudgetScreen.verifyUpdateTotalPlanned(
            'Housing', 0, valueVerify, tester);

        await tester.pumpAndSettle(const Duration(seconds: 2));
        await htLogd(
            tester,
            'BAR_T226 Check that Total Planned sum is updated automatically if Customer inserts a new value',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Failed BAR_T226 Check that Total Planned sum is updated automatically if Customer inserts a new value',
            '',
            'FINISHED');
      }
    });
  });
}
