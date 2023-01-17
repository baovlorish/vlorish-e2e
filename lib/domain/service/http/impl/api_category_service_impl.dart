import 'package:burgundy_budgeting_app/domain/network/http_manager.dart';
import 'package:burgundy_budgeting_app/domain/service/http/api_category_service.dart';
import 'package:dio/dio.dart';

class ApiCategoryServiceImpl implements ApiCategoryService {
  final HttpManager httpManager;
  final String categoryEndpoint = '/category';
  final String hideEndpoint = '/category/hide';
  final String unHideEndpoint = '/category/unhide';

  ApiCategoryServiceImpl(this.httpManager);

  @override
  Future<Response> getCategories() {
    return httpManager.dio.get(
      categoryEndpoint,
    );
  }

  @override
  Future<Response> hideCategory(
      {required String categoryIdToHide, String? categoryIdToMapTransactions}) {
    return httpManager.dio.post(hideEndpoint, data: {
      'categoryIdToHide': categoryIdToHide,
      'categoryIdToMapTransactions': categoryIdToMapTransactions,
    });
  }

  @override
  Future<Response> unHideCategory(String id) {
    return httpManager.dio.post(unHideEndpoint, data: {
      'categoryIdToUnhide': id,
    });
  }
}
