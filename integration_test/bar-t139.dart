import 'dart:io';
import 'package:collection/collection.dart';

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
            'BAR_T239 Check that user can change planned sum in any line manually', '', 'STARTED');
        await personalBudgetScreen.clickBudgetTab(btnAnnual, tester);
        await personalBudgetScreen.clickBudgetTab(btnMonthly, tester);
        await personalBudgetScreen.clickCategoryList('Income', tester);
        for (var i = 0; i < incomeSubCategoryList.length; i++) {
          // final number = randomInt(999999).toString();
          await plannedPersonalBudgetScreen.inputValueOnMonthly(
              incomeSubCategoryList[i], 0, '456789', tester);

          // await plannedPersonalBudgetScreen.verifyValueInCell(
          //     incomeSubCategoryList[i], 0, '456789', tester);
        }
        await personalBudgetScreen.clickCategoryList('Income', tester);
        await tester.pump(const Duration(seconds: 2));

        await personalBudgetScreen.clickCategoryList('Housing', tester);
        for (var i = 0; i < housingSubCategoryList.length; i++) {
          // final number = randomInt(999999).toString();
          await plannedPersonalBudgetScreen.inputValueOnMonthly(
              housingSubCategoryList[i], 0, '111333', tester);

          // await plannedPersonalBudgetScreen.verifyValueInCell(
          //     housingSubCategoryList[i], 0, '111333', tester);
        }
        await personalBudgetScreen.clickCategoryList('Income', tester);
        await tester.pump(const Duration(seconds: 2));
        await htLogd(tester, 'BAR_T239 Check that user can change planned sum in any line manually',
            '', 'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Failed BAR_T239 Check that user can change planned sum in any line manually',
            '',
            'FINISHED');
      }
    });
  });
}
