import 'package:burgundy_budgeting_app/core/navigator_manager.dart';
import 'package:burgundy_budgeting_app/domain/repository/category_repository.dart';
import 'package:burgundy_budgeting_app/ui/screen/budget/business/budget_business_page.dart';
import 'package:burgundy_budgeting_app/ui/screen/budget/personal/budget_personal_page.dart';
import 'package:burgundy_budgeting_app/ui/screen/category_management/category_management_state.dart';
import 'package:burgundy_budgeting_app/utils/logger.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

class CategoryManagementCubit extends Cubit<CategoryManagementState> {
  final Logger logger = getLogger('CategoryManagementCubit');
  final bool returnToPersonal;
  final CategoryRepository categoryRepository;

  CategoryManagementCubit(this.returnToPersonal, this.categoryRepository)
      : super(CategoryManagementInitial()) {
    logger.i('CategoryManagementCubit');
    emit(CategoryManagementLoading());
    fetchPageModel();
  }

  void navigateBack(BuildContext context) {
    NavigatorManager.navigateTo(
        context,
        returnToPersonal
            ? BudgetPersonalPage.routeName
            : BudgetBusinessPage.routeName,
        replace: true);
  }

  Future<void> fetchPageModel() async {
    try {
      var model = await categoryRepository.fetchCategoryManagement();
      emit(CategoryManagementLoaded(model));
    } catch (e) {
      emit(CategoryManagementError(e.toString()));
      rethrow;
    }
  }

  // if category had transactions, they are reassigned to new category
  Future<void> hideCategory(String id, {String? newCategoryId}) async {
    if (state is CategoryManagementLoaded) {
      var loadedState = state;
      try {
        var isSuccessful = await categoryRepository.hideCategory(
            categoryIdToHide: id, categoryIdToMapTransactions: newCategoryId);
        if (isSuccessful) {
          logger.i(
              'hide category $id${newCategoryId != null ? ', move transactions to $newCategoryId' : ''}');
          await fetchPageModel();
        } else {
          emit(CategoryManagementError(categoryRepository.generalErrorMessage));
          emit(loadedState);
        }
      } catch (e) {
        emit(CategoryManagementError(e.toString()));
        emit(loadedState);
        rethrow;
      }
    }
  }

  Future<void> unHideCategory(String id) async {
    if (state is CategoryManagementLoaded) {
      var loadedState = state;
      try {
        var isSuccessful = await categoryRepository.unHideCategory(id);
        if (isSuccessful) {
          logger.i('unHide category $id');
          await fetchPageModel();
        } else {
          emit(CategoryManagementError(categoryRepository.generalErrorMessage));
          emit(loadedState);
        }
      } catch (e) {
        emit(CategoryManagementError(e.toString()));
        emit(loadedState);
        rethrow;
      }
    }
  }
}
