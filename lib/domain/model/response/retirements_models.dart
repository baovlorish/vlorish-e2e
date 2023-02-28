import 'package:burgundy_budgeting_app/domain/model/response/index_funds_response.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/theme.dart';
import 'package:flutter/material.dart';

class RetirementModel {
  final String? id;
  final String? name;
  final double? initialCost;
  final DateTime? acquisitionDate;
  final double? currentCost;
  final String? custodian;
  final List<InvestmentTransaction>? transactions;
  int? retirementType;
  final bool isManual;

  RetirementModel({
    this.id,
    required this.name,
    required this.initialCost,
    required this.acquisitionDate,
    this.currentCost,
    this.custodian,
    this.transactions,
    required this.isManual,
    this.retirementType,
  });

  String get nameString {
    var result;
    switch (retirementType) {
      case 1:
        result = '401a';
        break;
      case 2:
        result = '401k';
        break;
      case 3:
        result = 'Roth401k';
        break;
      case 4:
        result = 'IRA';
        break;
      case 5:
        result = 'RothIra';
        break;
      case 6:
        result = 'Sep';
        break;
      case 7:
        result = '403b';
        break;
      case 8:
        result = '457b';
        break;
      case 9:
        result = 'Rrsp';
        break;
      case 10:
        result = 'TFSA';
        break;
      case 11:
        result = 'Tsp';
        break;
      case 12:
        result = 'Roth457b';
        break;
      default:
        result = 'Other';
    }

    return result;
  }

  factory RetirementModel.fromJson(Map<String, dynamic> json) {
    var transactions = <InvestmentTransaction>[];
    if (json['transactions'] != null) {
      json['transactions'].forEach((element) {
        transactions.add(InvestmentTransaction.fromJson(element));
      });
    }
    return RetirementModel(
      id: json['id'],
      retirementType: json['retirementType'] == 0 ? 13 : json['retirementType'],
      isManual: json['isManual'] ?? false,
      name: json['name'],
      initialCost: json['initialCost'],
      acquisitionDate: DateTime.parse(json['acquisitionDate']),
      currentCost: json['currentCost'],
      custodian: json['details'],
      transactions: transactions,
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['cost'] = initialCost;
    data['acquisitionDate'] = acquisitionDate?.toIso8601String();
    if (currentCost != null) data['currentCost'] = currentCost;
    data['details'] = custodian;
    if (transactions != null) {
      data['transactions'] =
          transactions!.map((transaction) => transaction.toJson()).toList();
    }
    if (retirementType == 13) retirementType = 0;
    data['retirementType'] = retirementType;
    return data;
  }

  Map<String, dynamic> deleteInvestmentByIdToJson(
      {String? sellDate, required bool removeHistory}) {
    final data = <String, dynamic>{};
    data['sellDate'] = sellDate;
    data['removeHistory'] = removeHistory;
    return data;
  }

  @override
  String toString() {
    var transactionList = '';
    transactions?.forEach((element) {
      transactionList += element.toString();
    });
    return 'id: $id, name: $name, initialCost: $initialCost, acquisitionDate: $acquisitionDate,currentCost: $currentCost,transactions: [$transactionList]';
  }
}

class RetirementPageModel {
  List<RetirementModel> models;

  List<Color> get statisticColors => [
        CustomColorScheme.goalColor1,
        CustomColorScheme.goalColor2,
        CustomColorScheme.goalColor3,
        CustomColorScheme.goalColor4,
        CustomColorScheme.goalColor5,
        CustomColorScheme.goalColor6,
        CustomColorScheme.goalColor7,
        CustomColorScheme.goalColor8,
        CustomColorScheme.goalColor1.withOpacity(0.5),
        CustomColorScheme.goalColor2.withOpacity(0.5),
        CustomColorScheme.goalColor3.withOpacity(0.5),
        CustomColorScheme.goalColor4.withOpacity(0.5),
        CustomColorScheme.goalColor5.withOpacity(0.5),
      ];

  RetirementPageModel({
    required this.models,
    this.chosenTabTypes = const [],
    this.chosenBarChartTypes = const [],
    this.chosenPieChartTypes = const [],
  });

  List<int> chosenTabTypes;
  List<int> chosenBarChartTypes;
  List<int> chosenPieChartTypes;

  List<int> get availableTypes {
    var result = <int>{};
    for (var item in models) {
      if (item.retirementType != null) {
        result.add(item.retirementType!);
      }
    }
    var list = result.toList();
    list.sort();
    return list;
  }

  Map<int, double> get chartValues {
    var result = <int, double>{};
    for (var item in availableTypes) {
      result[item] = 0;
    }
    for (var item in models) {
      if (item.retirementType != null) {
        result[item.retirementType!] =
            (result[item.retirementType!] ?? 0) + item.currentCost!;
      }
    }
    return result;
  }

  Map<int, String> typeMap = {
    1: '401a',
    2: '401k',
    3: 'Roth 401k',
    4: 'IRA',
    5: 'Roth IRA',
    6: 'Sep',
    7: '403b',
    8: '457b',
    9: 'RRSP',
    10: 'TFSA',
    11: 'TSP',
    12: 'Roth 457b',
    13: 'Other',
  };

  List<int> get chosenRetirements {
    var result = availableTypes;
    var preferable = [1, 2, 4, 12];
    for (var item in preferable) {
      if (!result.contains(item) && result.length < 6) {
        result.insert(preferable.indexOf(item), item);
      }
    }

    return result;
  }

  List<RetirementModel> modelsOfType(int retirementTab) {
    return models
        .where((element) => element.retirementType == retirementTab)
        .toList();
  }
}
