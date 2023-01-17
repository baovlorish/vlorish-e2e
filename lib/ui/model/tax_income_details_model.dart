import 'package:burgundy_budgeting_app/ui/model/tax_personal_info_model.dart';
import 'package:collection/collection.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TaxIncomeDetailsModel {
  final List<TaxSalaryPaycheck> salaryPaychecks;
  final List<TaxIncomeDetailSource> incomeSources;
  final int year;

  TaxIncomeDetailsModel({
    required this.salaryPaychecks,
    required this.incomeSources,
    required this.year,
  });

  Map<String, dynamic> toJson() {
    var salaryPaycheckList = <Map<String, dynamic>>[];
    salaryPaychecks.forEach((element) {
      salaryPaycheckList.add(element.toJson());
    });
    var data = <String, dynamic>{};

    data['salaryPaycheckList'] = salaryPaycheckList;
    incomeSources.forEach((element) {
      data[element.outputStatusKey] = element.status;
    });
    data['year'] = year;
    return data;
  }

  factory TaxIncomeDetailsModel.fromJson(Map<String, dynamic> json, int year) {
    var salaryPaychecks = <TaxSalaryPaycheck>[];
    json['salaryPaycheckList'].forEach((element) {
      salaryPaychecks.add(TaxSalaryPaycheck.fromJson(element));
    });
    var incomeSources = <TaxIncomeDetailSource>[];
    var incomeSourcesMap = Map<String, dynamic>.from(json);
    incomeSourcesMap.removeWhere((key, value) => key == 'salaryPaycheckList');
    incomeSourcesMap.forEach((key, value) {
      var amount = value['amount'];
      value.removeWhere((key, value) => key == 'amount');
      incomeSources.add(TaxIncomeDetailSource(
        key: key,
        statusKey: value.entries.first.key,
        amount: amount,
        status: value.entries.first.value,
      ));
    });

    return TaxIncomeDetailsModel(
      salaryPaychecks: salaryPaychecks,
      incomeSources: incomeSources,
      year: year,
    );
  }

  @override
  String toString() {
    var sources = '';
    incomeSources.forEach((element) {
      sources += '\n$element';
    });
    return 'salaryPaychecks ${salaryPaychecks.length}: $sources';
  }

  TaxIncomeDetailsModel updateWithSalary(TaxSalaryPaycheck newModel) {
    var newSalaryPaychecks = salaryPaychecks;
    newSalaryPaychecks.removeWhere(
        (element) => element.salaryPaycheckId == newModel.salaryPaycheckId);
    newSalaryPaychecks.add(newModel);

    return TaxIncomeDetailsModel(
      salaryPaychecks: newSalaryPaychecks,
      incomeSources: incomeSources,
      year: year,
    );
  }

  TaxIncomeDetailsModel updateWithSource(TaxIncomeDetailSource newModel) {
    var newIncomeSources = <TaxIncomeDetailSource>[];
    incomeSources.forEach((element) {
      newIncomeSources.add(element.copyWith());
    });

    var index =
        newIncomeSources.indexWhere((element) => element.key == newModel.key);
    newIncomeSources.removeAt(index);
    newIncomeSources.insert(index, newModel);

    return TaxIncomeDetailsModel(
      salaryPaychecks: salaryPaychecks,
      incomeSources: newIncomeSources,
      year: year,
    );
  }

  TaxIncomeDetailsModel copyWith({
    List<TaxSalaryPaycheck>? salaryPaychecks,
    List<TaxIncomeDetailSource>? incomeSources,
  }) {
    var salaryPaychecksList = <TaxSalaryPaycheck>[];
    if (salaryPaychecks == null) {
      this.salaryPaychecks.forEach((element) {
        salaryPaychecksList.add(element.copyWith());
      });
    }
    var incomeSourcesList = <TaxIncomeDetailSource>[];
    if (incomeSources == null) {
      this.incomeSources.forEach((element) {
        incomeSourcesList.add(element.copyWith());
      });
    }
    return TaxIncomeDetailsModel(
        salaryPaychecks: salaryPaychecks ?? salaryPaychecksList,
        incomeSources: incomeSources ?? incomeSourcesList,
        year: year);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaxIncomeDetailsModel &&
          runtimeType == other.runtimeType &&
          DeepCollectionEquality()
              .equals(salaryPaychecks, other.salaryPaychecks) &&
          DeepCollectionEquality().equals(incomeSources, other.incomeSources) &&
          year == other.year;

  @override
  int get hashCode =>
      salaryPaychecks.hashCode ^ incomeSources.hashCode ^ year.hashCode;
}

class TaxIncomeDetailSource {
  final String key;
  final String statusKey;
  final int status;
  final int? amount;

  bool get statusValue => status == 2;

  TaxIncomeDetailSource(
      {required this.key,
      required this.statusKey,
      required this.status,
      required this.amount});

  bool get isTaxable {
    if (!statusValue) {
      return true;
    } else {
      return key != 'ownerDraw' &&
          key != 'netBusinessIncome' &&
          key != 'retirementIncome' &&
          key != 'uncategorizedIncome' &&
          key != 'otherIncome';
    }
  }

  TaxIncomeDetailSource copyWith({int? status}) {
    return TaxIncomeDetailSource(
      status: status ?? this.status,
      amount: amount,
      statusKey: statusKey,
      key: key,
    );
  }

  String get outputStatusKey => key + 'TaxTreatment';

  String get secondOptionName {
    switch (key) {
      case 'ownerDraw':
        return 'Nontaxable';
      case 'netBusinessIncome':
        return 'Nontaxable';
      case 'rentalIncome':
        return 'Nonpassive';
      case 'investmentIncome':
        return 'Short-term';
      case 'dividendIncome':
        return 'Nonqualified';
      case 'retirementIncome':
        return 'Nontaxable';
      case 'uncategorizedIncome':
        return 'Nontaxable';
      case 'otherIncome':
        return 'Nontaxable';

      default:
        return '';
    }
  }

  String get firstOptionName {
    switch (key) {
      case 'ownerDraw':
        return 'Taxable';
      case 'netBusinessIncome':
        return 'Taxable';
      case 'rentalIncome':
        return 'Passive';
      case 'investmentIncome':
        return 'Long-term';
      case 'dividendIncome':
        return 'Qualified';
      case 'retirementIncome':
        return 'Taxable';
      case 'uncategorizedIncome':
        return 'Taxable';
      case 'otherIncome':
        return 'Taxable';

      default:
        return '';
    }
  }

  @override
  String toString() {
    return '$key: $statusKey: $status amount $amount';
  }

  String name(BuildContext context) {
    switch (key) {
      case 'dividendIncome':
        return AppLocalizations.of(context)!.dividendIncome;
      case 'investmentIncome':
        return AppLocalizations.of(context)!.investmentIncome;
      case 'netBusinessIncome':
        return AppLocalizations.of(context)!.netBusinessIncome;
      case 'otherIncome':
        return AppLocalizations.of(context)!.otherIncome;
      case 'ownerDraw':
        return AppLocalizations.of(context)!.ownerDraw;
      case 'rentalIncome':
        return AppLocalizations.of(context)!.rentalIncome;
      case 'retirementIncome':
        return AppLocalizations.of(context)!.retirementIncome;
      case 'uncategorizedIncome':
        return AppLocalizations.of(context)!.uncategorizedIncome;
      default:
        return '';
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaxIncomeDetailSource &&
          runtimeType == other.runtimeType &&
          key == other.key &&
          statusKey == other.statusKey &&
          status == other.status &&
          amount == other.amount;

  @override
  int get hashCode =>
      key.hashCode ^ statusKey.hashCode ^ status.hashCode ^ amount.hashCode;
}
