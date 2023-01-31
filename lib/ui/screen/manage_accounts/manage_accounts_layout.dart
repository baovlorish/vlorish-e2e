import 'package:burgundy_budgeting_app/ui/atomic/atom/back_button.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_divider.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_loading_indicator.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_radio_button.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/label.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/no_cards_here_widget.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/theme.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/button_item.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/error_alert_dialog.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/two_buttons_alert_dialog.dart';
import 'package:burgundy_budgeting_app/ui/atomic/organizm/add_manual_account_popup.dart';
import 'package:burgundy_budgeting_app/ui/atomic/organizm/annual_monthly_switcher.dart';
import 'package:burgundy_budgeting_app/ui/atomic/organizm/instituton_view.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/home_screen/home_screen.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/home_screen/home_screen_cubit.dart';
import 'package:burgundy_budgeting_app/ui/model/account_group.dart';
import 'package:burgundy_budgeting_app/ui/model/bank_account.dart';
import 'package:burgundy_budgeting_app/ui/model/proflie_overview_model.dart';
import 'package:burgundy_budgeting_app/ui/screen/manage_accounts/manage_accounts_cubit.dart';
import 'package:burgundy_budgeting_app/ui/screen/manage_accounts/manage_accounts_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ManageAccountsLayout extends StatefulWidget {
  final Function(List<BankAccount>) onSuccessCallback;

  const ManageAccountsLayout({Key? key, required this.onSuccessCallback})
      : super(key: key);

  @override
  State<ManageAccountsLayout> createState() => _ManageAccountsLayoutState();
}

class _ManageAccountsLayoutState extends State<ManageAccountsLayout> {
  bool? isManual;

  ProfileOverviewModel? user;
  late final ManageAccountsCubit _manageAccountsCubit;
  late final HomeScreenCubit _homeScreenCubit;
  var isInvestmentAccounts = false;

  @override
  void initState() {
    _manageAccountsCubit = BlocProvider.of<ManageAccountsCubit>(context);
    _homeScreenCubit = BlocProvider.of<HomeScreenCubit>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return HomeScreen(
      title: AppLocalizations.of(context)!.manageAccounts,
      currentTab: Tabs.AppbarTransactions,
      headerWidget: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CustomBackButton(
                onPressed: () {
                  _manageAccountsCubit.navigateToTransactionsPage(context);
                },
              ),
              Label(
                text: AppLocalizations.of(context)!.manageAccounts,
                type: LabelType.Header2,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 16),
                child: TwoOptionSwitcher(
                  isFirstItemSelected: !isInvestmentAccounts,
                  onPressed: () {
                    isInvestmentAccounts = !isInvestmentAccounts;
                    setState(() {});
                  },
                  options: ['Bank Accounts', 'Investments'],
                ),
              ),
            ],
          ),
          Row(
            children: [
              if (isInvestmentAccounts)
                ButtonItem(context,
                    text: AppLocalizations.of(context)!.addAsset,
                    onPressed: () async {
                  _manageAccountsCubit.addPlaidAccount(
                    onSuccessCallback: (List<BankAccount> bankAccounts) {
                      if (bankAccounts.isNotEmpty) {
                        widget.onSuccessCallback(bankAccounts);
                      }
                    },
                    type: LinkTokenType.Investments.index,
                  );
                }),
              if (!isInvestmentAccounts)
                ButtonItem(context,
                    text: AppLocalizations.of(context)!.addAccountLowercase,
                    onPressed: () {
                  isManual = null;
                  showDialog(
                    context: context,
                    builder: (_context) {
                      return StatefulBuilder(
                        builder: (_, setState) => TwoButtonsDialog(
                          context,
                          showCloseButton: false,
                          title: AppLocalizations.of(context)!.addAccount,
                          mainButtonText:
                              AppLocalizations.of(context)!.addAccount,
                          dismissButtonText:
                              AppLocalizations.of(context)!.cancel,
                          enableMainButton: isManual != null,
                          bodyWidget: RadioRow(
                            onChanged: (bool value) {
                              isManual = value;
                              setState(() {});
                            },
                          ),
                          onMainButtonPressed: () async {
                            var businessNameList = [''];
                            if(!_homeScreenCubit.user.subscription!.isStandard){
                              businessNameList =
                                  await _manageAccountsCubit.businessNameList();
                            }
                            if (isManual != null) {
                              if (isManual == false) {
                                _manageAccountsCubit.addPlaidAccount(
                                  onSuccessCallback:
                                      (List<BankAccount> bankAccounts) {
                                    if (bankAccounts.isNotEmpty) {
                                      widget.onSuccessCallback(bankAccounts);
                                    }
                                  },
                                  type: LinkTokenType.Transactions.index,
                                );
                              } else if (isManual == true) {
                                await showDialog(
                                  context: context,
                                  builder: (_) {
                                    return AddManualAccountPopup(
                                      context,
                                      businessNameList: businessNameList,
                                      isStandardSubscription:
                                          BlocProvider.of<HomeScreenCubit>(context).user.subscription!.isStandard,
                                      addAccountFunction: (
                                          {required String name,
                                          required int usageType,
                                          required int accountType,
                                          String? businessName}) async {
                                        return await _manageAccountsCubit
                                            .addManualAccount(
                                          name: name,
                                          usageType: usageType,
                                          accountType: accountType,
                                          businessName: businessName,
                                        );
                                      },
                                    );
                                  },
                                );
                              }
                            }
                          },
                        ),
                      );
                    },
                  );
                }),
            ],
          )
        ],
      ),
      bodyWidget: BlocConsumer<ManageAccountsCubit, ManageAccountsState>(
        listener: (context, state) {
          if (state is ManageAccountsError) {
            _manageAccountsCubit.getAccounts();

            showDialog(
              context: context,
              builder: (context) {
                return ErrorAlertDialog(context, message: state.error);
              },
            );
          } else if (state is ManageAccountsLoaded) {
            //updating user data when accounts deleted or added
            user = _homeScreenCubit.user;
            if ((user!.hasInstitutionAccounts) !=
                (state.accountGroupList
                    .where((element) => !element.isManual)
                    .isNotEmpty)) {
              _homeScreenCubit.updateUserData();
            } else if (!user!.hasConfiguredBankAccounts &&
                state.accountGroupList
                    .where((account) => !account.hasConfiguredAccounts)
                    .isEmpty) {
              _homeScreenCubit.updateUserData();
            }
          }
        },
        builder: (context, state) {
          if (state is ManageAccountsLoaded) {
            var hasAccounts = state.accountGroupList
                .where((element) => !element.isInvestment)
                .isNotEmpty;
            var hasInvestments = state.accountGroupList
                .where((element) => element.isInvestment)
                .isNotEmpty;
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 10.0,
                        color: CustomColorScheme.tableBorder,
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      //this stack with center is needed to expand parent container
                      Center(),
                      (hasInvestments && isInvestmentAccounts) ||
                              (hasAccounts && !isInvestmentAccounts)
                          ? SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children:
                                    _getWidgets(state.accountGroupList, user!),
                              ),
                            )
                          : NoCardsHereWidget(),
                    ],
                  ),
                ),
              ),
            );
          } else if (state is ManageAccountsLoading) {
            return CustomLoadingIndicator();
          } else {
            return Container();
          }
        },
      ),
    );
  }

  List<Widget> _getWidgets(
      List<AccountGroup> group, ProfileOverviewModel user) {
    var views = [
      for (var item in group)
        if (item.accounts.isNotEmpty &&
            item.isInvestment == isInvestmentAccounts)
          InstitutionView(
            key: Key(item.id),
            user: user,
            group: item,
            onDeleteGroup: () {
              showDialog(
                context: context,
                builder: (_context) {
                  return TwoButtonsDialog(
                    context,
                    title:
                        '${AppLocalizations.of(context)!.areYouSureToRemove} ${item.institutionName}?',
                    mainButtonText: AppLocalizations.of(context)!.yesRemoveIt,
                    dismissButtonText: AppLocalizations.of(context)!.no,
                    onMainButtonPressed: () async {
                      await _manageAccountsCubit.deleteInstitution(item);
                    },
                  );
                },
              );
            },
            onLoginWithPlaid: item.isManual
                ? () {}
                : () {
                    _manageAccountsCubit.loginWithPlaid(item.id, context);
                  },
            onManageInstitution: item.isManual
                ? () {}
                : () {
                    _manageAccountsCubit.manageInstitution(item.id,
                        onSuccessCallback: (List<BankAccount> bankAccounts) {
                      if (bankAccounts.isNotEmpty) {
                        widget.onSuccessCallback(bankAccounts);
                      }
                    });
                  },
          )
    ];
    var resultList = <Widget>[];
    for (var item in views) {
      resultList.add(item);
      if (views.indexOf(item) != views.length - 1) {
        resultList.add(
          CustomDivider(),
        );
      }
    }
    return resultList;
  }
}

class RadioRow extends StatefulWidget {
  final Function(bool) onChanged;

  const RadioRow({Key? key, required this.onChanged}) : super(key: key);

  @override
  _RadioRowState createState() => _RadioRowState();
}

class _RadioRowState extends State<RadioRow> {
  bool? isManual;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        CustomRadioButton(
          title: AppLocalizations.of(context)!.usingPlaid,
          groupValue: isManual,
          value: false,
          onTap: () => setState(() {
            isManual = false;
            widget.onChanged(false);
          }),
        ),
        CustomRadioButton(
          title: AppLocalizations.of(context)!.manually,
          groupValue: isManual,
          value: true,
          onTap: () => setState(() {
            isManual = true;
            widget.onChanged(true);
          }),
        ),
      ],
    );
  }
}

enum LinkTokenType { Transactions, Investments }
