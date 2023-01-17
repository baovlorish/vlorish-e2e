import 'package:burgundy_budgeting_app/domain/repository/tax_repository.dart';
import 'package:burgundy_budgeting_app/ui/model/tax_credits_and_adjustment_model.dart';
import 'package:burgundy_budgeting_app/ui/model/tax_estimated_taxes_model.dart';
import 'package:burgundy_budgeting_app/ui/model/tax_income_details_model.dart';
import 'package:burgundy_budgeting_app/ui/model/tax_personal_info_model.dart';
import 'package:burgundy_budgeting_app/ui/screen/tax/tax_state.dart';
import 'package:burgundy_budgeting_app/utils/logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

class TaxCubit extends Cubit<TaxState> {
  final Logger logger = getLogger('TaxCubit');
  final TaxRepository taxRepository;
  EstimatedTaxesModel? estimatedTaxesModel;
  int? estimationStage;
  var cubitFICAIncluded = false;
  int year = DateTime.now().year;

  TaxCubit(this.taxRepository) : super(TaxInitial()) {
    logger.i('Tax Page');
    load();
  }

  Future<void> load() async {
    try {
      estimationStage = await taxRepository.getEstimationStage(year);
      estimatedTaxesModel =
          await getEstimatedTaxes(isFICAIncluded: cubitFICAIncluded);
      changeEstimationTab(1);
    } catch (e) {
      emit(TaxError(e.toString()));
      rethrow;
    }
  }

  Future<void> createTaxDetails() async {
    if (estimationStage == 0) {
      await taxRepository.createTaxDetails(year);
      estimationStage = 1;
    }
  }

  void changeEstimationTab(int tab) async {
    await createTaxDetails();
    estimationStage = await taxRepository.getEstimationStage(year);
    estimatedTaxesModel =
        await getEstimatedTaxes(isFICAIncluded: cubitFICAIncluded);
    if (estimationStage! < tab) estimationStage = tab;
    var prevState = state;
    try {
      if (tab == 1) {
        var personalInfoModel = await taxRepository.getPersonalInfo(year);
        emit(TaxLoaded(
          currentEstimationTab: tab,
          personalInfoModel: personalInfoModel,
          estimatedTaxesModel: estimatedTaxesModel,
        ));
      } else if (tab == 2) {
        var incomeDetailsModel = await taxRepository.getIncomeDetails(year);
        emit(TaxLoaded(
          currentEstimationTab: tab,
          incomeDetailsModel: incomeDetailsModel,
          estimatedTaxesModel: estimatedTaxesModel,
        ));
      } else if (tab == 3) {
        var creditsAndAdjustmentModel =
            await taxRepository.getCreditsAndAdjustment(year);
        var personalInfoModel = await taxRepository.getPersonalInfo(year);

        emit(TaxLoaded(
            currentEstimationTab: tab,
            personalInfoModel: personalInfoModel,
            creditsAndAdjustmentModel: creditsAndAdjustmentModel,
            estimatedTaxesModel: estimatedTaxesModel));
      }
    } catch (e) {
      emit(TaxError(e.toString()));
      emit(prevState);
      rethrow;
    }
  }

  Future<void> updateIncomeDetails(
      TaxIncomeDetailsModel incomeDetailsModel) async {
    var prevState = state;
    try {
      await taxRepository.setIncomeDetails(incomeDetailsModel);
      if (prevState is TaxLoaded) {
        emit(prevState.copyWith(
            estimatedTaxesModel:
                await getEstimatedTaxes(isFICAIncluded: cubitFICAIncluded)));
      }
    } catch (e) {
      emit(TaxError(e.toString()));
      emit(prevState);
      rethrow;
    }
    if (estimationStage != 4) changeEstimationTab(3);
  }

  Future<void> updatePersonalInfo(
      TaxPersonalInfoModel personalInfoModel) async {
    var prevState = state;
    try {
      await taxRepository.setPersonalInfo(personalInfoModel);
      if (prevState is TaxLoaded) {
        emit(prevState.copyWith(
            estimatedTaxesModel:
                await getEstimatedTaxes(isFICAIncluded: cubitFICAIncluded)));
      }
    } catch (e) {
      emit(TaxError(e.toString()));
      emit(prevState);
      rethrow;
    }
    if (estimationStage != 4) changeEstimationTab(2);
  }

  Future<void> updateCreditsAndAdjustment(
      TaxCreditsAndAdjustmentModel creditsAndAdjustmentModel) async {
    var prevState = state;
    try {
      await taxRepository.setCreditsAndAdjustment(creditsAndAdjustmentModel);
      if (prevState is TaxLoaded) {
        emit(prevState.copyWith(
            estimatedTaxesModel: estimationStage == 4
                ? await taxRepository.getEstimatedTaxes(year, cubitFICAIncluded)
                : null));
      }
    } catch (e) {
      emit(TaxError(e.toString()));
      emit(prevState);
      rethrow;
    }
  }

  Future<int> getStudentInterestPaid(int studentLoanInterestPaid) async {
    var prevState = state;
    try {
      return await taxRepository.getStudentInterestPaid(
          studentLoanInterestPaid, year);
    } catch (e) {
      emit(TaxError(e.toString()));
      emit(prevState);
      rethrow;
    }
  }

  Future<int> getChildAndDependentCareCredit(
    IncomeAdjustments incomeAdjustments,
    int totalEligibleChildcareExpenses,
  ) async {
    var prevState = state;
    try {
      return await taxRepository.getChildAndDependentCareCredit(
          incomeAdjustments, totalEligibleChildcareExpenses, year);
    } catch (e) {
      emit(TaxError(e.toString()));
      emit(prevState);
      rethrow;
    }
  }

  Future<EstimatedTaxesModel?> getEstimatedTaxes(
      {required bool isFICAIncluded}) async {
    cubitFICAIncluded = isFICAIncluded;
    return estimationStage == 4
        ? await taxRepository.getEstimatedTaxes(year, cubitFICAIncluded)
        : null;
  }

  Future<void> updateEstimatedTaxes({required bool isFICAIncluded}) async {
    var prevState = state;
    try {
      if (prevState is TaxLoaded) {
        emit(prevState.copyWith(
            estimatedTaxesModel:
                await getEstimatedTaxes(isFICAIncluded: isFICAIncluded)));
      }
    } catch (e) {
      emit(TaxError(e.toString()));
      emit(prevState);
      rethrow;
    }
  }
}
