import 'dart:io';
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
        final valueVerify = '\$' + formatNumberToValue(number);
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
            'BAR_T230 Check cells with "0" value is keeped unfilled on "Planned" table',
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
        final valuVerify = formatNumberToValue(value);

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
        final incomeRowValue = await plannedPersonalBudgetScreen.getValue('', 'Income', 2, tester);
        await personalBudgetScreen.clickBudgetTab(btnMonthly, tester);
        await personalBudgetScreen.verifyBudgetMonthlyPage(tester);
        await plannedPersonalBudgetScreen.verifyValueTotalPlannedOnMonthlyPage(
            '', 'Income', 0, incomeRowValue, tester);
        await tester.pumpAndSettle(const Duration(seconds: 2));
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
        await personalBudgetScreen.clickBudgetTab(btnAnnual, tester);
        await personalBudgetScreen.verifyPersonalBudgetPage(tester);
        await personalBudgetScreen.clickBudgetTab(btnPlanned, tester);
        final incomeValue = await plannedPersonalBudgetScreen.getValue('', 'Income', 2, tester);
        final housingValue = await plannedPersonalBudgetScreen.getValue('', 'Housing', 2, tester);
        final debtPaymentsValue =
            await plannedPersonalBudgetScreen.getValue('', 'Debt Payments', 2, tester);
        final transportationValue =
            await plannedPersonalBudgetScreen.getValue('', 'Transportation', 2, tester);
        final livingExpensesValue =
            await plannedPersonalBudgetScreen.getValue('', 'Living Expenses', 2, tester);
        final lifestyleExpensesValue =
            await plannedPersonalBudgetScreen.getValue('', 'Lifestyle Expenses', 2, tester);
        final kidsValue = await plannedPersonalBudgetScreen.getValue('', 'Kids', 2, tester);
        final givingValue = await plannedPersonalBudgetScreen.getValue('', 'Giving', 2, tester);
        final taxesValue = await plannedPersonalBudgetScreen.getValue('', 'Taxes', 2, tester);
        final otherExpensesValue =
            await plannedPersonalBudgetScreen.getValue('', 'Other Expenses', 2, tester);
        final totalExpensesValue =
            await plannedPersonalBudgetScreen.getValue('readOnly', 'Total Expenses', 3, tester);
        final netIncomeValue =
            await plannedPersonalBudgetScreen.getValue('readOnly', 'Net Income', 3, tester);
        final goalsSinkingFundsValue = await plannedPersonalBudgetScreen.getValue(
            'readOnly', 'Goals/Sinking Funds', 3, tester);
        final investmentsValue =
            await plannedPersonalBudgetScreen.getValue('', 'Investments', 2, tester);
        final freeCashValue =
            await plannedPersonalBudgetScreen.getValue('readOnly', 'Free Cash', 3, tester);

        await personalBudgetScreen.clickBudgetTab(btnMonthly, tester);
        await personalBudgetScreen.verifyBudgetMonthlyPage(tester);
        await plannedPersonalBudgetScreen.verifyValueTotalPlannedOnMonthlyPage(
            '', 'Income', 0, incomeValue, tester);
        await plannedPersonalBudgetScreen.verifyValueTotalPlannedOnMonthlyPage(
            '', 'Housing', 0, housingValue, tester);
        await plannedPersonalBudgetScreen.verifyValueTotalPlannedOnMonthlyPage(
            '', 'Debt Payments', 0, debtPaymentsValue, tester);
        await plannedPersonalBudgetScreen.verifyValueTotalPlannedOnMonthlyPage(
            '', 'Transportation', 0, transportationValue, tester);
        await plannedPersonalBudgetScreen.verifyValueTotalPlannedOnMonthlyPage(
            '', 'Living Expenses', 0, livingExpensesValue, tester);
        await plannedPersonalBudgetScreen.verifyValueTotalPlannedOnMonthlyPage(
            '', 'Lifestyle Expenses', 0, lifestyleExpensesValue, tester);
        await plannedPersonalBudgetScreen.verifyValueTotalPlannedOnMonthlyPage(
            '', 'Kids', 0, kidsValue, tester);
        await plannedPersonalBudgetScreen.verifyValueTotalPlannedOnMonthlyPage(
            '', 'Giving', 0, givingValue, tester);
        await plannedPersonalBudgetScreen.verifyValueTotalPlannedOnMonthlyPage(
            '', 'Taxes', 0, taxesValue, tester);
        await plannedPersonalBudgetScreen.verifyValueTotalPlannedOnMonthlyPage(
            '', 'Other Expenses', 0, otherExpensesValue, tester);
        await plannedPersonalBudgetScreen.verifyValueTotalPlannedOnMonthlyPage(
            'readOnly', 'Total Expenses', 1, totalExpensesValue, tester);
        await plannedPersonalBudgetScreen.verifyValueTotalPlannedOnMonthlyPage(
            'readOnly', 'Net Income', 1, netIncomeValue, tester);
        await plannedPersonalBudgetScreen.verifyValueTotalPlannedOnMonthlyPage(
            'readOnly', 'Goals/Sinking Funds', 1, goalsSinkingFundsValue, tester);
        await plannedPersonalBudgetScreen.verifyValueTotalPlannedOnMonthlyPage(
            '', 'Investments', 1, investmentsValue, tester);
        await plannedPersonalBudgetScreen.verifyValueTotalPlannedOnMonthlyPage(
            'readOnly', 'Free Cash', 1, freeCashValue, tester);
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

      try {
        await htLogdDirect(
            'BAR_T236 Check that total sum is changed by all subcategories automatically if Customer changes Planned column value',
            '',
            'STARTED');

        await personalBudgetScreen.clickBudgetTab(btnAnnual, tester);
        await personalBudgetScreen.verifyPersonalBudgetPage(tester);
        await personalBudgetScreen.clickBudgetTab(btnPlanned, tester);
        var valueBeforeChange =
            await plannedPersonalBudgetScreen.getValue('', 'Housing', 0, tester);
        print('valueBeforeChange: $valueBeforeChange');
        await personalBudgetScreen.clickCategoryList('Housing', tester);
        await plannedPersonalBudgetScreen.inputValue(
            'Mortgage', 0, randomInt(999999).toString(), tester);
        var valueAfterChange = await plannedPersonalBudgetScreen.getValue('', 'Housing', 0, tester);

        await plannedPersonalBudgetScreen.verifyValueTotalSubCategoryPlannedIsChange(
            valueBeforeChange, valueAfterChange, tester);
        valueBeforeChange = valueAfterChange;

        await plannedPersonalBudgetScreen.inputValue(
            'Rent', 0, randomInt(999999).toString(), tester);
        valueAfterChange = await plannedPersonalBudgetScreen.getValue('', 'Housing', 0, tester);
        await plannedPersonalBudgetScreen.verifyValueTotalSubCategoryPlannedIsChange(
            valueBeforeChange, valueAfterChange, tester);
        valueBeforeChange = valueAfterChange;

        await plannedPersonalBudgetScreen.inputValue(
            'Utilities', 0, randomInt(999999).toString(), tester);
        valueAfterChange = await plannedPersonalBudgetScreen.getValue('', 'Housing', 0, tester);
        await plannedPersonalBudgetScreen.verifyValueTotalSubCategoryPlannedIsChange(
            valueBeforeChange, valueAfterChange, tester);
        valueBeforeChange = valueAfterChange;

        await plannedPersonalBudgetScreen.inputValue(
            'Home Repairs', 0, randomInt(999999).toString(), tester);
        valueAfterChange = await plannedPersonalBudgetScreen.getValue('', 'Housing', 0, tester);
        await plannedPersonalBudgetScreen.verifyValueTotalSubCategoryPlannedIsChange(
            valueBeforeChange, valueAfterChange, tester);
        valueBeforeChange = valueAfterChange;

        await plannedPersonalBudgetScreen.inputValue(
            'Home Services', 0, randomInt(999999).toString(), tester);
        valueAfterChange = await plannedPersonalBudgetScreen.getValue('', 'Housing', 0, tester);
        await plannedPersonalBudgetScreen.verifyValueTotalSubCategoryPlannedIsChange(
            valueBeforeChange, valueAfterChange, tester);
        valueBeforeChange = valueAfterChange;

        final mortgageValue =
            await plannedPersonalBudgetScreen.getValueInCell('Mortgage', 0, tester);
        final mortgageValueToInt = formatValueToNumber(mortgageValue);

        final rentValue = await plannedPersonalBudgetScreen.getValueInCell('Rent', 0, tester);
        final rentValueToInt = formatValueToNumber(rentValue);

        final utilitiesValue =
            await plannedPersonalBudgetScreen.getValueInCell('Utilities', 0, tester);
        final utilitiesValueToInt = formatValueToNumber(utilitiesValue);

        final homeRepairsValue =
            await plannedPersonalBudgetScreen.getValueInCell('Home Repairs', 0, tester);
        final homeRepairsValueToInt = formatValueToNumber(homeRepairsValue);

        final homeServicesValue =
            await plannedPersonalBudgetScreen.getValueInCell('Home Services', 0, tester);
        final homeServicesValueToInt = formatValueToNumber(homeServicesValue);

        final totalSumOfCategory = mortgageValueToInt +
            rentValueToInt +
            utilitiesValueToInt +
            homeRepairsValueToInt +
            homeServicesValueToInt;
        final valueVerify = '\$' + formatNumberToValue(totalSumOfCategory);

        await plannedPersonalBudgetScreen.verifyUpdateTotalPlanned(
            'Housing', 0, valueVerify, tester);
        await tester.pumpAndSettle(const Duration(seconds: 2));
        await personalBudgetScreen.clickCategoryArrowIcon(tester);
        await tester.pump(const Duration(seconds: 2));
        await htLogd(
            tester,
            'BAR_T236 Check that total sum is changed by all subcategories automatically if Customer changes Planned column value',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Failed BAR_T236 Check that total sum is changed by all subcategories automatically if Customer changes Planned column value',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'BAR_T240 Check that Dashboard contains 4 blocks: Total planned, Total spent, Difference, Total unplanned',
            '',
            'STARTED');

        await personalBudgetScreen.clickBudgetTab(btnAnnual, tester);
        await personalBudgetScreen.verifyPersonalBudgetPage(tester);
        await personalBudgetScreen.clickBudgetTab(btnPlanned, tester);
        final totalExpensesPlanned =
            await plannedPersonalBudgetScreen.getValue('readOnly', 'Total Expenses', 3, tester);
        print('totalExpensesPlanned: $totalExpensesPlanned');

        await personalBudgetScreen.clickBudgetTab(btnActual, tester);
        final totalExpensesActual =
            await plannedPersonalBudgetScreen.getValue('readOnly', 'Total Expenses', 3, tester);
        print('totalExpensesActual: $totalExpensesActual');

        await personalBudgetScreen.clickCategoryList('Other Expenses', tester);
        final totalUncategorizedExpensesActual = await plannedPersonalBudgetScreen.getValue(
            'readOnly', 'Uncategorized Expenses', 3, tester);
        print('totalUncategorizedExpensesActual: $totalUncategorizedExpensesActual');

        await personalBudgetScreen.clickBudgetTab(btnDifference, tester);
        final totalExpensesDifference =
            await plannedPersonalBudgetScreen.getValue('readOnly', 'Total Expenses', 3, tester);
        print('totalExpensesDifference: $totalExpensesDifference');

        await personalBudgetScreen.clickBudgetTab(btnMonthly, tester);
        await plannedPersonalBudgetScreen.verifyDashboardContains4Blocks(
            'TOTAL PLANNED', totalExpensesPlanned, tester);
        await plannedPersonalBudgetScreen.verifyDashboardContains4Blocks(
            'TOTAL SPENT', totalExpensesActual, tester);
        await plannedPersonalBudgetScreen.verifyDashboardContains4Blocks(
            'TOTAL UNCATEGORIZED', totalUncategorizedExpensesActual, tester);
        await plannedPersonalBudgetScreen.verifyDashboardContains4Blocks(
            'DIFFERENCE', totalExpensesDifference, tester);

        await personalBudgetScreen.clickCategoryArrowIcon(tester);
        await tester.pump(const Duration(seconds: 2));
        await htLogd(
            tester,
            'BAR_T240 Check that Dashboard contains 4 blocks: Total planned, Total spent, Difference, Total unplanned',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Failed BAR_T240 Check that Dashboard contains 4 blocks: Total planned, Total spent, Difference, Total unplanned',
            '',
            'FINISHED');
      }
    });
  });
}
