import 'package:burgundy_budgeting_app/core/navigator_manager.dart';
import 'package:burgundy_budgeting_app/domain/model/request/post_add_goal_request.dart';
import 'package:burgundy_budgeting_app/domain/repository/goals_repository.dart';
import 'package:burgundy_budgeting_app/ui/screen/goals/add_goal/add_goal_state.dart';
import 'package:burgundy_budgeting_app/ui/screen/goals/goals/goals_page.dart';
import 'package:burgundy_budgeting_app/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

class AddGoalCubit extends Cubit<AddGoalState> {
  final Logger logger = getLogger('AddGoalCubit');

  AddGoalCubit(this.repository) : super(AddGoalInitial()) {
    logger.i('Add Goal Page');
  }

  final GoalsRepository repository;

  void navigateToGoalsPage(BuildContext context) {
    NavigatorManager.navigateTo(context, GoalsPage.routeName, replace: true);
  }

  Future<void> addGoal(
    BuildContext context, {
    required String name,
    required int targetAmount,
    required String targetDate,
    int? fundedAmount,
    String? note,
    String? icon,
    String? startDate,
  }) async {
    try {
      emit(AddGoalLoading());
      await repository.addGoal(
        PostAddGoalRequest(
          name: name,
          targetAmount: targetAmount,
          targetDate: targetDate,
          fundedAmount: fundedAmount,
          note: note,
          icon: icon,
          startDate: startDate,
        ),
      );
      navigateToGoalsPage(context);
    } catch (e) {
      emit(AddGoalError(e.toString()));
      rethrow;
    }
  }

  Future<void> deleteGoal(BuildContext context, String id) async {
    try {
      await repository.deleteGoal(id);
      navigateToGoalsPage(context);
    } catch (e) {
      emit(AddGoalError(e.toString()));
      rethrow;
    }
  }

  Future<void> archiveGoal(BuildContext context, String id) async {
    try {
      await repository.archiveGoal(id);
      navigateToGoalsPage(context);
    } catch (e) {
      emit(AddGoalError(e.toString()));
      rethrow;
    }
  }

  Future<void> updateGoal(
    BuildContext context, {
    required String id,
    required String name,
    required int targetAmount,
    required String targetDate,
    int? fundedAmount,
    String? note,
    String? icon,
    String? startDate,
  }) async {
    try {
      emit(AddGoalLoading());
      await repository.updateGoal(
        PostAddGoalRequest(
          id: id,
          name: name,
          targetAmount: targetAmount,
          targetDate: targetDate,
          fundedAmount: fundedAmount,
          note: note,
          icon: icon,
          startDate: startDate,
        ),
      );
      navigateToGoalsPage(context);
    } catch (e) {
      emit(AddGoalError(e.toString()));
      rethrow;
    }
  }
}
