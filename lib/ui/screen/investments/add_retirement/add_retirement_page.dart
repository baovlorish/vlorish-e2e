import 'package:burgundy_budgeting_app/core/di_provider.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/home_screen/home_page.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/home_screen/home_screen_cubit.dart';
import 'package:burgundy_budgeting_app/ui/screen/investments/add_retirement/add_retirement_cubit.dart';
import 'package:burgundy_budgeting_app/ui/screen/investments/add_retirement/add_retirement_layout.dart';
import 'package:burgundy_budgeting_app/ui/screen/investments/investments/investments_cubit.dart';
import 'package:burgundy_budgeting_app/ui/screen/investments/investments/investments_layout.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddRetirementPage {
  static const String routeName = '/add_retirement';

  static void initRoute(FluroRouter router, UserContractor diContractor,
      {required Widget defaultRoute}) {
    var handler = Handler(
        handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
      var retirementType = context?.settings?.arguments as int?;

      if (diContractor.authRepository.sessionExists()) {
        if (retirementType == null) {
          return BlocProvider<HomeScreenCubit>(
            create: (_) => HomeScreenCubit(
              diContractor.authRepository,
              diContractor.userRepository,
              diContractor.subscriptionRepository,
            ),
            child: HomePage(
              innerBlocProvider: BlocProvider<InvestmentsCubit>(
                lazy: false,
                create: (_) => InvestmentsCubit(
                    diContractor.investmentRepository,
                    isRetirement: true,
                    retirementTab: retirementType),
                child: InvestmentsLayout(),
              ),
              title: AppLocalizations.of(context!)!.investments,
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
              innerBlocProvider: BlocProvider<AddRetirementCubit>(
                create: (_) => AddRetirementCubit(
                  diContractor.investmentRepository,
                  retirementType: retirementType,
                ),
                child: AddRetirementLayout(),
              ),
              title: AppLocalizations.of(context!)!.addInvestments,
            ),
          );
        }
      } else {
        return defaultRoute;
      }
    });
    router.define(routeName, handler: handler);
  }
}
