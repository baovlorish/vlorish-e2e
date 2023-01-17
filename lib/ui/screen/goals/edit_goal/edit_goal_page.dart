import 'package:burgundy_budgeting_app/core/di_provider.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/home_screen/home_page.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/home_screen/home_screen_cubit.dart';
import 'package:burgundy_budgeting_app/ui/model/goal.dart';
import 'package:burgundy_budgeting_app/ui/screen/goals/add_goal/add_goal_cubit.dart';
import 'package:burgundy_budgeting_app/ui/screen/goals/add_goal/add_goal_layout.dart';
import 'package:burgundy_budgeting_app/ui/screen/goals/goals/goals_cubit.dart';
import 'package:burgundy_budgeting_app/ui/screen/goals/goals/goals_layout.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EditGoalPage {
  static const String routeName = '/edit_goal';

  static void initRoute(FluroRouter router, UserContractor diContractor,
      {required Widget defaultRoute}) {
    var handler = Handler(
        handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
      if (diContractor.authRepository.sessionExists()) {
        if (context != null) {
          final goal = context.settings?.arguments as Goal?;
//
          if (goal == null) {
            return BlocProvider<HomeScreenCubit>(
              create: (_) => HomeScreenCubit(
                diContractor.authRepository,
                diContractor.userRepository,
                diContractor.subscriptionRepository,
              ),
              child: HomePage(
                innerBlocProvider: BlocProvider<GoalsCubit>(
                  lazy: false,
                  create: (_) => GoalsCubit(diContractor.goalsRepository),
                  child: GoalsLayout(),
                ),
                title: AppLocalizations.of(context)!.goals,
              ),
            );
          } else {
            return BlocProvider<HomeScreenCubit>(
              create: (_) => HomeScreenCubit(
                diContractor.authRepository,
                diContractor.userRepository,
                diContractor.subscriptionRepository,
              ),
              child: HomePage(
                innerBlocProvider: BlocProvider<AddGoalCubit>(
                  lazy: false,
                  child: AddGoalLayout(editedGoal: goal),
                  create: (_) => AddGoalCubit(diContractor.goalsRepository),
                ),
                title: AppLocalizations.of(context)!.editGoal,
              ),
            );
          }
        }
      } else {
        return defaultRoute;
      }
    });

    router.define(routeName, handler: handler);
  }
}
