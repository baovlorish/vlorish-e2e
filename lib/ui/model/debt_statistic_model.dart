import 'package:burgundy_budgeting_app/ui/model/statistic_model.dart';

class DebtStatisticModel {
  final List<StatisticModel> statisticModels;
  final int totalPayments;
  final int interestPaid;
  final int debtPaid;

  DebtStatisticModel({
    required this.statisticModels,
    required this.totalPayments,
    required this.interestPaid,
    required this.debtPaid,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DebtStatisticModel &&
          runtimeType == other.runtimeType &&
          statisticModels == other.statisticModels &&
          totalPayments == other.totalPayments &&
          interestPaid == other.interestPaid &&
          debtPaid == other.debtPaid;

  @override
  int get hashCode =>
      statisticModels.hashCode ^
      totalPayments.hashCode ^
      interestPaid.hashCode ^
      debtPaid.hashCode;
}
