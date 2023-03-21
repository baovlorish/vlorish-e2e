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
            'BAR_T246 Check that Actual column for "Category name" category line contains total spent sum by all subcategories for "Category name" category',
            '',
            'STARTED');
        await personalBudgetScreen.clickBudgetTab(btnMonthly, tester);
        final housingValue =
            await plannedPersonalBudgetScreen.getValueOnMonthly('', 'Housing', 1, tester);
        final debtPaymentsValue =
            await plannedPersonalBudgetScreen.getValueOnMonthly('', 'Debt Payments', 1, tester);
        final transportationValue =
            await plannedPersonalBudgetScreen.getValueOnMonthly('', 'Transportation', 1, tester);
        final livingExpensesValue =
            await plannedPersonalBudgetScreen.getValueOnMonthly('', 'Living Expenses', 1, tester);
        final lifestyleExpensesValue = await plannedPersonalBudgetScreen.getValueOnMonthly(
            '', 'Lifestyle Expenses', 1, tester);
        final kidsValue =
            await plannedPersonalBudgetScreen.getValueOnMonthly('', 'Kids', 1, tester);
        final givingValue =
            await plannedPersonalBudgetScreen.getValueOnMonthly('', 'Giving', 1, tester);
        final taxesValue =
            await plannedPersonalBudgetScreen.getValueOnMonthly('', 'Taxes', 1, tester);
        final otherExpensesValue =
            await plannedPersonalBudgetScreen.getValueOnMonthly('', 'Other Expenses', 1, tester);

        final sumTotalSpent = totalSpentSum(
            housingValue,
            debtPaymentsValue,
            transportationValue,
            livingExpensesValue,
            lifestyleExpensesValue,
            kidsValue,
            givingValue,
            taxesValue,
            otherExpensesValue);

        final sumTotalSpentVerify = '\$' + formatNumberToValue(sumTotalSpent);

        final totalExpensesValue = await plannedPersonalBudgetScreen.getValueOnMonthly(
            'readOnly', 'Total Expenses', 2, tester);

        expect(totalExpensesValue, equals(sumTotalSpentVerify));
        await htExpect(tester, totalExpensesValue, equals(sumTotalSpentVerify),
            reason: ('Verify-' +
                context +
                '-' +
                'Actual column contains total spent sum by all subcategories'));
        await tester.pump(const Duration(seconds: 2));
        await htLogd(
            tester,
            'BAR_T246 Check that Actual column for "Category name" category line contains total spent sum by all subcategories for "Category name" category',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Failed BAR_T246 Check that Actual column for "Category name" category line contains total spent sum by all subcategories for "Category name" category',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'BAR_T249 Check that Difference column for "Category name" category line should contain total sum by all subcategories for "Category name" category',
            '',
            'STARTED');

        await personalBudgetScreen.clickBudgetTab(btnAnnual, tester);
        await personalBudgetScreen.clickBudgetTab(btnMonthly, tester);
        final housingValue =
            await plannedPersonalBudgetScreen.getValueOnMonthly('', 'Housing', 2, tester);
        final debtPaymentsValue =
            await plannedPersonalBudgetScreen.getValueOnMonthly('', 'Debt Payments', 2, tester);
        final transportationValue =
            await plannedPersonalBudgetScreen.getValueOnMonthly('', 'Transportation', 2, tester);
        final livingExpensesValue =
            await plannedPersonalBudgetScreen.getValueOnMonthly('', 'Living Expenses', 2, tester);
        final lifestyleExpensesValue = await plannedPersonalBudgetScreen.getValueOnMonthly(
            '', 'Lifestyle Expenses', 2, tester);
        final kidsValue =
            await plannedPersonalBudgetScreen.getValueOnMonthly('', 'Kids', 2, tester);
        final givingValue =
            await plannedPersonalBudgetScreen.getValueOnMonthly('', 'Giving', 2, tester);
        final taxesValue =
            await plannedPersonalBudgetScreen.getValueOnMonthly('', 'Taxes', 2, tester);
        final otherExpensesValue =
            await plannedPersonalBudgetScreen.getValueOnMonthly('', 'Other Expenses', 2, tester);

        final sumTotalSpent = totalSpentSum(
            housingValue,
            debtPaymentsValue,
            transportationValue,
            livingExpensesValue,
            lifestyleExpensesValue,
            kidsValue,
            givingValue,
            taxesValue,
            otherExpensesValue);

        final sumTotalSpentVerify = '\$' + formatNumberToValue(sumTotalSpent);

        final totalExpensesValue = await plannedPersonalBudgetScreen.getValueOnMonthly(
            'readOnly', 'Total Expenses', 3, tester);

        expect(totalExpensesValue, equals(sumTotalSpentVerify));
        await htExpect(tester, totalExpensesValue, equals(sumTotalSpentVerify),
            reason: ('Verify-' +
                context +
                '-' +
                'Difference column contains total sum by all subcategories'));
        await tester.pump(const Duration(seconds: 2));
        await htLogd(
            tester,
            'BAR_T249 Check that Difference column for "Category name" category line should contain total sum by all subcategories for "Category name" category',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Failed BAR_T249 Check that Difference column for "Category name" category line should contain total sum by all subcategories for "Category name" category',
            '',
            'FINISHED');
      }
    });
  });
}
