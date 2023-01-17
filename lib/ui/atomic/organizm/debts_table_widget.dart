import 'package:burgundy_budgeting_app/ui/atomic/atom/label.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/theme.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/empty_widget.dart';
import 'package:burgundy_budgeting_app/ui/atomic/organizm/toggling_rows_table.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/home_screen/home_screen_cubit.dart';
import 'package:burgundy_budgeting_app/ui/model/debt_category.dart';
import 'package:burgundy_budgeting_app/ui/model/debts_page_model.dart';
import 'package:burgundy_budgeting_app/ui/screen/debts/debts_cubit.dart';
import 'package:burgundy_budgeting_app/ui/screen/debts/debts_state.dart';
import 'package:burgundy_budgeting_app/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DebtsTableWidget extends StatelessWidget {
  final bool isPersonal;
  final bool isAnnual;
  final DebtsPageModel model;
  final BuildContext context;
  late final TableData tableData;
  final Function(DebtCategory, bool) onCategorySelectionToggled;
  late final List<DebtCategory> categories;

  DebtsTableWidget(
    this.context, {
    Key? key,
    required this.model,
    required this.isPersonal,
    required this.onCategorySelectionToggled,
    required this.isAnnual,
  }) : super(key: key) {
    categories =
        isPersonal ? model.personalCategories : model.businessCategories;
    var debtsCubit = BlocProvider.of<DebtsCubit>(context);

    var selectedCategories =
        (debtsCubit.state as DebtsLoaded).selectedCategories;

    var collapsedCategories =
        (debtsCubit.state as DebtsLoaded).collapsedCategories;

    if (categories.isNotEmpty) {
      var headerRow = isAnnual ? _annualHeaderRow() : _monthlyHeaderRow();

      var categoryRows = isAnnual
          ? _annualCategoriesRows(
              categories, selectedCategories, collapsedCategories, debtsCubit)
          : _monthlyCategoriesRows(
              categories, selectedCategories, collapsedCategories, debtsCubit);

      var footers = isAnnual
          ? [
              RowData(
                  backgroundColor: CustomColorScheme.mainDarkBackground,
                  isBold: true,
                  textColor: CustomColorScheme.tableWhiteText,
                  hasBottomBorder: false,
                  cells: [
                    CellData(
                      AppLocalizations.of(context)!.totalDebts,
                      iconUrl: 'assets/images/icons/ic_sum.png',
                    ),
                    for (var sum in model.totalDebtsSums(isPersonal))
                      CellData(
                        sum.formattedWithDecorativeElementsString(),
                        hasRightBorder: false,
                      ),
                  ]),
            ]
          : <RowData>[];

      tableData = TableData(
          header: headerRow,
          listChildRow: categoryRows + footers,
          minColumnWidths: isAnnual
              ? [
                  240,
                  130,
                  130,
                  130,
                  130,
                  130,
                  130,
                  130,
                  130,
                  130,
                  130,
                  130,
                  130,
                ]
              : [240, 240, 240, 240]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return categories.isEmpty
        ? SizedBox(
            width: 400,
            child: EmptyWidget(
              title: AppLocalizations.of(context)!.noData,
              subtitle:
                  AppLocalizations.of(context)!.thisSectionWillDisplayYourDebts,
              iconUrl: 'assets/images/icons/ic_liability.png',
            ),
          )
        : Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: CustomColorScheme.blockBackground,
              boxShadow: [
                BoxShadow(
                  blurRadius: 10.0,
                  color: CustomColorScheme.tableBorder,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5.0),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: TogglingRowsTable(
                      tableData: tableData,
                      allowEditableCells:
                          BlocProvider.of<HomeScreenCubit>(context)
                                  .currentForeignSession
                                  ?.access
                                  .isSecondary ??
                              true,
                    ),
                  );
                },
              ),
            ),
          );
  }

  RowData _annualHeaderRow() {
    return RowData(
        backgroundColor: CustomColorScheme.blockBackground,
        labelType: LabelType.TableHeader,
        textColor: CustomColorScheme.tableHeaderText,
        cells: [
          CellData(
            AppLocalizations.of(context)!.account,
            hasRightBorder: false,
          ),
          for (var month in model.period.months)
            CellData(
              model.period.monthString(month.month),
              hasRightBorder: false,
            ),
        ]);
  }

  RowData _monthlyHeaderRow() {
    return RowData(
        backgroundColor: CustomColorScheme.blockBackground,
        labelType: LabelType.TableHeader,
        textColor: CustomColorScheme.tableHeaderText,
        cells: [
          CellData(
            AppLocalizations.of(context)!.account,
            hasRightBorder: false,
          ),
          CellData(
            AppLocalizations.of(context)!.totalPayments,
            hasRightBorder: false,
          ),
          CellData(
            AppLocalizations.of(context)!.interestPaid,
            hasRightBorder: false,
          ),
          CellData(
            AppLocalizations.of(context)!.debtPaid,
            hasRightBorder: false,
          ),
        ]);
  }

  List<RowData> _annualCategoriesRows(
      List<DebtCategory> categories,
      List<DebtCategory> selectedCategories,
      List<DebtCategory> collapsedCategories,
      DebtsCubit debtsCubit) {
    var selectedCategoryBackgroundColor =
        CustomColorScheme.tableExpenseBackground;
    var categoryBackgroundColor = CustomColorScheme.tableBlue;

    return List.generate(
      categories.length,
      (index) {
        var category = categories[index];
        var isSelected = selectedCategories
            .where((element) => element.categoryId == category.categoryId)
            .isNotEmpty;
        return RowData(
          key: ObjectKey(category),
          backgroundColor: isSelected
              ? selectedCategoryBackgroundColor
              : categoryBackgroundColor,
          cells: List.generate(13, (cIndex) {
            var padding =
                cIndex == 0 ? EdgeInsets.fromLTRB(0, 12, 12, 12) : null;
            return CellData(
                cIndex == 0
                    ? category.categoryName
                    : category.monthlySumsTotal[cIndex - 1]
                        .numericFormattedString(),
                padding: padding);
          }),
          expanded: collapsedCategories
              .where((element) => element == category)
              .isEmpty,
          toggleExpanded: (bool value) {
            debtsCubit.toggleExpanded(category, value);
          },
          withCheckBox: true,
          isChecked: isSelected,
          onCheckboxToggled: (value) {
            onCategorySelectionToggled(category, value);
          },
          children: List.generate(
            category.debtAccounts.length,
            (accIndex) => RowData(
              key: ObjectKey(category.debtAccounts[accIndex]),
              backgroundColor: Colors.white,
              cells: List.generate(
                13,
                (nodeIndex) => CellData(
                  nodeIndex == 0
                      ? category.debtAccounts[accIndex].name
                      : category.debtAccounts[accIndex].nodes[nodeIndex - 1]
                          .totalAmount
                          .numericFormattedString(),
                  isNumeric: nodeIndex != 0,
                  isEditable: nodeIndex == 0 ||
                      category.debtAccounts[accIndex].nodes[nodeIndex - 1]
                          .isEditable,
                  showManualIndicator: nodeIndex == 0 &&
                      category.debtAccounts[accIndex].isManual,
                  sideColor: nodeIndex == 0
                      ? isSelected
                          ? selectedCategoryBackgroundColor
                          : categoryBackgroundColor
                      : null,
                  changeValue: nodeIndex == 0
                      ? (value) {
                          debtsCubit.setAccountName(
                            id: category.debtAccounts[accIndex].id,
                            isPersonal: isPersonal,
                            name: value,
                            isManual: category.debtAccounts[accIndex].isManual,
                          );
                        }
                      : category.debtAccounts[accIndex].isManual
                          ? (value) {
                              debtsCubit.setNodeTotalAmount(
                                  isPersonal: isPersonal,
                                  manualAccountId:
                                      category.debtAccounts[accIndex].id,
                                  monthYear: category.debtAccounts[accIndex]
                                      .nodes[nodeIndex - 1].monthYear,
                                  totalAmount: value);
                            }
                          : null,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  List<RowData> _monthlyCategoriesRows(
    List<DebtCategory> categories,
    List<DebtCategory> selectedCategories,
    List<DebtCategory> collapsedCategories,
    DebtsCubit debtsCubit,
  ) {
    var selectedCategoryBackgroundColor =
        CustomColorScheme.tableExpenseBackground;
    var categoryBackgroundColor = CustomColorScheme.tableBlue;

    return List.generate(
      categories.length,
      (index) {
        var category = categories[index];
        var isSelected = selectedCategories
            .where((element) => element.categoryId == category.categoryId)
            .isNotEmpty;
        return RowData(
          key: ObjectKey(category),
          backgroundColor: isSelected
              ? selectedCategoryBackgroundColor
              : categoryBackgroundColor,
          cells: [
            CellData(
              category.categoryName,
              padding: EdgeInsets.fromLTRB(0, 12, 12, 12),
            ),
            CellData(
              category.monthlySumsTotal.first.numericFormattedString(),
            ),
            CellData(
              category.monthlySumsInterest.first.numericFormattedString(),
            ),
            CellData(
              category.monthlySumsDebt.first.numericFormattedString(),
            ),
          ],
          expanded: collapsedCategories
              .where((element) => element == category)
              .isEmpty,
          toggleExpanded: (bool value) {
            debtsCubit.toggleExpanded(category, value);
          },
          withCheckBox: true,
          isChecked: isSelected,
          onCheckboxToggled: (value) {
            onCategorySelectionToggled(category, value);
          },
          children: List.generate(
            category.debtAccounts.length,
            (accIndex) => RowData(
                key: ObjectKey(category.debtAccounts[accIndex]),
                backgroundColor: Colors.white,
                cells: [
                  CellData(
                    category.debtAccounts[accIndex].name,
                    isNumeric: false,
                    isEditable: true,
                    showManualIndicator:
                        category.debtAccounts[accIndex].isManual,
                    sideColor: isSelected
                        ? selectedCategoryBackgroundColor
                        : categoryBackgroundColor,
                    changeValue: (value) {
                      debtsCubit.setAccountName(
                        id: category.debtAccounts[accIndex].id,
                        isPersonal: isPersonal,
                        name: value,
                        isManual: category.debtAccounts[accIndex].isManual,
                      );
                    },
                  ),
                  CellData(
                    category.debtAccounts[accIndex].nodes.first.totalAmount
                        .numericFormattedString(),
                    isNumeric: true,
                    isEditable: category.debtAccounts[accIndex].isManual,
                    changeValue: category.debtAccounts[accIndex].isManual
                        ? (value) {
                            debtsCubit.setNodeTotalAmount(
                                isPersonal: isPersonal,
                                manualAccountId:
                                    category.debtAccounts[accIndex].id,
                                monthYear: category.debtAccounts[accIndex].nodes
                                    .first.monthYear,
                                totalAmount: value);
                          }
                        : null,
                  ),
                  CellData(
                    category.debtAccounts[accIndex].nodes.first.interestAmount
                        .numericFormattedString(),
                    isNumeric: true,
                    //user can set interest amount after they inputted total for this month
                    isEditable: category.debtAccounts[accIndex].isManual &&
                        category.debtAccounts[accIndex].nodes.first
                                .totalAmount >
                            0,
                    tooltipMessage: category.debtAccounts[accIndex].isManual &&
                            category.debtAccounts[accIndex].nodes.first
                                    .totalAmount <=
                                0
                        ? AppLocalizations.of(context)!.setTotalPaymentsFirst
                        : null,
                    changeValue: category.debtAccounts[accIndex].isManual
                        ? (value) {
                            debtsCubit.setNodeInterestAmount(
                                isPersonal: isPersonal,
                                manualAccountId:
                                    category.debtAccounts[accIndex].id,
                                monthYear: category.debtAccounts[accIndex].nodes
                                    .first.monthYear,
                                interestAmount: value);
                          }
                        : null,
                  ),
                  CellData(
                    category.debtAccounts[accIndex].nodes.first.debtAmount
                        .numericFormattedString(),
                  ),
                ]),
          ),
        );
      },
    );
  }
}
