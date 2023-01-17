import 'package:burgundy_budgeting_app/core/di_provider.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/home_screen/home_page.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/home_screen/home_screen_cubit.dart';
import 'package:burgundy_budgeting_app/ui/screen/goals/goals/goals_cubit.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'goals_layout.dart';

class GoalsPage {
  static const String routeName = '/goals';

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
                    lazy: false,
                    create: (_) => GoalsCubit(diContractor.goalsRepository),
                    child: GoalsLayout(),
                  ),
                  title: AppLocalizations.of(context!)!.goals,
                ),
              )
            : defaultRoute;
      },
    );
    router.define(routeName, handler: handler);
  }
}
