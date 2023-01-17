import 'package:burgundy_budgeting_app/core/di_provider.dart';
import 'package:burgundy_budgeting_app/domain/model/response/index_funds_response.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/home_screen/home_page.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/home_screen/home_screen_cubit.dart';
import 'package:burgundy_budgeting_app/ui/screen/investments/add_investment/add_investment_cubit.dart';
import 'package:burgundy_budgeting_app/ui/screen/investments/add_investment/add_investment_layout.dart';
import 'package:burgundy_budgeting_app/ui/screen/investments/investments/investments_cubit.dart';
import 'package:burgundy_budgeting_app/ui/screen/investments/investments/investments_layout.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddInvestmentPage {
  static const String routeName = '/add_investment';

  static void initRoute(FluroRouter router, UserContractor diContractor,
      {required Widget defaultRoute}) {
    var handler = Handler(
        handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
      var investmentGroup = context?.settings?.arguments as InvestmentGroup?;

      if (diContractor.authRepository.sessionExists()) {
        if (investmentGroup == null) {
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
                    isRetirement: false,
                    investmentTab: investmentGroup!.index),
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
              innerBlocProvider: BlocProvider<AddInvestmentCubit>(
                create: (_) => AddInvestmentCubit(
                  diContractor.investmentRepository,
                  currentInvestmentGroup: investmentGroup,
                ),
                child: AddInvestmentLayout(),
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
