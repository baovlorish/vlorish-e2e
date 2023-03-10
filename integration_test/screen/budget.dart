import 'dart:math';
import 'package:burgundy_budgeting_app/ui/atomic/atom/dashboard_item.dart';
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

class BudgetScreenTest {
  const BudgetScreenTest(this.tester);

  final WidgetTester tester;

  Future<void> verifyPersonalBudgetPage(WidgetTester tester,
      {String context = ''}) async {
    await tester.pumpAndSettle(const Duration(seconds: 45));
    await htExpect(tester, find.text('Personal Budget'), findsOneWidget,
        reason:
            ('Verify-' + context + '-' + 'Personal Budget Title is visible'));
    await htExpect(tester, find.text('Annual'), findsOneWidget,
        reason: ('Verify-' + context + '-' + 'Annual text is visible'));
    await htExpect(tester, find.text('CATEGORY'), findsOneWidget,
        reason: ('Verify-' + context + '-' + 'Category text is visible'));
    await tester.pumpAndSettle();
  }

  Future<void> verifyBusinessBudgetPage(WidgetTester tester,
      {String context = ''}) async {
    await tester.pumpAndSettle(const Duration(seconds: 45));
    await htExpect(tester, find.text('Business Budget'), findsOneWidget,
        reason:
            ('Verify-' + context + '-' + 'Business Budget Title is visible'));
    await htExpect(tester, find.text('Annual'), findsOneWidget,
        reason: ('Verify-' + context + '-' + 'Annual text is visible'));
    await htExpect(tester, find.text('CATEGORY'), findsOneWidget,
        reason: ('Verify-' + context + '-' + 'Category text is visible'));
    await tester.pumpAndSettle();
  }

  Future<void> clickMonthly(WidgetTester tester, {String context = ''}) async {
    await tester.pumpAndSettle(const Duration(seconds: 2));
    final btnForgotPass = find.text(btnMonthly).first;
    await tapSomething(
        tester, btnForgotPass, addContext(context, 'Click on btn Monthly'));
    await tester.pumpAndSettle();
  }

  Future<void> verifyBudgetMonthlyPage(WidgetTester tester,
      {String context = ''}) async {
    await tester.pumpAndSettle(const Duration(seconds: 30));
    // await verifyAnnualMonthlyTabSelector(btnAnnual, false, tester);
    // await verifyAnnualMonthlyTabSelector(btnMonthly, true, tester);
    await htExpect(tester, find.text('TOTAL PLANNED'), findsOneWidget,
        reason: ('Verify-' + context + '- Text Total Planned is visible'));
    await htExpect(tester, find.text('TOTAL SPENT'), findsOneWidget,
        reason: ('Verify-' + context + '- Text Total Spent is visible'));
    await htExpect(tester, find.text('TOTAL UNCATEGORIZED'), findsOneWidget,
        reason:
            ('Verify-' + context + '- Text Total Uncategorized is visible'));
    await tester.pumpAndSettle();
  }

  Future<void> verifyBudgetAnnualPage(WidgetTester tester,
      {String context = ''}) async {
    await tester.pumpAndSettle(const Duration(seconds: 30));
    await verifyAnnualMonthlyTabSelector(btnAnnual, true, tester);
    await verifyAnnualMonthlyTabSelector(btnMonthly, false, tester);
    await htExpect(tester, find.text('TOTAL PLANNED'), findsNothing,
        reason: ('Verify-' + context + '- Text Total Planned is NOT visible'));
    await htExpect(tester, find.text('TOTAL SPENT'), findsNothing,
        reason: ('Verify-' + context + '- Text Total Spent is NOT visible'));
    await htExpect(tester, find.text('TOTAL UNCATEGORIZED'), findsNothing,
        reason: ('Verify-' +
            context +
            '- Text Total Uncategorized is NOT visible'));
    await tester.pumpAndSettle();
  }

  Future<void> verifyAccountsTransactionsPage(WidgetTester tester,
      {String context = ''}) async {
    await tester.pumpAndSettle(const Duration(seconds: 30));
    await htExpect(tester, find.text('Accounts & Transactions'), findsOneWidget,
        reason: ('Verify-' +
            context +
            '- Text Accounts & Transactions Title is visible'));
    await htExpect(tester, find.text('Top Merchants'), findsOneWidget,
        reason: ('Verify-' + context + '- Text Top Merchants is visible'));
    await htExpect(tester, find.text('Top Transactions'), findsOneWidget,
        reason: ('Verify-' + context + '- Text Top Transactions is visible'));
    await tester.pumpAndSettle();
  }

  Future<void> verifyDebtsPage(WidgetTester tester,
      {String context = ''}) async {
    await tester.pumpAndSettle(const Duration(seconds: 15));
    await htExpect(tester, find.text('Debt Payoff'), findsOneWidget,
        reason: ('Verify-' + context + '- Text Debt Playoff Title is visible'));
    await htExpect(tester, find.text('Debts overview'), findsOneWidget,
        reason: ('Verify-' + context + '- Text Debts overview is visible'));
    await htExpect(tester, find.text('DEBT PAID'), findsOneWidget,
        reason: ('Verify-' + context + '- Text DEBT PAID is visible'));
    await tester.pumpAndSettle();
  }

  Future<void> verifyGoalsPage(WidgetTester tester,
      {String context = ''}) async {
    await tester.pumpAndSettle(const Duration(seconds: 15));
    await htExpect(tester, find.text('Archived Goals'), findsOneWidget,
        reason: ('Verify-' + context + '- Text Archived Goals is visible'));
    await htExpect(tester, find.text('Add a Goal'), findsOneWidget,
        reason: ('Verify-' + context + '- Text Add a Goal is visible'));
    await tester.pumpAndSettle();
  }

  Future<void> verifyTaxPage(WidgetTester tester, {String context = ''}) async {
    await tester.pumpAndSettle(const Duration(seconds: 15));
    final finder = find.byType(Title).last;
    final titleWidget = tester.firstWidget<Title>(finder);
    expect(titleWidget.title, 'Calculate your taxes');
    await tester.pumpAndSettle();
  }

  Future<void> verifyInvestmentsPage(WidgetTester tester,
      {String context = ''}) async {
    await tester.pumpAndSettle(const Duration(seconds: 10));
    final finder = find.byType(Title).last;
    final titleWidget = tester.firstWidget<Title>(finder);
    expect(titleWidget.title, 'Investments');
    await htExpect(tester, titleWidget.title, 'Investments',
        reason: ('Verify-' + context + '- Investments title page is visible'));
    await tester.pumpAndSettle();
  }

  Future<void> verifyPeerScorePage(WidgetTester tester,
      {String context = ''}) async {
    await tester.pumpAndSettle(const Duration(seconds: 2));
    await htExpect(tester, find.text('Your Peer Score???'), findsOneWidget,
        reason: ('Verify-' + context + 'Your Peer Score??? Title is visible'));
    await htExpect(
        tester,
        find.text(
            'Peer Score??? is a composite score designed to measure your overall financial situation. It is calculated by mapping your current resources and income generating ability against your obligations and spending habits in the context of your peer group to produce a relative score of your finances'),
        findsOneWidget,
        reason:
            ('Verify-' + context + 'Your Peer Score??? description is visible'));
    await tester.pumpAndSettle();
  }

  Future<void> clickRetirementTab(WidgetTester tester,
      {String context = ''}) async {
    await tester.pumpAndSettle(const Duration(seconds: 20));
    final retirementtTab = find.text('Retirement');
    await tapSomething(
        tester, retirementtTab, addContext(context, 'Click on Retirement Tab'));
    await tester.pumpAndSettle(const Duration(seconds: 2));
  }

  Future<void> verifyRetirementPage(WidgetTester tester,
      {String context = ''}) async {
    await tester.pumpAndSettle(const Duration(seconds: 15));
    await htExpect(
        tester,
        find.text(
            "Here, you can link or manually add and keep track of your retirement assets of all types. It's important to separate your traditional and Roth assets as it would have important tax considerations."),
        findsOneWidget,
        reason: ('Verify-' + context + '- Text on Retirement page is visible'));
    await tester.pumpAndSettle();
  }

  Future<void> clickPersonalTab(WidgetTester tester,
      {String context = ''}) async {
    await tester.pumpAndSettle(const Duration(seconds: 2));
    final btnName = find.text(btnPersonal).first;
    await tapSomething(
        tester, btnName, addContext(context, 'Click on btn Personal Budget'));
    await tester.pumpAndSettle();
  }

  Future<void> clickBusinessTab(WidgetTester tester,
      {String context = ''}) async {
    await tester.pumpAndSettle(const Duration(seconds: 10));
    final btnName = find.text(btnBusiness).first;
    await tapSomething(
        tester, btnName, addContext(context, 'Click on btn Business Budget'));
    await tester.pumpAndSettle();
  }

  Future<void> clickBudgetTab(String str, WidgetTester tester,
      {String context = ''}) async {
    await tester.pumpAndSettle(const Duration(seconds: 2));
    final btnBackIcon = find.text(str);
    await tapSomething(
        tester, btnBackIcon, addContext(context, 'Click on ' + str + ' tab'));
    await tester.pumpAndSettle();
  }

  Future<void> clickDifferenceTab(WidgetTester tester,
      {String context = ''}) async {
    await tester.pumpAndSettle(const Duration(seconds: 2));
    final btnBackIcon =
        find.widgetWithText(CustomMaterialInkWell, btnDifference);
    ;
    await tapSomething(tester, btnBackIcon,
        addContext(context, 'Click on ' + btnDifference + ' tab'));
    await tester.pumpAndSettle();
  }

  Future<void> clickSideMenu(String menuName, WidgetTester tester,
      {String context = ''}) async {
    await tester.pumpAndSettle(const Duration(seconds: 2));
    final btnSideMenu = find.widgetWithText(SideMenuButtonItem, menuName);
    await tapSomething(
        tester, btnSideMenu, addContext(context, 'Click on $menuName Menu'));
    await tester.pumpAndSettle();
  }

  Future<void> verifyShowActualPage(String str, WidgetTester tester,
      {String context = ''}) async {
    await verifyPlannedActualTabSelector(btnActual, true, tester);
    await verifyPlannedActualTabSelector(btnPlanned, false, tester);
    await verifyPlannedActualTabSelector(btnDifference, false, tester);
    await htExpect(tester, find.text(str), findsOneWidget,
        reason: ('Verify-' + context + str + ' page is visible'));
  }

  Future<void> verifyShowDifferencePage(String str, WidgetTester tester,
      {String context = ''}) async {
    await verifyPlannedActualTabSelector(btnActual, false, tester);
    await verifyPlannedActualTabSelector(btnPlanned, false, tester);
    await verifyPlannedActualTabSelector(btnDifference, true, tester);
    await htExpect(tester, find.text(str), findsOneWidget,
        reason: ('Verify-' + context + str + ' page is visible'));
  }

  Future<void> verifyShowPlannedPage(String str, WidgetTester tester,
      {String context = ''}) async {
    await verifyPlannedActualTabSelector(btnActual, false, tester);
    await verifyPlannedActualTabSelector(btnPlanned, true, tester);
    await verifyPlannedActualTabSelector(btnDifference, false, tester);
    await htExpect(tester, find.text(str), findsOneWidget,
        reason: ('Verify-' + context + str + ' page is visible'));
  }

//CategoryArrowIcon 11
  Future<void> clickCategoryArrowIcon(WidgetTester tester,
      {String context = ''}) async {
    await tester.pumpAndSettle();
    final imageIcon = find.byType(ImageIcon).at(11);
    await tapSomething(tester, imageIcon,
        addContext(context, 'Click on Category Arrow Down Icon'));
    await tester.pumpAndSettle(const Duration(seconds: 2));
  }

  Future<void> verifyExpandCategories(WidgetTester tester,
      {String context = ''}) async {
    await tester.pumpAndSettle(const Duration(seconds: 10));
    await htExpect(tester, find.text('Salary Paycheck'), findsOneWidget,
        reason: ('Verify-' + context + 'Salary Paycheck text is visible'));
    await htExpect(tester, find.text('Mortgage'), findsOneWidget,
        reason: ('Verify-' + context + 'Mortgage text is visible'));
    await htExpect(tester, find.text('Credit Cards'), findsOneWidget,
        reason: ('Verify-' + context + 'Credit Cards text is visible'));
    await tester.pumpAndSettle(const Duration(seconds: 2));
  }

  Future<void> verifyCollapseCategories(WidgetTester tester,
      {String context = ''}) async {
    await tester.pumpAndSettle(const Duration(seconds: 5));
    await htExpect(tester, find.text('Salary Paycheck'), findsNothing,
        reason: ('Verify-' + context + 'Salary Paycheck text is NOT visible'));
    await htExpect(tester, find.text('Mortgage'), findsNothing,
        reason: ('Verify-' + context + 'Mortgage text is NOT visible'));
    await htExpect(tester, find.text('Credit Cards'), findsNothing,
        reason: ('Verify-' + context + 'Credit Cards text is NOT visible'));
    await tester.pumpAndSettle(const Duration(seconds: 2));
  }

  Future<void> verifyShowPersonalDefautPageAfterSignIn(WidgetTester tester,
      {String context = ''}) async {
    await tester.pumpAndSettle(const Duration(seconds: 5));
    await verifyAnnualMonthlyTabSelector(btnAnnual, true, tester);
    await verifyAnnualMonthlyTabSelector(btnMonthly, false, tester);
    await verifyPlannedActualTabSelector(btnPlanned, false, tester);
    await verifyPlannedActualTabSelector(btnActual, true, tester);
    await verifyPlannedActualTabSelector(btnDifference, false, tester);
    await tester.pumpAndSettle();
  }

  Future<void> verifyPlannedActualTabSelector(
      String strTab, bool isSelected, WidgetTester tester,
      {String context = ''}) async {
    await tester.pumpAndSettle(const Duration(seconds: 5));

    final inkWellFinder =
        find.widgetWithText(CustomMaterialInkWell, strTab).first;
    CustomMaterialInkWell inkWell = tester.widget(inkWellFinder);

    if (isSelected == true) {
      await htExpect(tester, inkWell.type, InkWellType.Purple,
          reason: ('Verify-' + context + strTab + ' tab is selected'));
    } else {
      await htExpect(tester, inkWell.type, InkWellType.White,
          reason: ('Verify-' + context + strTab + ' tab is NOT selected'));
    }
    await tester.pumpAndSettle();
  }

  Future<void> verifyAnnualMonthlyTabSelector(
      String strTab, bool isSelected, WidgetTester tester,
      {String context = ''}) async {
    await tester.pumpAndSettle(const Duration(seconds: 5));
    final inkWellFinder = find.widgetWithText(TabSelectorButton, strTab).first;
    TabSelectorButton inkWell = tester.widget(inkWellFinder);

    if (isSelected == true) {
      await htExpect(tester, inkWell.isSelected, true,
          reason: ('Verify-' + context + strTab + ' btn is selected'));
    } else {
      await htExpect(tester, inkWell.isSelected, false,
          reason: ('Verify-' + context + strTab + ' btn is NOT selected'));
    }
    await tester.pumpAndSettle();
  }

  Future<void> verifyHideBusinessCategories(WidgetTester tester,
      {String context = ''}) async {
    await tester.pumpAndSettle(const Duration(seconds: 5));
    await htExpect(tester, find.text('Business income'), findsNothing,
        reason: ('Verify-' + context + 'Business income text is NOT visible'));
    await htExpect(tester, find.text('Other Income'), findsNothing,
        reason: ('Verify-' + context + 'Other Income text is NOT visible'));
    await htExpect(tester, find.text('Owner pay'), findsNothing,
        reason: ('Verify-' + context + 'Owner pay text is NOT visible'));
    await htExpect(tester, find.text('Financial planning'), findsNothing,
        reason:
            ('Verify-' + context + 'Financial planning text is NOT visible'));
    await tester.pumpAndSettle(const Duration(seconds: 2));
  }

  Future<void> verifyShowBusinessCategories(WidgetTester tester,
      {String context = ''}) async {
    await tester.pumpAndSettle(const Duration(seconds: 5));
    await htExpect(tester, find.text('Business income'), findsOneWidget,
        reason: ('Verify-' + context + 'Business income text is visible'));
    await htExpect(tester, find.text('Other Income'), findsOneWidget,
        reason: ('Verify-' + context + 'Other Income text is visible'));
    await htExpect(tester, find.text('Owner pay'), findsOneWidget,
        reason: ('Verify-' + context + 'Owner pay text is visible'));
    await htExpect(tester, find.text('Financial planning'), findsOneWidget,
        reason: ('Verify-' + context + 'Financial planning text is visible'));
    await tester.pumpAndSettle(const Duration(seconds: 2));
  }

  Future<void> clickRightArrowBtn(WidgetTester tester,
      {String context = ''}) async {
    await tester.pumpAndSettle(const Duration(seconds: 2));
    final assetImage = AssetImage('assets/images/icons/right.png');
    final imageIconFinder = find.byWidgetPredicate((widget) {
      if (widget is ImageIcon) {
        if (widget.image is AssetImage && widget.image == assetImage) {
          return true;
        }
      }
      return false;
    });
    await tapSomething(tester, imageIconFinder,
        addContext(context, 'Click on btn Right Arrow'));
    await tester.pumpAndSettle();
  }

  Future<void> clickLeftArrowBtn(WidgetTester tester,
      {String context = ''}) async {
    await tester.pumpAndSettle(const Duration(seconds: 2));
    final assetImage = AssetImage('assets/images/icons/left.png');
    final imageIconFinder = find.byWidgetPredicate((widget) {
      if (widget is ImageIcon) {
        if (widget.image is AssetImage && widget.image == assetImage) {
          return true;
        }
      }
      return false;
    });
    await tapSomething(tester, imageIconFinder,
        addContext(context, 'Click on btn Right Arrow'));
    await tester.pumpAndSettle();
  }

  Future<void> verifyYearOnBudgetAnnual(String year, WidgetTester tester,
      {String context = ''}) async {
    await tester.pumpAndSettle(const Duration(seconds: 2));
    final periodSelectorFinder = find.byType(PeriodSelector);

    final periodSelectorWidget =
        tester.widget<PeriodSelector>(periodSelectorFinder);

    final labelTexts = periodSelectorWidget.labelTexts;

    // final currentDate = DateTime.now();
    final currentYear = '${getCurrentYear()}';
    final previousYear = '${getPreviousYear()}';
    final nextYear = '${getNextYear()}';

    switch (year) {
      case 'currentYear':
        final currentYearIndex = labelTexts.indexOf(currentYear);
        final yearFinder = find.text(labelTexts[currentYearIndex]);
        await htExpect(tester, yearFinder, findsOneWidget,
            reason: ('Verify-' + context + '$yearFinder text is visible'));
        break;
      case 'previousYear':
        final previousYearIndex = labelTexts.indexOf(previousYear);
        final yearFinder = find.text(labelTexts[previousYearIndex]);
        await htExpect(tester, yearFinder, findsOneWidget,
            reason: ('Verify-' + context + '$yearFinder text is visible'));
        break;
      case 'nextYear':
        final nextYearIndex = labelTexts.indexOf(nextYear);
        final yearFinder = find.text(labelTexts[nextYearIndex]);
        await htExpect(tester, yearFinder, findsOneWidget,
            reason: ('Verify-' + context + '$yearFinder text is visible'));
        break;
    }

    await tester.pumpAndSettle();
  }

  Future<void> verifyYearOnBudgetMonthly(String year, WidgetTester tester,
      {String context = ''}) async {
    await tester.pumpAndSettle(const Duration(seconds: 2));
    final now = DateTime.now();

    final periodSelectorFinder = find.byType(PeriodSelector);

    final periodSelectorWidget =
        tester.widget<PeriodSelector>(periodSelectorFinder);

    final labelTexts = periodSelectorWidget.labelTexts;

    // final currentDate = DateTime.now();
    final currentMonthYear = '${getCurentMonthYear(now)}';
    final previousMonthYear = '${getPreviousMonthYear(now)}';
    final nextMonthYear = '${getNextMonthYear(now)}';

    switch (year) {
      case 'currentYear':
        final currentYearIndex = labelTexts.indexOf(currentMonthYear);
        final yearFinder = find.text(labelTexts[currentYearIndex]);
        await htExpect(tester, yearFinder, findsOneWidget,
            reason: ('Verify-' + context + '$yearFinder text is visible'));
        break;
      case 'previousYear':
        final previousYearIndex = labelTexts.indexOf(previousMonthYear);
        final yearFinder = find.text(labelTexts[previousYearIndex]);
        await htExpect(tester, yearFinder, findsOneWidget,
            reason: ('Verify-' + context + '$yearFinder text is visible'));
        break;
      case 'nextYear':
        final nextYearIndex = labelTexts.indexOf(nextMonthYear);
        final yearFinder = find.text(labelTexts[nextYearIndex]);
        await htExpect(tester, yearFinder, findsOneWidget,
            reason: ('Verify-' + context + '$yearFinder text is visible'));
        break;
    }

    await tester.pumpAndSettle();
  }

  //-----------------
  Future<void> clickCategoryList(String categoryName, WidgetTester tester,
      {String context = ''}) async {
    await tester.pumpAndSettle(const Duration(seconds: 5));
    final categoryFinder = find.descendant(
      of: find.byType(TogglingCell),
      matching: find.text(categoryName),
    );

    await tapSomething(tester, categoryFinder,
        addContext(context, 'Click on btn $categoryName'));
    await tester.pumpAndSettle();
  }

  Future<void> inputValuePlannedCell(
      String rowName, int indexCell, String value, WidgetTester tester,
      {String context = ''}) async {
    await tester.pumpAndSettle(const Duration(seconds: 10));
    final rowFinder = find.descendant(
      of: find.byType(TableBodyCell),
      matching: find.text(rowName),
    );
    await tester.pumpAndSettle(const Duration(seconds: 5));
    // print('final rowFinder :$rowFinder');

    final sizedBoxFinder = find.ancestor(
      of: rowFinder,
      matching: find.byType(SizedBox),
    );
    await tester.pumpAndSettle(const Duration(seconds: 5));
    // print('final sizedBoxFinder: $sizedBoxFinder');

    final textFormFieldFinder = find.descendant(
      of: sizedBoxFinder,
      matching: find.byType(TextFormField),
    );

    final textFormFields =
        tester.widgetList(textFormFieldFinder).cast<TextFormField>();
    final count = textFormFields.length;

    print('Number of TextFormFields in SizedBox: $count');

    await tester.tap(textFormFieldFinder.at(indexCell));
    await tester.pump(const Duration(seconds: 5));
    if (value != '') {
      await tester.enterText(textFormFieldFinder.at(indexCell), '');
      await tester.pump(const Duration(seconds: 5));
      await tester.tap(textFormFieldFinder.at(indexCell));
      await tester.enterText(textFormFieldFinder.at(indexCell), value);
      await tester.pumpAndSettle(const Duration(seconds: 15));
    }
    // await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    // print('final input input 11111111');

    await tester.pumpAndSettle(const Duration(seconds: 5));
  }

  Future<void> getValueCell(
      String rowName, int indexCell, String value, WidgetTester tester,
      {String context = ''}) async {
    await tester.pumpAndSettle(const Duration(seconds: 10));
    final rowFinder = find.descendant(
      of: find.byType(TableBodyCell),
      matching: find.text(rowName),
    );
    await tester.pumpAndSettle(const Duration(seconds: 5));
    print('final rowFinder :$rowFinder');

    final sizedBoxFinder = find.ancestor(
      of: rowFinder,
      matching: find.byType(SizedBox),
    );
    await tester.pumpAndSettle(const Duration(seconds: 5));
    print('final sizedBoxFinder: $sizedBoxFinder');

    final textFormFieldFinder = find.descendant(
      of: sizedBoxFinder,
      matching: find.byType(TextFormField),
    );

    final textFormFields =
        tester.widgetList(textFormFieldFinder).cast<TextFormField>();
    final count = textFormFields.length;

    print('Number of TextFormFields in SizedBox: $count');

// Get the value of the TextFormField widget
    final formFieldState = tester.state(textFormFieldFinder.at(indexCell))
        as FormFieldState<String>;
    final textFormFieldValue = formFieldState.value;

    // Verify that the TextFormField widget has the correct value
    // expect(textFormFieldValue, 'Hello, World!');

//------End get value----------------------
    print('End get value-------------------------: $textFormFieldValue');

    // expect(textFormFieldValue, '6');
    await htExpect(tester, textFormFieldValue, value,
        reason: ('Verify-' +
            context +
            'value $textFormFieldValue in cell is visible'));
    print('Complete-------------------------------------');

    await tester.pumpAndSettle(const Duration(seconds: 5));
  }
}
