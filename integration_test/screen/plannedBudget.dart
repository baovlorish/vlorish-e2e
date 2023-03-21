import 'dart:math';
import 'package:burgundy_budgeting_app/ui/atomic/atom/dashboard_item.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/label.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/editable_table_body_cell.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/month_dashboard.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/side_menu_button_item.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/table_body_cell.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/toggling_cell.dart';
import 'package:burgundy_budgeting_app/ui/atomic/organizm/period_selector.dart';
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

  Future<String> getValueTotalPlanned(
      String getValueOnPage, String rowName, int indexCell, WidgetTester tester,
      {String context = '', Finder? rowFinder}) async {
    await tester.pumpAndSettle(const Duration(seconds: 20));

    rowFinder ??= getValueOnPage == 'readOnly'
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

    return cellTextValue;
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

  Future<String> getValueOnMonthly(
      String valueType, String rowName, int indexCell, WidgetTester tester,
      {String context = '', Finder? rowFinder}) async {
    await tester.pumpAndSettle(const Duration(seconds: 2));

    rowFinder ??= valueType == 'readOnly'
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

    return cellTextValue;
  }
}
