import 'package:burgundy_budgeting_app/core/di_provider.dart';
import 'package:burgundy_budgeting_app/ui/atomic/organizm/add_account_from_plaid_popup.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/home_screen/home_page.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/home_screen/home_screen_cubit.dart';
import 'package:burgundy_budgeting_app/ui/model/bank_account.dart';
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
                    diContractor.accountsTransactionsRepository,
                    isRetirement: true,
                    retirementTab: retirementType),
                child: Builder(builder: (context) {
                  final isStandard = BlocProvider.of<HomeScreenCubit>(context)
                      .user
                      .subscription!
                      .isStandard;
                  return InvestmentsLayout(
                    onSuccessCallback:
                        (List<BankAccount> bankAccounts) async {
                      await showDialog(
                        //todo: add to invest page
                        context: context,
                        barrierDismissible: false,
                        builder: (_) {
                          return AddAccountFromPlaidPopup(
                            bankAccounts: bankAccounts,
                            businessNameList: [],
                            showCancelOption: true,
                            isStandardSubscription: isStandard,
                            plaidRepository:
                            diContractor.accountsTransactionsRepository,
                            netWorthRepository:
                            diContractor.netWorthRepository,
                            onSuccessCallback: () {
                            },
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
