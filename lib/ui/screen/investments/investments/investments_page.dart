import 'package:burgundy_budgeting_app/core/di_provider.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/home_screen/home_page.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/home_screen/home_screen_cubit.dart';
import 'package:burgundy_budgeting_app/ui/screen/investments/investments/investments_cubit.dart';
import 'package:burgundy_budgeting_app/ui/screen/investments/investments/investments_layout.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class InvestmentsPage {
  static const String routeName = '/investments';

  static void initRoute(FluroRouter router, UserContractor diContractor,
      {required Widget defaultRoute}) {
    var handler = Handler(
        handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
      var routeArguments =
          context?.settings?.arguments as Map<String, dynamic>?;
      bool? isRetirement;
      int? investmentTab;
      int? retirementTab;
      if (routeArguments != null) {
        isRetirement = routeArguments['isRetirement'] as bool?;
        investmentTab = routeArguments['investmentTab'] as int?;
        retirementTab = routeArguments['retirementTab'] as int?;
      }

      return diContractor.authRepository.sessionExists()
          ? BlocProvider<HomeScreenCubit>(
              create: (_) => HomeScreenCubit(
                diContractor.authRepository,
                diContractor.userRepository,
                diContractor.subscriptionRepository,
              ),
              child: HomePage(
                innerBlocProvider: BlocProvider<InvestmentsCubit>(
                  create: (_) => InvestmentsCubit(
                    diContractor.investmentRepository,
                    isRetirement: isRetirement ?? false,
                    investmentTab: investmentTab,
                    retirementTab: retirementTab,
                  ),
                  child: InvestmentsLayout(),
                ),
                title: AppLocalizations.of(context!)!.investment,
                //isPremium: true,
              ),
            )
          : defaultRoute;
    });
    router.define(routeName, handler: handler);
  }
}
