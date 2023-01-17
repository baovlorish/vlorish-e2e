import 'package:burgundy_budgeting_app/domain/network/http_manager.dart';
import 'package:dio/dio.dart';

abstract class ApiCategoryService {
  ApiCategoryService(HttpManager httpManager);

  Future<Response> getCategories();

  Future<Response> hideCategory(
      {required String categoryIdToHide, String? categoryIdToMapTransactions});

  Future<Response> unHideCategory(String id);
}
