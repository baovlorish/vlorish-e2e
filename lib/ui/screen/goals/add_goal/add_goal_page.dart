import 'package:burgundy_budgeting_app/core/di_provider.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/home_screen/home_page.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/home_screen/home_screen_cubit.dart';
import 'package:burgundy_budgeting_app/ui/screen/goals/add_goal/add_goal_cubit.dart';
import 'package:burgundy_budgeting_app/ui/screen/goals/add_goal/add_goal_layout.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddGoalPage {
  static const String routeName = '/add_goal';

  static void initRoute(FluroRouter router, UserContractor diContractor,
      {required Widget defaultRoute}) {
    var handler = Handler(
      handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
        return diContractor.authRepository.sessionExists()
            ? BlocProvider<HomeScreenCubit>(
                create: (_) => HomeScreenCubit(
                  diContractor.authRepository,
                  diContractor.userRepository,
                  diContractor.subscriptionRepository,
                ),
                child: HomePage(
                  innerBlocProvider: BlocProvider<AddGoalCubit>(
                    create: (_) => AddGoalCubit(diContractor.goalsRepository),
                    child: AddGoalLayout(),
                  ),
                  title: AppLocalizations.of(context!)!.addGoal,
                ),
              )
            : defaultRoute;
      },
    );
    router.define(routeName, handler: handler);
  }
}
