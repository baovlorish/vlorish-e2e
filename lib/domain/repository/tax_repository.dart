import 'package:burgundy_budgeting_app/domain/error/custom_error.dart';
import 'package:burgundy_budgeting_app/domain/service/http/api_tax_service.dart';
import 'package:burgundy_budgeting_app/ui/model/tax_credits_and_adjustment_model.dart';
import 'package:burgundy_budgeting_app/ui/model/tax_estimated_taxes_model.dart';
import 'package:burgundy_budgeting_app/ui/model/tax_income_details_model.dart';
import 'package:burgundy_budgeting_app/ui/model/tax_personal_info_model.dart';

abstract class TaxRepository {
  Future<int> getEstimationStage(int year);

  Future<TaxPersonalInfoModel> getPersonalInfo(int year);

  Future<void> setPersonalInfo(TaxPersonalInfoModel personalInfoModel);

  Future<TaxIncomeDetailsModel> getIncomeDetails(int year);

  Future<void> setIncomeDetails(TaxIncomeDetailsModel incomeDetailsModel);

  Future<void> createTaxDetails(int year);

  Future<TaxCreditsAndAdjustmentModel> getCreditsAndAdjustment(int year);

  Future<void> setCreditsAndAdjustment(
      TaxCreditsAndAdjustmentModel creditsAndAdjustment);

  Future<int> getStudentInterestPaid(int studentLoanInterestPaid, int year);

  Future<double> getChildAndDependentCareCredit(
    IncomeAdjustments incomeAdjustments,
    int totalEligibleChildcareExpenses,
    int year,
  );

  Future<EstimatedTaxesModel> getEstimatedTaxes(int year, bool isFICAIncluded);
}

class TaxRepositoryImpl implements TaxRepository {
  final ApiTaxService _apiTaxService;
  final String generalErrorMessage = 'Sorry, something went wrong';

  TaxRepositoryImpl(this._apiTaxService);

  @override
  Future<int> getEstimationStage(int year) async {
    var response = await _apiTaxService.getEstimationStage(year);
    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      return response.data['taxEstimationStage'];
    } else if (response.data['message'] != null) {
      throw Exception(response.data['message']);
    } else {
      throw Exception(generalErrorMessage);
    }
  }

  @override
  Future<TaxIncomeDetailsModel> getIncomeDetails(int year) async {
    var response = await _apiTaxService.getIncomeDetails(year);
    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      return TaxIncomeDetailsModel.fromJson(response.data, year);
    } else {
      throw CustomException(response.data['message'] ?? generalErrorMessage);
    }
  }

  @override
  Future<TaxPersonalInfoModel> getPersonalInfo(int year) async {
    var response = await _apiTaxService.getPersonalInfo(year);
    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      return TaxPersonalInfoModel.fromJson(response.data, year);
    } else {
      throw CustomException(response.data['message'] ?? generalErrorMessage);
    }
  }

  @override
  Future<void> setIncomeDetails(
      TaxIncomeDetailsModel incomeDetailsModel) async {
    var response = await _apiTaxService.setIncomeDetails(incomeDetailsModel);
    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      return;
    } else {
      throw CustomException(response.data['message'] ?? generalErrorMessage);
    }
  }

  @override
  Future<void> setPersonalInfo(TaxPersonalInfoModel personalInfoModel) async {
    var response = await _apiTaxService.setPersonalInfo(personalInfoModel);
    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      return;
    } else {
      throw CustomException(response.data['message'] ?? generalErrorMessage);
    }
  }

  @override
  Future<void> createTaxDetails(int year) async {
    var response = await _apiTaxService.createTaxDetails(year);
    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      return;
    } else {
      throw CustomException(response.data['message'] ?? generalErrorMessage);
    }
  }

  @override
  Future<TaxCreditsAndAdjustmentModel> getCreditsAndAdjustment(int year) async {
    var response = await _apiTaxService.getCreditsAndAdjustment(year);
    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      return TaxCreditsAndAdjustmentModel.fromJson(response.data, year);
    } else {
      throw CustomException(response.data['message'] ?? generalErrorMessage);
    }
  }

  @override
  Future<void> setCreditsAndAdjustment(
      TaxCreditsAndAdjustmentModel creditsAndAdjustment) async {
    var response =
        await _apiTaxService.setCreditsAndAdjustment(creditsAndAdjustment);
    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      return;
    } else {
      throw CustomException(response.data['message'] ?? generalErrorMessage);
    }
  }

  @override
  Future<int> getStudentInterestPaid(
      int studentLoanInterestPaid, int year) async {
    var response = await _apiTaxService.getStudentInterestPaid(
        studentLoanInterestPaid, year);
    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      return response.data['studentInterestPaidDuringTheYear'];
    } else {
      throw CustomException(response.data['message'] ?? generalErrorMessage);
    }
  }

  @override
  Future<double> getChildAndDependentCareCredit(
      IncomeAdjustments incomeAdjustments,
      int totalEligibleChildcareExpenses,
      int year) async {
    var response = await _apiTaxService.getChildAndDependentCareCredit(
        incomeAdjustments, totalEligibleChildcareExpenses, year);
    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      return response.data['childAndDependentCareCredit'];
    } else {
      throw CustomException(response.data['message'] ?? generalErrorMessage);
    }
  }

  @override
  Future<EstimatedTaxesModel> getEstimatedTaxes(
      int year, bool isFICAIncluded) async {
    var response = await _apiTaxService.getEstimatedTaxes(year, isFICAIncluded);
    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      return EstimatedTaxesModel.fromJson(response.data);
    } else {
      throw CustomException(response.data['message'] ?? generalErrorMessage);
    }
  }
}
