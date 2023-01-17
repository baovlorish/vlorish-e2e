import 'package:burgundy_budgeting_app/domain/model/response/index_funds_response.dart';
import 'package:burgundy_budgeting_app/domain/model/response/retirements_models.dart';
import 'package:burgundy_budgeting_app/domain/network/http_manager.dart';
import 'package:burgundy_budgeting_app/domain/service/http/api_investments_service.dart';
import 'package:dio/dio.dart';

class ApiInvestmentsServiceImpl extends ApiInvestmentsService {
  final String postIndexFunds = '/indexfunds';
  final String investmentsEndpoint = '/investments';
  final String postStocks = '/stocks';
  final String postProperties = '/properties';
  final String postStartUps = '/startups';
  final String postCryptocurrencies = '/cryptocurrencies';
  final String postOtherInvestments = '/otherinvestments';

  ///Need to add { id } in the end.
  final String getIndexFundsEndpoint = '/indexfunds/';
  final String getStocksEndpoint = '/stocks/';
  final String getStartUpsEndpoint = '/startups/';
  final String getCryptocurrenciesEndpoint = '/cryptocurrencies/';
  final String getOtherInvestmentsEndpoint = '/otherinvestments/';

  ///Need to add { id } in the end.
  final String availableEndpoint = '/available';

  final String attachEndpointEndPart = '/attach';

  final String retirementsEndpoint = '/retirements';
  final String postAvailableAttachEndpointEndPart = '/attach';

  final HttpManager httpManager;

  ApiInvestmentsServiceImpl(this.httpManager) : super(httpManager);

  @override
  Future<Response> getInvestment(InvestmentGroup investmentGroup) async {
    return await httpManager.dio.get(endpointSelector(investmentGroup));
  }

  @override
  Future<Response> getInvestmentsDashboardData() async {
    return await httpManager.dio.get(investmentsEndpoint);
  }

  @override
  Future<Response> addInvestment(InvestmentModel model) async {
    var response = await httpManager.dio
        .post(endpointSelector(model.investmentGroup), data: model.toJson());
    return response;
  }

  @override
  Future<Response> getInvestmentWithTransactions(InvestmentModel model) async {
    return await httpManager.dio
        .get(endpointSelector(model.investmentGroup) + model.id!);
  }

  @override
  Future<Response> deleteInvestmentById(
    InvestmentModel model,
    DateTime? sellDate,
    bool removeHistory,
  ) async {
    return await httpManager.dio.delete(
        endpointSelector(model.investmentGroup) + model.id!,
        data: model.deleteInvestmentByIdToJson(
            sellDate: sellDate?.toIso8601String(),
            removeHistory: removeHistory));
  }

  @override
  Future<Response> addTransactionsToInvestmentById(
      InvestmentModel model) async {
    return await httpManager.dio.put(
        endpointSelector(model.investmentGroup) + model.id!,
        data: model.toJson());
  }

  @override
  Future<Response> getAvailableInvestment(
      InvestmentGroup investmentGroup) async {
    return await httpManager.dio
        .get(endpointSelector(investmentGroup) + availableEndpoint);
  }

  @override
  Future<Response> availableInvestmentAttach(InvestmentGroup investmentGroup,
      List<AttachInvestmentRetirementModel> attachModel) async {
    var jsonAttachList = <Map>[];
    attachModel.forEach((element) {
      jsonAttachList.add(element.toJson());
    });
    return await httpManager.dio.post(
        endpointSelector(investmentGroup) + postAvailableAttachEndpointEndPart,
        data: {'items': jsonAttachList});
  }

  String endpointSelector(InvestmentGroup investmentGroup) {
    switch (investmentGroup) {
      case InvestmentGroup.IndexFunds:
        return postIndexFunds + '/';
      case InvestmentGroup.Stocks:
        return postStocks + '/';
      case InvestmentGroup.RealEstate:
        return postProperties + '/';
      case InvestmentGroup.StartUps:
        return postStartUps + '/';
      case InvestmentGroup.Cryptocurrencies:
        return postCryptocurrencies + '/';
      case InvestmentGroup.OtherInvestments:
        return postOtherInvestments + '/';
    }
  }

  @override
  Future<Response> addRetirement(RetirementModel model) async {
    return await httpManager.dio
        .post(retirementsEndpoint, data: model.toJson());
  }

  @override
  Future<Response> availableRetirementAttach(
      List<Map<String, dynamic>> items) async {
    return await httpManager.dio.post(
        retirementsEndpoint + attachEndpointEndPart,
        data: {'items': items});
  }

  @override
  Future<Response> deleteRetirementById(
      RetirementModel model, DateTime? sellDate, bool removeHistory) async {
    return await httpManager.dio.delete(
        retirementsEndpoint + '/${model.id}',
        data: model.deleteInvestmentByIdToJson(
            sellDate: sellDate?.toIso8601String(),
            removeHistory: removeHistory));
  }

  @override
  Future<Response> getAvailableRetirements(int type) async {
    return await httpManager.dio
        .get(retirementsEndpoint + availableEndpoint + '/$type');
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
