import 'dart:async';

import 'package:burgundy_budgeting_app/core/navigator_manager.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/budget_layout_inherited.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/label.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/table_row_decoration_model.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/theme.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/budget_memo_widget.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/calculation_item.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/month_dashboard.dart';
import 'package:burgundy_budgeting_app/ui/atomic/organizm/budget_monthly_layout.dart';
import 'package:burgundy_budgeting_app/ui/atomic/organizm/overlay_menu.dart';
import 'package:burgundy_budgeting_app/ui/atomic/organizm/reassign_transactions_dialog.dart';
import 'package:burgundy_budgeting_app/ui/atomic/organizm/toggling_rows_table.dart';
import 'package:burgundy_budgeting_app/ui/model/budget/monthly_budget_model.dart';
import 'package:burgundy_budgeting_app/ui/model/budget_model.dart';
import 'package:burgundy_budgeting_app/ui/model/memo_note_model.dart';
import 'package:burgundy_budgeting_app/ui/model/proflie_overview_model.dart';
import 'package:burgundy_budgeting_app/ui/screen/budget/budget_bloc.dart';
import 'package:burgundy_budgeting_app/ui/screen/budget/budget_events.dart';
import 'package:burgundy_budgeting_app/ui/screen/category_management/category_management_page.dart';
import 'package:burgundy_budgeting_app/utils/extensions.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BudgetMonthlyView extends StatefulWidget {
  final bool isPersonal;
  final bool isReadOnlyAdvisor;
  final MonthlyBudgetModel model;
  final void Function(MonthlyFormulaDataModel model) onEqualSignPressed;
  final double? initialHorizontalScrollOffset;
  final double? initialVerticalScrollOffset;
  final double? Function(double?) onHorizontalScrollOffset;
  final double? Function(double?) onVerticalScrollOffset;
  final ProfileOverviewModel user;

  final bool isCoach;

  BudgetMonthlyView({
    required this.onHorizontalScrollOffset,
    required this.onVerticalScrollOffset,
    this.initialHorizontalScrollOffset,
    this.initialVerticalScrollOffset,
    required this.model,
    required this.isPersonal,
    required this.onEqualSignPressed,
    required this.isReadOnlyAdvisor,
    required this.user,
    required this.isCoach,
  });

  @override
  State<BudgetMonthlyView> createState() => _BudgetMonthlyViewState();
}

class _BudgetMonthlyViewState extends State<BudgetMonthlyView> {
  _BudgetMonthlyViewState();

  double? verticalScrollOffset;
  double? horizontalScrollOffset;
  bool isMenuVisible = false;
  bool isMenuFocused = false;
  String? currentMenuTag;
  late final BudgetBloc _budgetBloc;
  late BudgetLayoutInherited _budgetLayoutInherited;
  late bool isTableEditable =
      widget.isPersonal || widget.model.businessId != null;

  @override
  void initState() {
    _budgetBloc = BlocProvider.of<BudgetBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    isTableEditable = widget.isPersonal || widget.model.businessId != null;

    _budgetLayoutInherited = BudgetLayoutInherited.of(context);
    var tableData = getTableData();
    var dashboardData = getDashboardData();
    return BudgetMonthlyLayout(
      tableData: tableData,
      dashboardData: dashboardData,
      onHorizontalScrollOffset: (value) {
        horizontalScrollOffset = value;
        widget.onHorizontalScrollOffset(value);
      },
      onVerticalScrollOffset: (value) {
        verticalScrollOffset = value;
        widget.onVerticalScrollOffset(value);
      },
      verticalScrollOffset: widget.initialVerticalScrollOffset,
      horizontalScrollOffset: widget.initialHorizontalScrollOffset,
      onUnbudgeted: widget.model.monthYear
                  .isBefore(_budgetBloc.transactionsStartDate) ||
              widget.model.monthYear.isAfter(_budgetBloc.transactionsEndDate)
          ? null
          : () {
              _budgetBloc.goToTransactionsForSelectedPeriod(
                context,
                widget.model.monthYear,
                isUnbudgeted: true,
              );
            },
    );
  }

  void toggleCategories(String categoryGroupId, bool value) {
    var expandedCategories = _budgetBloc.expandedCategories;
    expandedCategories[categoryGroupId] = value;
    _budgetBloc.add(ToggleCategoriesEvent(expandedCategories));
  }

  void updateTable(MonthlyBudgetSubcategory category, MonthlyBudgetModel model,
      TableType tableType,
      {bool locally = false, MonthlyBudgetSubcategory? oldSubcategory}) {
    _budgetBloc.add(
      UpdateMonthlyBudgetEvent(
        subcategory: category,
        newModel: widget.model.update(category),
        tableType: tableType,
        locally: locally,
        oldSubcategory: oldSubcategory,
      ),
    );
  }

  TableData getTableData() {
    // if its business, exclude separated expenses category (owner draw), it goes in footers
    var expensesGroup = widget.model.expenses;
    var groupRows = [
      for (var categoryGroup in [widget.model.income] + expensesGroup)
        _categoryGroupRow(
            context,
            categoryGroup,
            TableRowDecorationModel.budgetGroup(
                widget.isPersonal, categoryGroup.categoryType))
    ];
    var footers = _footerRows();

    return TableData(
      expandAll: () {
        var shouldExpand = _budgetBloc.expandedCategories.isEmpty;
        if (!shouldExpand) {
          _budgetBloc.add(ToggleCategoriesEvent({}));
        } else {
          var map = <String, bool>{};
          var list = [widget.model.income] + widget.model.expenses;
          if (widget.model.investments != null) {
            list.add(widget.model.investments!);
          }
          for (var item in list) {
            map[item.parentCategoryId] = true;
          }
          _budgetBloc.add(ToggleCategoriesEvent(map));
        }
      },
      minColumnWidths: [260, 210, 210, 210],
      header: RowData(
          cells: [
            CellData(
              'Category',
              hasRightBorder: false,
              ignoreFirstInRowProperty: true,
              onTap: () {
                NavigatorManager.navigateTo(
                  context,
                  CategoryManagementPage.routeName,
                  routeSettings: RouteSettings(
                    arguments: widget.isPersonal,
                  ),
                );
              },
              textColor: CustomColorScheme.text,
              labelType: LabelType.TableHeaderLink,
              tooltipMessage:
                  AppLocalizations.of(context)!.categoriesManagement,
            ),
            CellData('Planned', hasRightBorder: false),
            CellData('Actual', hasRightBorder: false),
            CellData('Difference', hasRightBorder: false),
          ],
          backgroundColor: CustomColorScheme.blockBackground,
          labelType: LabelType.TableHeader,
          textColor: CustomColorScheme.tableHeaderText),
      listChildRow: groupRows + footers,
    );
  }

  DashboardData getDashboardData() {
    return DashboardData(
      totalBudgeted: widget.model.totalExpenses.plannedAmount,
      totalSpent: widget.model.totalExpenses.actualAmount,
      difference: widget.model.totalExpenses.differenceAmount,
      totalUnbudgeted: widget.model.totalUnplannedAmount,
    );
  }

  List<RowData> _footerRows() {
    // Investments or Owner Draw
    var footerGroup = widget.isPersonal
        ? widget.model.investments
        : widget.model.expensesSeparated;
    return [
      //total expenses
      _calculatedFooterRow(
        AppLocalizations.of(context)!.totalExpenses,
        [
          widget.model.totalExpenses.plannedAmount,
          widget.model.totalExpenses.actualAmount,
          widget.model.totalExpenses.differenceAmount,
        ],
        TableRowDecorationModel.totalExpenses(widget.isPersonal),
      ),
      //net income
      _calculatedFooterRow(
        AppLocalizations.of(context)!.netIncome,
        [
          widget.model.netIncome.plannedAmount,
          widget.model.netIncome.actualAmount,
          widget.model.netIncome.differenceAmount,
        ],
        TableRowDecorationModel.netIncome(widget.isPersonal),
      ),
      if (widget.isPersonal && widget.model.expensesSeparated != null)
        _categoryGroupRow(
          context,
          widget.model.expensesSeparated!,
          TableRowDecorationModel.budgetGroup(
            widget.isPersonal,
            CategoryGroupType.ExpenseSeparated,
          ),
        ),
      if (footerGroup != null)
        _categoryGroupRow(
          context,
          footerGroup,
          TableRowDecorationModel.budgetGroup(
            widget.isPersonal,
            footerGroup.categoryType,
          ),
        ),
      // free cash
      _calculatedFooterRow(
        widget.isPersonal
            ? AppLocalizations.of(context)!.freeCash
            : AppLocalizations.of(context)!.retainedInTheBusiness,
        [
          widget.model.totalFreeCash.plannedAmount,
          widget.model.totalFreeCash.actualAmount,
          widget.model.totalFreeCash.differenceAmount,
        ],
        TableRowDecorationModel.freeCash(widget.isPersonal),
      ),
    ];
  }

  RowData _calculatedFooterRow(
      String name, List<int> values, TableRowDecorationModel decorationModel) {
    var cells = [
      CellData(
        name,
        iconUrl: decorationModel.iconUrl,
      ),
    ];

    for (var item in values) {
      cells.add(
        CellData(item.formattedWithDecorativeElementsString(),
            textColor:
                (item < 0 && decorationModel.alternativeTextColor != null)
                    ? decorationModel.alternativeTextColor
                    : decorationModel.mainTextColor),
      );
    }
    return RowData(
      cells: cells,
      isBold: decorationModel.isBold,
      backgroundColor: decorationModel.rowBackgroundColor,
      textColor: decorationModel.mainTextColor,
    );
  }

  RowData _categoryGroupRow(
      BuildContext context,
      MonthlyBudgetCategory categoryGroup,
      TableRowDecorationModel decorationModel) {
    var isOwnerDraw =
        (categoryGroup.categoryType == CategoryGroupType.ExpenseSeparated &&
            !widget.isPersonal);
    var isGoal = widget.isPersonal &&
        categoryGroup.categoryType == CategoryGroupType.ExpenseSeparated;
    var childRows = <RowData>[];
    var categories = categoryGroup.categories;
    childRows = categories.isNotEmpty
        ?
        //categories in group

        List.generate(
            categories.length,
            (index) {
              var managementSubcategory =
                  _budgetBloc.getManagementSubcategoryById(
                      id: categories[index].id,
                      groupId: categoryGroup.parentCategoryId);
              var subcategory = categories[index];
              var hasDoubleTap = (subcategory.nodes[0].amount != 0 &&
                  !isGoal &&
                  widget.model.monthYear
                      .isBefore(_budgetBloc.transactionsEndDate));
              var notifiers = [
                ValueNotifier<bool>(subcategory.nodes[0].notes.isNotEmpty),
                ValueNotifier<bool>(subcategory.nodes[1].notes.isNotEmpty),
                ValueNotifier<bool>(subcategory.nodes[2].notes.isNotEmpty)
              ];
              var tag =
                  'monthly${widget.model.monthYear.month}${categories[index].id}';
              return RowData(
                cells: [
                  //mixed data is displayed, not only mapped
                  CellData(
                    categories[index].id.nameLocalization(context).isNotEmpty
                        ? categories[index].id.nameLocalization(context)
                        : categories[index].name,
                    iconUrl: isOwnerDraw
                        ? categoryGroup.parentCategoryId.iconUrl()
                        : null,
                    key: Key(categories[index].id),
                    sideColor: decorationModel.rowBackgroundColor,
                    onDoubleTap: (managementSubcategory != null &&
                                !managementSubcategory.cannotBeHidden) &&
                            !widget.isReadOnlyAdvisor
                        ? () {
                            if (managementSubcategory.hasTransactions) {
                              showDialog(
                                  context: context,
                                  builder: (_context) {
                                    return ReAssignTransactionsDialog(
                                        subcategory: managementSubcategory,
                                        model:
                                            _budgetBloc.categoryManagementModel,
                                        isPersonal: widget.isPersonal,
                                        callback: (String id,
                                            {String? newCategoryId}) {
                                          _budgetBloc.add(
                                            HideCategoryEvent(id,
                                                newCategoryId: newCategoryId,
                                                subcategoryToExclude:
                                                    categories[index]),
                                          );
                                        });
                                  });
                            } else {
                              _budgetBloc.add(
                                HideCategoryEvent(managementSubcategory.id,
                                    subcategoryToExclude: categories[index]),
                              );
                            }
                          }
                        : null,
                  ),
                  CellData(
                      isOwnerDraw && !isTableEditable
                          ? subcategory.nodes[0].amount
                              .formattedWithDecorativeElementsString()
                          : subcategory.nodes[0].amount
                              .numericFormattedString(),
                      hasRightBorder: true,
                      isEditable: !widget.isReadOnlyAdvisor && isTableEditable,
                      hasError:
                          subcategory.nodes[0].expression?.isValid == false,
                      isHighlighted: _budgetLayoutInherited.data?.monthYear ==
                              widget.model.monthYear &&
                          _budgetLayoutInherited.data?.id == subcategory.id &&
                          _budgetLayoutInherited.data?.selectedType ==
                              TableType.Budgeted,
                      showFormulaIndicator: subcategory
                            .nodes[0].expression?.expression.isNotEmpty ??
                        false,
                    changeValue: (int value) {
                        var oldSubcategory =
                            MonthlyBudgetSubcategory.from(subcategory);
                        updateTable(
                            subcategory.copyWith(
                                amount: value,
                                selectedType: TableType.Budgeted),
                            widget.model,
                            TableType.Budgeted,
                            oldSubcategory: oldSubcategory);
                      },
                      showMemoNotifier: notifiers[0],
                      key: Key(tag +
                          'budgeted' +
                          subcategory.nodes[0].amount.toString()),
                      cellTag: tag + 'budgeted',
                      onEnter: (_) {
                        if (subcategory.nodes[0].notes.isNotEmpty) {
                          if (currentMenuTag != tag) {
                            showMemoMenu(
                                anchorTag: tag + 'budgeted',
                                node: subcategory.nodes[0],
                                isGoal: isGoal,
                                selectedType: TableType.Budgeted,
                                category: categories[index],
                                notifier: notifiers[0]);
                          }
                        }
                      },
                      onExit: (_) {
                        currentMenuTag = null;
                        if (isMenuVisible) {
                          Timer(Duration(milliseconds: 100), () {
                            if (isMenuVisible &&
                                !isMenuFocused &&
                                currentMenuTag == null) {
                              removeMemoMenu();
                            }
                          });
                        }
                      },
                      onPointerDown: (PointerEvent? event) {
                        if (event?.kind == PointerDeviceKind.mouse &&
                            event?.buttons == kSecondaryMouseButton) {
                          showMemoMenu(
                              anchorTag: tag + 'budgeted',
                              node: subcategory.nodes[0],
                              isGoal: isGoal,
                              selectedType: TableType.Budgeted,
                              category: categories[index],
                              notifier: notifiers[0]);
                        }
                      },
                    onEqualSignPressed: widget.isReadOnlyAdvisor
                        ? null
                        : () => widget.onEqualSignPressed(
                              MonthlyFormulaDataModel(
                                initialNode: subcategory.nodes[0],
                                tableType: TableType.Budgeted,
                                isGoal: isGoal,
                                category: subcategory,
                                budgetModel: widget.model,
                              ),
                            ),
                  ),
                  CellData(
                    isOwnerDraw
                        ? subcategory.nodes[1].amount
                            .formattedWithDecorativeElementsString()
                        : subcategory.nodes[1].amount.numericFormattedString(),
                    hasRightBorder: true,
                    //only goals are editable
                    isEditable: isGoal && !widget.isReadOnlyAdvisor,
                    hasError: subcategory.nodes[1].expression?.isValid == false,
                    isHighlighted: _budgetLayoutInherited.data?.monthYear ==
                            widget.model.monthYear &&
                        _budgetLayoutInherited.data?.id == subcategory.id &&
                        _budgetLayoutInherited.data?.selectedType ==
                            TableType.Actual,
                    showFormulaIndicator: subcategory
                            .nodes[1].expression?.expression.isNotEmpty ??
                        false,
                    changeValue: (int value) {
                      var oldSubcategory =
                          MonthlyBudgetSubcategory.from(subcategory);
                      updateTable(
                          subcategory.copyWith(
                              amount: value, selectedType: TableType.Actual),
                          widget.model,
                          TableType.Actual,
                          oldSubcategory: oldSubcategory);
                    },
                    key: Key(tag +
                        'actual' +
                        subcategory.nodes[1].amount.toString()),
                    cellTag: tag + 'actual',
                    onEnter: (_) {
                      if (subcategory.nodes[1].notes.isNotEmpty) {
                        if (currentMenuTag != tag) {
                          showMemoMenu(
                              anchorTag: tag + 'actual',
                              node: subcategory.nodes[1],
                              isGoal: isGoal,
                              selectedType: TableType.Actual,
                              category: subcategory,
                              notifier: notifiers[1]);
                        }
                      }
                    },
                    onExit: (_) {
                      currentMenuTag = null;
                      if (isMenuVisible) {
                        Timer(Duration(milliseconds: 100), () {
                          if (isMenuVisible &&
                              !isMenuFocused &&
                              currentMenuTag == null) {
                            removeMemoMenu();
                          }
                        });
                      }
                    },
                    onPointerDown: (PointerEvent? event) {
                      if (event?.kind == PointerDeviceKind.mouse &&
                          event?.buttons == kSecondaryMouseButton) {
                        showMemoMenu(
                            anchorTag: tag + 'actual',
                            node: subcategory.nodes[1],
                            isGoal: isGoal,
                            selectedType: TableType.Actual,
                            category: subcategory,
                            notifier: notifiers[1]);
                      }
                    },
                    onEqualSignPressed: !isGoal || widget.isReadOnlyAdvisor
                        ? null
                        : () => widget.onEqualSignPressed(
                              MonthlyFormulaDataModel(
                                  initialNode: subcategory.nodes[1],
                                  tableType: TableType.Actual,
                                  isGoal: isGoal,
                                  category: subcategory,
                                  budgetModel: widget.model),
                            ),
                    onDoubleTap: hasDoubleTap
                        ? null
                        : () => _budgetBloc.goToTransactionsForSelectedPeriod(
                              context,
                              widget.model.monthYear,
                              parentCategoryId: categoryGroup.parentCategoryId,
                              childCategoryId: categories[index].id,
                            ),
                    showMemoNotifier: notifiers[1],
                  ),
                  CellData(
                    isOwnerDraw
                        ? categories[index]
                            .difference
                            .amount
                            .formattedWithDecorativeElementsString()
                        : categories[index]
                            .difference
                            .amount
                            .numericFormattedString(),
                    showMemoNotifier: notifiers[2],
                    key: Key(tag +
                        'difference' +
                        categories[index].nodes[2].amount.toString()),
                    cellTag: tag + 'difference',
                    onEnter: (_) {
                      if (subcategory.nodes[2].notes.isNotEmpty) {
                        if (currentMenuTag != tag) {
                          showMemoMenu(
                              anchorTag: tag + 'difference',
                              node: subcategory.nodes[2],
                              isGoal: isGoal,
                              selectedType: TableType.Difference,
                              category: categories[index],
                              notifier: notifiers[2]);
                        }
                      }
                    },
                    onExit: (_) {
                      currentMenuTag = null;
                      if (isMenuVisible) {
                        Timer(Duration(milliseconds: 100), () {
                          if (isMenuVisible &&
                              !isMenuFocused &&
                              currentMenuTag == null) {
                            removeMemoMenu();
                          }
                        });
                      }
                    },
                    onPointerDown: (PointerEvent? event) {
                      if (event?.kind == PointerDeviceKind.mouse &&
                          event?.buttons == kSecondaryMouseButton) {
                        showMemoMenu(
                            anchorTag: tag + 'difference',
                            node: subcategory.nodes[2],
                            isGoal: isGoal,
                            selectedType: TableType.Difference,
                            category: subcategory,
                            notifier: notifiers[2]);
                      }
                    },
                  ),
                ],
                isBold: decorationModel.isBold,
                textColor: decorationModel.mainTextColor,
                backgroundColor: decorationModel.childrenBackgroundColor ??
                    decorationModel.rowBackgroundColor,
              );
            },
          )
        : [];

    return isOwnerDraw
        ? childRows.first
        : RowData(
            expanded: _budgetBloc
                    .expandedCategories[categoryGroup.parentCategoryId] ??
                false,
            toggleExpanded: (value) {
              toggleCategories(categoryGroup.parentCategoryId, value);
            },
            cells: [
              CellData(
                categoryGroup.parentCategoryId
                        .nameLocalization(context)
                        .isNotEmpty
                    ? categoryGroup.parentCategoryId.nameLocalization(context)
                    : categoryGroup.parentCategoryName,
                iconUrl: categoryGroup.parentCategoryId.iconUrl(),
              ),
              CellData((categoryGroup.categories.isNotEmpty
                      ? categoryGroup.totalPlannedAmount
                      : 0)
                  .formattedWithDecorativeElementsString()),
              CellData(
                (categoryGroup.categories.isNotEmpty
                        ? categoryGroup.totalActualAmount
                        : 0)
                    .formattedWithDecorativeElementsString(),
                onDoubleTap: categoryGroup.categories.isNotEmpty &&
                        categoryGroup.totalActualAmount != 0
                    ? () {
                        _budgetBloc.goToTransactionsForSelectedPeriod(
                          context,
                          widget.model.monthYear,
                          parentCategoryId: categoryGroup.parentCategoryId,
                        );
                      }
                    : null,
              ),
              CellData((categoryGroup.categories.isNotEmpty
                      ? categoryGroup.totalDifferenceAmount
                      : 0)
                  .formattedWithDecorativeElementsString()),
            ],
            isBold: true,
            backgroundColor: decorationModel.rowBackgroundColor,
            children: childRows,
          );
  }

  void removeMemoMenu() {
    if (isMenuVisible) {
      currentMenuTag = null;
      isMenuFocused = false;
      isMenuVisible = false;
      removeModal();
    }
  }

  void showMemoMenu(
      {required String anchorTag,
      required MonthlyNode node,
      required bool isGoal,
      required TableType selectedType,
      required MonthlyBudgetSubcategory category,
      required ValueNotifier<bool> notifier}) {
    removeMemoMenu();
    isMenuVisible = true;
    currentMenuTag = anchorTag;
    showModal(
      ModalEntry.selfPositioned(
        context,
        tag: 'memo$anchorTag',
        anchorTag: anchorTag,
        child: MouseRegion(
          onEnter: (_) {
            currentMenuTag = anchorTag;
            isMenuFocused = true;
          },
          onExit: (_) {
            removeMemoMenu();
          },
          child: MemoMenuWidget(
            notesPage: node.getNotesPage(
              isGoal,
              monthYear: widget.model.monthYear,
            ),
            isCoach: widget.isCoach,
            isPartner: widget.user.role.isPartner,
            budgetPartnerId: widget.user.partnerId,
            userId: widget.user.userId,
            onClose: () {
              removeMemoMenu();
            },
            onReply: (String text, MemoNoteModel note) async {
              var replyId = await _budgetBloc.addReply(
                note: text,
                noteId: note.transactionId ?? note.id,
                isTransaction: note.isTransaction,
                isGoal: isGoal,
              );
              if (replyId != null) {
                node.addNoteReply(
                    noteModel: note,
                    newReply: MemoNoteModel(
                        id: replyId,
                        transactionId: note.transactionId,
                        note: text,
                        isTransaction: note.isTransaction,
                        isGoal: isGoal,
                        authorUserId: widget.user.userId,
                        authorFirstName: widget.user.firstName,
                        authorLastName: widget.user.lastName,
                        authorImageUrl: widget.user.imageUrl,
                        isReply: true,
                        replies: [],
                        monthYear: note.monthYear,
                        canShowMore: false,
                        canAddReply: false));
                updateTable(category, widget.model, selectedType,
                    locally: true);
              }
            },
            onDelete: (note) async {
              await _budgetBloc.deleteNote(isGoal: isGoal, note: note);
              node.deleteNote(
                note: note,
              );
              updateTable(
                category,
                widget.model,
                selectedType,
                locally: true,
              );
            },
            onAdd: (String text) async {
              var noteId = await _budgetBloc.addNote(
                selectedType: selectedType,
                note: text,
                monthYear: widget.model.monthYear,
                categoryId: category.id,
                isGoal: isGoal,
                businessId: widget.model.businessId,
              );
              if (noteId != null) {
                node.addNote(
                  noteId: noteId,
                  transactionId: null,
                  note: text,
                  isGoal: isGoal,
                  transactionAmount: null,
                  creationDate: DateTime.now().toUtc(),
                  monthYear: widget.model.monthYear,
                  isTransaction: false,
                  currentUser: widget.user,
                );
                updateTable(category, widget.model, selectedType,
                    locally: true);
              }
            },
            onEdit: (note) async {
              await _budgetBloc.editNote(
                note: note,
                isGoal: isGoal,
              );
              node.addNote(
                noteId: note.id,
                note: note.note,
                transactionId: note.transactionId,
                isGoal: isGoal,
                transactionAmount: note.transactionAmount,
                monthYear: widget.model.monthYear,
                creationDate: note.creationDate,
                isTransaction: note.isTransaction,
                currentUser: widget.user,
              );
              updateTable(category, widget.model, selectedType, locally: true);
            },
            onUpdate: () async {
              var notesPage = await _budgetBloc.fetchNotesForNode(
                  selectedType: selectedType,
                  isGoal: isGoal,
                  monthYear: widget.model.monthYear,
                  businessId: widget.model.businessId,
                  categoryId: category.id);
              notifier.value = notesPage.notes.isNotEmpty;
              return notesPage;
            },
            onDeleteReply: (MemoNoteModel note, String replyId) async {
              await _budgetBloc.deleteNoteReply(
                replyId: replyId,
                isTransaction: note.isTransaction,
                isGoal: isGoal,
              );
              node.deleteNoteReply(noteModel: note, replyId: replyId);
              updateTable(category, widget.model, selectedType, locally: true);
            },
            onEditReply: (MemoNoteModel note, MemoNoteModel reply) async {
              await _budgetBloc.editNoteReply(
                replyId: reply.id,
                isTransaction: reply.isTransaction,
                replyText: reply.note,
                isGoal: isGoal,
              );
              node.addNoteReply(noteModel: note, newReply: reply);
              updateTable(category, widget.model, selectedType, locally: true);
            },
          ),
        ),
      ),
    );
    setState(() {});
  }
}
