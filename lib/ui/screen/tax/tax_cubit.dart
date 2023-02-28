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

  static const _taxPageStartYear = 2022;
  final _currentYear = DateTime.now().year;

  final TaxRepository taxRepository;
  EstimatedTaxesModel? estimatedTaxesModel;
  int? estimationStage;
  bool cubitFICAIncluded = false;

  late int _selectedYear = _currentYear;
  int get selectedYear => _selectedYear;

  late final _yearsList = <int>[for (var i = _taxPageStartYear; i <= _currentYear; i++) i];

  List<int> get yearsList => _yearsList;

  TaxCubit(this.taxRepository) : super(TaxInitial()) {
    logger.i('Tax Page');
    load();
  }

  Future<void> load() async {
    emit(TaxLoading());
    try {
      estimationStage = await taxRepository.getEstimationStage(selectedYear);

      if (estimationStage == TaxTab.Disclaimer.index) await taxRepository.createTaxDetails(selectedYear);
      if (estimationStage == TaxTab.Complete.index) estimatedTaxesModel = await getEstimatedTaxes(isFICAIncluded: cubitFICAIncluded);

      emit(TaxLoaded(
        currentEstimationTab: TaxTab.PersonalInfo,
        estimatedTaxesModel: estimatedTaxesModel,
        personalInfoModel: await taxRepository.getPersonalInfo(selectedYear),
      ));
    } catch (e) {
      emit(TaxError(e.toString()));
      rethrow;
    }
  }

  Future<void> createTaxDetails() async {
    if (estimationStage == TaxTab.Disclaimer.index) {
      await taxRepository.createTaxDetails(selectedYear);
      estimationStage = TaxTab.PersonalInfo.index;
    }
  }

  void changeEstimationTab(TaxTab tab) async {
    if (estimationStage! < tab.index) estimationStage = tab.index;
    var prevState = state;
    try {
      if (prevState is TaxLoaded) {
        switch (tab) {
          case TaxTab.Disclaimer:
            return await setPersonalInfoTab(prevState, selectedYear);
          case TaxTab.PersonalInfo:
            return await setPersonalInfoTab(prevState, selectedYear);
          case TaxTab.IncomeDetails:
            return await setIncomeDetailsTab(prevState, selectedYear);
          case TaxTab.CreditsAndAdjustment:
            return await setCreditsAndAdjustmentTab(prevState, selectedYear);
          case TaxTab.Complete:
            return await setPersonalInfoTab(prevState, selectedYear);

          default:
            return await setPersonalInfoTab(prevState, selectedYear);
        }
      }
    } catch (e) {
      emit(TaxError(e.toString()));
      emit(prevState);
      rethrow;
    }
  }

  Future<void> setPersonalInfoTab(TaxLoaded state, int selectedYear) async {
    var personalInfoModel = await taxRepository.getPersonalInfo(selectedYear);
    emit(state.copyWith(
      currentEstimationTab: TaxTab.PersonalInfo,
      personalInfoModel: personalInfoModel,
    ));
  }

  Future<void> setIncomeDetailsTab(TaxLoaded state, int selectedYear) async {
    var incomeDetailsModel = await taxRepository.getIncomeDetails(selectedYear);
    emit(state.copyWith(
      currentEstimationTab: TaxTab.IncomeDetails,
      incomeDetailsModel: incomeDetailsModel,
    ));
  }

  Future<void> setCreditsAndAdjustmentTab(TaxLoaded state, int selectedYear) async {
    var creditsAndAdjustmentModel = await taxRepository.getCreditsAndAdjustment(selectedYear);
    emit(state.copyWith(
      currentEstimationTab: TaxTab.CreditsAndAdjustment,
      creditsAndAdjustmentModel: creditsAndAdjustmentModel,
    ));
  }

  Future<void> updateIncomeDetails(TaxIncomeDetailsModel incomeDetailsModel) async {
    var prevState = state;
    try {
      await taxRepository.setIncomeDetails(incomeDetailsModel);
      if (prevState is TaxLoaded) {
        emit(prevState.copyWith(
            incomeDetailsModel: incomeDetailsModel,
            estimatedTaxesModel: await getEstimatedTaxes(isFICAIncluded: cubitFICAIncluded)));
      }
    } catch (e) {
      emit(TaxError(e.toString()));
      emit(prevState);
      rethrow;
    }
    if (estimationStage != TaxTab.Complete.index) changeEstimationTab(TaxTab.CreditsAndAdjustment);
  }

  Future<void> updatePersonalInfo(TaxPersonalInfoModel personalInfoModel) async {
    var prevState = state;
    try {
      await taxRepository.setPersonalInfo(personalInfoModel);
      if (prevState is TaxLoaded) {
        emit(prevState.copyWith(
            personalInfoModel: personalInfoModel,
            estimatedTaxesModel: await getEstimatedTaxes(isFICAIncluded: cubitFICAIncluded)));
      }
    } catch (e) {
      emit(TaxError(e.toString()));
      emit(prevState);
      rethrow;
    }
    if (estimationStage != TaxTab.Complete.index) changeEstimationTab(TaxTab.IncomeDetails);
  }

  Future<void> updateCreditsAndAdjustment(TaxCreditsAndAdjustmentModel creditsAndAdjustmentModel) async {
    var prevState = state;
    try {
      await taxRepository.setCreditsAndAdjustment(creditsAndAdjustmentModel);
      if (prevState is TaxLoaded) {
        emit(prevState.copyWith(
            estimatedTaxesModel: estimationStage == TaxTab.Complete.index
                ? await taxRepository.getEstimatedTaxes(selectedYear, cubitFICAIncluded)
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
      return await taxRepository.getStudentInterestPaid(studentLoanInterestPaid, selectedYear);
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
          incomeAdjustments, totalEligibleChildcareExpenses, selectedYear);
    } catch (e) {
      emit(TaxError(e.toString()));
      emit(prevState);
      rethrow;
    }
  }

  Future<EstimatedTaxesModel?> getEstimatedTaxes({required bool isFICAIncluded}) async {
    cubitFICAIncluded = isFICAIncluded;
    return estimationStage == TaxTab.Complete.index
        ? await taxRepository.getEstimatedTaxes(selectedYear, cubitFICAIncluded)
        : null;
  }

  Future<void> updateEstimatedTaxes({required bool isFICAIncluded}) async {
    var prevState = state;
    try {
      if (prevState is TaxLoaded) {
        emit(prevState.copyWith(estimatedTaxesModel: await getEstimatedTaxes(isFICAIncluded: isFICAIncluded)));
      }
    } catch (e) {
      emit(TaxError(e.toString()));
      emit(prevState);
      rethrow;
    }
  }

  Future<void> selectYear(int year) async {
    _selectedYear = year;
    await load();
  }
}

enum TaxTab {
  Disclaimer,
  PersonalInfo,
  IncomeDetails,
  CreditsAndAdjustment,
  Complete,
}
