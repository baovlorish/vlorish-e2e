import 'package:burgundy_budgeting_app/core/di_provider.dart';
import 'package:burgundy_budgeting_app/ui/atomic/organizm/add_account_from_plaid_popup.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/home_screen/home_page.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/home_screen/home_screen_cubit.dart';
import 'package:burgundy_budgeting_app/ui/model/bank_account.dart';
import 'package:burgundy_budgeting_app/ui/screen/manage_accounts/manage_accounts_cubit.dart';
import 'package:burgundy_budgeting_app/ui/screen/manage_accounts/manage_accounts_layout.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ManageAccountsPage {
  static const String routeName = '/manage_accounts';

  static void initRoute(FluroRouter router, UserContractor diContractor,
      {required Widget defaultRoute}) {
    var handler = Handler(
      handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
        // creating cubit instance so  we could access cubit's methods
        // in popup with different context
        var manageAccountsCubitInstance;
        //by url or other way
        //if coach goes to ManageAccounts during see client's budget
        //stop client's session
        //than coach see own ManageAccounts
        diContractor.userRepository.stopForeignSession();
        return diContractor.authRepository.sessionExists()
            ? BlocProvider<HomeScreenCubit>(
                create: (_) => HomeScreenCubit(
                  diContractor.authRepository,
                  diContractor.userRepository,
                  diContractor.subscriptionRepository,
                ),
                child: HomePage(
                  innerBlocProvider: BlocProvider<ManageAccountsCubit>(
                    lazy: false,
                    create: (context) {
                      manageAccountsCubitInstance = ManageAccountsCubit(
                          diContractor.userRepository,
                          diContractor.accountsTransactionsRepository,
                          diContractor.budgetRepository,
                          diContractor.netWorthRepository);
                      return manageAccountsCubitInstance;
                    },
                    child: Builder(builder: (context) {
                      return ManageAccountsLayout(
                        onSuccessCallback:
                            (List<BankAccount> bankAccounts) async {
                          final isStandard =
                              BlocProvider.of<HomeScreenCubit>(context)
                                  .user
                                  .subscription!
                                  .isStandard;

                          var businessNameList = [''];
                          if (!isStandard) {
                            businessNameList = await manageAccountsCubitInstance
                                .businessNameList();
                          }

                          await showDialog(//todo: add to invest page
                            context: context,
                            barrierDismissible: false,
                            builder: (_) {
                              return BlocProvider<ManageAccountsCubit>.value(
                                value: manageAccountsCubitInstance,
                                child: AddAccountFromPlaidPopup(
                                  bankAccounts: bankAccounts,
                                  businessNameList: businessNameList,
                                  showCancelOption: true,
                                  isStandardSubscription: isStandard,
                                  plaidRepository: diContractor
                                      .accountsTransactionsRepository,
                                  netWorthRepository:
                                      diContractor.netWorthRepository,
                                  onSuccessCallback: () {
                                    manageAccountsCubitInstance.getAccounts();
                                  },
                                ),
                              );
                            },
                          );
                        },
                      );
                    }),
                  ),
                  title: AppLocalizations.of(context!)!.manageAccounts,
                ),
              )
            : defaultRoute;
      },
    );

    router.define(routeName, handler: handler);
  }
}
