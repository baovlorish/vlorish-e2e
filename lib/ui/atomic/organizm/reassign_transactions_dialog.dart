import 'package:burgundy_budgeting_app/ui/atomic/atom/label.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/dropdown_item.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/two_buttons_alert_dialog.dart';
import 'package:burgundy_budgeting_app/ui/model/category_management_page_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ReAssignTransactionsDialog extends StatefulWidget {
  final ManagementSubcategory subcategory;
  final CategoryManagementPageModel model;
  final bool isPersonal;
  final Function callback;

  const ReAssignTransactionsDialog(
      {Key? key,
      required this.subcategory,
      required this.model,
      required this.isPersonal,
      required this.callback})
      : super(key: key);

  @override
  State<ReAssignTransactionsDialog> createState() =>
      _ReAssignTransactionsDialogState();
}

class _ReAssignTransactionsDialogState
    extends State<ReAssignTransactionsDialog> {
  var newCategoryId;
  String? newParentId;
  late var parentCategoryKeys = widget.model
      .usageType(widget.isPersonal)
      .possibleParentCategoriesIds(widget.subcategory);
  late var parentCategoryNames = widget.model
      .usageType(widget.isPersonal)
      .possibleParentCategoriesNames(context, widget.subcategory);
// currently can't move removing parent category
// if there is no subcategories in it, io initState
// because localization related inherited widget exception
// so it's performed in didChangeDependencies() only once
  bool init = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (init) {
      newParentId = widget.subcategory.parentCategoryId;
      var subcategoryKeys = widget.model
          .usageType(widget.isPersonal)
          .possibleSubcategoriesToMoveIds(widget.subcategory, newParentId!);
      if (subcategoryKeys.length == 1) {
        newCategoryId = subcategoryKeys.first;
      } else if (subcategoryKeys.isEmpty) {
        var index = parentCategoryKeys.indexOf(newParentId!);
        parentCategoryKeys.removeAt(index);
        parentCategoryNames.removeAt(index);
        newParentId = null;
      }
    }
    init = false;
  }

  @override
  Widget build(BuildContext context) {
    return TwoButtonsDialog(
      context,
      title:
          '${AppLocalizations.of(context)!.remove} ${widget.subcategory.name} ${AppLocalizations.of(context)!.category}',
      mainButtonText: AppLocalizations.of(context)!.move,
      dismissButtonText: AppLocalizations.of(context)!.cancel,
      bodyWidget: Column(
        children: [
          Label(
            text: AppLocalizations.of(context)!
                .thisCategoryHasTransactionsYouCanMoveThemToAnotherCategory,
            type: LabelType.General,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 80),
            child: DropdownItem<String>(
              isSmall: true,
              items: parentCategoryNames,
              initialValue: newParentId,
              itemKeys: parentCategoryKeys,
              hintText: AppLocalizations.of(context)!.select,
              callback: (String id) {
                newParentId = id;
                var subcategoryKeys = widget.model
                    .usageType(widget.isPersonal)
                    .possibleSubcategoriesToMoveIds(
                        widget.subcategory, newParentId!);
                if (subcategoryKeys.length == 1) {
                  newCategoryId = subcategoryKeys.first;
                } else {
                  newCategoryId = null;
                }
                setState(() {});
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 80),
            child: DropdownItem<String>(
              key: ObjectKey(newParentId),
              isSmall: true,
              initialValue: newCategoryId,
              enabled: newParentId != null,
              items: newParentId == null
                  ? []
                  : widget.model
                      .usageType(widget.isPersonal)
                      .possibleSubcategoriesToMove(
                          context, widget.subcategory, newParentId!),
              itemKeys: newParentId == null
                  ? []
                  : widget.model
                      .usageType(widget.isPersonal)
                      .possibleSubcategoriesToMoveIds(
                          widget.subcategory, newParentId!),
              hintText: AppLocalizations.of(context)!.select,
              callback: (String value) {
                newCategoryId = value;
                setState(() {});
              },
            ),
          ),
        ],
      ),
      enableMainButton: newCategoryId != null,
      onMainButtonPressed: () async {
        widget.callback(widget.subcategory.id, newCategoryId: newCategoryId);
      },
    );
  }
}
