import 'dart:math';
import 'package:burgundy_budgeting_app/ui/atomic/atom/dashboard_item.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/label.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/editable_table_body_cell.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/month_dashboard.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/side_menu_button_item.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/table_body_cell.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/toggling_cell.dart';
import 'package:burgundy_budgeting_app/ui/atomic/organizm/period_selector.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_inkwell.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/appbar_item.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/annual_monthly_button.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/avatar_widget.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import '../lib/function_common.dart';
import '../lib/test_lib_common.dart';
import '../lib/test_lib_const.dart';

class PlannedBudgetScreenTest {
  const PlannedBudgetScreenTest(this.tester);

  final WidgetTester tester;

  Future<void> inputValuePlannedCell(String rowName, WidgetTester tester,
      {String context = ''}) async {
    await tester.pumpAndSettle();
    final rowFinder = find.descendant(
      of: find.byType(TableBodyCell),
      matching: find.text(rowName),
    );

    final sizedBoxFinder = find.ancestor(
      of: rowFinder,
      matching: find.byType(SizedBox),
    );

    final textFormFieldFinder = find.descendant(
      of: sizedBoxFinder,
      matching: find.byType(TextFormField),
    );

    final textFormFields = tester.widgetList(textFormFieldFinder).cast<TextFormField>();
    final count = textFormFields.length;

    final index = randomInt(count - 1);
    final number = randomInt(999999);
    final valueInput = number.toString();
    final valueVerify = formatNumberToValue(number);

    await tester.tap(textFormFieldFinder.at(index));
    await tester.pump(const Duration(seconds: 2));
    if (valueInput != '') {
      await tester.sendKeyDownEvent(LogicalKeyboardKey.backspace);
      await tester.pump(const Duration(seconds: 2));
      await tester.tap(textFormFieldFinder.at(index));
      await tester.enterText(textFormFieldFinder.at(index), valueInput);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      if (index != count - 1) {
        await tester.tap(textFormFieldFinder.at(index + 1));
        await tester.pump(const Duration(seconds: 5));
      } else {
        await tester.tap(textFormFieldFinder.at(index - 1));
        await tester.pump(const Duration(seconds: 5));
      }

      await verifyValueInCell(rowName, index, valueVerify, tester);
    }
  }

  Future<void> clickCategoryList(String categoryName, WidgetTester tester,
      {String context = ''}) async {
    await tester.pumpAndSettle(const Duration(seconds: 5));
    final categoryFinder = find.descendant(
      of: find.byType(TogglingCell),
      matching: find.text(categoryName),
    );

    await tapSomething(tester, categoryFinder, addContext(context, 'Click on btn $categoryName'));
    await tester.pump();
    await tester.pumpAndSettle();
  }

  Future<void> verifyUpdateTotalPlanned(
      String rowName, int indexCell, String valueVerify, WidgetTester tester,
      {String context = '', Finder? rowFinder}) async {
    await tester.pumpAndSettle(const Duration(seconds: 20));

    rowFinder ??= find.descendant(
      of: find.byType(TogglingCell),
      matching: find.text(rowName),
    );

    final sizedBoxFinder = find.ancestor(
      of: rowFinder,
      matching: find.byType(SizedBox),
    );

    final tableBodyCellFinder = find.descendant(
      of: sizedBoxFinder,
      matching: find.byType(TableBodyCell),
    );

    final label = find.descendant(
      of: tableBodyCellFinder.at(indexCell),
      matching: find.byType(Label),
    );

    final cellText = find.descendant(
      of: label,
      matching: find.byType(Text),
    );

    final cellTextWidget = tester.widget<Text>(cellText);
    final cellTextValue = cellTextWidget.data ?? '';

    await tester.pumpAndSettle(const Duration(seconds: 5));
    expect(cellTextValue, valueVerify);
    await htExpect(tester, cellTextValue, valueVerify,
        reason: ('Verify-' + context + 'the Total value $valueVerify in cell has been update'));
  }

  Future<void> inputValue(String rowName, int indexCell, String valueInput, WidgetTester tester,
      {String context = ''}) async {
    await tester.pumpAndSettle();
    final rowFinder = find.descendant(
      of: find.byType(TableBodyCell),
      matching: find.text(rowName),
    );

    final sizedBoxFinder = find.ancestor(
      of: rowFinder,
      matching: find.byType(SizedBox),
    );

    final textFormFieldFinder = find.descendant(
      of: sizedBoxFinder,
      matching: find.byType(TextFormField),
    );

    final textFormFields = tester.widgetList(textFormFieldFinder).cast<TextFormField>();
    final count = textFormFields.length;
    await tester.tap(textFormFieldFinder.at(indexCell));
    await tester.pump(const Duration(seconds: 2));
    if (valueInput != '') {
      await tester.sendKeyDownEvent(LogicalKeyboardKey.backspace);
      await tester.pump(const Duration(seconds: 2));
      await tester.tap(textFormFieldFinder.at(indexCell));
      await tester.enterText(textFormFieldFinder.at(indexCell), valueInput);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      if (indexCell != 11) {
        await tester.tap(textFormFieldFinder.at(indexCell + 1));
        await tester.pump(const Duration(seconds: 5));
      } else {
        await tester.tap(textFormFieldFinder.at(indexCell - 1));
        await tester.pump(const Duration(seconds: 5));
      }

      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle(const Duration(seconds: 2));
    }
  }

  Future<void> checkValue0IsKeepeDunfilled(String rowName, WidgetTester tester,
      {String context = ''}) async {
    await tester.pumpAndSettle();
    final rowFinder = find.descendant(
      of: find.byType(TableBodyCell),
      matching: find.text(rowName),
    );

    final sizedBoxFinder = find.ancestor(
      of: rowFinder,
      matching: find.byType(SizedBox),
    );

    final textFormFieldFinder = find.descendant(
      of: sizedBoxFinder,
      matching: find.byType(TextFormField),
    );

    final textFormFields = tester.widgetList(textFormFieldFinder).cast<TextFormField>();
    final count = textFormFields.length;

    final indexCell = randomInt(count);

    await tester.tap(textFormFieldFinder.at(indexCell));
    await tester.pump(const Duration(seconds: 2));

    await tester.sendKeyDownEvent(LogicalKeyboardKey.backspace);
    await tester.pump(const Duration(seconds: 2));

    if (indexCell != count - 1) {
      await tester.tap(textFormFieldFinder.at(indexCell + 1));
      await tester.pump(const Duration(seconds: 5));
    } else {
      await tester.tap(textFormFieldFinder.at(indexCell - 1));
      await tester.pump(const Duration(seconds: 5));
    }

    await tester.pump(const Duration(seconds: 2));
    await verifyValueInCell(rowName, indexCell, '0', tester);
    await tester.pumpAndSettle(const Duration(seconds: 2));
  }

  Future<void> verifyValueInCell(String rowName, int indexCell, String value, WidgetTester tester,
      {String context = ''}) async {
    await tester.pumpAndSettle();
    final rowFinder = find.descendant(
      of: find.byType(TableBodyCell),
      matching: find.text(rowName),
    );

    final sizedBoxFinder = find.ancestor(
      of: rowFinder,
      matching: find.byType(SizedBox),
    );

    final textFormFieldFinder = find.descendant(
      of: sizedBoxFinder,
      matching: find.byType(TextFormField),
    );

    final formFieldState =
        tester.state(textFormFieldFinder.at(indexCell)) as FormFieldState<String>;

    final textFormFieldValue = formFieldState.value;
    await htExpect(tester, textFormFieldValue, value,
        reason: ('Verify-' + context + 'the value $value in cell has been input'));

    await tester.pumpAndSettle();
  }

  Future<void> verifyValueTotalPlannedOnMonthlyPage(
      String rowStyle, String rowName, int indexCell, String valueVerify, WidgetTester tester,
      {String context = '', Finder? rowFinder}) async {
    await tester.pumpAndSettle();

    rowFinder ??= rowStyle == 'readOnly'
        ? find.descendant(
            of: find.byType(TableBodyCell),
            matching: find.text(rowName),
          )
        : find.descendant(
            of: find.byType(TogglingCell),
            matching: find.text(rowName),
          );

    final sizedBoxFinder = find.ancestor(
      of: rowFinder,
      matching: find.byType(SizedBox),
    );
    final tableBodyCellFinder = find.descendant(
      of: sizedBoxFinder,
      matching: find.byType(TableBodyCell),
    );
    final label = find.descendant(
      of: tableBodyCellFinder.at(indexCell),
      matching: find.byType(Label),
    );
    final cellText = find.descendant(
      of: label,
      matching: find.byType(Text),
    );
    final cellTextWidget = tester.widget<Text>(cellText);
    final cellTextValue = cellTextWidget.data ?? '';
    expect(cellTextValue, equals(valueVerify));
    await htExpect(tester, cellTextValue, valueVerify,
        reason: ('Verify-' + context + 'total value in $rowName is found on the Monthly page'));

    await tester.pumpAndSettle();
  }

  Future<String> getValueInCell(String rowName, int indexCell, WidgetTester tester,
      {String context = ''}) async {
    await tester.pumpAndSettle();
    final rowFinder = find.descendant(
      of: find.byType(TableBodyCell),
      matching: find.text(rowName),
    );

    final sizedBoxFinder = find.ancestor(
      of: rowFinder,
      matching: find.byType(SizedBox),
    );

    final textFormFieldFinder = find.descendant(
      of: sizedBoxFinder,
      matching: find.byType(TextFormField),
    );

    final formFieldState =
        tester.state(textFormFieldFinder.at(indexCell)) as FormFieldState<String>;

    final textFormFieldValue = formFieldState.value ?? '';
    await tester.pumpAndSettle();
    return textFormFieldValue;
  }

  Future<void> verifyValueTotalSubCategoryPlannedIsChange(
      String valueTotalBefore, String valueTotalAfter, WidgetTester tester,
      {String context = '', Finder? rowFinder}) async {
    await tester.pumpAndSettle(const Duration(seconds: 20));
    await htExpect(tester, valueTotalBefore, isNot(valueTotalAfter),
        reason: ('Verify-' +
            context +
            'Total sum subCategory $valueTotalBefore in cell has been update to $valueTotalAfter'));
  }

  Future<void> verifyValueInActualDifferenceAfterInput(
      String valueTotalBefore, String valueTotalAfter, WidgetTester tester,
      {String context = '', Finder? rowFinder}) async {
    await tester.pumpAndSettle(const Duration(seconds: 20));
    await htExpect(tester, valueTotalBefore, isNot(valueTotalAfter),
        reason: ('Verify-' + context + 'Can NOT input $valueTotalAfter in cell'));
  }

  Future<void> verifyTotalValueCurrentMonth(
      String valueTotalBefore, String valueTotalAfter, WidgetTester tester,
      {String context = '', Finder? rowFinder}) async {
    await tester.pumpAndSettle(const Duration(seconds: 2));
    await htExpect(tester, valueTotalBefore, equals(valueTotalAfter),
        reason: ('Verify-' +
            context +
            'sum is shown by subcategories for current months in category line'));
  }

  Future<void> verifyDashboardContains4Blocks(
      String dashboardTitle, String dashboardValue, WidgetTester tester,
      {String context = ''}) async {
    await tester.pumpAndSettle(const Duration(seconds: 2));

    final labelText = find.descendant(
      of: find.byType(Label),
      matching: find.text(dashboardTitle),
    );
    await htExpect(tester, labelText, findsOneWidget,
        reason: ('Verify-' + context + '$dashboardTitle Block Title is visible'));

    final dashboardItem = find.ancestor(
      of: labelText,
      matching: find.byType(DashboardItem),
    );

    final textFinder = find.descendant(
      of: dashboardItem,
      matching: find.byType(Text),
    );
    final textList = tester.widgetList(textFinder).cast<Text>();
    final textValue = textList.elementAt(0).data;

    await htExpect(tester, textValue, equals(dashboardValue),
        reason:
            ('Verify-' + context + '$dashboardTitle Block have value $dashboardValue is visible'));
  }

  Future<void> inputValueInActualDifference(
      String nameRow, int indexCell, String valueInput, WidgetTester tester,
      {String context = ''}) async {
    await tester.pumpAndSettle();
    final rowFinder = find.descendant(
      of: find.byType(TableBodyCell),
      matching: find.text(nameRow),
    );
    print('rowFinder: --$rowFinder');
    final sizedBoxFinder = find.ancestor(
      of: rowFinder,
      matching: find.byType(SizedBox),
    );
    print('sizedBoxFinder: --$sizedBoxFinder');

    final tableBodyCellFinder = find.descendant(
      of: sizedBoxFinder,
      matching: find.byType(TableBodyCell),
    );
    print('tableBodyCellFinder: --$tableBodyCellFinder');

    await tester.tap(tableBodyCellFinder.at(indexCell));
    await tester.pump(const Duration(seconds: 2));
    await tester.sendKeyDownEvent(LogicalKeyboardKey.backspace);
    await tester.pump(const Duration(seconds: 2));
    await tester.tap(tableBodyCellFinder.at(indexCell), warnIfMissed: false);
    await tester.pump(const Duration(seconds: 5));
    await tester.enterText(tableBodyCellFinder.at(indexCell), valueInput);
    await tester.pumpAndSettle(const Duration(seconds: 10));
    await tester.sendKeyDownEvent(LogicalKeyboardKey.tab);

    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle(const Duration(seconds: 2));

    final tableCellWidget = tester.widget<TableBodyCell>(tableBodyCellFinder.at(indexCell));
    expect(tableCellWidget.text, isNot(contains(valueInput)));
    await tester.pumpAndSettle();
  }

  Future<void> inputValueOnMonthly(
      String rowName, int indexCell, String valueInput, WidgetTester tester,
      {String context = ''}) async {
    await tester.pumpAndSettle();
    final rowFinder = find.descendant(
      of: find.byType(TableBodyCell),
      matching: find.text(rowName),
    );

    final sizedBoxFinder = find.ancestor(
      of: rowFinder,
      matching: find.byType(SizedBox),
    );

    final textFormFieldFinder = find.descendant(
      of: sizedBoxFinder,
      matching: find.byType(TextFormField),
    );

    final textFormFields = tester.widgetList(textFormFieldFinder).cast<TextFormField>();
    final count = textFormFields.length;
    await tester.tap(textFormFieldFinder.at(indexCell), buttons: kPrimaryButton | kSecondaryButton);
    await tester.pump(const Duration(seconds: 2));
    await tester.sendKeyDownEvent(LogicalKeyboardKey.backspace);
    await tester.pump(const Duration(seconds: 2));
    await tester.tap(textFormFieldFinder.at(indexCell), buttons: kPrimaryButton | kSecondaryButton);
    await tester.enterText(textFormFieldFinder.at(indexCell), valueInput);
    await tester.pumpAndSettle(const Duration(seconds: 2));
    await tester.sendKeyDownEvent(LogicalKeyboardKey.tab);

    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle(const Duration(seconds: 2));
  }

  Future<void> inputValueInCell(
      String rowName, int indexCell, String valueInput, WidgetTester tester,
      {String context = ''}) async {
    await tester.pumpAndSettle();
    final rowFinder = find.descendant(
      of: find.byType(TableBodyCell),
      matching: find.text(rowName),
    );

    final sizedBoxFinder = find.ancestor(
      of: rowFinder,
      matching: find.byType(SizedBox),
    );

    final textFormFieldFinder = find.descendant(
      of: sizedBoxFinder,
      matching: find.byType(TextFormField),
    );

    final textFormFields = tester.widgetList(textFormFieldFinder).cast<TextFormField>();
    final count = textFormFields.length;
    await tester.tap(textFormFieldFinder.at(indexCell));
    await tester.pump(const Duration(seconds: 2));
    await tester.sendKeyDownEvent(LogicalKeyboardKey.backspace);
    await tester.pump(const Duration(seconds: 2));
    await tester.tap(textFormFieldFinder.at(indexCell));
    await tester.enterText(textFormFieldFinder.at(indexCell), valueInput);
    await tester.pumpAndSettle(const Duration(seconds: 2));

    if (indexCell != count - 1) {
      await tester.tap(textFormFieldFinder.at(indexCell + 1));
      await tester.pump(const Duration(seconds: 5));
    } else {
      await tester.tap(textFormFieldFinder.at(indexCell - 1));
      await tester.pump(const Duration(seconds: 5));
    }

    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle(const Duration(seconds: 2));
  }

  Future<String> getValue(String valueType, String rowName, int indexCell, WidgetTester tester,
      {String context = '', Finder? rowFinder}) async {
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle(const Duration(seconds: 2));

    if (valueType == 'readOnly') {
      rowFinder ??= find.descendant(
        of: find.byType(TableBodyCell),
        matching: find.text(rowName),
      );
    } else {
      rowFinder ??= find.descendant(
        of: find.byType(TogglingCell),
        matching: find.text(rowName),
      );
    }

    final sizedBoxFinder = find.ancestor(
      of: rowFinder,
      matching: find.byType(SizedBox),
    );

    final tableBodyCellFinder = find.descendant(
      of: sizedBoxFinder,
      matching: find.byType(TableBodyCell),
    );

    final label = find.descendant(
      of: tableBodyCellFinder.at(indexCell),
      matching: find.byType(Label),
    );

    var cellTextValue = '';

    final cellText = find.descendant(
      of: label,
      matching: find.byType(Text),
    );

    final cellTextWidget = tester.widget<Text>(cellText);
    cellTextValue = cellTextWidget.data ?? '';

    await tester.pump(const Duration(seconds: 2));
    print('cellTextValue: -----------$cellTextValue');
    return cellTextValue;
  }

  Future<void> verifyShowHeadingOfTheMonth(String monthOfColumn, String monthDisplay, int indexCell,
      String pageName, WidgetTester tester,
      {String context = '', Finder? rowFinder}) async {
    await tester.pumpAndSettle(const Duration(seconds: 2));
    await htExpect(tester, monthOfColumn, equals(monthDisplay),
        reason: ('Verify-' +
            context +
            'At column position $indexCell value $monthOfColumn is visible on the $pageName'));
  }

  Future<void> verifyShowValueInCell(
      String valueInCell, String monthDisplay, String nameRow, String pageName, WidgetTester tester,
      {String context = '', Finder? rowFinder}) async {
    await tester.pumpAndSettle(const Duration(seconds: 2));
    await htExpect(tester, valueInCell, contains('\$'),
        reason: ('Verify-' +
            context +
            'The value in the $monthDisplay column of $pageName\'s $nameRow is non-null and contains the \$ character is visible'));
  }

  Future<void> verifyShowValueYearColumn(
      String valueActual, String valueMatcher, String nameRow, String pageName, WidgetTester tester,
      {String context = '', Finder? rowFinder}) async {
    await tester.pumpAndSettle(const Duration(seconds: 2));
    await htExpect(tester, valueActual, equals(valueMatcher),
        reason: ('Verify-' +
            context +
            'Category total sum is shown by columns in "Year" column of $pageName\'s $nameRow is visible'));
  }

  Future<void> verifyValueBetweenActualAndPlanned(
      String valueActual, String valueMatcher, String nameRow, WidgetTester tester,
      {String context = '', Finder? rowFinder}) async {
    await tester.pumpAndSettle(const Duration(seconds: 2));
    await htExpect(tester, valueActual, equals(valueMatcher),
        reason: ('Verify-' +
            context +
            '"Difference" table shows the difference between the actual and planned amount on the $nameRow row'));
  }

  Future<void> getAndVerifyValueAllCategory(int begin, int limit, WidgetTester tester,
      {String context = '', Finder? rowFinder}) async {
    for (var i = begin; i < limit; i++) {
      await tester.pumpAndSettle(const Duration(seconds: 2));
      final btnBackIcon = find.text(getMonthAtYear(1));
      await tapSomething(
          tester, btnBackIcon, addContext(context, 'Click on ' + getMonthAtYear(1) + ' tab'));
      await tester.pump();
      await tester.pumpAndSettle();

      for (var j = 1; j < monthNames.length; j++) {
        if (i == 10 || i == 11 || i == 12 || i == 14 || i == 15) {
          final columnValue = await getValue('readOnly', mainCategoryList[i], j, tester);
          await tester.pumpAndSettle(const Duration(seconds: 2));
          await htExpect(tester, columnValue, contains('\$'),
              reason: ('Verify-' +
                  context +
                  'The value in the ${getMonthAtYear(j)} column of ${mainCategoryList[i]} is non-null and contains the \$ character is visible'));
        } else {
          print('object AAAAAAAAA');
          final columnValue = await getValue('', mainCategoryList[i], j - 1, tester);
          print('BBBBBBBBBBB : $columnValue');
          await tester.pumpAndSettle(const Duration(seconds: 2));
          await htExpect(tester, columnValue, contains('\$'),
              reason: ('Verify-' +
                  context +
                  'The value in the ${getMonthAtYear(j)} column of ${mainCategoryList[i]} is non-null and contains the \$ character is visible'));
        }
      }
    }
  }

  Future<void> getAndVerifyValueCurrentMonthCategory(
      String pageName, String categoryName, List<String> subCategoryName, WidgetTester tester,
      {String context = '', Finder? rowFinder}) async {
    final currentMonth = getCurrentMonth();
    final currentMonthIndex = monthNames.indexOf('$currentMonth');
    await clickCategoryList(categoryName, tester);

    final getValueCategory = await getValue('', categoryName, currentMonthIndex - 1, tester);

    var sumValueSub = 0;
    for (var i = 0; i < subCategoryName.length; i++) {
      if (pageName == 'Planned') {
        print('pageName = Planned');
        final cellValue = await getValueInCell(subCategoryName[i], currentMonthIndex - 1, tester);
        sumValueSub += currencyStringToNumber(cellValue);
      } else {
        print('pageName != Planned');
        final cellValue = await getValue('readOnly', subCategoryName[i], currentMonthIndex, tester);
        sumValueSub += currencyStringToNumber(cellValue);
      }
    }
    final sumTotalValue = '\$' + formatNumberToValue(sumValueSub);
    await verifyTotalValueCurrentMonth(getValueCategory, sumTotalValue, tester);
    await clickCategoryList(categoryName, tester);
  }

  // Future<void> getAndVerifyValue(int begin, int limit, WidgetTester tester,
  //     {String context = '', Finder? rowFinder}) async {
  //   for (var i = begin; i < limit; i++) {
  //     await tester.tap(find.text(getMonthAtYear(1)));
  //     for (var j = 1; j < monthNames.length; j++) {
  //       if (i == 10 || i == 11 || i == 12 || i == 14 || i == 15) {
  //         final columnValue = getValue('readOnly', mainCategoryList[i], j, tester);
  //         await htExpect(tester, columnValue, contains('\$'),
  //             reason: ('Verify-' +
  //                 context +
  //                 'The value in the ${getMonthAtYear(j)} column of ${mainCategoryList[i]} is non-null and contains the \$ character is visible'));
  //       } else {
  //         final columnValue = getValue('', mainCategoryList[i], j - 1, tester);
  //         await htExpect(tester, columnValue, contains('\$'),
  //             reason: ('Verify-' +
  //                 context +
  //                 'The value in the ${getMonthAtYear(j)} column of ${mainCategoryList[i]} is non-null and contains the \$ character is visible'));
  //       }
  //     }
  //   }
  // }
}
