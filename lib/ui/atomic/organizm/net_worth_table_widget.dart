import 'package:burgundy_budgeting_app/domain/model/response/net_worth_model.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/label.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/theme.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/empty_widget.dart';
import 'package:burgundy_budgeting_app/ui/atomic/organizm/toggling_rows_table.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/home_screen/home_screen_cubit.dart';
import 'package:burgundy_budgeting_app/ui/model/net_worth_category.dart';
import 'package:burgundy_budgeting_app/ui/screen/net_worth/net_worth_cubit.dart';
import 'package:burgundy_budgeting_app/ui/screen/net_worth/net_worth_state.dart';
import 'package:burgundy_budgeting_app/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NetWorthTableWidget extends StatelessWidget {
  final bool isPersonal;
  final NetWorthModel model;
  final BuildContext context;
  late final TableData tableData;
  late final List<NetWorthCategory> assetCategories;
  late final List<NetWorthCategory> debtCategories;

  NetWorthTableWidget(
    this.context, {
    Key? key,
    required this.model,
    required this.isPersonal,
  }) : super(key: key) {
    assetCategories = isPersonal ? model.personalAssets : model.businessAssets;

    debtCategories = isPersonal ? model.personalDebts : model.businessDebts;
    final netWorthCubit = BlocProvider.of<NetWorthCubit>(context);
    if (assetCategories.isNotEmpty || debtCategories.isNotEmpty) {
      var headerRow = _headerRow();
      var assetsRowGroup = _categoriesRows(context, assetCategories,
          isAssets: true,
          isExpanded: (netWorthCubit.state as NetWorthLoaded).isAssetsExpanded);
      var debtsRowGroup = _categoriesRows(context, debtCategories,
          isAssets: false,
          isExpanded: (netWorthCubit.state as NetWorthLoaded).isDebtsExpanded);
      var footer = RowData(
          backgroundColor: CustomColorScheme.mainDarkBackground,
          isBold: true,
          textColor: CustomColorScheme.tableWhiteText,
          hasBottomBorder: false,
          cells: [
            CellData(
              AppLocalizations.of(context)!.netWorth,
              iconUrl: 'assets/images/icons/ic_net.png',
            ),
            for (var sum in model.netWorth(isPersonal))
              CellData(
                sum.formattedWithDecorativeElementsString(),
                hasRightBorder: false,
              ),
          ]);
      tableData = TableData(header: headerRow, listChildRow: [
        assetsRowGroup,
        debtsRowGroup,
        footer
      ], minColumnWidths: [
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
      ]);
    }
  }

  @override
  Widget build(BuildContext context) {
    var homeScreenCubit = BlocProvider.of<HomeScreenCubit>(context);
    return (assetCategories.isEmpty && debtCategories.isEmpty)
        ? Container(
            constraints: (BoxConstraints(maxWidth: 1100)),
            child: Center(
              child: SizedBox(
                width: 400,
                child: EmptyWidget(
                  title: AppLocalizations.of(context)!.noData,
                  subtitle: AppLocalizations.of(context)!
                      .thisSectionWillDisplayYourNetWorth,
                  iconUrl: 'assets/images/icons/ic_net.png',
                ),
              ),
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
                      allowEditableCells: homeScreenCubit
                              .currentForeignSession?.access.isSecondary ??
                          true,
                    ),
                  );
                },
              ),
            ),
          );
  }

  RowData _headerRow() {
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
            )
        ]);
  }

  RowData _categoriesRows(
    BuildContext context,
    List<NetWorthCategory> categories, {
    required bool isAssets,
    required bool isExpanded,
  }) {
    var categoryBackgroundColor = isAssets
        ? isPersonal
            ? CustomColorScheme.tableNetWorthBackground
            : CustomColorScheme.tableIncomeBusinessBackground
        : isPersonal
            ? CustomColorScheme.tableDebtBackground
            : CustomColorScheme.tableExpensesBusinessBackground;
    var netWorthCubit = BlocProvider.of<NetWorthCubit>(context);
    return RowData(
      key: ObjectKey(categories),
      backgroundColor: categoryBackgroundColor,
      cells: List.generate(13, (index) {
        return CellData(
          index == 0
              ? isAssets
                  ? AppLocalizations.of(context)!.assets
                  : AppLocalizations.of(context)!.debts
              : categories
                  .monthlySum(model.period)[index - 1]
                  .numericFormattedString(),
          iconUrl: index == 0
              ? isAssets
                  ? 'assets/images/icons/ic_assets.png'
                  : 'assets/images/icons/ic_debts.png'
              : null,
        );
      }),
      expanded: isExpanded,
      toggleExpanded: (bool value) {
        netWorthCubit.toggleExpanded(
          value,
          isAssets: isAssets,
        );
      },
      children: List.generate(
        categories.length,
        (accIndex) => RowData(
          key: ObjectKey(categories[accIndex]),
          backgroundColor: Colors.white,
          cells: List.generate(
            13,
            (nodeIndex) => CellData(
              nodeIndex == 0
                  ? categories[accIndex].name
                  : categories[accIndex]
                      .nodes[nodeIndex - 1]
                      .amount
                      .numericFormattedString(),
              isNumeric: nodeIndex != 0,
              isEditable: (nodeIndex == 0 &&
                      categories[accIndex].canEdit &&
                      categories[accIndex].isManual) ||
                  (nodeIndex == 0 && !categories[accIndex].isManual) ||
                  (nodeIndex != 0 &&
                      categories[accIndex].isManual &&
                      categories[accIndex].nodes[nodeIndex - 1].isEditable &&
                      categories[accIndex].canEdit),
              showManualIndicator:
                  nodeIndex == 0 && categories[accIndex].isManual,
              sideColor: nodeIndex == 0 ? categoryBackgroundColor : null,
              changeValue: nodeIndex == 0
                  ? (value) {
                      netWorthCubit.setAccountName(
                          id: categories[accIndex].id,
                          isPersonal: isPersonal,
                          name: value,
                          isManual: categories[accIndex].isManual,
                          isAssets: isAssets);
                    }
                  : (categories[accIndex].isManual)
                      ? (value) {
                          netWorthCubit.setNode(
                              manualAccountId: categories[accIndex].id,
                              monthYear: categories[accIndex]
                                  .nodes[nodeIndex - 1]
                                  .monthYear,
                              amount: value,
                              isPersonal: isPersonal,
                              isAssets: isAssets);
                        }
                      : null,
            ),
          ),
        ),
      ),
    );
  }
}
