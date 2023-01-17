import 'package:burgundy_budgeting_app/core/di_provider.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/home_screen/home_page.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/home_screen/home_screen_cubit.dart';
import 'package:burgundy_budgeting_app/ui/screen/goals/goals/goals_cubit.dart';
import 'package:burgundy_budgeting_app/ui/screen/goals/goals/goals_layout.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ArchivedGoalsPage {
  static const String routeName = '/archived_goals';

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
                  innerBlocProvider: BlocProvider<GoalsCubit>(
                    create: (_) => GoalsCubit(diContractor.goalsRepository,
                        isArchived: true),
                    child: GoalsLayout(isArchived: true),
                  ),
                  title: AppLocalizations.of(context!)!.archivedGoals,
                ),
              )
            : defaultRoute;
      },
    );
    router.define(routeName, handler: handler);
  }
}
