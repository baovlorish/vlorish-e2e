import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_tooltip.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/label.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/theme.dart';
import 'package:burgundy_budgeting_app/ui/model/category_management_page_model.dart';
import 'package:burgundy_budgeting_app/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CategoryGroupTile extends StatefulWidget {
  final ManagementCategory categoryModel;
  final EdgeInsets padding;
  final double width;
  final bool isInUse;
  final bool isReadOnlyAdvisor;
  final Function(String) onCategoryReassigned;
  final Function(ManagementSubcategory) onSubcategoryReassigned;

  const CategoryGroupTile({
    Key? key,
    required this.categoryModel,
    required this.width,
    this.padding = const EdgeInsets.all(0),
    required this.isInUse,
    required this.onCategoryReassigned,
    required this.onSubcategoryReassigned,
    required this.isReadOnlyAdvisor,
  }) : super(key: key);

  @override
  State<CategoryGroupTile> createState() => _CategoryGroupTileState();
}

class _CategoryGroupTileState extends State<CategoryGroupTile> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding,
      child: Container(
        width: widget.width,
        decoration: BoxDecoration(
          color: widget.categoryModel.isIncome
              ? CustomColorScheme.tableIncomeBackground
              : CustomColorScheme.tableExpenseBackground,
          border: Border.all(color: CustomColorScheme.tableBorder),
        ),
        child: ExpansionTile(
          onExpansionChanged: (expanded) {
            setState(
              () {
                isExpanded = expanded;
              },
            );
          },
          leading: ImageIcon(
            AssetImage(widget.categoryModel.id.iconUrl()),
            color: CustomColorScheme.text,
            size: 24,
          ),
          title: Label(
            text: widget.categoryModel.name,
            type: LabelType.GeneralBold,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _categoryButton(widget.isReadOnlyAdvisor),
              ImageIcon(
                isExpanded
                    ? AssetImage('assets/images/icons/arrow_up.png')
                    : AssetImage('assets/images/icons/arrow.png'),
                color: CustomColorScheme.errorPopupButton,
                size: 24,
              )
            ],
          ),
          children: [
            for (var item in widget.categoryModel.categories)
              Container(
                height: 52,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: CustomColorScheme.tableBorder,
                    width: 0.5,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Label(
                            text: item.name,
                            type: LabelType.General,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: IconButton(
                        icon: Icon(
                          widget.isInUse
                              ? Icons.remove_circle
                              : Icons.add_circle,
                          color: item.cannotBeHidden || widget.isReadOnlyAdvisor
                              ? CustomColorScheme.clipElementInactive
                              : CustomColorScheme.mainDarkBackground,
                        ),
                        onPressed: item.cannotBeHidden || widget.isReadOnlyAdvisor
                            ? null
                            : () {
                                widget.onSubcategoryReassigned(item);
                              },
                      ),
                    )
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _categoryButton(bool isReadOnlyAdvisor) {
    var shouldShowTooltip = !isReadOnlyAdvisor
        ? (widget.categoryModel.hasTransactions ||
                widget.categoryModel.cannotBeHidden) &&
            widget.isInUse
        : false;
    var button = IconButton(
      icon: Icon(
        widget.isInUse ? Icons.remove_circle : Icons.add_circle,
        color: shouldShowTooltip || isReadOnlyAdvisor
            ? CustomColorScheme.clipElementInactive
            : CustomColorScheme.mainDarkBackground,
      ),
      onPressed: shouldShowTooltip || isReadOnlyAdvisor
          ? null
          : () {
              widget.onCategoryReassigned(widget.categoryModel.id);
            },
    );
    return shouldShowTooltip
        ? CustomTooltip(
            message: widget.categoryModel.isDebt
                ? AppLocalizations.of(context)!
                    .thisCategoryCannotBeHiddenBecauseItHasAccounts
                : AppLocalizations.of(context)!
                    .pleaseRemoveItsTransactionsFirst,
            color: CustomColorScheme.mainDarkBackground,
            child: button,
          )
        : button;
  }
}
