import 'package:burgundy_budgeting_app/domain/model/request/debt_node_balance_request.dart';
import 'package:burgundy_budgeting_app/domain/model/request/get_debt_request.dart';
import 'package:burgundy_budgeting_app/domain/model/request/node_interest_amount_request.dart';
import 'package:burgundy_budgeting_app/domain/model/request/node_total_amount_request.dart';
import 'package:burgundy_budgeting_app/domain/network/http_manager.dart';
import 'package:dio/dio.dart';

abstract class ApiDebtsService {
  ApiDebtsService(HttpManager httpManager);

  Future<Response> getDebts(DebtsPageModelRequest request);

  Future<Response> nodeInterestAmount(NodeInterestAmountRequest request);

  Future<Response> nodeTotalAmount(NodeTotalAmountRequest request);

  Future<Response> nodeBalance(NodeBalanceRequest request);
}
