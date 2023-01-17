import 'package:burgundy_budgeting_app/ui/atomic/organizm/tax_column_chart.dart';

class EstimatedTaxesModel {
  double? totalIncome;
  double? taxableIncome;
  TaxPieChartData? taxPieChartData;
  TaxBarChartData? taxBarChartData;

  EstimatedTaxesModel(
      {this.totalIncome,
      this.taxableIncome,
      this.taxPieChartData,
      this.taxBarChartData});

  EstimatedTaxesModel.fromJson(Map<String, dynamic> json) {
    totalIncome = json['totalIncome'];
    taxableIncome = json['taxableIncome'];
    taxPieChartData = json['pieChart'] != null
        ? TaxPieChartData.fromJson(json['pieChart'])
        : null;
    taxBarChartData = json['barChart'] != null
        ? TaxBarChartData.fromJson(json['barChart'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['totalIncome'] = totalIncome;
    data['taxableIncome'] = taxableIncome;
    if (taxPieChartData != null) {
      data['pieChart'] = taxPieChartData!.toJson();
    }
    if (taxBarChartData != null) {
      data['barChart'] = taxBarChartData!.toJson();
    }
    return data;
  }

  @override
  String toString() {
    return 'totalIncome: $totalIncome,\n\ttaxableIncome: $taxableIncome,\n\tpieChart: ${taxPieChartData.toString()},\n\tbarChart: ${taxBarChartData.toString()}';
  }
}

class TaxPieChartData {
  double? totalTaxLiability;
  TaxPieChartItem? taxWithholdings;
  TaxPieChartItem? estimatedTaxesPaid;
  TaxPieChartItem? remainingBalance;
  bool? isRemainingBalanceNegative;
  bool? isTotalTaxLiabilityNegative;

  TaxPieChartData(
      {this.totalTaxLiability,
      this.taxWithholdings,
      this.estimatedTaxesPaid,
      this.remainingBalance,
      required this.isRemainingBalanceNegative,
      required this.isTotalTaxLiabilityNegative});

  TaxPieChartData.fromJson(Map<String, dynamic> json) {
    isTotalTaxLiabilityNegative = json['isTotalTaxLiabilityNegative'] ?? false;
    isRemainingBalanceNegative = json['isRemainingBalanceNegative'] ?? false;
    totalTaxLiability = json['totalTaxLiability'];
    taxWithholdings = json['taxWithholdings'] != null
        ? TaxPieChartItem.fromJson(json['taxWithholdings'])
        : null;
    estimatedTaxesPaid = json['estimatedTaxesPaid'] != null
        ? TaxPieChartItem.fromJson(json['estimatedTaxesPaid'])
        : null;
    remainingBalance = json['remainingBalance'] != null
        ? TaxPieChartItem.fromJson(json['remainingBalance'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['totalTaxLiability'] = totalTaxLiability;
    if (taxWithholdings != null) {
      data['taxWithholdings'] = taxWithholdings!.toJson();
    }
    if (estimatedTaxesPaid != null) {
      data['estimatedTaxesPaid'] = estimatedTaxesPaid!.toJson();
    }
    if (remainingBalance != null) {
      data['remainingBalance'] = remainingBalance!.toJson();
    }
    return data;
  }

  @override
  String toString() {
    return ' {\n\ttotalTaxLiability: $totalTaxLiability,\n\ttaxWithholdings: ${taxWithholdings.toString()},\n\testimatedTaxesPaid : ${estimatedTaxesPaid.toString()},\n\tremainingBalance: ${remainingBalance.toString()}\n\t}';
  }
}

class TaxPieChartItem {
  double? value;
  double? percentageOfTotal;

  TaxPieChartItem({this.value, this.percentageOfTotal});

  TaxPieChartItem.fromJson(Map<String, dynamic> json) {
    value = json['value'];
    percentageOfTotal = json['percentageOfTotal'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['value'] = value;
    data['percentageOfTotal'] = percentageOfTotal;
    return data;
  }

  @override
  String toString() {
    return ' {\n\tvalue: $value, \n\tpercentageOfTotal: $percentageOfTotal\n\t}';
  }
}

class TaxBarChartData {
  List<QuarterComponents>? quarterComponents;

  TaxBarChartData({this.quarterComponents});

  TaxBarChartData.fromJson(Map<String, dynamic> json) {
    if (json['quarterComponents'] != null) {
      quarterComponents = <QuarterComponents>[];
      json['quarterComponents'].forEach((v) {
        quarterComponents!.add(QuarterComponents.fromJson(v));
      });
    }
  }

  List<TaxChartData> get chartData {
    var result = <TaxChartData>[];
    if (quarterComponents != null) {
      for (var item in quarterComponents!) {
        result.add(TaxChartData(
            item.federalTax ?? 0, item.stateTax ?? 0, item.fica ?? 0));
      }
    }
    return result;
  }

  double? get minimum {
    if (quarterComponents != null) {
      var min = 0.0;
      for (var item in quarterComponents!) {
        if (min > (item.federalTax ?? 0)) {
          min = item.federalTax ?? 0;
        }
        if (min > (item.stateTax ?? 0)) {
          min = item.stateTax ?? 0;
        }
        if (min > (item.fica ?? 0)) {
          min = item.fica ?? 0;
        }
      }
      return min;
    }
  }

  double? get maximum {
    if (quarterComponents != null) {
      var max = 0.0;
      for (var item in quarterComponents!) {
        if (max < (item.federalTax ?? 0)) {
          max = item.federalTax ?? 0;
        }
        if (max < (item.stateTax ?? 0)) {
          max = item.stateTax ?? 0;
        }
        if (max < (item.fica ?? 0)) {
          max = item.fica ?? 0;
        }
      }
      return max;
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (quarterComponents != null) {
      data['quarterComponents'] =
          quarterComponents!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  String toString() {
    var printString = '{';
    quarterComponents?.forEach((element) {
      printString += '\n\t${element.toString()}';
    });
    printString += '\n\t}';
    return printString;
  }
}

class QuarterComponents {
  double? quarter;
  double? federalTax;
  double? stateTax;
  double? fica;

  QuarterComponents({this.quarter, this.federalTax, this.stateTax, this.fica});

  QuarterComponents.fromJson(Map<String, dynamic> json) {
    quarter = json['quarter'];
    federalTax = json['federalTax'];
    stateTax = json['stateTax'];
    fica = json['fica'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['quarter'] = quarter;
    data['federalTax'] = federalTax;
    data['stateTax'] = stateTax;
    data['fica'] = fica;
    return data;
  }

  @override
  String toString() {
    return ' {\n\tquarter: $quarter,\n\tfederalTax: $federalTax,\n\tstateTax: $federalTax,\n\tfica: $fica\n\t}';
  }
}
