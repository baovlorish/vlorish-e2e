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
        await personalBudgetScreen.clickCategoryArrowIcon(tester);
        await tester.pump(const Duration(seconds: 2));
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
        final valueInput = number.toString();
        final valueVerify = '\$' + formatted(number);
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
        await personalBudgetScreen.clickCategoryArrowIcon(tester);
        await tester.pump(const Duration(seconds: 2));
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

      try {
        await htLogdDirect(
            'BAR_T230 Check cells with "0" value is keeped unfilled on "Planned" table',
            '',
            'STARTED');

        await personalBudgetScreen.clickPersonalTab(tester);
        await personalBudgetScreen.verifyPersonalBudgetPage(tester);
        await personalBudgetScreen.clickBudgetTab(btnPlanned, tester);
        await personalBudgetScreen.clickCategoryList('Income', tester);
        await plannedPersonalBudgetScreen.checkValue0IsKeepeDunfilled('Owner Draw', tester);
        await tester.pumpAndSettle(const Duration(seconds: 2));
        await personalBudgetScreen.clickCategoryArrowIcon(tester);
        await tester.pump(const Duration(seconds: 2));
        await htLogd(
            tester,
            'BAR_T226 Check cells with "0" value is keeped unfilled on "Planned" table',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Failed BAR_T230 Check cells with "0" value is keeped unfilled on "Planned" table',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'BAR_T227 Check that max value in cells is 1000000000000', '', 'STARTED');
        final value = 1000000000000 - 1;
        final valueInput = value.toString();
        final valuVerify = formatted(value);

        await personalBudgetScreen.clickPersonalTab(tester);
        await personalBudgetScreen.verifyPersonalBudgetPage(tester);
        await personalBudgetScreen.clickBudgetTab(btnPlanned, tester);
        await personalBudgetScreen.clickCategoryList('Debt Payments', tester);
        await plannedPersonalBudgetScreen.inputValue('Student Loans', 0, valueInput, tester);
        await plannedPersonalBudgetScreen.verifyValueInCell('Student Loans', 0, valuVerify, tester);
        await tester.pumpAndSettle(const Duration(seconds: 2));
        await personalBudgetScreen.clickCategoryArrowIcon(tester);
        await tester.pump(const Duration(seconds: 2));
        await htLogd(
            tester, 'BAR_T227 Check that max value in cells is 1000000000000', '', 'FINISHED');
      } catch (e) {
        await htLogd(tester, 'Failed BAR_T227 Check that max value in cells is 1000000000000e', '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'BAR_T234 Check that total sum is shown by all subcategory in the "Income" line on Personal Monthly page',
            '',
            'STARTED');
        await personalBudgetScreen.clickPersonalTab(tester);
        await personalBudgetScreen.verifyPersonalBudgetPage(tester);
        await personalBudgetScreen.clickBudgetTab(btnPlanned, tester);
        final incomeRowValue =
            await plannedPersonalBudgetScreen.getValueTotalPlanned(btnAnnual, 'Income', 2, tester);
        await personalBudgetScreen.clickBudgetTab(btnMonthly, tester);
        await personalBudgetScreen.verifyBudgetMonthlyPage(tester);
        await plannedPersonalBudgetScreen.verifyValueTotalPlannedOnMonthlyPage(
            'Income', 0, incomeRowValue, tester);
        await tester.pump(const Duration(seconds: 2));
        await htLogd(
            tester,
            'BAR_T234 Check that total sum is shown by all subcategory in the "Income" line on Personal Monthly page',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Failed BAR_T234 Check that total sum is shown by all subcategory in the "Income" line on Personal Monthly page',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'BAR_T235 Check that  total sum is shown by all subcategory in thein the "Category name" line on Personal Monthly page',
            '',
            'STARTED');
        await personalBudgetScreen.clickPersonalTab(tester);
        await personalBudgetScreen.verifyPersonalBudgetPage(tester);
        await personalBudgetScreen.clickBudgetTab(btnPlanned, tester);
        final incomeValue =
            await plannedPersonalBudgetScreen.getValueTotalPlanned(btnAnnual, 'Income', 2, tester);
        final housingValue =
            await plannedPersonalBudgetScreen.getValueTotalPlanned(btnAnnual, 'Housing', 2, tester);
        final debtPaymentsValue = await plannedPersonalBudgetScreen.getValueTotalPlanned(
            btnAnnual, 'Debt Payments', 2, tester);
        final transportationValue = await plannedPersonalBudgetScreen.getValueTotalPlanned(
            btnAnnual, 'Transportation', 2, tester);
        final livingExpensesValue = await plannedPersonalBudgetScreen.getValueTotalPlanned(
            btnAnnual, 'Living Expenses', 2, tester);
        final lifestyleExpensesValue = await plannedPersonalBudgetScreen.getValueTotalPlanned(
            btnAnnual, 'Lifestyle Expenses', 2, tester);
        final kidsValue =
            await plannedPersonalBudgetScreen.getValueTotalPlanned(btnAnnual, 'Kids', 2, tester);
        final givingValue =
            await plannedPersonalBudgetScreen.getValueTotalPlanned(btnAnnual, 'Giving', 2, tester);
        final taxesValue =
            await plannedPersonalBudgetScreen.getValueTotalPlanned(btnAnnual, 'Taxes', 2, tester);
        final otherExpensesValue = await plannedPersonalBudgetScreen.getValueTotalPlanned(
            btnAnnual, 'Other Expenses', 2, tester);
        final totalExpensesValue = await plannedPersonalBudgetScreen.getValueTotalPlanned(
            btnAnnual, 'Total Expenses', 2, tester);
        final netIncomeValue = await plannedPersonalBudgetScreen.getValueTotalPlanned(
            btnAnnual, 'Net Income', 2, tester);
        final goalsSinkingFundsValue = await plannedPersonalBudgetScreen.getValueTotalPlanned(
            btnAnnual, 'Goals/Sinking Funds', 2, tester);
        final investmentsValue = await plannedPersonalBudgetScreen.getValueTotalPlanned(
            btnAnnual, 'Investments', 2, tester);
        final freeCashValue = await plannedPersonalBudgetScreen.getValueTotalPlanned(
            btnAnnual, 'Free Cash', 2, tester);

        await personalBudgetScreen.clickBudgetTab(btnMonthly, tester);
        await personalBudgetScreen.verifyBudgetMonthlyPage(tester);
        await plannedPersonalBudgetScreen.verifyValueTotalPlannedOnMonthlyPage(
            'Income', 0, incomeValue, tester);
        await plannedPersonalBudgetScreen.verifyValueTotalPlannedOnMonthlyPage(
            'Housing', 0, housingValue, tester);
        await plannedPersonalBudgetScreen.verifyValueTotalPlannedOnMonthlyPage(
            'Debt Payments', 0, debtPaymentsValue, tester);
        await plannedPersonalBudgetScreen.verifyValueTotalPlannedOnMonthlyPage(
            'Transportation', 0, transportationValue, tester);
        await plannedPersonalBudgetScreen.verifyValueTotalPlannedOnMonthlyPage(
            'Living Expenses', 0, livingExpensesValue, tester);
        await plannedPersonalBudgetScreen.verifyValueTotalPlannedOnMonthlyPage(
            'Lifestyle Expenses', 0, lifestyleExpensesValue, tester);
        await plannedPersonalBudgetScreen.verifyValueTotalPlannedOnMonthlyPage(
            'Kids', 0, kidsValue, tester);
        await plannedPersonalBudgetScreen.verifyValueTotalPlannedOnMonthlyPage(
            'Giving', 0, givingValue, tester);
        await plannedPersonalBudgetScreen.verifyValueTotalPlannedOnMonthlyPage(
            'Taxes', 0, taxesValue, tester);
        await plannedPersonalBudgetScreen.verifyValueTotalPlannedOnMonthlyPage(
            'Other Expenses', 0, otherExpensesValue, tester);
        await plannedPersonalBudgetScreen.verifyValueTotalPlannedOnMonthlyPage(
            'Total Expenses', 0, totalExpensesValue, tester);
        await plannedPersonalBudgetScreen.verifyValueTotalPlannedOnMonthlyPage(
            'Net Income', 0, netIncomeValue, tester);
        await plannedPersonalBudgetScreen.verifyValueTotalPlannedOnMonthlyPage(
            'Goals/Sinking Funds', 0, goalsSinkingFundsValue, tester);
        await plannedPersonalBudgetScreen.verifyValueTotalPlannedOnMonthlyPage(
            'Investments', 0, investmentsValue, tester);
        await plannedPersonalBudgetScreen.verifyValueTotalPlannedOnMonthlyPage(
            'Free Cash', 0, freeCashValue, tester);
        await tester.pump(const Duration(seconds: 2));
        await htLogd(
            tester,
            'BAR_T235 Check that  total sum is shown by all subcategory in thein the "Category name" line on Personal Monthly page',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Failed BAR_T235 Check that  total sum is shown by all subcategory in thein the "Category name" line on Personal Monthly pagee',
            '',
            'FINISHED');
      }
    });
  });
}
