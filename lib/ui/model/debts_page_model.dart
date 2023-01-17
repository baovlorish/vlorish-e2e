import 'package:burgundy_budgeting_app/ui/model/debt_account.dart';
import 'package:burgundy_budgeting_app/ui/model/debt_node.dart';
import 'package:burgundy_budgeting_app/ui/model/period.dart';

import 'debt_category.dart';

class DebtsPageModel {
  List<DebtCategory> personalCategories;
  List<DebtCategory> businessCategories;
  Period period;

  DebtsPageModel({
    required this.personalCategories,
    required this.businessCategories,
    required this.period,
  });

  factory DebtsPageModel.fromJson(Map<String, dynamic> json, Period period) {
    var personalCategories = <DebtCategory>[];
    var businessCategories = <DebtCategory>[];
    if (json['personalCategories'] != null) {
      json['personalCategories'].forEach((v) {
        personalCategories.add(DebtCategory.fromJson(v, period, true));
      });
    }
    if (json['businessCategories'] != null) {
      json['businessCategories'].forEach((v) {
        businessCategories.add(DebtCategory.fromJson(v, period, false));
      });
    }

    return DebtsPageModel(
        businessCategories: businessCategories,
        personalCategories: personalCategories,
        period: period);
  }

  List<DebtCategory> get allCategories =>
      personalCategories + businessCategories;

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['personalCategories'] =
        personalCategories.map((v) => v.toJson()).toList();

    map['businessCategories'] =
        businessCategories.map((v) => v.toJson()).toList();

    return map;
  }

  DebtsPageModel copyWithNodeOrAccountName({
    String? accountId,
    DateTime? monthYear,
    required bool isPersonal,
    String? name,
    int? totalAmount,
    int? interestAmount,
  }) {
    var newPersonalCategories = <DebtCategory>[];
    var newBusinessCategories = <DebtCategory>[];

    if (isPersonal) {
      newBusinessCategories = businessCategories;
    } else {
      newPersonalCategories = personalCategories;
    }

    for (var category in isPersonal ? personalCategories : businessCategories) {
      var accounts = <DebtAccount>[];
      for (var account in category.debtAccounts) {
        if (account.id == accountId) {
          var nodes = <DebtNode>[];
          for (var node in account.nodes) {
            if (monthYear != null && node.monthYear == monthYear) {
              nodes.add(DebtNode(
                interestAmount: interestAmount ?? node.interestAmount,
                totalAmount: totalAmount ?? node.totalAmount,
                debtAmount: account.isManual
                    ? ((totalAmount ?? node.totalAmount) -
                        (interestAmount ?? node.interestAmount))
                    : node.debtAmount,
                monthYear: monthYear,
                isManual: node.isEditable,
              ));
            } else {
              nodes.add(node);
            }
          }
          accounts.add(
            DebtAccount(
                nodes: nodes,
                isManual: account.isManual,
                name: name ?? account.name,
                id: account.id),
          );
        } else {
          accounts.add(
            DebtAccount(
                nodes: account.nodes,
                isManual: account.isManual,
                name: account.name,
                id: account.id),
          );
        }
      }
      if (isPersonal) {
        newPersonalCategories.add(DebtCategory(
          categoryName: category.categoryName,
          categoryId: category.categoryId,
          isPersonal: category.isPersonal,
          debtAccounts: accounts,
        ));
      } else {
        newBusinessCategories.add(DebtCategory(
          categoryName: category.categoryName,
          categoryId: category.categoryId,
          isPersonal: category.isPersonal,
          debtAccounts: accounts,
        ));
      }
    }

    return DebtsPageModel(
        personalCategories: newPersonalCategories,
        businessCategories: newBusinessCategories,
        period: period);
  }

  List<int> totalDebtsSums(bool isPersonal) {
    var categories = isPersonal ? personalCategories : businessCategories;
    var sums = <int>[];
    var length = categories.first.monthlySumsTotal.length;

    for (var index = 0; index < length; index++) {
      var sum = 0;
      for (var category in categories) {
        sum += category.monthlySumsTotal[index];
      }
      sums.add(sum);
    }
    return sums;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DebtsPageModel &&
          runtimeType == other.runtimeType &&
          personalCategories == other.personalCategories &&
          businessCategories == other.businessCategories &&
          period == other.period;

  @override
  int get hashCode =>
      personalCategories.hashCode ^
      businessCategories.hashCode ^
      period.hashCode;
}
