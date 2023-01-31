import 'package:burgundy_budgeting_app/domain/model/response/index_funds_response.dart';
import 'package:burgundy_budgeting_app/domain/model/response/retirements_models.dart';
import 'package:burgundy_budgeting_app/domain/network/http_manager.dart';
import 'package:dio/dio.dart';

abstract class ApiInvestmentsService {
  ApiInvestmentsService(HttpManager httpManager);

  Future<Response> getInvestment(InvestmentGroup investmentGroup);

  Future<Response> getInvestmentsDashboardData();

  Future<Response> addInvestment(InvestmentModel model);

  Future<Response> getInvestmentWithTransactions(InvestmentModel model);

  Future<Response> deleteInvestmentById(
      InvestmentModel model, DateTime? sellDate, bool removeHistory);

  Future<Response> addTransactionsToInvestmentById(InvestmentModel model);

  Future<Response> getRetirements();

  Future<Response> addRetirement(RetirementModel model);

  Future<Response> deleteRetirementById(
      RetirementModel model, DateTime? sellDate, bool removeHistory);

  Future<Response> updateRetirementById(RetirementModel model);

  Future<Response> getRetirementById(String id);
}
