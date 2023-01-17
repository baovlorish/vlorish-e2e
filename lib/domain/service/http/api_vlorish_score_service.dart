import 'package:burgundy_budgeting_app/domain/network/http_manager.dart';
import 'package:dio/dio.dart';

abstract class ApiVlorishScoreService {
  ApiVlorishScoreService(HttpManager httpManager);

  Future<Response> getLast();
  Future<Response> refresh();
}
