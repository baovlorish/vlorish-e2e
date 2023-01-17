import 'package:burgundy_budgeting_app/ui/model/debt_category_ui_model.dart';
import 'package:flutter/material.dart';
import 'goal.dart';
import 'merchant.dart';

class StatisticModel with Comparable {
  final double amount;
  final double totalAmount;
  final String name;
  final Color color;
  final int progress;
  final String? hint;

  StatisticModel({
    required this.amount,
    required this.name,
    required this.color,
    required this.totalAmount,
    required this.progress,
    this.hint,
  });

  factory StatisticModel.fromGoal(Goal goal) {
    return StatisticModel(
      amount: goal.totalFunded.toDouble(),
      name: goal.goalName,
      color: goal.color,
      totalAmount: goal.target.toDouble(),
      progress: goal.progress,
    );
  }

  factory StatisticModel.fromMerchant(Merchant merchant) {
    return StatisticModel(
      amount: merchant.sum,
      name: merchant.name,
      color: merchant.color,
      totalAmount: merchant.sumOfAllTransactions,
      progress: merchant.progress,
    );
  }

  factory StatisticModel.fromDebtCategory(
      DebtCategoryUiModel debtCategory, double totalAmount) {
    var name = debtCategory.categoryName;

    return StatisticModel(
      amount: debtCategory.sum.toDouble(),
      name: name,
      color: debtCategory.color,
      totalAmount: totalAmount,
      progress: totalAmount == 0 ? 0 : (debtCategory.sum * 100) ~/ totalAmount,
    );
  }

  @override
  int compareTo(other) {
    if (progress > other.progress) return -1;
    if (progress < other.progress) return 1;
    return 0;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StatisticModel &&
          runtimeType == other.runtimeType &&
          amount == other.amount &&
          totalAmount == other.totalAmount &&
          name == other.name &&
          color == other.color &&
          progress == other.progress;

  @override
  int get hashCode =>
      amount.hashCode ^
      totalAmount.hashCode ^
      name.hashCode ^
      color.hashCode ^
      progress.hashCode;
}
