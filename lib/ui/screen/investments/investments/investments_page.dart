import 'package:burgundy_budgeting_app/core/di_provider.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/new_show_dialog.dart';
import 'package:burgundy_budgeting_app/ui/atomic/organizm/add_account_from_plaid_popup.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/home_screen/home_page.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/home_screen/home_screen_cubit.dart';
import 'package:burgundy_budgeting_app/ui/model/bank_account.dart';
import 'package:burgundy_budgeting_app/ui/screen/investments/investments/investments_cubit.dart';
import 'package:burgundy_budgeting_app/ui/screen/investments/investments/investments_layout.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'investments_state.dart';

class InvestmentsPage {
  static const String routeName = '/investments';

  static void initRoute(FluroRouter router, UserContractor diContractor,
      {required Widget defaultRoute}) {
    var handler = Handler(
        handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
      var investmentsCubitInstance;

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
                  create: (_) {
                    investmentsCubitInstance = InvestmentsCubit(
                      diContractor.investmentRepository,
                      diContractor.accountsTransactionsRepository,
                      isRetirement: isRetirement ?? false,
                      investmentTab: investmentTab,
                      retirementTab: retirementTab,
                    );
                    return investmentsCubitInstance;
                  },
                  child: Builder(builder: (context) {
                    final isStandard = BlocProvider.of<HomeScreenCubit>(context)
                        .user
                        .subscription!
                        .isStandard;
                    return InvestmentsLayout(
                      onSuccessCallback:
                          (List<BankAccount> bankAccounts) async {
                        if (bankAccounts.isNotEmpty) {
                          await newShowDialog(
                            context,
                            barrierDismissible: false,
                            builder: (_) {
                              return BlocProvider<InvestmentsCubit>.value(
                                value: investmentsCubitInstance,
                                child: AddAccountFromPlaidPopup(
                                  bankAccounts: bankAccounts,
                                  businessNameList: [],
                                  showCancelOption: true,
                                  isStandardSubscription: isStandard,
                                  plaidRepository: diContractor
                                      .accountsTransactionsRepository,
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
                        } else {
                          investmentsCubitInstance.loadInvestments(
                              tab: (investmentsCubitInstance.state
                                      as InvestmentsLoaded)
                                  .investmentsTab);
                        }
                      },
                    );
                  }),
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
