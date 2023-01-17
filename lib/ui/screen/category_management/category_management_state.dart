import 'package:burgundy_budgeting_app/ui/model/category_management_page_model.dart';
import 'package:equatable/equatable.dart';

abstract class CategoryManagementState extends Equatable {
  const CategoryManagementState();
}

class CategoryManagementInitial extends CategoryManagementState {
  CategoryManagementInitial();

  @override
  List<Object?> get props => [];
}

class CategoryManagementLoading extends CategoryManagementState {
  CategoryManagementLoading();

  @override
  List<Object?> get props => [];
}

class CategoryManagementLoaded extends CategoryManagementState {
  final CategoryManagementPageModel model;

  CategoryManagementLoaded(this.model);

  @override
  List<Object?> get props => [model];
}

class CategoryManagementError extends CategoryManagementState {
  final String error;

  CategoryManagementError(this.error);

  @override
  List<Object?> get props => [error];
}
