import 'package:equatable/equatable.dart';

class TaxCreditsAndAdjustmentModel extends Equatable {
  TaxCreditsAndAdjustmentModel({
    required this.incomeAdjustments,
    required this.itemizedDeductions,
    required this.qualifiedBusinessIncomeDeduction,
    required this.taxCredits,
    required this.year,
  });

  final IncomeAdjustments incomeAdjustments;
  final ItemizedDeductions itemizedDeductions;
  final int qualifiedBusinessIncomeDeduction;
  final TaxCredits taxCredits;
  final int year;

  Map<String, dynamic> toJson() {
    return {
      'incomeAdjustments': incomeAdjustments,
      'itemizedDeductions': itemizedDeductions,
      'taxCredits': taxCredits,
      'year': year,
    };
  }

  factory TaxCreditsAndAdjustmentModel.fromJson(
      Map<String, dynamic> json, int year) {
    return TaxCreditsAndAdjustmentModel(
      incomeAdjustments: IncomeAdjustments.fromJson(json['incomeAdjustments']),
      itemizedDeductions:
          ItemizedDeductions.fromJson(json['itemizedDeductions']),
      qualifiedBusinessIncomeDeduction: json['qbiDeduction']
          ['qualifiedBusinessIncomeDeduction'],
      taxCredits: TaxCredits.fromJson(json['taxCredits']),
      year: year,
    );
  }

  TaxCreditsAndAdjustmentModel copyWith({
    IncomeAdjustments? incomeAdjustments,
    ItemizedDeductions? itemizedDeductions,
    int? qualifiedBusinessIncomeDeduction,
    TaxCredits? taxCredits,
  }) {
    return TaxCreditsAndAdjustmentModel(
      incomeAdjustments: incomeAdjustments ?? this.incomeAdjustments.copyWith(),
      itemizedDeductions:
          itemizedDeductions ?? this.itemizedDeductions.copyWith(),
      qualifiedBusinessIncomeDeduction: qualifiedBusinessIncomeDeduction ??
          this.qualifiedBusinessIncomeDeduction,
      taxCredits: taxCredits ?? this.taxCredits.copyWith(),
      year: year,
    );
  }

  @override
  String toString() {
    return 'CreditsAndAdjustmentModel :{ \n${incomeAdjustments.toString()},\n${itemizedDeductions.toString()},\nqualifiedBusinessIncomeDeduction: $qualifiedBusinessIncomeDeduction,\n${taxCredits.toString()},\nyear: $year}';
  }

  @override
  List<Object> get props => [
        incomeAdjustments,
        itemizedDeductions,
        qualifiedBusinessIncomeDeduction,
        taxCredits,
        year
      ];
}

class IncomeAdjustments {
  IncomeAdjustments({
    required this.selfEmployedHealthInsurance,
    required this.hsaContribution,
    required this.retirementContributionsNotDeductedFromPaycheck,
    required this.studentInterestPaidDuringTheYear,
    required this.studentLoanInterestPaid,
    required this.halfOfSelfEmploymentTaxesPaid,
    required this.other,
  });

  int selfEmployedHealthInsurance;
  int hsaContribution;
  int retirementContributionsNotDeductedFromPaycheck;
  int studentInterestPaidDuringTheYear;
  int studentLoanInterestPaid;
  double halfOfSelfEmploymentTaxesPaid;
  int other;

  Map<String, dynamic> toJson() {
    return {
      'selfEmployedHealthInsurance': selfEmployedHealthInsurance,
      'hsaContribution': hsaContribution,
      'retirementContributionsNotDeductedFromPaycheck':
          retirementContributionsNotDeductedFromPaycheck,
      'studentInterestPaidDuringTheYear': studentInterestPaidDuringTheYear,
      'studentLoanInterestPaid': studentLoanInterestPaid,
      'halfOfSelfEmploymentTaxesPaid': halfOfSelfEmploymentTaxesPaid,
      'other': other,
    };
  }

  factory IncomeAdjustments.fromJson(Map<String, dynamic> json) {
    return IncomeAdjustments(
      studentInterestPaidDuringTheYear:
          json['studentInterestPaidDuringTheYear'],
      studentLoanInterestPaid: json['studentLoanInterestPaid'],
      retirementContributionsNotDeductedFromPaycheck:
          json['retirementContributionsNotDeductedFromPaycheck'],
      selfEmployedHealthInsurance: json['selfEmployedHealthInsurance'],
      hsaContribution: json['hsaContribution'],
      halfOfSelfEmploymentTaxesPaid: json['halfOfSelfEmploymentTaxesPaid'],
      other: json['other'],
    );
  }

  IncomeAdjustments copyWith({
    int? selfEmployedHealthInsurance,
    int? hsaContribution,
    int? studentLoanInterestPaid,
    int? other,
    int? retirementContributionsNotDeductedFromPaycheck,
  }) {
    return IncomeAdjustments(
      selfEmployedHealthInsurance:
          selfEmployedHealthInsurance ?? this.selfEmployedHealthInsurance,
      hsaContribution: hsaContribution ?? this.hsaContribution,
      studentLoanInterestPaid:
          studentLoanInterestPaid ?? this.studentLoanInterestPaid,
      other: other ?? this.other,
      retirementContributionsNotDeductedFromPaycheck:
          retirementContributionsNotDeductedFromPaycheck ??
              this.retirementContributionsNotDeductedFromPaycheck,

      ///not editable fields
      halfOfSelfEmploymentTaxesPaid: halfOfSelfEmploymentTaxesPaid,
      studentInterestPaidDuringTheYear: studentInterestPaidDuringTheYear,
    );
  }

  @override
  String toString() {
    return 'IncomeAdjustments: {\n\tstudentInterestPaidDuringTheYear $studentInterestPaidDuringTheYear,\n\tstudentLoanInterestPaid $studentLoanInterestPaid,\n\tretirementContributionsNotDeductedFromPaycheck $retirementContributionsNotDeductedFromPaycheck,\n\tselfEmployedHealthInsurance $selfEmployedHealthInsurance,\n\thsaContribution $hsaContribution,\n\thalfOfSelfEmploymentTaxesPaid $halfOfSelfEmploymentTaxesPaid,\n\tother $other}';
  }

  List<Object> get props => [
        selfEmployedHealthInsurance,
        hsaContribution,
        retirementContributionsNotDeductedFromPaycheck,
        studentInterestPaidDuringTheYear,
        studentLoanInterestPaid,
        halfOfSelfEmploymentTaxesPaid,
        other,
      ];
}

class ItemizedDeductions extends Equatable {
  ItemizedDeductions({
    required this.mortgageInterestPaid,
    required this.propertyTaxPayments,
    required this.charitableContributions,
    required this.otherItemizedDeduction,
    required this.compareToStandardDeduction,
  });

  int mortgageInterestPaid;
  int propertyTaxPayments;
  int charitableContributions;
  int otherItemizedDeduction;
  int compareToStandardDeduction;

  Map<String, dynamic> toJson() {
    return {
      'mortgageInterestPaid': mortgageInterestPaid,
      'propertyTaxPayments': propertyTaxPayments,
      'charitableContributions': charitableContributions,
      'otherItemizedDeduction': otherItemizedDeduction,
      'compareToStandardDeduction': compareToStandardDeduction,
    };
  }

  factory ItemizedDeductions.fromJson(Map<String, dynamic> json) {
    return ItemizedDeductions(
      mortgageInterestPaid: json['mortgageInterestPaid'],
      propertyTaxPayments: json['propertyTaxPayments'],
      charitableContributions: json['charitableContributions'],
      otherItemizedDeduction: json['otherItemizedDeduction'],
      compareToStandardDeduction: json['compareToStandardDeduction'],
    );
  }
  ItemizedDeductions copyWith({
    int? mortgageInterestPaid,
    int? propertyTaxPayments,
    int? charitableContributions,
    int? otherItemizedDeduction,
  }) {
    return ItemizedDeductions(
      mortgageInterestPaid: mortgageInterestPaid ?? this.mortgageInterestPaid,
      propertyTaxPayments: propertyTaxPayments ?? this.propertyTaxPayments,
      charitableContributions:
          charitableContributions ?? this.charitableContributions,
      otherItemizedDeduction:
          otherItemizedDeduction ?? this.otherItemizedDeduction,

      ///not editable fields
      compareToStandardDeduction: compareToStandardDeduction,
    );
  }

  @override
  String toString() {
    return 'ItemizedDeductions: {\n\tmortgageInterestPaid: $mortgageInterestPaid,\n\tpropertyTaxPayments: $propertyTaxPayments,\n\tcharitableContributions: $charitableContributions,\n\totherItemizedDeduction: $otherItemizedDeduction,\n\tcompareToStandardDeduction: $compareToStandardDeduction}';
  }

  @override
  List<Object> get props => [
        mortgageInterestPaid,
        propertyTaxPayments,
        charitableContributions,
        otherItemizedDeduction,
        compareToStandardDeduction,
      ];
}

class TaxCredits extends Equatable {
  TaxCredits({
    required this.childTaxCredit,
    required this.childAndDependentCareCredit,
    required this.totalEligibleChildcareExpenses,
    required this.energyCredit,
    required this.electricVehicleCredit,
    required this.otherTaxCredit,
  });

  int childTaxCredit;
  int childAndDependentCareCredit;
  int totalEligibleChildcareExpenses;
  int energyCredit;
  int electricVehicleCredit;
  int otherTaxCredit;

  Map<String, dynamic> toJson() {
    return {
      'childTaxCredit': childTaxCredit,
      'childAndDependentCareCredit': childAndDependentCareCredit,
      'totalEligibleChildcareExpenses': totalEligibleChildcareExpenses,
      'energyCredit': energyCredit,
      'electricVehicleCredit': electricVehicleCredit,
      'otherTaxCredit': otherTaxCredit,
    };
  }

  factory TaxCredits.fromJson(Map<String, dynamic> json) {
    return TaxCredits(
      childTaxCredit: json['childTaxCredit'],
      childAndDependentCareCredit: json['childAndDependentCareCredit'],
      totalEligibleChildcareExpenses: json['totalEligibleChildcareExpenses'],
      energyCredit: json['energyCredit'],
      electricVehicleCredit: json['electricVehicleCredit'],
      otherTaxCredit: json['otherTaxCredit'],
    );
  }

  TaxCredits copyWith({
    int? energyCredit,
    int? electricVehicleCredit,
    int? otherTaxCredit,
  }) {
    return TaxCredits(
      energyCredit: energyCredit ?? this.energyCredit,
      electricVehicleCredit:
          electricVehicleCredit ?? this.electricVehicleCredit,
      otherTaxCredit: otherTaxCredit ?? this.otherTaxCredit,

      ///not editable fields
      childTaxCredit: childTaxCredit,
      childAndDependentCareCredit: childAndDependentCareCredit,
      totalEligibleChildcareExpenses: totalEligibleChildcareExpenses,
    );
  }

  @override
  String toString() {
    return 'TaxCredits :\n {\tchildTaxCredit: $childTaxCredit,\n\tchildAndDependentCareCredit: $childAndDependentCareCredit,\n\ttotalEligibleChildcareExpenses: $totalEligibleChildcareExpenses,\n\tenergyCredit: $energyCredit,\n\telectricVehicleCredit: $electricVehicleCredit,\n\totherTaxCredit: $otherTaxCredit\n}';
  }

  @override
  List<Object> get props => [
        childTaxCredit,
        childAndDependentCareCredit,
        totalEligibleChildcareExpenses,
        energyCredit,
        electricVehicleCredit,
        otherTaxCredit,
      ];
}
