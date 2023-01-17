import 'package:burgundy_budgeting_app/ui/atomic/atom/budget_layout_inherited.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/clip_selector.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_loading_indicator.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_tooltip.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/label.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/maybe_scrollable_widget.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/theme.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/arrow_buttons.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/calculation_item.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/clip_selector_element.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/error_alert_dialog.dart';
import 'package:burgundy_budgeting_app/ui/atomic/organizm/annual_monthly_switcher.dart';
import 'package:burgundy_budgeting_app/ui/atomic/organizm/period_selector.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/home_screen/home_screen.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/home_screen/home_screen_cubit.dart';
import 'package:burgundy_budgeting_app/ui/model/arithmetic_expression.dart';
import 'package:burgundy_budgeting_app/ui/model/budget/monthly_budget_model.dart';
import 'package:burgundy_budgeting_app/ui/model/budget_model.dart';
import 'package:burgundy_budgeting_app/ui/model/period.dart';
import 'package:burgundy_budgeting_app/ui/screen/budget/budget_annual_view.dart';
import 'package:burgundy_budgeting_app/ui/screen/budget/budget_bloc.dart';
import 'package:burgundy_budgeting_app/ui/screen/budget/budget_events.dart';
import 'package:burgundy_budgeting_app/ui/screen/budget/budget_monthly_view.dart';
import 'package:burgundy_budgeting_app/ui/screen/budget/budget_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BudgetLayout extends StatefulWidget {
  final bool isPersonal;

  BudgetLayout({required this.isPersonal});

  @override
  State<BudgetLayout> createState() => _BudgetLayoutState();
}

class _BudgetLayoutState extends State<BudgetLayout> {
  double? horizontalScrollOffset;
  double? verticalScrollOffset;
  late Period userPeriod;

  BudgetLayoutHighlightedCellData? highlightedCellData;

  var typeMap = {
    Key('budgeted'): TableType.Budgeted,
    Key('actual'): TableType.Actual,
    Key('difference'): TableType.Difference,
  };

  late Widget bodyWidget;

  late final HomeScreenCubit homeScreenCubit;
  late final BudgetBloc budgetBloc;

  bool isFormulaFieldOpen = false;
  covariant GeneralFormulaDataModel? formulaDataModel;
  TableType selectedType = TableType.Actual;

  MonthlyBudgetSubcategory? oldNodeMonthlySubcategory;

  void openAndFocusCalculationField(covariant GeneralFormulaDataModel model) {
    isFormulaFieldOpen = true;
    if (model is AnnualFormulaDataModel) {
      highlightedCellData = BudgetLayoutHighlightedCellData(
          selectedType: model.initialNode.tableType,
          id: model.category.id,
          monthYear: model.initialNode.monthYear);
      formulaDataModel = model;
    } else if (model is MonthlyFormulaDataModel) {
      highlightedCellData = BudgetLayoutHighlightedCellData(
          selectedType: model.tableType,
          id: model.category.id,
          monthYear: model.budgetModel.monthYear);
      formulaDataModel = model;
    }

    setState(() {});
  }

  @override
  void initState() {
    homeScreenCubit = BlocProvider.of<HomeScreenCubit>(context);
    budgetBloc = BlocProvider.of<BudgetBloc>(context);
    super.initState();
    RawKeyboard.instance.addListener(
      (RawKeyEvent event) {
        if ((event.isControlPressed || event.isMetaPressed) &&
            event.physicalKey == PhysicalKeyboardKey.keyZ &&
            !event.repeat &&
            event is RawKeyDownEvent) {
          undo();
        } else if ((event.isControlPressed || event.isMetaPressed) &&
            event.physicalKey == PhysicalKeyboardKey.keyY &&
            !event.repeat &&
            event is RawKeyDownEvent) {
          redo();
        }
      },
    );
  }

  void undo() {
    if (budgetBloc.state is BudgetLoadedState &&
        (budgetBloc.undoAnnualNodeQueue.isNotEmpty ||
            budgetBloc.undoMonthlyTableType.isNotEmpty)) {
      budgetBloc.add(UndoNodeEvent());
    }
  }

  void redo() {
    if (budgetBloc.state is BudgetLoadedState &&
        (budgetBloc.redoAnnualNode != null ||
            budgetBloc.redoMonthlyTableType != null)) {
      budgetBloc.add(RedoNodeEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BudgetBloc, BudgetState>(
      listener: (BuildContext context, state) {
        if (state is BudgetErrorState) {
          showDialog(
              context: context,
              builder: (context) {
                return ErrorAlertDialog(
                  context,
                  message: state.message,
                );
              });
        }
        if (state is BudgetAnnualLoadedState ||
            state is BudgetMonthlyLoadedState) {
          userPeriod = homeScreenCubit.longPeriod;
        }
      },
      buildWhen: (previous, current) {
        if (current is BudgetLoadingState) {
          return current.showLoading;
        } else {
          return true;
        }
      },
      builder: (context, state) {
        if (state is BudgetAnnualLoadedState) {
          bodyWidget = BudgetAnnualView(
            onHorizontalScrollOffset: (value) => horizontalScrollOffset = value,
            onVerticalScrollOffset: (value) => verticalScrollOffset = value,
            initialHorizontalScrollOffset: horizontalScrollOffset,
            initialVerticalScrollOffset: verticalScrollOffset,
            user: homeScreenCubit.user,
            isPersonal: widget.isPersonal,
            model: state.model,
            userPeriod: userPeriod,
            onEditableCellDoubleTap: (AnnualFormulaDataModel model) {
              openAndFocusCalculationField(model);
            },
            isCoach: homeScreenCubit.currentForeignSession != null,
            isLimitedCoach:
                homeScreenCubit.currentForeignSession?.access.isLimited ??
                    false,
          );
        } else if (state is BudgetMonthlyLoadedState) {
          bodyWidget = BudgetMonthlyView(
            onHorizontalScrollOffset: (value) => horizontalScrollOffset = value,
            onVerticalScrollOffset: (value) => verticalScrollOffset = value,
            initialHorizontalScrollOffset: horizontalScrollOffset,
            initialVerticalScrollOffset: verticalScrollOffset,
            user: homeScreenCubit.user,
            isPersonal: widget.isPersonal,
            model: state.model,
            onEditableCellDoubleTap: (MonthlyFormulaDataModel model) {
              openAndFocusCalculationField(model);
            },
            isCoach: homeScreenCubit.currentForeignSession != null,
            isLimitedCoach:
                homeScreenCubit.currentForeignSession?.access.isLimited ??
                    false,
          );
        } else if (state is BudgetLoadingState) {
          bodyWidget = CustomLoadingIndicator();
        } else if (state is BudgetMigratingState) {
          bodyWidget = Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 100.0),
                  child: Icon(
                    Icons.card_travel_rounded,
                    size: 100,
                    color: CustomColorScheme.textHint,
                  ),
                ),
                Label(
                  type: LabelType.HintLargeBold,
                  text: 'No data here yet',
                ),
              ],
            ),
          );
        } else {
          bodyWidget = Container();
        }

        return BudgetLayoutInherited(
          data: highlightedCellData,
          child: HomeScreen(
            currentTab:
                widget.isPersonal ? Tabs.BudgetPersonal : Tabs.BudgetBusiness,
            title: widget.isPersonal
                ? AppLocalizations.of(context)!.personalBudget
                : AppLocalizations.of(context)!.businessBudget,
            headerWidget: Column(
              children: [
                LayoutBuilder(builder: (context, constraints) {
                  var shouldScroll = constraints.maxWidth < 1150;
                  return MaybeScrollableWidget(
                    shouldScrollWhen: shouldScroll,
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Label(
                          text: widget.isPersonal
                              ? AppLocalizations.of(context)!.personalBudget
                              : AppLocalizations.of(context)!.businessBudget,
                          type: LabelType.Header2,
                        ),
                        SizedBox(width: 24),
                        if (!widget.isPersonal &&
                            budgetBloc.businessList != null &&
                            budgetBloc.businessList!.length > 2)
                          CustomTooltip(
                            message: AppLocalizations.of(context)!
                                .selectBusinessAccount,
                            child: PopupMenuButton<String>(
                              padding: EdgeInsets.zero,
                              // if tooltip is null here, it shows default 'show menu' tooltip
                              tooltip: '',
                              onSelected: (String value) {
                                if (value !=
                                    AppLocalizations.of(context)!.all) {
                                  budgetBloc.add(ChangeBusinessNameEvent(
                                      value, state is BudgetAnnualLoadedState));
                                } else {
                                  budgetBloc.add(ChangeBusinessNameEvent(
                                      null, state is BudgetAnnualLoadedState));
                                }
                                budgetBloc.clearUndoAndRedoQueues();
                              },
                              itemBuilder: (BuildContext context) {
                                return List.generate(
                                    budgetBloc.businessList!.length, (index) {
                                  var value = index == 0
                                      ? null
                                      : budgetBloc.businessList![index].id;
                                  var enabled = budgetBloc.businessList![index]
                                          .hasTransactions ==
                                      true;
                                  return PopupMenuItem(
                                    value: value ??
                                        AppLocalizations.of(context)!.all,
                                    enabled: enabled,
                                    child: Label(
                                      text:
                                          budgetBloc.businessList![index].name,
                                      color: enabled
                                          ? CustomColorScheme.text
                                          : CustomColorScheme.textHint,
                                      type: value ==
                                              (state as BudgetLoadedState)
                                                  .model
                                                  .businessId
                                          ? LabelType.GeneralBold
                                          : LabelType.General,
                                    ),
                                  );
                                });
                              },
                              child: Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15)),
                                child: Icon(
                                  Icons.more_vert,
                                  color: CustomColorScheme.mainDarkBackground,
                                ),
                              ),
                            ),
                          ),
                        SizedBox(width: 24),
                        if (state is BudgetLoadedState)
                          TwoOptionSwitcher(
                            isFirstItemSelected:
                                state is BudgetAnnualLoadedState,
                            options: [
                              AppLocalizations.of(context)!.annual,
                              AppLocalizations.of(context)!.monthly,
                            ],
                            onPressed: () {
                              if (state is BudgetAnnualLoadedState) {
                                budgetBloc.add(BudgetMonthlyFetchEvent(
                                  monthYear: DateTime(
                                    state.model.year,
                                    DateTime.now().month,
                                  ),
                                  businessId: state.model.businessId,
                                ));
                                budgetBloc.clearUndoAndRedoQueues();
                              } else {
                                budgetBloc.add(
                                  BudgetAnnualFetchEvent(
                                    year: (state as BudgetMonthlyLoadedState)
                                        .model
                                        .monthYear
                                        .year,
                                    type: selectedType,
                                    businessId: state.model.businessId,
                                  ),
                                );
                                budgetBloc.clearUndoAndRedoQueues();
                              }
                            },
                          ),
                        SizedBox(width: 20),
                        if (state is BudgetLoadedState)
                          ArrowButtons(
                            onPressedFirstButton: budgetBloc
                                        .undoAnnualNodeQueue.isNotEmpty ||
                                    budgetBloc.undoMonthlyTableType.isNotEmpty
                                ? () {
                                    undo();
                                  }
                                : null,
                            onPressedSecondButton:
                                budgetBloc.redoAnnualNode != null ||
                                        budgetBloc.redoMonthlyTableType != null
                                    ? () {
                                        budgetBloc.add(RedoNodeEvent());
                                      }
                                    : null,
                          ),
                        SizedBox(width: 20),
                        if (state is BudgetAnnualLoadedState)
                          PeriodSelector(
                            ObjectKey(state.model.year),
                            isSmall: true,
                            defaultPosition: userPeriod.years.indexWhere(
                              (element) => element == state.model.year,
                            ),
                            labelTexts: List.generate(userPeriod.years.length,
                                (index) => userPeriod.years[index].toString()),
                            onPressed: (selectedPosition) {
                              budgetBloc.add(
                                BudgetAnnualFetchEvent(
                                  year: userPeriod.years[selectedPosition],
                                  type: selectedType,
                                  businessId: state.model.businessId,
                                ),
                              );
                              budgetBloc.clearUndoAndRedoQueues();
                            },
                          )
                        else if (state is BudgetMonthlyLoadedState)
                          PeriodSelector(
                            ObjectKey(state.model.monthYear),
                            isSmall: false,
                            defaultPosition: userPeriod.months.indexWhere(
                              (element) =>
                                  element ==
                                  DateTime(
                                    state.model.monthYear.year,
                                    state.model.monthYear.month,
                                  ),
                            ),
                            labelTexts: List.generate(
                                userPeriod.months.length,
                                (index) =>
                                    '${userPeriod.monthString(userPeriod.months[index].month)} ${userPeriod.months[index].year}'),
                            onPressed: (selectedPosition) {
                              budgetBloc.add(
                                BudgetMonthlyFetchEvent(
                                  monthYear:
                                      userPeriod.months[selectedPosition],
                                  businessId: state.model.businessId,
                                ),
                              );
                              budgetBloc.clearUndoAndRedoQueues();
                            },
                          ),
                        if (!shouldScroll) Spacer(),
                        if (state is BudgetAnnualLoadedState)
                          ClipSelectorElement(
                            [
                              ClipSelectorData(
                                  key: Key('budgeted'),
                                  title: 'Planned',
                                  selected: selectedType == TableType.Budgeted),
                              ClipSelectorData(
                                  key: Key('actual'),
                                  title: 'Actual',
                                  selected: selectedType == TableType.Actual),
                              ClipSelectorData(
                                  key: Key('difference'),
                                  title: 'Difference',
                                  selected:
                                      selectedType == TableType.Difference),
                            ],
                            (selected) {
                              selectedType =
                                  typeMap[selected.key] ?? TableType.Actual;
                              budgetBloc.add(
                                BudgetAnnualFetchEvent(
                                  year: state.model.year,
                                  type: selectedType,
                                  businessId: state.model.businessId,
                                ),
                              );
                              budgetBloc.clearUndoAndRedoQueues();
                            },
                            padding: EdgeInsets.only(right: 16.0),
                          ),
                        if (!shouldScroll) Spacer(),
                      ],
                    ),
                  );
                }),
                if (isFormulaFieldOpen && formulaDataModel != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: CalculationItem(
                      model: formulaDataModel!,
                      key: ObjectKey(formulaDataModel),
                      onValueUpdated: (int? value, String? expression) {
                        if (value != null) {
                          if (formulaDataModel is AnnualFormulaDataModel) {
                            var oldNode =
                                (formulaDataModel as AnnualFormulaDataModel)
                                    .initialNode;
                            var node =
                                (formulaDataModel as AnnualFormulaDataModel)
                                    .initialNode
                                    .copyWith(
                                        amount: value, expression: expression);
                            budgetBloc.add(UpdateAnnualBudgetEvent(
                                newModel:
                                    (formulaDataModel as AnnualFormulaDataModel)
                                        .budgetModel
                                        .update(
                                            node,
                                            (formulaDataModel
                                                    as AnnualFormulaDataModel)
                                                .category),
                                node: node,
                                oldNode: oldNode,
                                locally: true));
                            (formulaDataModel as AnnualFormulaDataModel)
                                .currentNode = node;
                          } else if (formulaDataModel
                              is MonthlyFormulaDataModel) {
                            oldNodeMonthlySubcategory ??=
                                MonthlyBudgetSubcategory.from((formulaDataModel
                                        as MonthlyFormulaDataModel)
                                    .category);
                            var node =
                                (formulaDataModel as MonthlyFormulaDataModel)
                                    .initialNode;
                            node.amount = value;
                            node.expression =
                                expression != null && expression.isNotEmpty
                                    ? ArithmeticExpression.fromExpression(
                                        expression)
                                    : null;
                            var subcategory =
                                (formulaDataModel as MonthlyFormulaDataModel)
                                    .category
                                    .copyWith(
                                        selectedType: TableType.Budgeted,
                                        amount: node.amount,
                                        expression: node.expression);
                            budgetBloc.add(UpdateMonthlyBudgetEvent(
                                subcategory: subcategory,
                                newModel: (formulaDataModel
                                        as MonthlyFormulaDataModel)
                                    .budgetModel
                                    .update(subcategory),
                                locally: true,
                                tableType: formulaDataModel!.tableType));
                          }
                        }
                      },
                      onValueSubmitted: () {
                        if (formulaDataModel is AnnualFormulaDataModel) {
                          budgetBloc.add(UpdateAnnualBudgetEvent(
                              node: (formulaDataModel as AnnualFormulaDataModel)
                                  .currentNode,
                              newModel:
                                  (formulaDataModel as AnnualFormulaDataModel)
                                      .budgetModel
                                      .update(
                                          (formulaDataModel
                                                  as AnnualFormulaDataModel)
                                              .currentNode,
                                          (formulaDataModel
                                                  as AnnualFormulaDataModel)
                                              .category),
                              oldNode:
                                  (formulaDataModel as AnnualFormulaDataModel)
                                      .initialNode,
                              oldNodeCategory:
                                  (formulaDataModel as AnnualFormulaDataModel)
                                      .category));
                        } else if (formulaDataModel
                            is MonthlyFormulaDataModel) {
                          var subcategory =
                              (formulaDataModel as MonthlyFormulaDataModel)
                                  .category
                                  .copyWith(
                                      selectedType: TableType.Budgeted,
                                      amount: (formulaDataModel
                                              as MonthlyFormulaDataModel)
                                          .currentNode
                                          .amount,
                                      expression: (formulaDataModel
                                              as MonthlyFormulaDataModel)
                                          .currentNode
                                          .expression);
                          budgetBloc.add(UpdateMonthlyBudgetEvent(
                              subcategory: subcategory,
                              newModel:
                                  (formulaDataModel as MonthlyFormulaDataModel)
                                      .budgetModel
                                      .update(subcategory),
                              tableType: TableType.Budgeted,
                              oldSubcategory: oldNodeMonthlySubcategory));
                          oldNodeMonthlySubcategory = null;
                        }
                        isFormulaFieldOpen = false;
                        formulaDataModel = null;
                        highlightedCellData = null;
                        setState(() {});
                      },
                      onClose: () {
                        highlightedCellData = null;
                        if (formulaDataModel is AnnualFormulaDataModel) {
                          budgetBloc.add(UpdateAnnualBudgetEvent(
                              node: (formulaDataModel as AnnualFormulaDataModel)
                                  .initialNode,
                              newModel:
                                  (formulaDataModel as AnnualFormulaDataModel)
                                      .budgetModel,
                              locally: true));
                        } else if (formulaDataModel
                            is MonthlyFormulaDataModel) {
                          var subcategory =
                              (formulaDataModel as MonthlyFormulaDataModel)
                                  .category
                                  .copyWith(
                                      selectedType: selectedType,
                                      amount: (formulaDataModel
                                              as MonthlyFormulaDataModel)
                                          .initialNode
                                          .amount,
                                      expression: (formulaDataModel
                                              as MonthlyFormulaDataModel)
                                          .initialExpression);
                          budgetBloc.add(
                            UpdateMonthlyBudgetEvent(
                                subcategory: subcategory,
                                newModel: (formulaDataModel
                                        as MonthlyFormulaDataModel)
                                    .budgetModel
                                    .update(subcategory),
                                locally: true,
                                tableType: formulaDataModel!.tableType),
                          );
                        }

                        isFormulaFieldOpen = false;
                        formulaDataModel = null;
                        setState(() {});
                      },
                    ),
                  ),
              ],
            ),
            bodyWidget: bodyWidget,
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    RawKeyboard.instance.removeListener((RawKeyEvent event) {});
    super.dispose();
  }
}
