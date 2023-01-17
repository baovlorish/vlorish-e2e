import 'package:burgundy_budgeting_app/core/navigator_manager.dart';
import 'package:burgundy_budgeting_app/domain/model/response/index_funds_response.dart';
import 'package:burgundy_budgeting_app/domain/model/response/retirements_models.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_inkwell.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_loading_indicator.dart';
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
import 'package:burgundy_budgeting_app/ui/atomic/organizm/overlay_menu.dart';
import 'package:burgundy_budgeting_app/ui/atomic/organizm/retirement_column_chart.dart';
import 'package:burgundy_budgeting_app/ui/atomic/organizm/retirement_statistics_widget.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/home_screen/home_screen_cubit.dart';
import 'package:burgundy_budgeting_app/ui/screen/investments/investments/investments_cubit.dart';
import 'package:burgundy_budgeting_app/ui/screen/investments/investments/investments_state.dart';
import 'package:burgundy_budgeting_app/ui/screen/manage_accounts/manage_accounts_page.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../screen/manage_accounts/manage_accounts_layout.dart';

class InvestmentsRetirementWidget extends StatefulWidget {
  const InvestmentsRetirementWidget({Key? key}) : super(key: key);

  @override
  _InvestmentsRetirementWidgetState createState() =>
      _InvestmentsRetirementWidgetState();
}

class _InvestmentsRetirementWidgetState
    extends State<InvestmentsRetirementWidget> {
  late var investmentsCubit = BlocProvider.of<InvestmentsCubit>(context);

  late var model = (investmentsCubit.state as InvestmentsLoaded).retirements ??
      RetirementPageModel(models: []);

  late var tabs =
      (investmentsCubit.state as InvestmentsLoaded).chosenRetirementTabs;
  var tabTexts = <String>[];

  var allTabTexts = [
    '401(k)',
    'Roth 401(k)',
    'IRA',
    'Roth IRA',
    'SEP IRA',
    '403(b)',
    '401a',
    '457(b)',
    'Roth 457(b)',
    'TSP',
    'RRSP',
    'TFSA',
    'Other',
  ];

  late var isLimitedCoach = BlocProvider.of<HomeScreenCubit>(context)
          .currentForeignSession
          ?.access
          .isLimited ??
      false;

  @override
  Widget build(BuildContext context) {
    tabTexts = <String>[];
    tabs = (investmentsCubit.state as InvestmentsLoaded).chosenRetirementTabs;
    tabs.forEach((element) {
      tabTexts.add(model.typeMap[element] ?? '');
    });
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
                    return SizedBox(
                      width: constraints.maxWidth,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    width: constraints.maxWidth,
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Label(
                                        softWrap: true,
                                        text:
                                            "Here, you can link or manually add and keep track of your retirement assets of all types. It's important to separate your traditional and Roth assets as it would have important tax considerations.",
                                        type: LabelType.General,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ],
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
                                        RetirementColumnChart(
                                          data: state.retirements ??
                                              RetirementPageModel(models: []),
                                          xMapper: allTabTexts,
                                        ),
                                        CustomVerticalDivider(),
                                        RetirementStatisticsWidget(
                                          state.retirements ??
                                              RetirementPageModel(models: []),
                                          xMapper: allTabTexts,
                                        ),
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
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    children: [
                                      for (var index = 0;
                                          index < tabTexts.length;
                                          index++)
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: TabSelectorButton(
                                              labelText: tabTexts[index],
                                              padding: EdgeInsets.all(12),
                                              onPressed: () {
                                                investmentsCubit
                                                    .selectRetirementTab(
                                                        tabs[index]);
                                              },
                                              isSelected: state.retirementTab ==
                                                  tabs[index]),
                                        ),
                                      ModalAnchor(
                                        tag: 'page',
                                        child: CustomMaterialInkWell(
                                          onTap: () {
                                            showOptions(tabs, investmentsCubit);
                                          },
                                          type: InkWellType.Purple,
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          child: Container(
                                            height: 30,
                                            width: 30,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15)),
                                            child: Icon(
                                              Icons.more_vert,
                                              color: CustomColorScheme.text,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ]),
                              ),
                              state.retirements != null &&
                                      state.retirements!
                                          .modelsOfType(state.retirementTab)
                                          .isNotEmpty
                                  ? SizedBox(
                                      width: constraints.maxWidth,
                                      child: InvestmentList(
                                          key: UniqueKey(),
                                          width: constraints.maxWidth,
                                          showPopUpCallback: () {
                                            showAddRetirementPopUp(
                                                state.retirementTab);
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
                                                  'Let’s connect your Retirement assets',
                                              type: LabelType.Header3,
                                              fontSize: 18,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 120,
                                            child: ButtonItem(context,
                                                text: AppLocalizations.of(
                                                        context)!
                                                    .connect,
                                                enabled: !isLimitedCoach,
                                                onPressed: () async {
                                              await showAddRetirementPopUp(
                                                  state.retirementTab);
                                            }),
                                          ),
                                        ],
                                      ),
                                    ),
                            ],
                          )
                        ],
                      ),
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

  void showOptions(List<int> selected, InvestmentsCubit cubit) {
    showModal(
      ModalEntry.anchored(
        context,
        anchorAlignment: Alignment.topLeft,
        modalAlignment: Alignment.bottomRight,
        barrierDismissible: true,
        anchorTag: 'page',
        tag: 'pageModal',
        child: BlocProvider<InvestmentsCubit>.value(
          value: cubit,
          child: BlocBuilder<InvestmentsCubit, InvestmentsState>(
              builder: (context, state) {
            return Container(
              color: Colors.white,
              width: 170,
              key: UniqueKey(),
              child: TabPageSelector(selected, cubit),
            );
          }),
        ),
      ),
    );
  }

  Future<void> showAddRetirementPopUp(int tab) async {
    bool? isManual;
    var isMainButtonClicked = false;
    await showDialog(
        context: context,
        builder: (_context) {
          return StatefulBuilder(builder: (context, setState) {
            return TwoButtonsDialog(context,
                title: AppLocalizations.of(context)!.add +
                    ' ' +
                    (model.typeMap[(investmentsCubit.state as InvestmentsLoaded)
                            .retirementTab] ??
                        ''),
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
                  investmentsCubit.navigateToAddRetirementPage(
                    context,
                    retirementType: tab,
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
        var available = await investmentsCubit.getAvailableRetirements();
        if (available != null && available.isNotEmpty) {
          var checkList = <bool>[];
          for (var i = 0; i <= available.length - 1; i++) {
            checkList.add(false);
          }
          await showDialog(
            context: context,
            builder: (context) {
              return _AddRetirementsViaPlaidPopUp(
                investmentsCubit: investmentsCubit,
                availableInvestments: available,
                tabText: model.typeMap[
                    (investmentsCubit.state as InvestmentsLoaded)
                        .retirementTab],
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

class TabPageSelector extends StatefulWidget {
  final List<int> selected;
  final InvestmentsCubit cubit;

  const TabPageSelector(
    this.selected,
    this.cubit, {
    Key? key,
  }) : super(key: key);

  @override
  _TabPageSelectorState createState() => _TabPageSelectorState();
}

class _TabPageSelectorState extends State<TabPageSelector> {
  late var selected = widget.selected;

  @override
  Widget build(BuildContext context) {
    var items = {};
    (widget.cubit.state as InvestmentsLoaded)
        .retirements!
        .typeMap
        .forEach((key, value) {
      items[key] = false;
    });
    for (var item in selected) {
      items[item] = true;
    }
    return Material(
      key: UniqueKey(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var item in items.entries.toList())
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Row(
                children: [
                  Checkbox(
                    splashRadius: 0.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    value: item.value,
                    onChanged: (selected.length < 6 || item.value == true)
                        ? (newValue) {
                            var newSelected = selected;
                            if (newValue == true) {
                              newSelected.add(item.key);
                            } else {
                              newSelected.remove(item.key);
                            }
                            widget.cubit
                                .selectChosenRetirementTabs(newSelected);
                            setState(() {});
                          }
                        : null,
                  ),
                  Label(
                      text: (widget.cubit.state as InvestmentsLoaded)
                              .retirements!
                              .typeMap[item.key] ??
                          '',
                      type: LabelType.General),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _AddRetirementsViaPlaidPopUp extends StatefulWidget {
  final List<AvailableInvestment> availableInvestments;
  final tabText;
  final InvestmentsCubit investmentsCubit;

  const _AddRetirementsViaPlaidPopUp({
    Key? key,
    required this.availableInvestments,
    required this.tabText,
    required this.investmentsCubit,
  }) : super(key: key);

  @override
  State<_AddRetirementsViaPlaidPopUp> createState() =>
      _AddRetirementsViaPlaidPopUpState();
}

class _AddRetirementsViaPlaidPopUpState
    extends State<_AddRetirementsViaPlaidPopUp> {
  var popUpState = PopUpState.ChooseRetirements;
  late var checkList = <bool>[];
  late var custodianList = <int?>[];
  late var invTypeList = <int?>[];

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
      height: 500,
      title: 'Choose ${widget.tabText}',
      bodyWidget: popUpState == PopUpState.ChooseRetirements
          ? SizedBox(
              height: 400,
              child: Column(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        for (int i = 0;
                            i <= widget.availableInvestments.length - 1;
                            i++)
                          Row(
                            children: [
                              Checkbox(
                                side: MaterialStateBorderSide.resolveWith(
                                  (states) => BorderSide(
                                      width: 2.0,
                                      color: CustomColorScheme.button),
                                ),
                                checkColor: CustomColorScheme.button,
                                activeColor: CustomColorScheme
                                    .tableCellGeneralBackground,
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
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6.0),
                    child: RichText(
                      text: TextSpan(children: [
                        TextSpan(
                          text:
                              'If you want to add another account via Plaid, please, go to ',
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
              ),
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
                                  top: 16.0, bottom: 16.0),
                              child: Label(
                                text: widget.availableInvestments[i].name!,
                                type: LabelType.Header3,
                              ),
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            DropdownItem<int>(
                              itemKeys: [
                                1, //'Guideline'
                                2, //'Human Interest',
                                3, //'Betterment',
                                4, //'Wealthfront',
                                5, //'Fidelity',
                                6, // 'T. Rowe Price',
                                7, //'Merril Edge',
                                8, // 'Charles Scwab',
                                9, // 'ADP',
                                0, // 'Other',
                              ],
                              callback: (value) {
                                custodianList[i] = value;
                                if (invTypeList[i] != null) {
                                  checkList[i] = true;
                                }
                                setState(() {});
                              },
                              labelText: 'Custodian*',
                              items: [
                                'Guideline',
                                'Human Interest',
                                'Betterment',
                                'Wealthfront',
                                'Fidelity',
                                'T. Rowe Price',
                                'Merril Edge',
                                'Charles Scwab',
                                'ADP',
                                'Other',
                              ],
                              hintText: AppLocalizations.of(context)!.select,
                            ),
                            DropdownItem<int>(
                              itemKeys: [
                                1, //'Stock'
                                2, //'Index Fund,
                                0, // 'Other',
                              ],
                              callback: (value) {
                                invTypeList[i] = value;
                                if (custodianList[i] != null) {
                                  checkList[i] = true;
                                }
                                setState(() {});
                              },
                              labelText: 'Invest Type*',
                              items: [
                                'Stock',
                                'Index Fund',
                                'Other',
                              ],
                              hintText: AppLocalizations.of(context)!.select,
                            ),
                          ],
                        ),
                      ),
                    SizedBox(height: 8)
                  ],
                ),
              ),
            ),
      enableMainButton: popUpState == PopUpState.ChooseRetirements
          ? checkList.contains(true)
          : !checkList.contains(false),
      mainButtonText: AppLocalizations.of(context)!.continueWord,
      dismissButtonText: AppLocalizations.of(context)!.cancel,
      enableNavigationPopMainButton: popUpState == PopUpState.ChooseCustodian,
      onMainButtonPressed: () async {
        if (popUpState == PopUpState.ChooseRetirements) {
          for (var i = widget.availableInvestments.length - 1; i >= 0; i--) {
            if (checkList[i] == false) {
              widget.availableInvestments.removeAt(i);
            }
          }

          checkList.clear();
          for (var i = 0; i <= widget.availableInvestments.length - 1; i++) {
            checkList.add(false);
            custodianList.add(null);
            invTypeList.add(null);
          }

          popUpState = PopUpState.ChooseCustodian;
        } else if (popUpState == PopUpState.ChooseCustodian) {
          var attachInvestments = <AttachInvestmentRetirementModel>[];
          for (var i = 0; i <= widget.availableInvestments.length - 1; i++) {
            attachInvestments.add(
              AttachInvestmentRetirementModel(
                  id: widget.availableInvestments[i].id,
                  custodian: custodianList[i],
                  investType: invTypeList[i],
                  acquisitionMonthYear: DateTime.now()),
            );
          }
          await widget.investmentsCubit.availableRetirementAttach(
              attachInvestments,
              (widget.investmentsCubit.state as InvestmentsLoaded)
                  .retirementTab);
          Navigator.pop(context);
        }
        setState(() {});
      },
    );
  }
}

enum PopUpState { ChooseRetirements, ChooseCustodian }
