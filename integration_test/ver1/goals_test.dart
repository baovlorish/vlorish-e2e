import 'dart:io';
import 'package:collection/collection.dart';

import '../lib/test_lib_common.dart';
import '../lib/test_lib_const.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:burgundy_budgeting_app/main.dart' as app;
import 'package:path_provider/path_provider.dart';
import '../lib/function_common.dart';
import 'screen/dashboard.dart';
import '../screen/signin.dart';
import 'screen/budget.dart';
import 'screen/goals.dart';
import 'screen/profile.dart';
import 'screen/plannedBudget.dart';

const String testDescription = 'Personal Budget';
void main() async {
  SignInScreenTest signInScreen;
  DashboardScreenTest dashboardScreen;
  BudgetScreenTest personalBudgetScreen;
  GoalsScreenTest goalsScreen;
  await htTestInit(description: testDescription);
  group('Personal Budget', () {
    testWidgets('Personal Budget test', (tester, [String? context]) async {
      await app.main();
      signInScreen = SignInScreenTest(tester);
      dashboardScreen = DashboardScreenTest(tester);
      personalBudgetScreen = BudgetScreenTest(tester);
      goalsScreen = GoalsScreenTest(tester);
      context = context ?? '';

      await dashboardScreen.clickLogoText();
      await signInScreen.inputEmailAndPassword(emailLogin, passLogin, tester);
      await signInScreen.clickLoginButton(tester, context: context);
      await personalBudgetScreen.verifyPersonalBudgetPage(tester);

      try {
        await htLogdDirect(
            'BAR_T296Check that FundedAmount can not be more than TargetAmount', '', 'STARTED');

        final randomValue = randomInt(5000);
        final fundedAmountValue = randomValue.toString();
        final targetAmountValue = (randomValue + 100).toString();
        await goalsScreen.clickBtnGoals(tester);
        await goalsScreen.clickBtnAddAGoals(tester);
        await goalsScreen.inputFundedAmount(fundedAmountValue, tester);
        await goalsScreen.inputTargetAmount(targetAmountValue, tester);
        await goalsScreen.clickBtnSave(tester);
        await goalsScreen.verifyErrorMessage(
            'Entered value is more than original transaction amount', tester);

        await htLogd(tester, 'BAR_T296 Check that FundedAmount can not be more than TargetAmount',
            '', 'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Failed BAR_T296 Check that FundedAmount can not be more than TargetAmount',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'BAR_T300 User can not enter more than 20 digits in field "Goal name"', '', 'STARTED');

        final randomValue = getRandomString(21);
        await dashboardScreen.clickLogoText();
        await goalsScreen.clickBtnGoals(tester);
        await goalsScreen.clickBtnAddAGoals(tester);
        await goalsScreen.inputFundedAmount(randomValue, tester);
        await goalsScreen.clickBtnSave(tester);
        await goalsScreen.verifyShowText(randomValue, tester);

        await htLogd(tester, 'BAR_T300 User can not enter more than 20 digits in field "Goal name"',
            '', 'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Failed BAR_T300 User can not enter more than 20 digits in field "Goal name"',
            '',
            'FINISHED');
      }
    });
  });
}
