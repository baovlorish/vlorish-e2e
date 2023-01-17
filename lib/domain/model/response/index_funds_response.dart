import 'package:burgundy_budgeting_app/ui/atomic/atom/theme.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

enum InvestmentGroup {
  Stocks,
  IndexFunds,
  Cryptocurrencies,
  RealEstate,
  StartUps,
  OtherInvestments
}

abstract class AvailableInvestmentInterface {
  final String? id;
  final String? name;

  AvailableInvestmentInterface({required this.id, required this.name});
}

abstract class InvestmentGroupInterface
    implements AvailableInvestmentInterface {
  @override
  final String? id;
  @override
  final String? name;
  final double? initialCost;
  final DateTime? acquisitionDate;
  final double? currentCost;
  final InvestmentGroup investmentGroup;

  InvestmentGroupInterface({
    required this.id,
    required this.name,
    required this.initialCost,
    required this.acquisitionDate,
    required this.currentCost,
    required this.investmentGroup,
  });
}

class InvestmentsDashboardModel {
  List<InvestmentsDashboardItem> items;

  InvestmentsDashboardModel(this.items);

  factory InvestmentsDashboardModel.fromJson(Map<String, dynamic> json) {
    var items = <InvestmentsDashboardItem>[];
    for (var item in json['items']) {
      items.add(InvestmentsDashboardItem.fromJson(item));
      items.sort((a, b) => a.type.compareTo(b.type));
    }
    return InvestmentsDashboardModel(items);
  }

  List<Color> get statisticColors => [
        CustomColorScheme.goalColor1,
        CustomColorScheme.goalColor2,
        CustomColorScheme.goalColor3,
        CustomColorScheme.goalColor4,
        CustomColorScheme.goalColor5,
        CustomColorScheme.goalColor7,
      ];

  double get total {
    var result = 0.0;
    for (var item in items) {
      result += item.currentCost;
    }
    return result;
  }

  InvestmentsDashboardItem? get stocks =>
      items.firstWhereOrNull((element) => element.type == 1);

  InvestmentsDashboardItem? get indexFunds =>
      items.firstWhereOrNull((element) => element.type == 2);

  InvestmentsDashboardItem? get crypto =>
      items.firstWhereOrNull((element) => element.type == 3);

  InvestmentsDashboardItem? get realEstate =>
      items.firstWhereOrNull((element) => element.type == 4);

  InvestmentsDashboardItem? get startups =>
      items.firstWhereOrNull((element) => element.type == 5);

  InvestmentsDashboardItem? get other =>
      items.firstWhereOrNull((element) => element.type == 6);
}

class InvestmentsDashboardItem {
  final int type;
  final double initialCost;
  final double currentCost;

  double get percent => 100 * (currentCost - initialCost) / initialCost;

  InvestmentsDashboardItem({
    required this.type,
    required this.initialCost,
    required this.currentCost,
  });

  factory InvestmentsDashboardItem.fromJson(Map<String, dynamic> json) {
    var type = json['type'] ?? 0;
    //different order on be enum
    if (type == 2) {
      type = 4;
    } else if (type == 3) {
      type = 2;
    } else if (type == 4) {
      type = 3;
    }
    return InvestmentsDashboardItem(
      type: type,
      initialCost: json['initialCost'] ?? 0,
      currentCost: json['currentCost'] ?? 0,
    );
  }
  // compare only type value
  @override
  bool operator ==(Object other) =>
      other is InvestmentsDashboardItem &&
      runtimeType == other.runtimeType &&
      type == other.type;

  @override
  int get hashCode => type.hashCode;

  @override
  String toString() {
    return 'InvestmentsDashboardItem{type: $type, initialCost: $initialCost, currentCost: $currentCost}';
  }
}

class AvailableInvestment implements AvailableInvestmentInterface {
  @override
  final String? id;

  @override
  final String? name;

  AvailableInvestment({required this.id, required this.name});

  factory AvailableInvestment.fromJson(Map<String, dynamic> json) =>
      AvailableInvestment(id: json['id'], name: json['name']);

  @override
  String toString() {
    return '\tid: $id,\n\tname:$name';
  }
}

class InvestmentModel implements InvestmentGroupInterface {
  @override
  final String? id;
  @override
  final String? name;
  @override
  final double? initialCost;
  @override
  final DateTime? acquisitionDate;
  @override
  final double? currentCost;
  final int? exchange;
  final String? address;
  final int? brokerage;
  final List<InvestmentTransaction>? transactions;
  @override
  final InvestmentGroup investmentGroup;
  final int? usageType;
  final int? otherType;
  final bool isManual;

  InvestmentModel({
    this.id,
    required this.name,
    required this.initialCost,
    required this.acquisitionDate,
    this.currentCost,
    this.address,
    this.usageType,
    this.exchange,
    this.brokerage,
    this.transactions,
    required this.isManual,
    required this.investmentGroup,
    this.otherType,
  });

  factory InvestmentModel.fromJson(
      Map<String, dynamic> json, InvestmentGroup investmentGroup) {
    var transactions = <InvestmentTransaction>[];
    if (json['transactions'] != null) {
      json['transactions'].forEach((element) {
        transactions.add(InvestmentTransaction.fromJson(element));
      });
    }
    return InvestmentModel(
        id: json['id'],
        address: json['address'],
        usageType: json['usageType'],
        otherType: json['type'],
        isManual: json['isManual'] ?? false,
        name: json['name'],
        initialCost: json['initialCost'],
        acquisitionDate: DateTime.parse(json['acquisitionDate']),
        currentCost: json['currentCost'],
        brokerage: json['brokerage'],
        exchange: json['exchange'],
        transactions: transactions,
        investmentGroup: investmentGroup);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['address'] = address;
    data['usageType'] = usageType;
    data['cost'] = initialCost;
    data['acquisitionDate'] = acquisitionDate?.toIso8601String();
    if (currentCost != null) data['currentCost'] = currentCost;
    data['brokerage'] = brokerage;
    data['exchange'] = exchange;
    if (transactions != null) {
      data['transactions'] =
          transactions!.map((transaction) => transaction.toJson()).toList();
    }
    data['type'] = otherType;
    return data;
  }

  Map<String, dynamic> deleteInvestmentByIdToJson(
      {String? sellDate, required bool removeHistory}) {
    final data = <String, dynamic>{};
    data['sellDate'] = sellDate;
    data['removeHistory'] = removeHistory;
    return data;
  }

  Map<String, dynamic> addTransactionsInvestmentByIdToJson() {
    final data = <String, dynamic>{};
    data['name'] = name;
    data['currentCost'] = currentCost;
    data['brokerage'] = brokerage;
    if (transactions != null) {
      data['transactions'] =
          transactions!.map((transaction) => transaction.toJson()).toList();
    }
    return data;
  }

  @override
  String toString() {
    var transactionList = '';
    transactions?.forEach((element) {
      transactionList += element.toString();
    });
    return 'id: $id, name: $name, initialCost: $initialCost, acquisitionDate: $acquisitionDate,currentCost: $currentCost, exchange: $exchange, brokerage: $brokerage,transactions: [$transactionList]';
  }
}

class InvestmentTransaction {
  final double? amount;
  final int? type;

  InvestmentTransaction({required this.amount, required this.type});

  factory InvestmentTransaction.fromJson(Map<String, dynamic> json) {
    return InvestmentTransaction(
      amount: json['amount'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    var data = <String, dynamic>{};
    data['amount'] = amount;
    data['type'] = type;
    return data;
  }

  @override
  String toString() {
    return '{ amount:$amount, type:$type\n}';
  }
}

class AttachInvestmentRetirementModel {
  final int? brokerage;
  final int? custodian;
  final int? investType;
  final DateTime? acquisitionMonthYear;
  final String? id;

  AttachInvestmentRetirementModel({
    this.brokerage,
    this.acquisitionMonthYear,
    this.id,
    this.custodian,
    this.investType,
  });

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['brokerage'] = brokerage;
    data['acquisitionMonthYear'] = acquisitionMonthYear?.toIso8601String();
    data['id'] = id;
    data['custodian'] = custodian;
    data['investType'] = investType;
    return data;
  }
}
