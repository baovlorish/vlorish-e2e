import 'package:burgundy_budgeting_app/domain/network/http_manager.dart';
import 'package:burgundy_budgeting_app/ui/model/tax_credits_and_adjustment_model.dart';
import 'package:burgundy_budgeting_app/ui/model/tax_income_details_model.dart';
import 'package:burgundy_budgeting_app/ui/model/tax_personal_info_model.dart';
import 'package:dio/dio.dart';

abstract class ApiTaxService {
  final HttpManager httpManager;

  ApiTaxService(this.httpManager);

  Future<Response<dynamic>> getEstimationStage(int year);

  Future<Response<dynamic>> getPersonalInfo(int year);

  Future<Response<dynamic>> setPersonalInfo(
      TaxPersonalInfoModel personalInfoModel);

  Future<Response<dynamic>> getIncomeDetails(int year);

  Future<Response<dynamic>> setIncomeDetails(
      TaxIncomeDetailsModel incomeDetailsModel);

  Future<Response<dynamic>> createTaxDetails(int year);

  Future<Response<dynamic>> getCreditsAndAdjustment(int year);

  Future<Response<dynamic>> setCreditsAndAdjustment(
      TaxCreditsAndAdjustmentModel creditsAndAdjustmentModel);

  Future<Response<dynamic>> getStudentInterestPaid(
      int studentLoanInterestPaid, int year);

  Future<Response<dynamic>> getChildAndDependentCareCredit(
    IncomeAdjustments incomeAdjustments,
    int totalEligibleChildcareExpenses,
    int year,
  );

  Future<Response<dynamic>> getEstimatedTaxes(int year, bool isFICAIncluded);
}
