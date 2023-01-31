import 'package:burgundy_budgeting_app/core/di_provider.dart';
import 'package:burgundy_budgeting_app/domain/model/response/retirements_models.dart';
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

import '../../../atomic/organizm/add_account_from_plaid_popup.dart';
import '../../../model/bank_account.dart';

class EditRetirementPage {
  static const String routeName = '/edit_retirement';

  static void initRoute(FluroRouter router, UserContractor diContractor,
      {required Widget defaultRoute}) {
    var handler = Handler(
        handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
      if (diContractor.authRepository.sessionExists()) {
        if (context != null) {
          final retirement = context.settings?.arguments as RetirementModel?;

          if (retirement == null) {
            return BlocProvider<HomeScreenCubit>(
              lazy: false,
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
                      retirementTab: retirement!.retirementType),
                  child: Builder(builder: (context) {
                    final isStandard = BlocProvider.of<HomeScreenCubit>(context)
                        .user
                        .subscription!
                        .isStandard;
                    return InvestmentsLayout(
                      onSuccessCallback:
                          (List<BankAccount> bankAccounts) async {
                        await showDialog(
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
                title: AppLocalizations.of(context)!.investments,
              ),
            );
          } else {
            return BlocProvider<HomeScreenCubit>(
              lazy: false,
              create: (_) => HomeScreenCubit(
                diContractor.authRepository,
                diContractor.userRepository,
                diContractor.subscriptionRepository,
              ),
              child: HomePage(
                innerBlocProvider: BlocProvider<AddRetirementCubit>(
                  lazy: false,
                  child: AddRetirementLayout(editRetirement: retirement),
                  create: (_) => AddRetirementCubit(
                    diContractor.investmentRepository,
                    retirement: retirement,
                    retirementType: retirement.retirementType!,
                  ),
                ),
                title: AppLocalizations.of(context)!.editInvestment,
              ),
            );
          }
        }
      } else {
        return defaultRoute;
      }
    });

    router.define(routeName, handler: handler);
  }
}
