import 'package:burgundy_budgeting_app/domain/service/http/api_tax_service.dart';
import 'package:burgundy_budgeting_app/ui/model/tax_credits_and_adjustment_model.dart';
import 'package:burgundy_budgeting_app/ui/model/tax_income_details_model.dart';
import 'package:burgundy_budgeting_app/ui/model/tax_personal_info_model.dart';
import 'package:dio/dio.dart';

class ApiTaxServiceImpl extends ApiTaxService {
  final String estimationStageEndpoint = '/tax/get-estimation-stage';
  final String getPersonalInfoEndpoint = '/tax/personal-info/get';
  final String updatePersonalInfoEndpoint = '/tax/personal-info/update';
  final String getIncomeDetailsEndpoint = '/tax/income-details/get';
  final String updateIncomeDetailsEndpoint = '/tax/income-details/update';
  final String createTaxDetailsEndpoint = '/tax/create-tax-details';
  final String getCreditsAndAdjustmentEndpoint =
      '/tax/credits-and-adjustment/get';
  final String updateCreditsAndAdjustmentEndpoint =
      '/tax/credits-and-adjustment/update';
  final String getStudentInterestPaidEndpoint =
      '/tax/credits-and-adjustment/get-student-interest-paid';
  final String getChildAndDependentCareCreditEndpoint =
      '/tax/credits-and-adjustment/get-child-and-dependent-care-credit';
  final String getEstimatedTaxesEndpoint = '/tax/get-estimated-taxes';

  ApiTaxServiceImpl(super.httpManager);

  @override
  Future<Response<dynamic>> getEstimationStage(int year) async {
    return await httpManager.dio
        .post(estimationStageEndpoint, data: {'year': year});
  }

  @override
  Future<Response<dynamic>> getPersonalInfo(int year) async {
    return await httpManager.dio
        .post(getPersonalInfoEndpoint, data: {'year': year});
  }

  @override
  Future<Response<dynamic>> setPersonalInfo(
      TaxPersonalInfoModel personalInfoModel) async {
    return await httpManager.dio.post(
      updatePersonalInfoEndpoint,
      data: personalInfoModel.toJson(),
    );
  }

  @override
  Future<Response<dynamic>> getIncomeDetails(int year) async {
    return await httpManager.dio
        .post(getIncomeDetailsEndpoint, data: {'year': year});
  }

  @override
  Future<Response<dynamic>> setIncomeDetails(
      TaxIncomeDetailsModel incomeDetailsModel) async {
    return await httpManager.dio.post(
      updateIncomeDetailsEndpoint,
      data: incomeDetailsModel.toJson(),
    );
  }

  @override
  Future<Response> createTaxDetails(int year) async {
    return await httpManager.dio
        .post(createTaxDetailsEndpoint, data: {'year': year});
  }

  @override
  Future<Response<dynamic>> getCreditsAndAdjustment(int year) async {
    return await httpManager.dio
        .post(getCreditsAndAdjustmentEndpoint, data: {'year': year});
  }

  @override
  Future<Response<dynamic>> setCreditsAndAdjustment(
      TaxCreditsAndAdjustmentModel creditsAndAdjustmentModel) async {
    return await httpManager.dio.post(updateCreditsAndAdjustmentEndpoint,
        data: creditsAndAdjustmentModel.toJson());
  }

  @override
  Future<Response<dynamic>> getStudentInterestPaid(
      int studentLoanInterestPaid, int year) async {
    return await httpManager.dio.post(getStudentInterestPaidEndpoint, data: {
      'studentLoanInterestPaid': studentLoanInterestPaid,
      'year': year
    });
  }

  @override
  Future<Response<dynamic>> getChildAndDependentCareCredit(
    IncomeAdjustments incomeAdjustments,
    int totalEligibleChildcareExpenses,
    int year,
  ) async {
    return await httpManager.dio
        .post(getChildAndDependentCareCreditEndpoint, data: {
      'incomeAdjustments': incomeAdjustments.toJson(),
      'totalEligibleChildcareExpenses': totalEligibleChildcareExpenses,
      'year': year
    });
  }

  @override
  Future<Response<dynamic>> getEstimatedTaxes(
      int year, bool isFICAIncluded) async {
    return await httpManager.dio.post(getEstimatedTaxesEndpoint,
        data: {'year': year, 'isFICAIncluded': isFICAIncluded});
  }
}
