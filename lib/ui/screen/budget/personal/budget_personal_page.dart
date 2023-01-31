import 'package:burgundy_budgeting_app/core/di_provider.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/home_screen/home_page.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/home_screen/home_screen_cubit.dart';
import 'package:burgundy_budgeting_app/ui/screen/budget/budget_bloc.dart';
import 'package:burgundy_budgeting_app/ui/screen/budget/budget_layout.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BudgetPersonalPage {
  static const String routeName = '/budget_personal';

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
                child: Builder(builder: (context) {
                  return HomePage(
                    innerBlocProvider: BlocProvider<BudgetBloc>(
                      create: (_) => BudgetBloc(
                        diContractor.budgetRepository,
                        diContractor.categoryRepository,
                        diContractor.accountsTransactionsRepository,
                        isPersonal: true,
                        isRegistrationStepsCompleted:
                            BlocProvider.of<HomeScreenCubit>(context)
                                    .user
                                    .registrationStep ==
                                8,
                      ),
                      child: BudgetLayout(isPersonal: true),
                    ),
                    title: AppLocalizations.of(context)!.personalBudget,
                  );
                }),
              )
            : defaultRoute;
      },
    );

    router.define(routeName, handler: handler);
  }
}
