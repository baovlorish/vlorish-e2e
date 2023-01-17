import 'package:burgundy_budgeting_app/domain/model/request/net_worth_node_request.dart';
import 'package:burgundy_budgeting_app/domain/network/http_manager.dart';
import 'package:dio/dio.dart';

abstract class ApiNetWorthService {
  ApiNetWorthService(HttpManager httpManager);

  Future<Response> fetchNetWorth( int year);

  Future<Response> node(NetWorthNodeRequest request);
}
