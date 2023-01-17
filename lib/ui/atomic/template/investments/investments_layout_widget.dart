import 'package:burgundy_budgeting_app/core/navigator_manager.dart';
import 'package:burgundy_budgeting_app/domain/model/response/index_funds_response.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_loading_indicator.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_tooltip.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_vertical_devider.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/label.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/maybe_scrollable_widget.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/text_styles.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/theme.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/annual_monthly_button.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/button_item.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/dropdown_item.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/error_alert_dialog.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/inform_alert_dialog.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/two_buttons_alert_dialog.dart';
import 'package:burgundy_budgeting_app/ui/atomic/organizm/investment_list.dart';
import 'package:burgundy_budgeting_app/ui/atomic/organizm/investments_column_chart.dart';
import 'package:burgundy_budgeting_app/ui/atomic/organizm/investments_statistics_widget.dart';
import 'package:burgundy_budgeting_app/ui/atomic/organizm/tax_statistics_widget.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/home_screen/home_screen_cubit.dart';
import 'package:burgundy_budgeting_app/ui/screen/investments/investments/investments_cubit.dart';
import 'package:burgundy_budgeting_app/ui/screen/investments/investments/investments_state.dart';
import 'package:burgundy_budgeting_app/ui/screen/manage_accounts/manage_accounts_layout.dart';
import 'package:burgundy_budgeting_app/ui/screen/manage_accounts/manage_accounts_page.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class InvestmentsLayoutWidget extends StatefulWidget {
  const InvestmentsLayoutWidget({Key? key}) : super(key: key);

  @override
  _InvestmentsLayoutWidgetState createState() =>
      _InvestmentsLayoutWidgetState();
}

class _InvestmentsLayoutWidgetState extends State<InvestmentsLayoutWidget> {
  late var investmentsCubit = BlocProvider.of<InvestmentsCubit>(context);

  // late var state = investmentsCubit.state as InvestmentsLoaded;

  InvestmentGroup? tabToInvestTransform(int tab) {
    switch (tab) {
      case 0:
        return InvestmentGroup.Stocks;
      case 1:
        return InvestmentGroup.IndexFunds;
      case 2:
        return InvestmentGroup.Cryptocurrencies;
      case 3:
        return InvestmentGroup.RealEstate;
      case 4:
        return InvestmentGroup.StartUps;
      case 5:
        return InvestmentGroup.OtherInvestments;
      default:
        return null;
    }
  }

  var tabTexts = [
    'Stocks',
    'Index Funds',
    'Cryptocurrency',
    'Inv. Properties',
    'Startups',
    'Other',
  ];

  var hintMap = {
    'Index Funds': 'Includes Index funds, ETFs and mutual funds',
    'Inv. Properties': 'Real Estate only. Excludes residential',
    'Startups': 'Angel investments, startup financing, crowdfunded investments',
    'Other':
        'All other investments that are not covered in other asset types above',
  };
  late var isLimitedCoach = BlocProvider.of<HomeScreenCubit>(context)
          .currentForeignSession
          ?.access
          .isLimited ??
      false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<InvestmentsCubit, InvestmentsState>(
      listener: (context, state) {
        if (state is InvestmentsError) {
          showDialog(
            context: context,
            builder: (context) {
              return ErrorAlertDialog(
                context,
                message: state.message,
              );
            },
          );
        }
      },
      builder: (context, state) {
        if (state is InvestmentsLoaded) {
          return Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
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
                child: SingleChildScrollView(
                  child: LayoutBuilder(builder: (context, constraints) {
                    var moneyCards = [
                      MoneyInfoCard(
                        amount: state.dashboardData.stocks?.currentCost ?? 0,
                        growth: state.dashboardData.stocks?.percent,
                        color: CustomColorScheme.text,
                        padding: const EdgeInsets.all(8.0),
                        title: 'Stocks',
                        imageUrl: 'assets/images/icons/stocks.png',
                      ),
                      MoneyInfoCard(
                          amount:
                              state.dashboardData.realEstate?.currentCost ?? 0,
                          growth: state.dashboardData.realEstate?.percent,
                          padding: const EdgeInsets.all(8.0),
                          color: CustomColorScheme.cardBorder,
                          title: 'Inv. Properties',
                          imageUrl: 'assets/images/icons/real_estate.png',
                          textColor: CustomColorScheme.text),
                      MoneyInfoCard(
                        amount: state.dashboardData.crypto?.currentCost ?? 0,
                        growth: state.dashboardData.crypto?.percent,
                        padding: const EdgeInsets.all(8.0),
                        color: CustomColorScheme.goalColor5,
                        title: 'Cryptocurrency',
                        imageUrl: 'assets/images/icons/crypto.png',
                      ),
                      MoneyInfoCard(
                        amount: state.dashboardData.other?.currentCost ?? 0,
                        growth: state.dashboardData.other?.percent,
                        padding: const EdgeInsets.all(8.0),
                        color: CustomColorScheme.FAQsTiles,
                        title: 'Other Investments',
                        imageUrl: 'assets/images/icons/other_investments.png',
                        textColor: CustomColorScheme.text,
                      ),
                    ];
                    var moneyCardsWidget = constraints.maxWidth > 1270
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: moneyCards,
                          )
                        : constraints.maxWidth > 680
                            ? Column(mainAxisSize: MainAxisSize.min, children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    moneyCards[0],
                                    moneyCards[1],
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    moneyCards[2],
                                    moneyCards[3],
                                  ],
                                ),
                              ])
                            : Column(
                                mainAxisSize: MainAxisSize.min,
                                children: moneyCards,
                              );
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            moneyCardsWidget,
                            Container(
                              height: 1,
                              color: CustomColorScheme.dividerColor,
                              width: constraints.maxWidth,
                            ),
                            SizedBox(
                              width: constraints.maxWidth,
                              child: MaybeScrollableWidget(
                                scrollDirection: Axis.horizontal,
                                shouldScrollWhen: constraints.maxWidth < 1300,
                                child: IntrinsicHeight(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      InvestmentsColumnChart(
                                          data: state.dashboardData),
                                      CustomVerticalDivider(),
                                      InvestmentsStatisticsWidget(
                                          state.dashboardData),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              height: 1,
                              color: CustomColorScheme.dividerColor,
                              width: constraints.maxWidth,
                            ),
                            SizedBox(
                              width: constraints.maxWidth,
                              child: Wrap(
                                  alignment: WrapAlignment.spaceAround,
                                  children: [
                                    for (var index = 0;
                                        index < tabTexts.length;
                                        index++)
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            TabSelectorButton(
                                                labelText: tabTexts[index],
                                                padding: EdgeInsets.all(12),
                                                onPressed: () async {
                                                  await investmentsCubit
                                                      .selectTab(index);
                                                },
                                                isSelected:
                                                    state.investmentsTab ==
                                                        index),
                                            if (hintMap[tabTexts[index]] !=
                                                null)
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 12.0),
                                                child: CustomTooltip(
                                                  message:
                                                      hintMap[tabTexts[index]]!,
                                                  child: Icon(
                                                    Icons.info_rounded,
                                                    color: CustomColorScheme
                                                        .taxInfoTooltip,
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                  ]),
                            ),
                            state.investments != null &&
                                    state.investments!.isNotEmpty
                                ? SizedBox(
                                    width: constraints.maxWidth,
                                    child: InvestmentList(
                                        key: ObjectKey(state.investments),
                                        width: constraints.maxWidth,
                                        showPopUpCallback: () {
                                          var invest = tabToInvestTransform(
                                              (investmentsCubit.state
                                                      as InvestmentsLoaded)
                                                  .investmentsTab);
                                          if (invest != null) {
                                            showAddInvestPopUp(invest);
                                          }
                                        }),
                                  )
                                : Center(
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: 40,
                                        ),
                                        SizedBox(
                                          height: 120,
                                          child: Image.asset(
                                            'assets/images/no_investments.png',
                                            fit: BoxFit.scaleDown,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(20.0),
                                          child: Label(
                                            text:
                                                'Let’s connect your Investments',
                                            type: LabelType.Header3,
                                            fontSize: 18,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 120,
                                          child: ButtonItem(context,
                                              text:
                                                  AppLocalizations.of(context)!
                                                      .connect,
                                              enabled: !isLimitedCoach,
                                              onPressed: () {
                                            var invest = tabToInvestTransform(
                                                (investmentsCubit.state
                                                        as InvestmentsLoaded)
                                                    .investmentsTab);
                                            if (invest != null) {
                                              showAddInvestPopUp(invest);
                                            }
                                          }),
                                        ),
                                      ],
                                    ),
                                  ),
                          ],
                        )
                      ],
                    );
                  }),
                ),
              ),
            ),
          );
        } else {
          return CustomLoadingIndicator();
        }
      },
    );
  }

  void showAddInvestPopUp(InvestmentGroup invest) async {
    if (invest == InvestmentGroup.StartUps ||
        invest == InvestmentGroup.RealEstate) {
      investmentsCubit.navigateToAddInvestmentPage(
        context,
        investmentGroup: invest,
      );
    } else {
      var textArticle = (investmentsCubit.state as InvestmentsLoaded)
                      .investmentsTab ==
                  1 ||
              (investmentsCubit.state as InvestmentsLoaded).investmentsTab == 5
          ? ' '
          : ' a ';
      bool? isManual;
      var isMainButtonClicked = false;
      await showDialog(
          context: context,
          builder: (_context) {
            return StatefulBuilder(builder: (context, setState) {
              return TwoButtonsDialog(context,
                  title: AppLocalizations.of(context)!.add +
                      textArticle +
                      tabTexts[(investmentsCubit.state as InvestmentsLoaded)
                          .investmentsTab],
                  mainButtonText: AppLocalizations.of(context)!.addAccount,
                  dismissButtonText: AppLocalizations.of(context)!.cancel,
                  enableMainButton: isManual != null, bodyWidget: RadioRow(
                onChanged: (bool value) {
                  isManual = value;
                  setState(() {});
                },
              ), onMainButtonPressed: () async {
                if (isManual != null) {
                  if (isManual == true) {
                    investmentsCubit.navigateToAddInvestmentPage(
                      context,
                      investmentGroup: invest,
                    );
                  } else {
                    isMainButtonClicked = true;
                  }
                }
              });
            });
          }).then((value) async {
        ///choose plaid investments pop up
        if (isManual == false && isMainButtonClicked) {
          var available = await investmentsCubit.getAvailableInvestment(
              tabToInvestTransform((investmentsCubit.state as InvestmentsLoaded)
                  .investmentsTab)!);
          if (available != null && available.isNotEmpty) {
            var checkList = <bool>[];
            for (var i = 0; i <= available.length - 1; i++) {
              checkList.add(false);
            }
            await showDialog(
              context: context,
              builder: (context) {
                return _AddInvestmentsViaPlaidPopUp(
                  investmentsCubit: investmentsCubit,
                  availableInvestments: available,
                  tabTexts: tabTexts,
                );
              },
            );
          } else {
            await showDialog(
              context: context,
              builder: (context) {
                return InformAlertDialog(
                  context,
                  icon: Icons.info_rounded,
                  title:
                      'Sorry, you haven’t connected Plaid accounts for ${tabTexts[(investmentsCubit.state as InvestmentsLoaded).investmentsTab]}',
                  text:
                      'If you want to add account via Plaid, please, go to manage page',
                  buttonText: AppLocalizations.of(context)!.manageAccounts,
                  onButtonPress: () {
                    NavigatorManager.navigateTo(
                        context, ManageAccountsPage.routeName);
                  },
                );
              },
            );
          }
        }
      });
    }
  }
}

class _AddInvestmentsViaPlaidPopUp extends StatefulWidget {
  final List<AvailableInvestment> availableInvestments;
  final tabTexts;
  final InvestmentsCubit investmentsCubit;

  const _AddInvestmentsViaPlaidPopUp({
    Key? key,
    required this.availableInvestments,
    required this.tabTexts,
    required this.investmentsCubit,
  }) : super(key: key);

  @override
  State<_AddInvestmentsViaPlaidPopUp> createState() =>
      _AddInvestmentsViaPlaidPopUpState();
}

class _AddInvestmentsViaPlaidPopUpState
    extends State<_AddInvestmentsViaPlaidPopUp> {
  var popUpState = PopUpState.ChooseInvestments;
  var checkList = <bool>[];
  var brokerageList = <int?>[];

  @override
  void initState() {
    for (var i = 0; i <= widget.availableInvestments.length - 1; i++) {
      checkList.add(false);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TwoButtonsDialog(
      context,
      width: 500,
      title:
          'Choose ${widget.tabTexts[(widget.investmentsCubit.state as InvestmentsLoaded).investmentsTab]}',
      bodyWidget: popUpState == PopUpState.ChooseInvestments
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (int i = 0;
                    i <= widget.availableInvestments.length - 1;
                    i++)
                  Row(
                    children: [
                      Checkbox(
                        side: MaterialStateBorderSide.resolveWith(
                          (states) => BorderSide(
                              width: 2.0, color: CustomColorScheme.button),
                        ),
                        checkColor: CustomColorScheme.button,
                        activeColor:
                            CustomColorScheme.tableCellGeneralBackground,
                        value: checkList[i],
                        onChanged: (bool? value) {
                          setState(() {
                            checkList[i] = value!;
                          });
                        },
                      ),
                      Label(
                          text: widget.availableInvestments[i].name!,
                          type: LabelType.General),
                    ],
                  ),
                SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6.0),
                  child: RichText(
                    text: TextSpan(children: [
                      TextSpan(
                        text:
                            'If you want to add another account via Plaid go to ',
                        style: CustomTextStyle.LabelTextStyle(context),
                      ),
                      TextSpan(
                          text: 'manage page',
                          style: CustomTextStyle.LinkTextStyle(context),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              NavigatorManager.navigateTo(
                                  context, ManageAccountsPage.routeName);
                            }),
                    ]),
                  ),
                ),
              ],
            )
          : Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    for (int i = 0;
                        i <= widget.availableInvestments.length - 1;
                        i++)
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 32.0, bottom: 24.0),
                              child: Label(
                                text: widget.availableInvestments[i].name!,
                                type: LabelType.Header3,
                              ),
                            ),
                            DropdownItem<int>(
                              itemKeys: [
                                1, //Robinhood
                                2, //Webull
                                3, //Fidelity
                                4, //Charleshwab
                                5, //TDAmeritrade
                                6, //ETrade
                                7, //AllyInvest
                                8, //IteractiveBorkers
                                0 //Other
                              ],
                              callback: (value) {
                                brokerageList[i] = value;
                                checkList[i] = true;
                                setState(() {});
                              },
                              labelText:
                                  AppLocalizations.of(context)!.brokerage + '*',
                              items: [
                                AppLocalizations.of(context)!.robinhood,
                                AppLocalizations.of(context)!.webull,
                                AppLocalizations.of(context)!.fidelity,
                                AppLocalizations.of(context)!.charleshwab,
                                AppLocalizations.of(context)!.tdAmeritrade,
                                AppLocalizations.of(context)!.etrade,
                                AppLocalizations.of(context)!.allyInvest,
                                AppLocalizations.of(context)!
                                    .interactiveBrokers,
                                AppLocalizations.of(context)!.other,
                              ],
                              hintText: AppLocalizations.of(context)!
                                  .chooseTheBrokerageType,
                            ),
                          ],
                        ),
                      ),
                    SizedBox(height: 8)
                  ],
                ),
              ),
            ),
      enableMainButton: popUpState == PopUpState.ChooseInvestments
          ? checkList.contains(true)
          : !checkList.contains(false) && !brokerageList.contains(null),
      mainButtonText: AppLocalizations.of(context)!.continueWord,
      dismissButtonText: AppLocalizations.of(context)!.cancel,
      enableNavigationPopMainButton: popUpState == PopUpState.ChooseBrokerage,
      onMainButtonPressed: () async {
        if (popUpState == PopUpState.ChooseInvestments) {
          for (var i = widget.availableInvestments.length - 1; i >= 0; i--) {
            if (checkList[i] == false) {
              widget.availableInvestments.removeAt(i);
            }
          }

          checkList.clear();
          for (var i = 0; i <= widget.availableInvestments.length - 1; i++) {
            checkList.add(false);
            brokerageList.add(null);
          }

          popUpState = PopUpState.ChooseBrokerage;
        } else if (popUpState == PopUpState.ChooseBrokerage) {
          var attachInvestments = <AttachInvestmentRetirementModel>[];
          for (var i = 0; i <= widget.availableInvestments.length - 1; i++) {
            attachInvestments.add(
              AttachInvestmentRetirementModel(
                  id: widget.availableInvestments[i].id,
                  brokerage: brokerageList[i],
                  acquisitionMonthYear: DateTime.now()),
            );
          }
          await widget.investmentsCubit
              .availableInvestmentAttach(
                  attachInvestments,
                  InvestmentGroup.values[
                      (widget.investmentsCubit.state as InvestmentsLoaded)
                          .investmentsTab])
              .then((value) async => await widget.investmentsCubit.selectTab(
                  (widget.investmentsCubit.state as InvestmentsLoaded)
                      .investmentsTab));
          Navigator.pop(context);
        }
        setState(() {});
      },
    );
  }
}

enum PopUpState { ChooseInvestments, ChooseBrokerage }
