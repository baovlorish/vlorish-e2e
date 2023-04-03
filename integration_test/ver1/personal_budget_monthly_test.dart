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
        final housingValue = await plannedPersonalBudgetScreen.getValue('', 'Housing', 1, tester);
        final debtPaymentsValue =
            await plannedPersonalBudgetScreen.getValue('', 'Debt Payments', 1, tester);
        final transportationValue =
            await plannedPersonalBudgetScreen.getValue('', 'Transportation', 1, tester);
        final livingExpensesValue =
            await plannedPersonalBudgetScreen.getValue('', 'Living Expenses', 1, tester);
        final lifestyleExpensesValue =
            await plannedPersonalBudgetScreen.getValue('', 'Lifestyle Expenses', 1, tester);
        final kidsValue = await plannedPersonalBudgetScreen.getValue('', 'Kids', 1, tester);
        final givingValue = await plannedPersonalBudgetScreen.getValue('', 'Giving', 1, tester);
        final taxesValue = await plannedPersonalBudgetScreen.getValue('', 'Taxes', 1, tester);
        final otherExpensesValue =
            await plannedPersonalBudgetScreen.getValue('', 'Other Expenses', 1, tester);

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

        final totalExpensesValue =
            await plannedPersonalBudgetScreen.getValue('readOnly', 'Total Expenses', 2, tester);

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

        final totalExpensesValue =
            await plannedPersonalBudgetScreen.getValue('readOnly', 'Total Expenses', 3, tester);

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

      try {
        await htLogdDirect(
            'BAR_T259 Check that Months are shown by columns from Jan to Dec with heading appropriate to month value',
            '',
            'STARTED');
        await personalBudgetScreen.clickBudgetTab(btnPlanned, tester);
        for (var i = 1; i < monthNames.length; i++) {
          final columnValue =
              await plannedPersonalBudgetScreen.getValue('readOnly', 'CATEGORY', i, tester);
          await plannedPersonalBudgetScreen.verifyShowHeadingOfTheMonth(
              columnValue, getMonthAtYear(i), i, btnPlanned, tester);
        }

        await personalBudgetScreen.clickBudgetTab(btnActual, tester);
        for (var i = 1; i < monthNames.length; i++) {
          final columnValue =
              await plannedPersonalBudgetScreen.getValue('readOnly', 'CATEGORY', i, tester);
          await plannedPersonalBudgetScreen.verifyShowHeadingOfTheMonth(
              columnValue, getMonthAtYear(i), i, btnActual, tester);
        }

        await personalBudgetScreen.clickBudgetTab(btnDifference, tester);
        for (var i = 1; i < monthNames.length; i++) {
          final columnValue =
              await plannedPersonalBudgetScreen.getValue('readOnly', 'CATEGORY', i, tester);
          await plannedPersonalBudgetScreen.verifyShowHeadingOfTheMonth(
              columnValue, getMonthAtYear(i), i, btnDifference, tester);
        }
        await htLogd(
            tester,
            'BAR_T259 Check that Months are shown by columns from Jan to Dec with heading appropriate to month value',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Failed BAR_T259 Check that Months are shown by columns from Jan to Dec with heading appropriate to month value',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'BAR_T251 Check that values for all categories in columns are shown from Jan to Dec on ‘Planned’, ‘Actual’ and ‘Difference’ tables',
            '',
            'STARTED');
        await personalBudgetScreen.clickBudgetTab(btnPlanned, tester);
        for (var i = 0; i < mainCategoryList.length; i++) {
          await personalBudgetScreen.clickBudgetTab(getMonthAtYear(1), tester);
          for (var j = 1; j < monthNames.length; j++) {
            if (i == 10 || i == 11 || i == 12 || i == 14 || i == 15) {
              final columnValue = await plannedPersonalBudgetScreen.getValue(
                  'readOnly', mainCategoryList[i], j, tester);
              await plannedPersonalBudgetScreen.verifyShowValueInCell(
                  columnValue, getMonthAtYear(j), mainCategoryList[i], btnPlanned, tester);
            } else {
              final columnValue = await plannedPersonalBudgetScreen.getValue(
                  '', mainCategoryList[i], j - 1, tester);
              await plannedPersonalBudgetScreen.verifyShowValueInCell(
                  columnValue, getMonthAtYear(j), mainCategoryList[i], btnPlanned, tester);
            }
          }
        }

        await personalBudgetScreen.clickBudgetTab(btnActual, tester);
        for (var i = 0; i < mainCategoryList.length; i++) {
          await personalBudgetScreen.clickBudgetTab(getMonthAtYear(1), tester);
          for (var j = 1; j < monthNames.length; j++) {
            if (i == 10 || i == 11 || i == 12 || i == 14 || i == 15) {
              final columnValue = await plannedPersonalBudgetScreen.getValue(
                  'readOnly', mainCategoryList[i], j, tester);
              await plannedPersonalBudgetScreen.verifyShowValueInCell(
                  columnValue, getMonthAtYear(j), mainCategoryList[i], btnActual, tester);
            } else {
              final columnValue =
                  await plannedPersonalBudgetScreen.getValue('', mainCategoryList[i], j, tester);
              await plannedPersonalBudgetScreen.verifyShowValueInCell(
                  columnValue, getMonthAtYear(j), mainCategoryList[i], btnActual, tester);
            }
          }
        }

        await personalBudgetScreen.clickBudgetTab(btnDifference, tester);
        for (var i = 0; i < mainCategoryList.length; i++) {
          await personalBudgetScreen.clickBudgetTab(getMonthAtYear(1), tester);
          for (var j = 1; j < monthNames.length; j++) {
            if (i == 10 || i == 11 || i == 12 || i == 14 || i == 15) {
              final columnValue = await plannedPersonalBudgetScreen.getValue(
                  'readOnly', mainCategoryList[i], j, tester);
              await plannedPersonalBudgetScreen.verifyShowValueInCell(
                  columnValue, getMonthAtYear(j), mainCategoryList[i], btnDifference, tester);
            } else {
              final columnValue =
                  await plannedPersonalBudgetScreen.getValue('', mainCategoryList[i], j, tester);
              await plannedPersonalBudgetScreen.verifyShowValueInCell(
                  columnValue, getMonthAtYear(j), mainCategoryList[i], btnDifference, tester);
            }
          }
        }
        await htLogd(
            tester,
            'BAR_T251 Check that values for all categories in columns are shown from Jan to Dec on ‘Planned’, ‘Actual’ and ‘Difference’ tables',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Failed BAR_T251 Check that values for all categories in columns are shown from Jan to Dec on ‘Planned’, ‘Actual’ and ‘Difference’ tables',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'BAR_T261 Check that the category total sum is shown by columns in "Year" column',
            '',
            'STARTED');
        await personalBudgetScreen.clickBudgetTab(btnPlanned, tester);
        final columnValue = await plannedPersonalBudgetScreen.getValue(
            'readOnly', 'CATEGORY', monthNames.length, tester);
        await plannedPersonalBudgetScreen.verifyShowHeadingOfTheMonth(
            columnValue, 'YEAR', monthNames.length, btnPlanned, tester);

        for (var i = 0; i < mainCategoryList.length; i++) {
          await personalBudgetScreen.clickBudgetTab(getMonthAtYear(1), tester);
          var totalValueRow = 0;
          for (var j = 1; j < monthNames.length; j++) {
            if (i == 10 || i == 11 || i == 12 || i == 14 || i == 15) {
              final columnValue = await plannedPersonalBudgetScreen.getValue(
                  'readOnly', mainCategoryList[i], j, tester);
              totalValueRow += currencyStringToNumber(columnValue);
            } else {
              final columnValue = await plannedPersonalBudgetScreen.getValue(
                  '', mainCategoryList[i], j - 1, tester);
              totalValueRow += currencyStringToNumber(columnValue);
            }
          }
          final sumTotalValue = '\$' + formatNumberToValue(totalValueRow);
          if (i == 10 || i == 11 || i == 12 || i == 14 || i == 15) {
            final valueInYear = await plannedPersonalBudgetScreen.getValue(
                'readOnly', mainCategoryList[i], monthNames.length, tester);
            await plannedPersonalBudgetScreen.verifyShowValueYearColumn(
                valueInYear, sumTotalValue, mainCategoryList[i], btnPlanned, tester);
          } else {
            final valueInYear = await plannedPersonalBudgetScreen.getValue(
                '', mainCategoryList[i], monthNames.length - 1, tester);
            await plannedPersonalBudgetScreen.verifyShowValueYearColumn(
                valueInYear, sumTotalValue, mainCategoryList[i], btnPlanned, tester);
          }
        }

        await htLogd(
            tester,
            'BAR_T261 Check that the category total sum is shown by columns in "Year" column',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Failed BAR_T261 Check that the category total sum is shown by columns in "Year" column',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'BAR_T256 Check that the "Difference" table shows user the difference between the actual and planned amount',
            '',
            'STARTED');
        await personalBudgetScreen.clickBudgetTab(btnPlanned, tester);

        for (var i = 0; i < mainCategoryList.length; i++) {
          var valueOfPlanned = <String>[];
          var valueOfActual = <String>[];

          for (var j = 1; j < monthNames.length; j++) {
            if (i == 10 || i == 11 || i == 12 || i == 14 || i == 15) {
              final getValuePlanned = await plannedPersonalBudgetScreen.getValue(
                  'readOnly', mainCategoryList[i], j, tester);
              valueOfPlanned.add(getValuePlanned);
            } else {
              final getValuePlanned = await plannedPersonalBudgetScreen.getValue(
                  '', mainCategoryList[i], j - 1, tester);
              valueOfPlanned.add(getValuePlanned);
            }
          }

          await personalBudgetScreen.clickBudgetTab(btnActual, tester);
          for (var j = 1; j < monthNames.length; j++) {
            if (i == 10 || i == 11 || i == 12 || i == 14 || i == 15) {
              final getValueActual = await plannedPersonalBudgetScreen.getValue(
                  'readOnly', mainCategoryList[i], j, tester);
              valueOfActual.add(getValueActual);
            } else {
              final getValueActual = await plannedPersonalBudgetScreen.getValue(
                  '', mainCategoryList[i], j - 1, tester);
              valueOfActual.add(getValueActual);
            }
          }

          await personalBudgetScreen.clickBudgetTab(btnDifference, tester);
          for (var j = 1; j < monthNames.length; j++) {
            if (i == 10 || i == 11 || i == 12 || i == 14 || i == 15) {
              final getValueDifference = await plannedPersonalBudgetScreen.getValue(
                  'readOnly', mainCategoryList[i], j, tester);
              final valueMatcher =
                  calculateValueDifference(valueOfPlanned[j - 1], valueOfActual[j - 1]);
              final valueVerify = '\$' + formatNumberToValue(valueMatcher);
              calculateValueDifference(valueOfPlanned[j - 1], valueOfActual[j - 1]).toString();
              await plannedPersonalBudgetScreen.verifyValueBetweenActualAndPlanned(
                  getValueDifference, valueVerify, mainCategoryList[i], tester);
            } else {
              final getValueDifference = await plannedPersonalBudgetScreen.getValue(
                  '', mainCategoryList[i], j - 1, tester);
              final valueMatcher =
                  calculateValueDifference(valueOfPlanned[j - 1], valueOfActual[j - 1]);
              final valueVerify = '\$' + formatNumberToValue(valueMatcher);
              await plannedPersonalBudgetScreen.verifyValueBetweenActualAndPlanned(
                  getValueDifference, valueVerify, mainCategoryList[i], tester);
            }
          }
          await personalBudgetScreen.clickBudgetTab(btnPlanned, tester);
        }

        await htLogd(
            tester,
            'BAR_T256 Check that the "Difference" table shows user the difference between the actual and planned amount',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Failed BAR_T256 Check that the "Difference" table shows user the difference between the actual and planned amount',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'BAR_T247 Check that user cannot change Actual sum manually', '', 'STARTED');
        await personalBudgetScreen.clickBudgetTab(btnAnnual, tester);
        await personalBudgetScreen.clickBudgetTab(btnMonthly, tester);
        await personalBudgetScreen.clickCategoryList('Housing', tester);
        for (int i = 0; i < incomeSubCategoryList.length; i++) {
          final number = randomInt(999999).toString();
          final number1 = randomInt(999999).toString();
          await plannedPersonalBudgetScreen.inputValueInActualDifference(
              housingSubCategoryList[i], 1, number, tester);
          final getvalue = await plannedPersonalBudgetScreen.getValue(
              'readOnly', housingSubCategoryList[i], 1, tester);
          await plannedPersonalBudgetScreen.verifyValueInActualDifferenceAfterInput(
              getvalue, number, tester);
          await plannedPersonalBudgetScreen.inputValueInActualDifference(
              housingSubCategoryList[i], 2, number1, tester);
          final getvalue1 = await plannedPersonalBudgetScreen.getValue(
              'readOnly', housingSubCategoryList[i], 2, tester);
          await plannedPersonalBudgetScreen.verifyValueInActualDifferenceAfterInput(
              getvalue1, number1, tester);
        }
        await personalBudgetScreen.clickCategoryArrowIcon(tester);
        await tester.pump(const Duration(seconds: 2));
        await htLogd(
            tester, 'BAR_T247 Check that user cannot change Actual sum manually', '', 'FINISHED');
      } catch (e) {
        await htLogd(tester, 'Failed BAR_T247 Check that user cannot change Actual sum manually',
            '', 'FINISHED');
      }

      try {
        await htLogdDirect(
            'BAR_T239 Check that user can change planned sum in any line manually', '', 'STARTED');
        await personalBudgetScreen.clickBudgetTab(btnAnnual, tester);
        await personalBudgetScreen.clickBudgetTab(btnMonthly, tester);
        await personalBudgetScreen.clickCategoryList('Income', tester);
        for (int i = 0; i < incomeSubCategoryList.length; i++) {
          final number = randomInt(999999).toString();
          await plannedPersonalBudgetScreen.inputValueOnMonthly(
              incomeSubCategoryList[i], 0, number, tester);

          final getvalueIncell = await plannedPersonalBudgetScreen.verifyValueInCell(
              incomeSubCategoryList[i], 0, number, tester);
        }
        await personalBudgetScreen.clickCategoryArrowIcon(tester);
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
