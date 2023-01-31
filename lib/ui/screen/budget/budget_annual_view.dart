import 'dart:async';

import 'package:burgundy_budgeting_app/core/navigator_manager.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/budget_layout_inherited.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/label.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/table_row_decoration_model.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/theme.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/budget_memo_widget.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/calculation_item.dart';
import 'package:burgundy_budgeting_app/ui/atomic/organizm/budget_annual_layout.dart';
import 'package:burgundy_budgeting_app/ui/atomic/organizm/overlay_menu.dart';
import 'package:burgundy_budgeting_app/ui/atomic/organizm/reassign_transactions_dialog.dart';
import 'package:burgundy_budgeting_app/ui/atomic/organizm/toggling_rows_table.dart';
import 'package:burgundy_budgeting_app/ui/model/budget/annual_budget_model.dart';
import 'package:burgundy_budgeting_app/ui/model/budget_model.dart';
import 'package:burgundy_budgeting_app/ui/model/memo_note_model.dart';
import 'package:burgundy_budgeting_app/ui/model/period.dart';
import 'package:burgundy_budgeting_app/ui/model/proflie_overview_model.dart';
import 'package:burgundy_budgeting_app/ui/screen/budget/budget_bloc.dart';
import 'package:burgundy_budgeting_app/ui/screen/budget/budget_events.dart';
import 'package:burgundy_budgeting_app/ui/screen/category_management/category_management_page.dart';
import 'package:burgundy_budgeting_app/utils/extensions.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BudgetAnnualView extends StatefulWidget {
  final bool isPersonal;
  final bool isReadOnlyAdvisor;
  final double? initialHorizontalScrollOffset;
  final double? initialVerticalScrollOffset;
  final double? Function(double?) onHorizontalScrollOffset;
  final double? Function(double?) onVerticalScrollOffset;
  final Period userPeriod;
  final AnnualBudgetModel model;
  final Function(AnnualFormulaDataModel model) onEditableCellDoubleTap;
  final ProfileOverviewModel user;

  final bool isCoach;

  const BudgetAnnualView({
    required this.onHorizontalScrollOffset,
    required this.onVerticalScrollOffset,
    required this.model,
    required this.isReadOnlyAdvisor,
    required this.isPersonal,
    this.initialHorizontalScrollOffset,
    this.initialVerticalScrollOffset,
    required this.userPeriod,
    required this.onEditableCellDoubleTap,
    required this.user,
    required this.isCoach,
  });

  @override
  State<BudgetAnnualView> createState() => _BudgetAnnualViewState();
}

class _BudgetAnnualViewState extends State<BudgetAnnualView> {
  double? verticalScrollOffset;
  double? horizontalScrollOffset;
  int? selectedEditableCellIndex;
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
    _budgetLayoutInherited = BudgetLayoutInherited.of(context);
    var tableData = getTableData(context, widget.model);
    return BudgetAnnualLayout(
      verticalScrollOffset: widget.initialVerticalScrollOffset,
      horizontalScrollOffset: widget.initialHorizontalScrollOffset,
      tableData: tableData,
      onHorizontalScrollOffset: (value) {
        horizontalScrollOffset = value;
        widget.onHorizontalScrollOffset(value);
      },
      onVerticalScrollOffset: (value) {
        verticalScrollOffset = value;
        widget.onVerticalScrollOffset(value);
      },
    );
  }

  TableData getTableData(BuildContext context, AnnualBudgetModel model) {
    var footers = _footers(model, context, model.type);
    var expensesGroup = model.expenses
        .where((element) =>
            element.categoryType == CategoryGroupType.ExpenseGeneral)
        .toList();
    var groupRows = [
      for (var categoryGroup in [model.income] + expensesGroup)
        _categoryGroupRow(
            context,
            categoryGroup,
            model,
            TableRowDecorationModel.budgetGroup(
                widget.isPersonal, categoryGroup.categoryType))
    ];

    var width = 146.0;
    var headerWidth = 268.0;
    var cellWidths = [headerWidth] + List.generate(14, (index) => width);

    var monthHeaderCells = <CellData>[];
    for (var item in model.period.months) {
      var hasDoubleTap = model.type == TableType.Budgeted &&
          item.isBefore(widget.userPeriod.months.last) &&
          !widget.isReadOnlyAdvisor &&
          isTableEditable;
      monthHeaderCells.add(
        CellData(
          model.period.monthString(item.month),
          mainAxisAlignment: MainAxisAlignment.start,
          textColor: hasDoubleTap ? CustomColorScheme.text : null,
          hasRightBorder: false,
          tooltipMessage: hasDoubleTap
              ? AppLocalizations.of(context)!.doubleClickToCopyPlannedBudget
              : null,
          onDoubleTap: hasDoubleTap
              ? () {
                  _budgetBloc.add(CopyMonthEvent(item, model.businessId));
                }
              : null,
          key: hasDoubleTap ? UniqueKey() : null,
        ),
      );
    }

    return TableData(
      minColumnWidths: cellWidths,
      expandAll: () {
        var shouldExpand = _budgetBloc.expandedCategories.isEmpty;
        if (!shouldExpand) {
          _budgetBloc.add(ToggleCategoriesEvent({}));
        } else {
          var map = <String, bool>{};
          var list = [model.income] + model.expenses;
          if (model.investments != null) {
            list.add(model.investments!);
          }
          for (var item in list) {
            map[item.parentCategoryId] = true;
          }
          _budgetBloc.add(ToggleCategoriesEvent(map));
        }
      },
      header: RowData(
          cells: [
            CellData(
              'Category',
              hasRightBorder: false,
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
            for (var item in monthHeaderCells) item,
            CellData(
              'year',
              mainAxisAlignment: MainAxisAlignment.start,
              hasRightBorder: false,
            ),
            CellData(
              '%',
              mainAxisAlignment: MainAxisAlignment.start,
            )
          ],
          backgroundColor: CustomColorScheme.blockBackground,
          labelType: LabelType.TableHeader,
          textColor: CustomColorScheme.tableHeaderText),
      listChildRow: groupRows + footers,
    );
  }

  void toggleCategories(String categoryGroupId, bool value) {
    var expandedCategories = _budgetBloc.expandedCategories;
    expandedCategories[categoryGroupId] = value;
    _budgetBloc.add(ToggleCategoriesEvent(expandedCategories));
  }

  List<RowData> _footers(
      AnnualBudgetModel budget, BuildContext context, TableType selectedType) {
    var rows = <RowData>[];
    // Investments or Owner Draw
    var footerGroup =
        widget.isPersonal ? budget.investments! : budget.expensesSeparated;

// total expenses row
    rows.add(_footerRow(
        selectedType: selectedType,
        name: AppLocalizations.of(context)!.totalExpenses,
        decorationModel:
            TableRowDecorationModel.totalExpenses(widget.isPersonal),
        values: budget.totalExpenses.totalByMonth.amount,
        yearValue: budget.totalExpenses.totalByYear,
        percent: budget.totalExpenses.percentage.toString()));
    //net income row
    rows.add(_footerRow(
        selectedType: selectedType,
        name: AppLocalizations.of(context)!.netIncome,
        decorationModel: TableRowDecorationModel.netIncome(widget.isPersonal),
        values: budget.netIncome.totalByMonth.amount,
        yearValue: budget.netIncome.totalByYear,
        percent: budget.netIncome.percentage.toString()));

    var groupRow = _categoryGroupRow(
        context,
        footerGroup!,
        budget,
        TableRowDecorationModel.budgetGroup(
          widget.isPersonal,
          footerGroup.categoryType,
        ));

    // free cash row
    var freeCashRow = _footerRow(
        selectedType: selectedType,
        name: widget.isPersonal
            ? AppLocalizations.of(context)!.freeCash
            : AppLocalizations.of(context)!.retainedInTheBusiness,
        decorationModel: TableRowDecorationModel.freeCash(widget.isPersonal),
        values: budget.freeCash.totalByMonth.amount,
        yearValue: budget.freeCash.totalByYear,
        percent: budget.freeCash.percentage.toString());

    //total cash reserves

    var totalCashReservesRow = _footerRow(
        selectedType: selectedType,
        name: widget.isPersonal ? 'Total Cash Reserves' : 'Ending Cash Reserve',
        decorationModel: TableRowDecorationModel.netIncome(widget.isPersonal,
            iconUrl: widget.isPersonal
                ? 'assets/images/icons/categories_total_cash_reserves.png'
                : 'assets/images/icons/ending_cash_reserve.png'),
        values: budget.totalCashReserves.totalByMonth.amount,
        yearValue: budget.totalCashReserves.totalByYear,
        percent: budget.totalCashReserves.percentage.toString());
    if (widget.isPersonal) {
      //goals
      if (budget.expensesSeparated != null) {
        rows.add(_categoryGroupRow(
            context,
            budget.expensesSeparated!,
            budget,
            TableRowDecorationModel.budgetGroup(
              widget.isPersonal,
              footerGroup.categoryType,
            )));
      }
      //investments
      rows.add(groupRow);
      rows.add(freeCashRow);
      rows.add(totalCashReservesRow);
    } else {
      rows.add(groupRow);
      rows.add(freeCashRow);
      rows.add(totalCashReservesRow);
    }

    return rows;
  }

  RowData _categoryGroupRow(
      BuildContext context,
      BudgetAnnualCategory categoryGroup,
      AnnualBudgetModel model,
      TableRowDecorationModel decorationModel) {
    var isOwnerDraw =
        (categoryGroup.categoryType == CategoryGroupType.ExpenseSeparated &&
            !widget.isPersonal);
    var isDebt = (categoryGroup.parentCategoryId ==
            'd23427c2-79e8-4ef4-ba6c-54190e107eff' ||
        categoryGroup.parentCategoryId ==
            'a6050bc7-7fd5-4186-bbb2-66ba5f25888d');
    var childRows = <RowData>[];
    childRows = categoryGroup.categories.isNotEmpty
        ?
        //categories in group
        List.generate(categoryGroup.categories.length, (index) {
            var category = categoryGroup.categories[index];
            var cells = <CellData>[];
            var managementSubcategory =
                _budgetBloc.getManagementSubcategoryById(
                    id: category.id, groupId: categoryGroup.parentCategoryId);
            cells.add(
              CellData(
                category.id.nameLocalization(context).isNotEmpty
                    ? category.id.nameLocalization(context)
                    : category.name,
                key: Key(category.id),
                iconUrl: isOwnerDraw
                    ? categoryGroup.parentCategoryId.iconUrl()
                    : null,
                sideColor: decorationModel.rowBackgroundColor,
                onDoubleTap: (managementSubcategory != null &&
                        !managementSubcategory.cannotBeHidden &&
                        !widget.isReadOnlyAdvisor)
                    ? () {
                        if (managementSubcategory.hasTransactions) {
                          showDialog(
                              context: context,
                              builder: (_context) {
                                return ReAssignTransactionsDialog(
                                    subcategory: managementSubcategory,
                                    model: _budgetBloc.categoryManagementModel,
                                    isPersonal: widget.isPersonal,
                                    callback: (String id,
                                        {String? newCategoryId}) {
                                      _budgetBloc.add(
                                        HideCategoryEvent(id,
                                            newCategoryId: newCategoryId,
                                            subcategoryToExclude: category),
                                      );
                                    });
                              });
                        } else {
                          _budgetBloc.add(
                            HideCategoryEvent(managementSubcategory.id,
                                subcategoryToExclude: category),
                          );
                        }
                      }
                    : null,
                hasRightBorder: true,
              ),
            );
            for (var node in category.nodes) {
              var tag =
                  '${node.monthYear.month}${category.id}${categoryGroup.tableType}';
              var isGoal = widget.isPersonal &&
                  categoryGroup.categoryType ==
                      CategoryGroupType.ExpenseSeparated;
              var isEditableGoal = isGoal &&
                  !node.isStub &&
                  categoryGroup.tableType != TableType.Difference;
              var isEditable =
                  ((categoryGroup.tableType == TableType.Budgeted && !isGoal) ||
                          isEditableGoal) &&
                      !widget.isReadOnlyAdvisor &&
                      isTableEditable;
              var isHighlighted =
                  _budgetLayoutInherited.data?.monthYear == node.monthYear &&
                      _budgetLayoutInherited.data?.id == node.categoryId;
              var hasDoubleTap = (categoryGroup.tableType == TableType.Actual &&
                  !isGoal &&
                  node.amount != 0 &&
                  node.monthYear.isBefore(_budgetBloc.transactionsEndDate));
              var notifier = ValueNotifier<bool>(node.notes.isNotEmpty);
              var cellValue = node.amount;
              cells.add(
                CellData(
                  isOwnerDraw && !isEditable
                      ? cellValue.formattedWithDecorativeElementsString()
                      : cellValue.numericFormattedString(),
                  hasRightBorder: true,
                  showFormulaIndicator: node.expression != null,
                  isEditable: isEditable,
                  isHighlighted: isHighlighted,
                  hasError: node.expression?.isValid == false,
                  changeValue: (int value) {
                    var oldNode = node;
                    updateTable(
                      node.copyWith(amount: value),
                      category,
                      oldNode: oldNode,
                    );
                  },
                  onDoubleTap: !isDebt && hasDoubleTap
                      ? () {
                          _budgetBloc.goToTransactionsForSelectedPeriod(
                            context,
                            node.monthYear,
                            parentCategoryId: categoryGroup.parentCategoryId,
                            childCategoryId: category.id,
                          );
                        }
                      : isEditable
                          ? () {
                              widget.onEditableCellDoubleTap(
                                  AnnualFormulaDataModel(
                                initialNode: node,
                                isGoal: isGoal,
                                category: category,
                                budgetModel: model,
                              ));
                            }
                          : null,
                  showMemoNotifier: notifier,
                  key: Key(tag + cellValue.toString()),
                  cellTag: tag,
                  onEnter: (isGoal && node.isStub)
                      ? null
                      : (_) {
                          if (node.notes.isNotEmpty) {
                            if (currentMenuTag != tag) {
                              removeMemoMenu();
                              showMemoMenu(
                                  anchorTag: tag,
                                  node: node,
                                  isGoal: isGoal,
                                  parentCategory: categoryGroup,
                                  category: category,
                                  notifier: notifier);
                            }
                          }
                        },
                  onExit: (isGoal && node.isStub)
                      ? null
                      : (_) {
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
                  onPointerDown: (isGoal && node.isStub)
                      ? null
                      : (PointerEvent? event) {
                          if (event?.kind == PointerDeviceKind.mouse &&
                              event?.buttons == kSecondaryMouseButton) {
                            showMemoMenu(
                                anchorTag: tag,
                                node: node,
                                isGoal: isGoal,
                                category: category,
                                parentCategory: categoryGroup,
                                notifier: notifier);
                          }
                        },
                ),
              );
            }
            //year
            cells.add(
              CellData(
                _mapFormatterString(category, isOwnerDraw),
                hasRightBorder: true,
                backgroundColor: decorationModel.yearChildRowBackgroundColor,
                onDoubleTap: !isDebt &&
                        model.type == TableType.Actual &&
                        category.totalByYear != 0
                    ? () {
                        _budgetBloc.goToTransactionsForSelectedPeriod(
                          context,
                          model.period.startDate,
                          parentCategoryId: categoryGroup.parentCategoryId,
                          childCategoryId: category.id,
                          isYear: true,
                        );
                      }
                    : null,
              ),
            );
            //percent

            cells.add(CellData(
              '${category.percentage.toString()}%',
              hasRightBorder: false,
              textColor: decorationModel.percentTextColor,
            ));
            return RowData(
              cells: cells,
              backgroundColor: decorationModel.childrenBackgroundColor ??
                  decorationModel.rowBackgroundColor,
              isBold: decorationModel.isBold,
              textColor: decorationModel.mainTextColor,
            );
          })
        : [];
    //CategoryGroup header
    var headerCells = [
      CellData(
        categoryGroup.parentCategoryId.nameLocalization(context),
        iconUrl: categoryGroup.parentCategoryId.iconUrl(),
        hasRightBorder: true,
      ),
    ];
    //monthsHeaderCells
    var headerMonthValues = categoryGroup.categories.isNotEmpty
        ? categoryGroup.totalByMonth.amount
        : List.generate(12, (index) => 0);
    for (var month in model.period.months) {
      headerCells.add(
        CellData(
          headerMonthValues[model.period.months.indexOf(month)]
              .formattedWithDecorativeElementsString(),
          hasRightBorder: true,
          onDoubleTap: !isDebt &&
                  headerMonthValues[model.period.months.indexOf(month)] != 0
              ? () {
                  _budgetBloc.goToTransactionsForSelectedPeriod(
                    context,
                    month,
                    parentCategoryId: categoryGroup.parentCategoryId,
                  );
                }
              : null,
        ),
      );
    }
    //yearHeaderCell
    var yearSum = categoryGroup.totalByYear;
    headerCells.add(
      CellData(
        yearSum.formattedWithDecorativeElementsString(),
        key: Key(categoryGroup.parentCategoryId + yearSum.toString()),
        hasRightBorder: false,
        backgroundColor: decorationModel.yearBackgroundColor,
        onDoubleTap: !isDebt && yearSum != 0
            ? () {
                _budgetBloc.goToTransactionsForSelectedPeriod(
                  context,
                  model.period.startDate,
                  parentCategoryId: categoryGroup.parentCategoryId,
                  isYear: true,
                );
              }
            : null,
      ),
    );
    //percentHeaderCell
    headerCells.add(
      CellData(
        '${categoryGroup.percentage.toString()}%',
        textColor: decorationModel.percentTextColor,
      ),
    );
    return isOwnerDraw
        ? childRows.first
        : RowData(
            expanded: _budgetBloc
                    .expandedCategories[categoryGroup.parentCategoryId] ??
                false,
            toggleExpanded: (value) {
              toggleCategories(categoryGroup.parentCategoryId, value);
            },
            cells: headerCells,
            backgroundColor: decorationModel.rowBackgroundColor,
            isBold: true,
            children: childRows,
          );
  }

  RowData _footerRow({
    required TableType selectedType,
    required String name,
    required TableRowDecorationModel decorationModel,
    required List<int> values,
    required int yearValue,
    required String percent,
  }) {
    var cells = [
      CellData(
        name,
        iconUrl: decorationModel.iconUrl,
      ),
    ];

    for (var item in values) {
      cells.add(
        CellData(
          item.formattedWithDecorativeElementsString(),
          hasRightBorder: true,
          textColor: item < 0 && decorationModel.alternativeTextColor != null
              ? decorationModel.alternativeTextColor!
              : decorationModel.mainTextColor,
        ),
      );
    }
    //year
    cells.add(CellData(
      yearValue.formattedWithDecorativeElementsString(),
      hasRightBorder: true,
      backgroundColor: decorationModel.yearBackgroundColor,
      textColor: yearValue < 0 && decorationModel.alternativeTextColor != null
          ? decorationModel.alternativeTextColor!
          : decorationModel.mainTextColor,
    ));
    //percent
    cells.add(
      CellData(
        '$percent%',
        textColor: decorationModel.percentTextColor,
      ),
    );
    return RowData(
      key: ObjectKey(cells),
      cells: cells,
      isBold: decorationModel.isBold,
      backgroundColor: decorationModel.rowBackgroundColor,
      textColor: decorationModel.mainTextColor,
    );
  }

  void updateTable(
    BudgetAnnualNode node,
    BudgetAnnualSubcategory category, {
    bool locally = false,
    BudgetAnnualNode? oldNode,
  }) {
    _budgetBloc.add(UpdateAnnualBudgetEvent(
      node: node,
      newModel: widget.model.update(node, category),
      oldNode: oldNode,
      oldNodeCategory: category,
      locally: locally,
    ));
  }

  @override
  void dispose() {
    super.dispose();
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
      required BudgetAnnualNode node,
      required bool isGoal,
      required BudgetAnnualCategory parentCategory,
      required BudgetAnnualSubcategory category,
      required ValueNotifier<bool> notifier}) {
    {
      currentMenuTag = anchorTag;
      showModal(
        ModalEntry.selfPositioned(
          context,
          tag: 'memo$anchorTag',
          anchorTag: anchorTag,
          child: MouseRegion(
            onEnter: (_) {
              isMenuFocused = true;
              currentMenuTag = anchorTag;
            },
            onExit: (_) {
              removeMemoMenu();
            },
            child: MemoMenuWidget(
              notesPage: node.getNotesPage(isGoal),
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
                  isTransaction: note.isTransaction,
                  noteId: note.id,
                  isGoal: isGoal,
                );
                if (replyId != null) {
                  node.addNoteReply(
                      noteModel: note,
                      newReply: MemoNoteModel(
                          id: replyId,
                          note: text,
                          transactionId: note.transactionId,
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
                  updateTable(node, category, locally: true);
                }
              },
              onDelete: (note) async {
                await _budgetBloc.deleteNote(isGoal: isGoal, note: note);
                node.deleteNote(
                  note: note,
                );
                updateTable(
                  node,
                  category,
                  locally: true,
                );
              },
              onAdd: (String text) async {
                var noteId = await _budgetBloc.addNote(
                  selectedType: widget.model.type,
                  note: text,
                  monthYear: node.monthYear,
                  categoryId: category.id,
                  isGoal: isGoal,
                  businessId: widget.model.businessId,
                );
                if (noteId != null) {
                  node.addNote(
                    noteId: noteId,
                    note: text,
                    transactionId: null,
                    isTransaction: false,
                    transactionAmount: null,
                    creationDate: DateTime.now().toUtc(),
                    isGoal: isGoal,
                    currentUser: widget.user,
                  );
                  updateTable(
                    node,
                    category,
                    locally: true,
                  );
                }
              },
              onEdit: (note) async {
                await _budgetBloc.editNote(
                  note: note,
                  isGoal: isGoal,
                );
                node.addNote(
                  noteId: note.id,
                  transactionId: note.transactionId,
                  note: note.note,
                  isGoal: isGoal,
                  transactionAmount: note.transactionAmount,
                  creationDate: note.creationDate,
                  isTransaction: note.isTransaction,
                  currentUser: widget.user,
                );
                updateTable(
                  node,
                  category,
                  locally: true,
                );
              },
              onUpdate: () async {
                var notesPage = await _budgetBloc.fetchNotesForNode(
                    selectedType: widget.model.type,
                    isGoal: isGoal,
                    monthYear: node.monthYear,
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
                updateTable(
                  node,
                  category,
                  locally: true,
                );
              },
              onEditReply: (MemoNoteModel note, MemoNoteModel reply) async {
                await _budgetBloc.editNoteReply(
                  replyId: reply.id,
                  isTransaction: reply.isTransaction,
                  replyText: reply.note,
                  isGoal: isGoal,
                );
                node.addNoteReply(noteModel: note, newReply: reply);
                updateTable(
                  node,
                  category,
                  locally: true,
                );
              },
            ),
          ),
        ),
      );
      isMenuVisible = true;
      setState(() {});
    }
  }

  String _mapFormatterString(
    BudgetAnnualSubcategory category,
    bool isOwnerDraw,
  ) {
    var value = category.totalByYear;

    if (isOwnerDraw) {
      return value.formattedWithDecorativeElementsString();
    } else {
      return value.numericFormattedString();
    }
  }
}
