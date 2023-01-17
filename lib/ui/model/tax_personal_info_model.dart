import 'package:equatable/equatable.dart';

class TaxPersonalInfoModel extends Equatable {
  final List<TaxSalaryPaycheck> salaryPaychecks;
  String? stateCode;
  int? taxFilingStatus;
  int? children17andYoungerCount;
  int? children13andYoungerCount;
  final int year;

  TaxPersonalInfoModel({
    required this.salaryPaychecks,
    required this.stateCode,
    required this.taxFilingStatus,
    required this.children17andYoungerCount,
    required this.children13andYoungerCount,
    required this.year,
  });

  Map<String, dynamic> toJson() {
    var salaryPaycheckList = <Map<String, dynamic>>[];
    salaryPaychecks.forEach((element) {
      salaryPaycheckList.add(element.toJson());
    });
    return {
      'salaryPaycheckList': salaryPaycheckList,
      'stateCode': stateCode,
      'children17andYoungerCount': children17andYoungerCount,
      'children13andYoungerCount': children13andYoungerCount,
      'taxFilingStatus': taxFilingStatus,
      'year': year,
    };
  }

  factory TaxPersonalInfoModel.fromJson(Map<String, dynamic> json, int year) {
    var salaryPaychecks = <TaxSalaryPaycheck>[];
    json['salaryPaycheckList'].forEach((element) {
      salaryPaychecks.add(TaxSalaryPaycheck.fromJson(element));
    });
    return TaxPersonalInfoModel(
      salaryPaychecks: salaryPaychecks,
      children13andYoungerCount: json['children13andYoungerCount'],
      children17andYoungerCount: json['children17andYoungerCount'],
      stateCode: json['stateCode'],
      taxFilingStatus:
          json['taxFilingStatus'] == 0 ? null : json['taxFilingStatus'],
      year: year,
    );
  }

  TaxPersonalInfoModel copyWith({
    List<TaxSalaryPaycheck>? salaryPaychecks,
    String? stateCode,
    int? taxFilingStatus,
    int? children17andYoungerCount,
    int? children13andYoungerCount,
  }) {
    var salaryPaychecksList = <TaxSalaryPaycheck>[];
    if (salaryPaychecks == null) {
      this.salaryPaychecks.forEach((element) {
        salaryPaychecksList.add(element.copyWith());
      });
    }
    return TaxPersonalInfoModel(
        salaryPaychecks: salaryPaychecks ?? salaryPaychecksList,
        stateCode: stateCode ?? this.stateCode,
        children13andYoungerCount:
            children13andYoungerCount ?? this.children13andYoungerCount,
        children17andYoungerCount:
            children17andYoungerCount ?? this.children17andYoungerCount,
        taxFilingStatus: taxFilingStatus ?? this.taxFilingStatus,
        year: year);
  }

  @override
  String toString() {
    return 'taxFilingStatus $taxFilingStatus \nchildren13andYoungerCount $children13andYoungerCount \nchildren17andYoungerCount $children17andYoungerCount \nstateCode $stateCode \nsalaryPaychecks ${salaryPaychecks.length})}';
  }

  @override
  List<Object?> get props => [
        taxFilingStatus,
        children13andYoungerCount,
        children17andYoungerCount,
        stateCode,
        salaryPaychecks,
        year
      ];
}

class TaxSalaryPaycheck extends Equatable {
  final String salaryPaycheckId;
  final String? name;
  int? source;
  int? annualSalary;
  final int? beforeTaxAmount;
  final int? afterTaxAmount;

  late final int status;

  bool get statusValue => status == 2;

  String get secondOptionName => 'Before tax';

  String get firstOptionName => 'After tax';

  TaxSalaryPaycheck({
    required this.salaryPaycheckId,
    this.name,
    this.source,
    this.annualSalary,
    this.afterTaxAmount,
    this.beforeTaxAmount,
    int? setStatus,
  }) : status = (setStatus) ?? (beforeTaxAmount != null ? 1 : 2);

  TaxSalaryPaycheck copyWith({
    int? source,
    int? annualSalary,
    int? beforeTaxAmount,
    int? setStatus,
    bool replaceBeforeTax = false,
  }) {
    return TaxSalaryPaycheck(
      salaryPaycheckId: salaryPaycheckId,
      name: name,
      source: source ?? this.source,
      annualSalary: annualSalary ?? this.annualSalary,
      beforeTaxAmount: replaceBeforeTax
          ? beforeTaxAmount
          : (beforeTaxAmount ?? this.beforeTaxAmount),
      afterTaxAmount: afterTaxAmount,
      setStatus: setStatus,
    );
  }

  factory TaxSalaryPaycheck.fromJson(Map<String, dynamic> json) {
    return TaxSalaryPaycheck(
      salaryPaycheckId: json['salaryPaycheckId'],
      name: json['name'],
      source: json['source'] == 0 ? null : json['source'],
      annualSalary: json['annualSalary'],
      afterTaxAmount: json['amountFromBudget'],
      beforeTaxAmount: json['manualBeforeTaxAmount'],
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['salaryPaycheckId'] = salaryPaycheckId;
    data['name'] = name;
    data['source'] = source;
    data['annualSalary'] = annualSalary;
    data['amountFromBudget'] = afterTaxAmount;
    data['manualBeforeTaxAmount'] = beforeTaxAmount;
    return data;
  }

  @override
  List<Object?> get props => [
        salaryPaycheckId,
        name,
        source,
        annualSalary,
        afterTaxAmount,
        beforeTaxAmount,
      ];

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is TaxSalaryPaycheck &&
          runtimeType == other.runtimeType &&
          salaryPaycheckId == other.salaryPaycheckId &&
          name == other.name &&
          source == other.source &&
          annualSalary == other.annualSalary &&
          beforeTaxAmount == other.beforeTaxAmount &&
          afterTaxAmount == other.afterTaxAmount &&
          status == other.status;

  @override
  int get hashCode =>
      super.hashCode ^
      salaryPaycheckId.hashCode ^
      name.hashCode ^
      source.hashCode ^
      annualSalary.hashCode ^
      beforeTaxAmount.hashCode ^
      afterTaxAmount.hashCode ^
      status.hashCode;
}
