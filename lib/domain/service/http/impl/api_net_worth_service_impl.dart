import 'package:burgundy_budgeting_app/domain/model/request/net_worth_node_request.dart';
import 'package:burgundy_budgeting_app/domain/network/http_manager.dart';
import 'package:burgundy_budgeting_app/domain/service/http/api_net_worth_service.dart';
import 'package:burgundy_budgeting_app/utils/logger.dart';
import 'package:dio/src/response.dart';
import 'package:logger/logger.dart';

class ApiNetWorthServiceImpl extends ApiNetWorthService {
  final String getAnnualNetWorthEndpoint = '/asset/get-annual-net-worth';
  final String nodeNetWorthEndpoint = '/asset/node';

  final Logger logger = getLogger('ApiNetWorthServiceImpl');

  final HttpManager httpManager;

  ApiNetWorthServiceImpl(this.httpManager) : super(httpManager);

  @override
  Future<Response> fetchNetWorth( int year) async {
    return await httpManager.dio.post(
      getAnnualNetWorthEndpoint,
      data: {'year': year},
    );
  }

  @override
  Future<Response> node(NetWorthNodeRequest request) async {
    return await httpManager.dio.post(
      nodeNetWorthEndpoint,
      data: request.toJson(),
    );
  }
}
