import 'package:burgundy_budgeting_app/ui/model/period.dart';

import 'debt_account.dart';

class DebtCategory {
  final String categoryName;
  final String categoryId;
  final List<DebtAccount> debtAccounts;
  final bool isPersonal;

  DebtCategory({
    required this.categoryName,
    required this.categoryId,
    required this.debtAccounts,
    required this.isPersonal,
  });

  factory DebtCategory.fromJson(dynamic json, Period period, bool isPersonal) {
    var debtAccounts = <DebtAccount>[];
    if (json['debtAccounts'] != null) {
      json['debtAccounts'].forEach((v) {
        debtAccounts.add(DebtAccount.fromJson(v, period));
      });
    }

    return DebtCategory(
      categoryName: json['categoryName'],
      categoryId: json['categoryId'],
      debtAccounts: debtAccounts,
      isPersonal: isPersonal,
    );
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['categoryName'] = categoryName;
    map['categoryId'] = categoryId;
    map['debtAccounts'] = debtAccounts.map((v) => v.toJson()).toList();
    return map;
  }

  List<int> get monthlySumsTotal {
    var monthlySums = <int>[];
    var monthCount = 0;
    if (debtAccounts.isNotEmpty) {
      monthCount = debtAccounts.first.nodes.length;
    }

    for (var monthIndex = 0; monthIndex < monthCount; monthIndex++) {
      var sum = 0;
      for (var account in debtAccounts) {
        sum += account.nodes[monthIndex].totalAmount;
      }
      monthlySums.add(sum);
    }
    return monthlySums;
  }

  List<int> get monthlySumsInterest {
    var monthlySums = <int>[];
    var monthCount = 0;
    if (debtAccounts.isNotEmpty) {
      monthCount = debtAccounts.first.nodes.length;
    }

    for (var monthIndex = 0; monthIndex < monthCount; monthIndex++) {
      var sum = 0;
      for (var account in debtAccounts) {
        sum += account.nodes[monthIndex].interestAmount;
      }
      monthlySums.add(sum);
    }
    return monthlySums;
  }

  List<int> get monthlySumsDebt {
    var monthlySums = <int>[];
    var monthCount = 0;
    if (debtAccounts.isNotEmpty) {
      monthCount = debtAccounts.first.nodes.length;
    }

    for (var monthIndex = 0; monthIndex < monthCount; monthIndex++) {
      var sum = 0;
      for (var account in debtAccounts) {
        sum += account.nodes[monthIndex].debtAmount;
      }
      monthlySums.add(sum);
    }
    return monthlySums;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DebtCategory &&
          runtimeType == other.runtimeType &&
          categoryName == other.categoryName &&
          categoryId == other.categoryId &&
          isPersonal == other.isPersonal;

  @override
  int get hashCode =>
      categoryName.hashCode ^ categoryId.hashCode ^ isPersonal.hashCode;
}
