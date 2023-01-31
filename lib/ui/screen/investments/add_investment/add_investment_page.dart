import 'package:burgundy_budgeting_app/core/di_provider.dart';
import 'package:burgundy_budgeting_app/domain/model/response/index_funds_response.dart';
import 'package:burgundy_budgeting_app/ui/atomic/organizm/add_account_from_plaid_popup.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/home_screen/home_page.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/home_screen/home_screen_cubit.dart';
import 'package:burgundy_budgeting_app/ui/model/bank_account.dart';
import 'package:burgundy_budgeting_app/ui/screen/investments/add_investment/add_investment_cubit.dart';
import 'package:burgundy_budgeting_app/ui/screen/investments/add_investment/add_investment_layout.dart';
import 'package:burgundy_budgeting_app/ui/screen/investments/investments/investments_cubit.dart';
import 'package:burgundy_budgeting_app/ui/screen/investments/investments/investments_layout.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../investments/investments_state.dart';

class AddInvestmentPage {
  static const String routeName = '/add_investment';

  static void initRoute(FluroRouter router, UserContractor diContractor,
      {required Widget defaultRoute}) {
    var handler = Handler(
        handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
      var investmentsCubitInstance;

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
                create: (_) {
                  investmentsCubitInstance = InvestmentsCubit(
                      diContractor.investmentRepository,
                      diContractor.accountsTransactionsRepository,
                      isRetirement: false,
                      investmentTab: investmentGroup!.index);
                  return investmentsCubitInstance;
                },
                child: Builder(builder: (context) {
                  final isStandard = BlocProvider.of<HomeScreenCubit>(context)
                      .user
                      .subscription!
                      .isStandard;
                  return InvestmentsLayout(
                    onSuccessCallback: (List<BankAccount> bankAccounts) async {
                      await showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (_) {
                          return BlocProvider<InvestmentsCubit>.value(
                            value: investmentsCubitInstance,
                            child: AddAccountFromPlaidPopup(
                              bankAccounts: bankAccounts,
                              businessNameList: [],
                              showCancelOption: true,
                              isStandardSubscription: isStandard,
                              plaidRepository:
                                  diContractor.accountsTransactionsRepository,
                              netWorthRepository:
                                  diContractor.netWorthRepository,
                              onSuccessCallback: () {
                                investmentsCubitInstance.loadInvestments(
                                    tab: (investmentsCubitInstance.state
                                            as InvestmentsLoaded)
                                        .investmentsTab);
                              },
                            ),
                          );
                        },
                      );
                    },
                  );
                }),
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
