import 'package:burgundy_budgeting_app/ui/atomic/atom/theme.dart';
import 'package:burgundy_budgeting_app/ui/atomic/organizm/spline_chart_widget.dart';
import 'package:burgundy_budgeting_app/ui/model/net_worth_category.dart';
import 'package:burgundy_budgeting_app/ui/model/net_worth_node.dart';
import 'package:burgundy_budgeting_app/ui/model/period.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NetWorthModel {
  final List<NetWorthCategory> personalDebts;
  final List<NetWorthCategory> businessAssets;
  final List<NetWorthCategory> personalAssets;
  final List<NetWorthCategory> businessDebts;
  final Period period;

  List<NetWorthCategory> get allCategories =>
      personalAssets + businessAssets + personalDebts + businessDebts;

  List<NetWorthCategory> get assetsCategories =>
      personalAssets + businessAssets;

  List<NetWorthCategory> get debtsCategories => personalDebts + businessDebts;

  int get totalAssets {
    var totalAssets = 0;
    assetsCategories.forEach((category) {
      var node = category.nodes
          .firstWhere((node) => DateTime.now().month == node.monthYear.month);
      totalAssets += node.amount;
    });
    return totalAssets;
  }

  int get totalDebts {
    var totalDebts = 0;
    debtsCategories.forEach((category) {
      var node = category.nodes
          .firstWhere((node) => DateTime.now().month == node.monthYear.month);
      totalDebts += node.amount;
    });
    return totalDebts;
  }

  const NetWorthModel(
      {required this.personalDebts,
      required this.businessAssets,
      required this.personalAssets,
      required this.businessDebts,
      required this.period});

  NetWorthModel copyWithNodeOrAccountName(
      {String? accountId,
      name,
      int? amount,
      DateTime? monthYear,
      required bool isPersonal,
      required bool isAssets}) {
    var categories = <NetWorthCategory>[];
    for (var category in isPersonal
        ? isAssets
            ? personalAssets
            : personalDebts
        : isAssets
            ? businessAssets
            : businessDebts) {
      if (category.id == accountId) {
        var nodes = <NetWorthNode>[];
        for (var node in category.nodes) {
          if (monthYear != null && node.monthYear == monthYear) {
            nodes.add(NetWorthNode(
              amount: amount ?? node.amount,
              monthYear: monthYear,
            ));
          } else {
            nodes.add(node);
          }
        }
        categories.add(
          NetWorthCategory(
            nodes: nodes,
            isManual: category.isManual,
            canEdit: category.canEdit,
            name: name ?? category.name,
            id: category.id,
            period: period,
          ),
        );
      } else {
        categories.add(
          category,
        );
      }
    }
    return NetWorthModel(
        personalDebts: isPersonal && !isAssets ? categories : personalDebts,
        businessAssets: !isPersonal && isAssets ? categories : businessAssets,
        personalAssets: isPersonal && isAssets ? categories : personalAssets,
        businessDebts: !isPersonal && !isAssets ? categories : businessDebts,
        period: period);
  }

  factory NetWorthModel.fromJson(Map<String, dynamic> json, Period period) {
    var personalDebts = <NetWorthCategory>[];
    var businessAssets = <NetWorthCategory>[];
    var personalAssets = <NetWorthCategory>[];
    var businessDebts = <NetWorthCategory>[];

    if (json['personalDebts'] != null) {
      json['personalDebts'].forEach((v) {
        personalDebts.add(NetWorthCategory.fromJson(v, period));
      });
    }
    if (json['businessAssets'] != null) {
      json['businessAssets'].forEach((v) {
        businessAssets.add(NetWorthCategory.fromJson(v, period));
      });
    }
    if (json['personalAssets'] != null) {
      json['personalAssets'].forEach((v) {
        personalAssets.add(NetWorthCategory.fromJson(v, period));
      });
    }
    if (json['businessDebts'] != null) {
      json['businessDebts'].forEach((v) {
        businessDebts.add(NetWorthCategory.fromJson(v, period));
      });
    }

    return NetWorthModel(
      personalDebts: personalDebts,
      businessAssets: businessAssets,
      personalAssets: personalAssets,
      businessDebts: businessDebts,
      period: period,
    );
  }

  SplineChartModel splineChartModel(BuildContext context) {
    var splines = <SplineUiModel>[];

    var assets = <String, int?>{};
    var debts = <String, int?>{};

    var assetData = <SplineChartData>[];
    var debtsData = <SplineChartData>[];
    var netWorthData = <SplineChartData>[];

    period.months.forEach((month) {
      if (month.year == DateTime.now().year &&
          month.month > DateTime.now().month) {
        assets[period.monthString(month.month)] = null;
        debts[period.monthString(month.month)] = null;
      } else {
        assets[period.monthString(month.month)] =
            assetsCategories.monthlySum(period)[period.months.indexOf(month)];

        debts[period.monthString(month.month)] =
            debtsCategories.monthlySum(period)[period.months.indexOf(month)];
      }
    });

    assets.forEach((key, value) {
      assetData.add(
        SplineChartData(key, value),
      );
    });

    debts.forEach((key, value) {
      debtsData.add(
        SplineChartData(key, value),
      );
      if (assets[key] != null && debts[key] != null) {
        netWorthData.add(
          SplineChartData(key, assets[key]! - debts[key]!),
        );
      } else {
        netWorthData.add(
          SplineChartData(key, null),
        );
      }
    });

    splines.addAll([
      SplineUiModel(
        name: AppLocalizations.of(context)!.assets,
        data: assetData,
        color: CustomColorScheme.successPopupButton,
      ),
      SplineUiModel(
        name: AppLocalizations.of(context)!.debts,
        data: debtsData,
        color: CustomColorScheme.inputErrorBorder,
      ),
      SplineUiModel(
        name: AppLocalizations.of(context)!.netWorth,
        data: netWorthData,
        color: CustomColorScheme.button,
      ),
    ]);

    return SplineChartModel(
      period: period,
      splines: splines,
    );
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (personalDebts.isNotEmpty) {
      map['personalDebts'] = personalDebts.map((v) => v.toJson()).toList();
    }
    if (businessAssets.isNotEmpty) {
      map['businessAssets'] = businessAssets.map((v) => v.toJson()).toList();
    }
    if (personalAssets.isNotEmpty) {
      map['personalAssets'] = personalAssets.map((v) => v.toJson()).toList();
    }
    if (businessDebts.isNotEmpty) {
      map['businessDebts'] = businessDebts.map((v) => v.toJson()).toList();
    }
    return map;
  }

  List<int> netWorth(bool isPersonal) {
    var monthlyNetWorth = <int>[];
    var monthCount = period.durationInMonths;

    for (var monthIndex = 0; monthIndex < monthCount; monthIndex++) {
      var sum = 0;
      for (var account in isPersonal ? personalAssets : businessAssets) {
        sum += account.nodes[monthIndex].amount;
      }
      for (var account in isPersonal ? personalDebts : businessDebts) {
        sum -= account.nodes[monthIndex].amount;
      }
      monthlyNetWorth.add(sum);
    }
    return monthlyNetWorth;
  }
}

extension MontlySum on List<NetWorthCategory> {
  List<int> monthlySum(Period period) {
    var monthlySums = <int>[];
    var monthCount = period.durationInMonths;

    for (var monthIndex = 0; monthIndex < monthCount; monthIndex++) {
      var sum = 0;
      for (var account in this) {
        sum += account.nodes[monthIndex].amount;
      }
      monthlySums.add(sum);
    }
    return monthlySums;
  }
}
