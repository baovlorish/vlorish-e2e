import 'package:burgundy_budgeting_app/domain/error/custom_error.dart';
import 'package:burgundy_budgeting_app/domain/service/http/api_category_service.dart';
import 'package:burgundy_budgeting_app/ui/model/category_management_page_model.dart';

abstract class CategoryRepository {
  abstract final String generalErrorMessage;

  CategoryRepository(ApiCategoryService categoryService);

  Future<CategoryManagementPageModel> fetchCategoryManagement();

  Future<bool> hideCategory(
      {required String categoryIdToHide, String? categoryIdToMapTransactions});

  Future<bool> unHideCategory(String id);
}

class CategoryRepositoryImpl implements CategoryRepository {
  @override
  final String generalErrorMessage = 'Sorry, something went wrong';

  final ApiCategoryService _categoryService;

  CategoryRepositoryImpl(
    this._categoryService,
  );

  @override
  Future<CategoryManagementPageModel> fetchCategoryManagement() async {
    var response = await _categoryService.getCategories();
    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      return CategoryManagementPageModel.fromJson(response.data);
    } else {
      throw CustomException(response.data['message'] ?? generalErrorMessage);
    }
  }

  @override
  Future<bool> hideCategory(
      {required String categoryIdToHide,
      String? categoryIdToMapTransactions}) async {
    var response = await _categoryService.hideCategory(
        categoryIdToHide: categoryIdToHide,
        categoryIdToMapTransactions: categoryIdToMapTransactions);
    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      return true;
    } else {
      throw CustomException(response.data['message'] ?? generalErrorMessage);
    }
  }

  @override
  Future<bool> unHideCategory(String id) async {
    var response = await _categoryService.unHideCategory(id);
    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      return true;
    } else {
      throw CustomException(response.data['message'] ?? generalErrorMessage);
    }
  }
}
