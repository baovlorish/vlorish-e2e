import 'package:burgundy_budgeting_app/domain/model/response/index_funds_response.dart';
import 'package:burgundy_budgeting_app/domain/model/response/retirements_models.dart';
import 'package:burgundy_budgeting_app/domain/network/http_manager.dart';
import 'package:burgundy_budgeting_app/domain/service/http/api_investments_service.dart';
import 'package:dio/dio.dart';

class ApiInvestmentsServiceImpl extends ApiInvestmentsService {
  final String investmentsEndpoint = '/investments';

  final String overviewEndpoint = '/overview';

  ///Need to add { id } in the end.
  final String availableEndpoint = '/available';

  final String attachEndpointEndPart = '/attach';

  final String retirementsEndpoint = '/retirements';
  final String postAvailableAttachEndpointEndPart = '/attach';

  final HttpManager httpManager;

  ApiInvestmentsServiceImpl(this.httpManager) : super(httpManager);

  /// backed enum
  /// 0 - None,
  /// 1 - Stocks,
  /// 2 - RealEstate,
  /// 3 - IndexFunds,
  /// 4 - Cryptocurrency,
  /// 5 - StartUp,
  /// 6 - Other;
  int investToBackendEnumTransform(InvestmentGroup tab) {
    return tab.index + 1;
  }

  @override
  Future<Response> getInvestment(InvestmentGroup investmentGroup) async {
    return await httpManager.dio.get(investmentsEndpoint +
        '?type=' +
        investToBackendEnumTransform(investmentGroup).toString());
  }

  @override
  Future<Response> getInvestmentsDashboardData() async {
    return await httpManager.dio.get(investmentsEndpoint + overviewEndpoint);
  }

  @override
  Future<Response> addInvestment(InvestmentModel model) async {
    var response =
        await httpManager.dio.post(investmentsEndpoint, data: model.toJson());
    return response;
  }

  @override
  Future<Response> getInvestmentWithTransactions(InvestmentModel model) async {
    return await httpManager.dio.get(investmentsEndpoint + '/' + model.id!);
  }

  @override
  Future<Response> deleteInvestmentById(
    InvestmentModel model,
    DateTime? sellDate,
    bool removeHistory,
  ) async {
    return await httpManager.dio.delete(investmentsEndpoint + '/' + model.id!,
        data: model.deleteInvestmentByIdToJson(
            sellDate: sellDate?.toIso8601String(),
            removeHistory: removeHistory));
  }

  @override
  Future<Response> addTransactionsToInvestmentById(
      InvestmentModel model) async {
    return await httpManager.dio
        .put(investmentsEndpoint + '/' + model.id!, data: model.toJson());
  }

  @override
  Future<Response> addRetirement(RetirementModel model) async {
    return await httpManager.dio
        .post(retirementsEndpoint, data: model.toJson());
  }

  @override
  Future<Response> deleteRetirementById(
      RetirementModel model, DateTime? sellDate, bool removeHistory) async {
    return await httpManager.dio.delete(retirementsEndpoint + '/${model.id}',
        data: model.deleteInvestmentByIdToJson(
            sellDate: sellDate?.toIso8601String(),
            removeHistory: removeHistory));
  }

  @override
  Future<Response> getRetirements() async {
    return await httpManager.dio.get(retirementsEndpoint);
  }

  @override
  Future<Response> updateRetirementById(RetirementModel model) async {
    return await httpManager.dio
        .put(retirementsEndpoint + '/${model.id}', data: model.toJson());
  }

  @override
  Future<Response> getRetirementById(String id) async {
    return await httpManager.dio.get(retirementsEndpoint + '/$id');
  }
}
