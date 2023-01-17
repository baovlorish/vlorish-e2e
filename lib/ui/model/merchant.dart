import 'package:burgundy_budgeting_app/ui/model/transaction_model.dart';
import 'package:burgundy_budgeting_app/utils/get_stats_color.dart';
import 'package:flutter/material.dart';

class Merchant with Comparable, GetStatsColor {
  final double sum;
  final double sumOfAllTransactions;
  final String name;
  final int number;

  late final Color color;
  late final int progress;

  Merchant({
    required this.sum,
    required this.name,
    required this.sumOfAllTransactions,
    required this.number,
  }) {
    progress = (sum * 100) ~/ sumOfAllTransactions;

    color = mapColor(number);
  }

  factory Merchant.fromTransactions(
    List<TransactionModel> transactions,
    double sumOfAllTransactions,
    int number,
  ) {
    var sum = 0.0;
    transactions.forEach((tr) {
      sum += tr.amount;
    });

    return Merchant(
      sum: sum,
      name: transactions.first.merchantName,
      sumOfAllTransactions: sumOfAllTransactions,
      number: number,
    );
  }

  @override
  int compareTo(other) {
    if (progress > other.progress) return -1;
    if (progress < other.progress) return 1;
    return 0;
  }
}
