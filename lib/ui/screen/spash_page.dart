/*
import 'package:burgundy_budgeting_app/core/di_provider.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/home_screen/home_page.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/home_screen/home_screen_cubit.dart';
import 'package:burgundy_budgeting_app/ui/screen/auth/signin/signin_cubit.dart';
import 'package:burgundy_budgeting_app/ui/screen/auth/signin/signin_layout.dart';
import 'package:burgundy_budgeting_app/ui/screen/budget/personal/budget_personal_cubit.dart';
import 'package:burgundy_budgeting_app/ui/screen/budget/personal/budget_personal_layout.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SplashScreen {
  static const String routeName = '/';

  static void initRoute(FluroRouter router, UserContractor diContractor) {
    var rootHandler = Handler(handlerFunc:
        (BuildContext? context, Map<String, List<String>> parameters) {
      return diContractor.authRepository.sessionExists()
          ? BlocProvider<HomeScreenCubit>(
              create: (_) => HomeScreenCubit(
                diContractor.authRepository,
                diContractor.userRepository,
                diContractor.subscriptionRepository,
              ),
              child: HomePage(
                innerBlocProvider: BlocProvider<BudgetPersonalCubit>(
                  create: (_) => BudgetPersonalCubit(
                    diContractor.budgetRepository,
                    diContractor.categoryRepository,
                    diContractor.accountsTransactionsRepository,
                  ),
                  child: BudgetPersonalLayout(),
                ),
                title: AppLocalizations.of(context!)!.personalBudget,
              ),
            )
          : BlocProvider<SigninCubit>(
              create: (_) => SigninCubit(diContractor.authRepository),
              child: SigninLayout(),
            );
    });
    router.define(routeName, handler: rootHandler);
  }
}
*/
