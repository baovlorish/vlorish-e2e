import 'package:burgundy_budgeting_app/ui/atomic/atom/colored_button.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_loading_indicator.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_radio_button.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/label.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/new_show_dialog.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/new_text_switch.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/no_cards_here_widget.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/theme.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/version_two_color_scheme.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/appbar_item.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/error_alert_dialog.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/two_buttons_alert_dialog.dart';
import 'package:burgundy_budgeting_app/ui/atomic/organizm/add_manual_account_popup.dart';
import 'package:burgundy_budgeting_app/ui/atomic/organizm/instituton_view.dart';
import 'package:burgundy_budgeting_app/ui/atomic/organizm/notification_menu.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/home_screen/home_screen.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/home_screen/home_screen_cubit.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/home_screen/home_screen_state.dart';
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

  const ManageAccountsLayout({Key? key, required this.onSuccessCallback}) : super(key: key);

  @override
  State<ManageAccountsLayout> createState() => _ManageAccountsLayoutState();
}

class _ManageAccountsLayoutState extends State<ManageAccountsLayout> {
  ProfileOverviewModel? user;
  late final ManageAccountsCubit _manageAccountsCubit;
  late final HomeScreenCubit _homeScreenCubit;
  var isInvestmentAccounts = false;

  static const iconsRepositionWidthTriggerPoint = 943.0;
  static const buttonsRepositionWidthTriggerPoint = 700.0;

  @override
  void initState() {
    _manageAccountsCubit = BlocProvider.of<ManageAccountsCubit>(context);
    _homeScreenCubit = BlocProvider.of<HomeScreenCubit>(context);
    super.initState();
  }

  void showAddAccountDialog() => newShowDialog(
        context,
        builder: (_context) {
          return TwoButtonDialogNew(
            title: AppLocalizations.of(context)!.addAccount,
            description: AppLocalizations.of(context)!.selectedMethodToAddYourAccount,
            leftButtonParams: ButtonParams(
              AppLocalizations.of(context)!.authomaticAccountLinking,
              onPressed: () => _manageAccountsCubit.addPlaidAccount(
                type: LinkTokenType.Transactions.index,
                onSuccessCallback: (List<BankAccount> bankAccounts) {
                  if (bankAccounts.isNotEmpty) widget.onSuccessCallback(bankAccounts);
                },
              ),
            ),
            rightButtonParams: ButtonParams(
              AppLocalizations.of(context)!.manualAccountCreation,
              onPressed: () async {
                var businessNameList = [''];
                if (!_homeScreenCubit.user.subscription!.isStandard) {
                  businessNameList = await _manageAccountsCubit.businessNameList();
                }
                await newShowDialog(
                  context,
                  builder: (_) => AddManualAccountPopup(
                    context,
                    businessNameList: businessNameList,
                    isStandardSubscription: BlocProvider.of<HomeScreenCubit>(context).user.subscription!.isStandard,
                    addAccountFunction: ({
                      required String name,
                      required int usageType,
                      required int accountType,
                      String? businessName,
                    }) async =>
                        await _manageAccountsCubit.addManualAccount(
                      name: name,
                      usageType: usageType,
                      accountType: accountType,
                      businessName: businessName,
                    ),
                  ),
                );
              },
            ),
          );
        },
      );

  @override
  Widget build(BuildContext context) {
    return HomeScreen(
      title: AppLocalizations.of(context)!.manageAccounts,
      currentTab: Tabs.AppbarTransactions,
      newHeaderWidget: LayoutBuilder(builder: (context, boxConstrains) {
        return Container(
          decoration: BoxDecoration(
            color: VersionTwoColorScheme.PageBackground,
            boxShadow: [BoxShadow(color: VersionTwoColorScheme.Shadow, offset: Offset(0, 2), blurRadius: 12)],
          ),
          padding: EdgeInsets.symmetric(vertical: 22, horizontal: 30),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return ManageAccountsHeaderWidget(
                  isInvestmentAccounts: isInvestmentAccounts,
                  tabSwitchCallback: () => setState(() => isInvestmentAccounts = !isInvestmentAccounts),
                  addAccountCallback: showAddAccountDialog,
                  addAssetCallback: () => _manageAccountsCubit.addPlaidAccount(
                        onSuccessCallback: (List<BankAccount> bankAccounts) {
                          if (bankAccounts.isNotEmpty) {
                            widget.onSuccessCallback(bankAccounts);
                          }
                        },
                        type: LinkTokenType.Investments.index,
                      ),
                  currentWidth: constraints.maxWidth,
                  iconsRepositionWidth: iconsRepositionWidthTriggerPoint,
                  buttonsRepositionWidth: buttonsRepositionWidthTriggerPoint);
            },
          ),
        );
      }),
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
                (state.accountGroupList.where((element) => !element.isManual).isNotEmpty)) {
              _homeScreenCubit.updateUserData();
            } else if (!user!.hasConfiguredBankAccounts &&
                state.accountGroupList.where((account) => !account.hasConfiguredAccounts).isEmpty) {
              _homeScreenCubit.updateUserData();
            }
          }
        },
        builder: (context, state) {
          if (state is ManageAccountsLoaded) {
            var hasAccounts = state.accountGroupList.where((element) => !element.isInvestment).isNotEmpty;
            var hasInvestments = state.accountGroupList.where((element) => element.isInvestment).isNotEmpty;
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
                      (hasInvestments && isInvestmentAccounts) || (hasAccounts && !isInvestmentAccounts)
                          ? SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: _getWidgets(state.accountGroupList, user!),
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

  List<Widget> _getWidgets(List<AccountGroup> group, ProfileOverviewModel user) {
    var views = [
      for (var item in group)
        if (item.accounts.isNotEmpty && item.isInvestment == isInvestmentAccounts)
          InstitutionView(
            key: Key(item.id),
            user: user,
            group: item,
            onDeleteGroup: () {
              newShowDialog(context,
                  builder: (_context) => DeleteAccountAlertDialog(
                        itemName: item.institutionName,
                        deleteCallback: () async => await _manageAccountsCubit.deleteInstitution(item),
                      ));
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

class AppBarIcons extends StatelessWidget {
  //TODO: (viacheslav) add functionality
  const AppBarIcons({
    Key? key,
    required this.homeScreenCubit,
    this.notificationOffset,
  }) : super(key: key);
  final HomeScreenCubit homeScreenCubit;
  final Offset? notificationOffset;

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      ImageIcon(
        AssetImage('assets/images/icons/notes_icon.png'),
        color: VersionTwoColorScheme.Black,
        size: 24,
      ),
      SizedBox(width: 26),
      ImageIcon(
        AssetImage('assets/images/icons/chat_icon.png'),
        color: VersionTwoColorScheme.Black,
        size: 24,
      ),
      SizedBox(width: 13),
      IconButton(
        icon: ImageIcon(
          AssetImage('assets/images/icons/new_gift_icon.png'),
          color: VersionTwoColorScheme.Black,
        ),
        onPressed: () => homeScreenCubit.navigateToReferralPage(context),
      ),
      AppBarItem(
        iconUrl: 'assets/images/icons/notifications_icon.png',
        iconColor: VersionTwoColorScheme.Black,
        isSmall: true,
        minPadding: 0,
        maxPadding: 0,
        usesAlignedMenu: true,
        notificationCount: (homeScreenCubit.state is HomeScreenLoaded)
            ? (homeScreenCubit.state as HomeScreenLoaded).user.remainedTransactionRefreshCount
            : 0,
        hoverMenuWidget: NotificationMenu(
          //TODO: (viacheslav) redesign menu
          maxHeight: MediaQuery.of(context).size.height - 100,
          width: homeScreenCubit.user.subscription != null &&
                  homeScreenCubit.user.subscription!.isAdvisor &&
                  homeScreenCubit.user.hasClients
              ? 469
              : 409,
          fetchNotificationPage: homeScreenCubit.fetchNotificationPage,
          deleteNotification: (String id) async => await homeScreenCubit.deleteNotification(id),
          clearAll: () async => await homeScreenCubit.clearNotifications(),
          homeScreenCubit: homeScreenCubit,
        ),
        showMenuOnHover: false,
      ),
      Icon(
        Icons.more_vert,
        size: 24,
        color: VersionTwoColorScheme.Black,
      )
    ]);
  }
}

class ManageAccountsHeaderWidget extends StatelessWidget {
  const ManageAccountsHeaderWidget(
      {Key? key,
      required this.isInvestmentAccounts,
      required this.tabSwitchCallback,
      required this.addAccountCallback,
      required this.addAssetCallback,
      required this.currentWidth,
      required this.iconsRepositionWidth,
      required this.buttonsRepositionWidth})
      : super(key: key);

  final double currentWidth;
  final bool isInvestmentAccounts;
  final void Function() tabSwitchCallback;
  final void Function() addAccountCallback;
  final void Function() addAssetCallback;
  final double iconsRepositionWidth;
  final double buttonsRepositionWidth;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        spacing: 26,
        runSpacing: 26,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ImageIcon(
                AssetImage('assets/images/icons/manage_accounts_icon.png'),
                color: VersionTwoColorScheme.Black,
                size: 24,
              ),
              SizedBox(width: 8),
              Label(
                text: AppLocalizations.of(context)!.manageAccounts,
                type: LabelType.NewHeader3,
              ),
            ],
          ),
          if (currentWidth >= buttonsRepositionWidth)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomTextSwitch(
                  initialSelection: isInvestmentAccounts,
                  firstOptionName: AppLocalizations.of(context)!.bankAccounts,
                  secondOptionName: AppLocalizations.of(context)!.investments,
                  onSelected: () => tabSwitchCallback(),
                ),
                SizedBox(width: 32),
                if (isInvestmentAccounts)
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 138),
                    child: ColoredButton(
                      onPressed: addAssetCallback,
                      buttonStyle: ColoredButtonStyle.Green,
                      child: Row(
                        children: [
                          Label(
                              text: AppLocalizations.of(context)!.addAsset,
                              type: LabelType.NewSmallTextStyle,
                              color: VersionTwoColorScheme.White),
                          SizedBox(width: 8),
                          Icon(
                            Icons.add_rounded,
                            color: VersionTwoColorScheme.White,
                            size: 12,
                          )
                        ],
                      ),
                    ),
                  ),
                if (!isInvestmentAccounts)
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 154),
                    child: ColoredButton(
                      onPressed: addAccountCallback,
                      buttonStyle: ColoredButtonStyle.Green,
                      child: Row(
                        children: [
                          Label(
                              text: AppLocalizations.of(context)!.addAccountLowercase,
                              type: LabelType.NewSmallTextStyle,
                              color: VersionTwoColorScheme.White),
                          SizedBox(width: 8),
                          Icon(
                            Icons.add_rounded,
                            color: VersionTwoColorScheme.White,
                            size: 12,
                          )
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          if (currentWidth < buttonsRepositionWidth)
            CustomTextSwitch(
              initialSelection: isInvestmentAccounts,
              firstOptionName: AppLocalizations.of(context)!.bankAccounts,
              secondOptionName: AppLocalizations.of(context)!.investments,
              onSelected: () => tabSwitchCallback(),
            ),
          if (currentWidth < buttonsRepositionWidth)
            if (isInvestmentAccounts)
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 138),
                child: ColoredButton(
                  onPressed: addAssetCallback,
                  buttonStyle: ColoredButtonStyle.Green,
                  child: Row(
                    children: [
                      Label(
                          text: AppLocalizations.of(context)!.addAsset,
                          type: LabelType.NewSmallTextStyle,
                          color: VersionTwoColorScheme.White),
                      SizedBox(width: 8),
                      Icon(
                        Icons.add_rounded,
                        color: VersionTwoColorScheme.White,
                        size: 12,
                      )
                    ],
                  ),
                ),
              ),
          if (currentWidth < buttonsRepositionWidth)
            if (!isInvestmentAccounts)
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 154),
                child: ColoredButton(
                  onPressed: addAccountCallback,
                  buttonStyle: ColoredButtonStyle.Green,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Label(
                          text: AppLocalizations.of(context)!.addAccountLowercase,
                          type: LabelType.NewSmallTextStyle,
                          color: VersionTwoColorScheme.White),
                      SizedBox(width: 8),
                      Icon(
                        Icons.add_rounded,
                        color: VersionTwoColorScheme.White,
                        size: 12,
                      )
                    ],
                  ),
                ),
              ),
          if (currentWidth >= iconsRepositionWidth)
            AppBarIcons(homeScreenCubit: BlocProvider.of<HomeScreenCubit>(context))
          else
            Align(
                alignment: Alignment.centerRight,
                child: AppBarIcons(homeScreenCubit: BlocProvider.of<HomeScreenCubit>(context))),
        ],
      ),
    );
  }
}

enum LinkTokenType { Transactions, Investments }
