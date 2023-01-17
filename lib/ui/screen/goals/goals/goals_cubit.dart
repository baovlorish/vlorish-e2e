import 'dart:math';

import 'package:burgundy_budgeting_app/core/navigator_manager.dart';
import 'package:burgundy_budgeting_app/domain/repository/goals_repository.dart';
import 'package:burgundy_budgeting_app/ui/model/goal.dart';
import 'package:burgundy_budgeting_app/ui/screen/goals/add_goal/add_goal_page.dart';
import 'package:burgundy_budgeting_app/ui/screen/goals/archived_goals/archived_goals_page.dart';
import 'package:burgundy_budgeting_app/ui/screen/goals/edit_goal/edit_goal_page.dart';
import 'package:burgundy_budgeting_app/ui/screen/goals/goals/goals_page.dart';
import 'package:burgundy_budgeting_app/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:logger/logger.dart';

import 'goals_state.dart';

class GoalsCubit extends Cubit<GoalsState> {
  final Logger logger = getLogger('GoalsCubit');

  final GoalsRepository repository;

  final bool isArchived;

  GoalsCubit(this.repository, {this.isArchived = false})
      : super(GoalsInitial()) {
    logger.i('Goals Page');
    if (isArchived) {
      getArchivedGoals();
    } else {
      getActiveGoals();
    }
  }

  List<int> availableYears(List<Goal> goals) {
    var years = <int>{};
    if (goals.isNotEmpty) {
      goals.forEach((element) {
        years.add(element.endDate.year);
        years.add(element.startDate.year);
      });
      var minimumYear = years.reduce(min);
      var maximumYear = years.reduce(max);

      var currentYear = DateTime.now().year;

      if (minimumYear > currentYear) {
        minimumYear = currentYear;
      } else if (maximumYear < currentYear) {
        maximumYear = currentYear;
      }

      var list = [for (int i = minimumYear; i <= maximumYear; i++) i];

      return list;
    } else {
      return [];
    }
  }

  Map<int, List<Goal>> mapGoalsByYears(List<Goal> goals) {
    var years = availableYears(goals);

    if (years.isNotEmpty) {
      var map = <int, List<Goal>>{};

      years.forEach((year) {
        map[year] = goals
            .where((goal) =>
                year <= goal.endDate.year && year >= goal.startDate.year)
            .toList();
      });
      return map;
    } else {
      return {};
    }
  }

  Future<void> getGoals() async {
    try {
      emit(GoalsLoading());
      var goals = await repository.getGoals();
      emit(GoalsLoaded(
        goals: goals,
        goalsByYear: mapGoalsByYears(goals),
      ));
    } catch (e) {
      emit(GoalsErrorState(e.toString()));
      rethrow;
    }
  }

  Future<void> getActiveGoals() async {
    try {
      emit(GoalsLoading());
      var goals = await repository.getActiveGoals();
      emit(GoalsLoaded(
        goals: goals,
        goalsByYear: mapGoalsByYears(goals),
      ));
    } catch (e) {
      emit(GoalsErrorState(e.toString()));
      rethrow;
    }
  }

  Future<void> getArchivedGoals() async {
    try {
      emit(GoalsLoading());
      var goals = await repository.getArchivedGoals();
      emit(GoalsLoaded(
        goals: goals,
        goalsByYear: mapGoalsByYears(goals),
      ));
    } catch (e) {
      emit(GoalsErrorState(e.toString()));
      rethrow;
    }
  }

  Future<void> archiveGoal(String id) async {
    try {
      await repository.archiveGoal(id);
      await getActiveGoals();
    } catch (e) {
      emit(GoalsErrorState(e.toString(), callback: () async {
        await getActiveGoals();
      }));

      await getActiveGoals();
      rethrow;
    }
  }

  Future<void> unarchiveGoal(String id, Function showInformPopup) async {
    try {
      if (await canAddGoals() ?? false) {
        await repository.unarchiveGoal(id);
        await getArchivedGoals();
      } else {
        showInformPopup();
      }
    } catch (e) {
      emit(GoalsErrorState(e.toString(), callback: () async {
        await getArchivedGoals();
      }));

      await getArchivedGoals();
      rethrow;
    }
  }

  Future<bool?> canAddGoals() async {
    try {
      return await repository.canAddGoals();
    } catch (e) {
      emit(GoalsErrorState(e.toString(), callback: () {}));
      rethrow;
    }
  }

  void navigateToAddGoalPage(
      BuildContext context, Function showInformPopup) async {
    if (await canAddGoals() ?? false) {
      NavigatorManager.navigateTo(context, AddGoalPage.routeName);
    } else {
      showInformPopup();
    }
  }

  void navigateToEditGoalPage(BuildContext context, {required Goal goal}) {
    NavigatorManager.navigateTo(
      context,
      EditGoalPage.routeName,
      routeSettings: RouteSettings(
        arguments: goal,
      ),
    );
  }

  void navigateToArchivedGoals(BuildContext context) {
    NavigatorManager.navigateTo(
      context,
      ArchivedGoalsPage.routeName,
    );
  }

  void navigateToGoalsPage(BuildContext context) {
    NavigatorManager.navigateTo(
      context,
      GoalsPage.routeName,
      replace: true,
    );
  }
}
