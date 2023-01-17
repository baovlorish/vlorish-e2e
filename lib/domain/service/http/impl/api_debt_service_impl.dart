import 'package:burgundy_budgeting_app/domain/model/request/debt_node_balance_request.dart';
import 'package:burgundy_budgeting_app/domain/model/request/get_debt_request.dart';
import 'package:burgundy_budgeting_app/domain/model/request/node_interest_amount_request.dart';
import 'package:burgundy_budgeting_app/domain/model/request/node_total_amount_request.dart';
import 'package:burgundy_budgeting_app/domain/network/http_manager.dart';
import 'package:burgundy_budgeting_app/domain/service/http/api_debt_service.dart';
import 'package:dio/dio.dart';

class ApiDebtsServiceImpl extends ApiDebtsService {
  final String getDebtsEndpoint = '/debt/get';
  final String nodeInterestAmountEndpoint = '/debt/node-interest-amount';
  final String nodeTotalAmountEndpoint = '/debt/node-total-amount';
  final String nodeBalanceEndpoint = '/debt/node-balance';

  final HttpManager httpManager;

  ApiDebtsServiceImpl(this.httpManager) : super(httpManager);

  @override
  Future<Response> getDebts(DebtsPageModelRequest request) async {
    return await httpManager.dio.post(
      getDebtsEndpoint,
      data: request.toJson(),
    );
  }

  @override
  Future<Response> nodeInterestAmount(NodeInterestAmountRequest request) async {
    return await httpManager.dio.post(
      nodeInterestAmountEndpoint,
      data: request.toJson(),
    );
  }

  @override
  Future<Response> nodeTotalAmount(NodeTotalAmountRequest request) async {
    return await httpManager.dio.post(
      nodeTotalAmountEndpoint,
      data: request.toJson(),
    );
  }

  @override
  Future<Response> nodeBalance(NodeBalanceRequest request) async {
    return await httpManager.dio.post(
      nodeBalanceEndpoint,
      data: request.toJson(),
    );
  }
}
