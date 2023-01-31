import 'package:burgundy_budgeting_app/domain/model/response/index_funds_response.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_loading_indicator.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_tooltip.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_vertical_devider.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/label.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/maybe_scrollable_widget.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/theme.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/annual_monthly_button.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/button_item.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/error_alert_dialog.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/two_buttons_alert_dialog.dart';
import 'package:burgundy_budgeting_app/ui/atomic/organizm/investment_institution_accounts_popup.dart';
import 'package:burgundy_budgeting_app/ui/atomic/organizm/investment_list.dart';
import 'package:burgundy_budgeting_app/ui/atomic/organizm/investments_column_chart.dart';
import 'package:burgundy_budgeting_app/ui/atomic/organizm/investments_statistics_widget.dart';
import 'package:burgundy_budgeting_app/ui/atomic/organizm/tax_statistics_widget.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/home_screen/home_screen_cubit.dart';
import 'package:burgundy_budgeting_app/ui/model/bank_account.dart';
import 'package:burgundy_budgeting_app/ui/screen/investments/investments/investments_cubit.dart';
import 'package:burgundy_budgeting_app/ui/screen/investments/investments/investments_state.dart';
import 'package:burgundy_budgeting_app/ui/screen/manage_accounts/manage_accounts_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class InvestmentsLayoutWidget extends StatefulWidget {
  final Function(List<BankAccount> bankAccounts) onSuccessCallback;

  const InvestmentsLayoutWidget({Key? key, required this.onSuccessCallback})
      : super(key: key);

  @override
  _InvestmentsLayoutWidgetState createState() =>
      _InvestmentsLayoutWidgetState();
}

class _InvestmentsLayoutWidgetState extends State<InvestmentsLayoutWidget> {
  late var investmentsCubit = BlocProvider.of<InvestmentsCubit>(context);

  InvestmentGroup? tabToInvestTransform(int tab) {
    switch (tab) {
      case 0:
        return InvestmentGroup.Stocks;
      case 1:
        return InvestmentGroup.IndexFunds;
      case 2:
        return InvestmentGroup.Cryptocurrencies;
      case 3:
        return InvestmentGroup.Property;
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
  late var isReadOnlyAdvisor = BlocProvider.of<HomeScreenCubit>(context)
          .currentForeignSession
          ?.access
          .isReadOnly ??
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
                                              enabled: !isReadOnlyAdvisor,
                                              onPressed: !isReadOnlyAdvisor
                                                  ? () {
                                                      var invest =
                                                          tabToInvestTransform(
                                                              (investmentsCubit
                                                                          .state
                                                                      as InvestmentsLoaded)
                                                                  .investmentsTab);
                                                      if (invest != null) {
                                                        showAddInvestPopUp(
                                                            invest);
                                                      }
                                                    }
                                                  : () {}),
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
        invest == InvestmentGroup.Property) {
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
          var accounts =
              await investmentsCubit.getInvestmentInstitutionAccounts();
          accounts.isEmpty
              ? await investmentsCubit.addPlaidAccount(
                  onSuccessCallback: widget.onSuccessCallback,
                  type: LinkTokenType.Investments.index,
                )
              : await showDialog(
                  context: context,
                  builder: (context) => ChooseInvestmentInstitutionAccountPopup(
                        accounts: accounts,
                        onSubmit: (String id, bool isLoginRequired) async =>
                            isLoginRequired
                                ? await investmentsCubit.loginWithPlaid(id, context)
                                : await investmentsCubit.manageInstitution(id,
                                    onSuccessCallback:
                                        widget.onSuccessCallback),
                        onAddAnother: () async => await investmentsCubit.addPlaidAccount(
                          onSuccessCallback: widget.onSuccessCallback,
                          type: LinkTokenType.Investments.index,
                        ),
                      ));
        }
      });
    }
  }
}
