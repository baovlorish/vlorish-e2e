import 'package:burgundy_budgeting_app/ui/atomic/atom/theme.dart';
import 'package:burgundy_budgeting_app/ui/model/budget_model.dart';
import 'package:flutter/material.dart';

class TableRowDecorationModel {
  final Color rowBackgroundColor;
  final Color mainTextColor;

  // if values in cells have alternative text color, e.g. negative and positive in budget table footers
  final Color? alternativeTextColor;

  /// if this row is toggling and has children
  final Color? childrenBackgroundColor;

  /// only used in budget annual table
  final Color? yearBackgroundColor;

  /// only used in budget annual table
  final Color? percentTextColor;
  final bool isBold;
  final bool? withCheckBox;
  final bool? hasBottomBorder;
  final String? iconUrl;

  final Color? yearChildRowBackgroundColor;

  TableRowDecorationModel({
    required this.rowBackgroundColor,
    required this.mainTextColor,
    this.alternativeTextColor,
    this.childrenBackgroundColor,
    this.yearBackgroundColor,
    this.percentTextColor,
    required this.isBold,
    this.withCheckBox,
    this.hasBottomBorder,
    this.iconUrl,
    this.yearChildRowBackgroundColor,
  });

  factory TableRowDecorationModel.totalExpenses(bool isPersonal) {
    return TableRowDecorationModel(
      rowBackgroundColor: CustomColorScheme.tableCellGeneralBackground,
      mainTextColor: isPersonal
          ? CustomColorScheme.negativeTransaction
          : CustomColorScheme.tableExpensesBusinessText,
      isBold: true,
      iconUrl: 'assets/images/icons/categories_total_expenses.png',
      yearBackgroundColor: isPersonal
          ? CustomColorScheme.tableExpenseBackground
          : CustomColorScheme.tableExpensesBusinessBackground,
      percentTextColor: CustomColorScheme.tableOtherText,
    );
  }

  factory TableRowDecorationModel.netIncome(bool isPersonal,
      {String? iconUrl}) {
    return TableRowDecorationModel(
      rowBackgroundColor: CustomColorScheme.tableCellGeneralBackground,
      mainTextColor: isPersonal
          ? CustomColorScheme.tablePositivePersonal
          : CustomColorScheme.tablePositiveBusiness,
      alternativeTextColor: isPersonal
          ? CustomColorScheme.negativeTransaction
          : CustomColorScheme.tableExpensesBusinessText,
      isBold: true,
      iconUrl: iconUrl ?? 'assets/images/icons/categories_total_income.png',
      yearBackgroundColor: isPersonal
          ? CustomColorScheme.tableIncomeBackground
          : CustomColorScheme.tableIncomeBusinessBackground,
      percentTextColor: CustomColorScheme.tableOtherText,
    );
  }

  factory TableRowDecorationModel.freeCash(bool isPersonal) {
    return TableRowDecorationModel(
      rowBackgroundColor: isPersonal
          ? CustomColorScheme.tableFreeCashBackground
          : CustomColorScheme.tableCellGeneralBackground,
      mainTextColor: isPersonal
          ? CustomColorScheme.tablePositivePersonal
          : CustomColorScheme.tablePositiveBusiness,
      alternativeTextColor: isPersonal
          ? CustomColorScheme.negativeTransaction
          : CustomColorScheme.tableExpensesBusinessText,
      isBold: true,
      iconUrl: isPersonal
          ? 'assets/images/icons/categories_free_cash.png'
          : 'assets/images/icons/retained_in_the_business.png',
      yearBackgroundColor: isPersonal
          ? CustomColorScheme.tableIncomeBackground
          : CustomColorScheme.tableIncomeBusinessBackground,
      percentTextColor: CustomColorScheme.tableOtherText,
    );
  }

  factory TableRowDecorationModel.budgetGroup(bool isPersonal, CategoryGroupType type) {
    var isOwnerDraw =
        (type == CategoryGroupType.ExpenseSeparated && !isPersonal);
    return TableRowDecorationModel(
      rowBackgroundColor: type == CategoryGroupType.Income
          ? isPersonal
              ? CustomColorScheme.tableIncomeBackground
              : CustomColorScheme.tableIncomeBusinessBackground
          : type == CategoryGroupType.ExpenseGeneral
              ? isPersonal
                  ? CustomColorScheme.tableExpenseBackground
                  : CustomColorScheme.tableExpensesBusinessBackground
              : isOwnerDraw
                  ? Color.fromRGBO(251, 248, 249, 1)
                  : CustomColorScheme.tableLightBlue,
      childrenBackgroundColor:
          isOwnerDraw ? null : CustomColorScheme.tableCellGeneralBackground,
      mainTextColor: isOwnerDraw
          ? CustomColorScheme.tableExpensesBusinessText
          : CustomColorScheme.text,
      isBold: isOwnerDraw,
      yearBackgroundColor: type == CategoryGroupType.Income
          ? isPersonal
              ? CustomColorScheme.tableIncomeDarkBackground
              : Color.fromRGBO(201, 234, 235, 1)
          : type == CategoryGroupType.ExpenseGeneral
              ? isPersonal
                  ? CustomColorScheme.tableExpenseDarkBackground
                  : Color.fromRGBO(247, 211, 205, 1)
              : CustomColorScheme.tableBlue,
      percentTextColor: CustomColorScheme.tableOtherText,
      yearChildRowBackgroundColor: isOwnerDraw
          ? CustomColorScheme.tableExpensesBusinessBackground
          : CustomColorScheme.tableExpensesTotalBackground,
    );
  }
}
