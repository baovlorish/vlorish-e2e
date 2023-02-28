import 'package:burgundy_budgeting_app/ui/model/tax_credits_and_adjustment_model.dart';
import 'package:burgundy_budgeting_app/ui/model/tax_estimated_taxes_model.dart';
import 'package:burgundy_budgeting_app/ui/model/tax_income_details_model.dart';
import 'package:burgundy_budgeting_app/ui/model/tax_personal_info_model.dart';
import 'package:burgundy_budgeting_app/ui/screen/tax/tax_cubit.dart';
import 'package:equatable/equatable.dart';

abstract class TaxState extends Equatable {
  const TaxState();
}

class TaxInitial extends TaxState {
  TaxInitial();

  @override
  List<Object?> get props => [];
}

class TaxLoading extends TaxState {
  TaxLoading();

  @override
  List<Object?> get props => [];
}

class TaxError extends TaxState {
  final String message;

  TaxError(this.message);

  @override
  List<Object?> get props => [message];
}

class TaxLoaded extends TaxState {
  final EstimatedTaxesModel? estimatedTaxesModel;
  final TaxTab currentEstimationTab;
  final TaxPersonalInfoModel? personalInfoModel;
  final TaxIncomeDetailsModel? incomeDetailsModel;
  final TaxCreditsAndAdjustmentModel? creditsAndAdjustmentModel;

  TaxLoaded({
    required this.currentEstimationTab,
    this.estimatedTaxesModel,
    this.personalInfoModel,
    this.incomeDetailsModel,
    this.creditsAndAdjustmentModel,
  });

  @override
  List<Object?> get props => [
    currentEstimationTab,
    estimatedTaxesModel,
    personalInfoModel,
    incomeDetailsModel,
    creditsAndAdjustmentModel
  ];

  TaxLoaded copyWith({
    EstimatedTaxesModel? estimatedTaxesModel,
    TaxTab? currentEstimationTab,
    TaxPersonalInfoModel? personalInfoModel,
    TaxIncomeDetailsModel? incomeDetailsModel,
    TaxCreditsAndAdjustmentModel? creditsAndAdjustmentModel,
  }) =>
      TaxLoaded(
        currentEstimationTab: currentEstimationTab ?? this.currentEstimationTab,
        estimatedTaxesModel: estimatedTaxesModel ?? this.estimatedTaxesModel,
        personalInfoModel: personalInfoModel ?? this.personalInfoModel,
        incomeDetailsModel: incomeDetailsModel ?? this.incomeDetailsModel,
        creditsAndAdjustmentModel:
        creditsAndAdjustmentModel ?? this.creditsAndAdjustmentModel,
      );
}