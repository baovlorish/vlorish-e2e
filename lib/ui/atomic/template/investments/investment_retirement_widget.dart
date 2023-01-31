import 'package:burgundy_budgeting_app/domain/model/response/retirements_models.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_inkwell.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_loading_indicator.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_vertical_devider.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/label.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/maybe_scrollable_widget.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/theme.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/annual_monthly_button.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/button_item.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/error_alert_dialog.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/two_buttons_alert_dialog.dart';
import 'package:burgundy_budgeting_app/ui/atomic/organizm/investment_list.dart';
import 'package:burgundy_budgeting_app/ui/atomic/organizm/overlay_menu.dart';
import 'package:burgundy_budgeting_app/ui/atomic/organizm/retirement_column_chart.dart';
import 'package:burgundy_budgeting_app/ui/atomic/organizm/retirement_statistics_widget.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/home_screen/home_screen_cubit.dart';
import 'package:burgundy_budgeting_app/ui/model/bank_account.dart';
import 'package:burgundy_budgeting_app/ui/screen/investments/investments/investments_cubit.dart';
import 'package:burgundy_budgeting_app/ui/screen/investments/investments/investments_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../screen/manage_accounts/manage_accounts_layout.dart';
import '../../organizm/investment_institution_accounts_popup.dart';

class InvestmentsRetirementWidget extends StatefulWidget {
  final Function(List<BankAccount> bankAccounts) onSuccessCallback;

  const InvestmentsRetirementWidget({Key? key, required this.onSuccessCallback})
      : super(key: key);

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

  late var isReadOnlyAdvisor = BlocProvider.of<HomeScreenCubit>(context)
          .currentForeignSession
          ?.access
          .isReadOnly ??
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
                                                enabled: !isReadOnlyAdvisor,
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
                              ? await investmentsCubit.loginWithPlaid(
                                  id, context)
                              : await investmentsCubit.manageInstitution(id,
                                  onSuccessCallback: widget.onSuccessCallback),
                      onAddAnother: () async =>
                          await investmentsCubit.addPlaidAccount(
                        onSuccessCallback: widget.onSuccessCallback,
                        type: LinkTokenType.Investments.index,
                      ),
                    ));
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
