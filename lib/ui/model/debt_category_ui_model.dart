import 'package:burgundy_budgeting_app/ui/model/debt_account.dart';
import 'package:burgundy_budgeting_app/ui/model/debt_category.dart';
import 'package:burgundy_budgeting_app/utils/get_stats_color.dart';
import 'package:flutter/material.dart';

class DebtCategoryUiModel with GetStatsColor {
  String categoryName;

  List<DebtAccount> debtAccounts;

  final int number;
  final String id;
  late final int total;
  late final int interest;
  late final int debtPaid;

  late final Color color;
  late final int sum;

  DebtCategoryUiModel({
    required this.categoryName,
    required this.debtAccounts,
    required this.number,
    required this.id,
  }) {
    var sumBuff = 0;
    var totalBuff = 0;
    var interestBuff = 0;
    var debtPaidBuff = 0;

    debtAccounts.forEach((account) {
      account.nodes.forEach((node) {
        totalBuff += node.totalAmount;
        interestBuff += node.interestAmount;
        sumBuff += node.totalAmount;
        debtPaidBuff += node.debtAmount;
      });
    });

    sum = sumBuff;
    total = totalBuff;
    interest = interestBuff;
    debtPaid = debtPaidBuff;
    color = mapDebtCategoryColor(id);
  }

  factory DebtCategoryUiModel.fromDebtCategory(
    DebtCategory debtCategory, {
    required int number,
  }) =>
      DebtCategoryUiModel(
        id: debtCategory.categoryId,
        categoryName: debtCategory.categoryName,
        debtAccounts: debtCategory.debtAccounts,
        number: number,
      );

  Map<String, dynamic> toJson() {
    return {
      'categoryName': categoryName,
      'debtAccounts': debtAccounts,
      'sum': sum,
      'number': number,
      'color': color,
    };
  }
}
