import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_divider.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_tooltip.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_vertical_devider.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/label.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/theme.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/button_item.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/custom_switch.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/editable_table_body_cell.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/error_alert_dialog.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/input_item.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/home_screen/home_screen_cubit.dart';
import 'package:burgundy_budgeting_app/ui/model/tax_income_details_model.dart';
import 'package:burgundy_budgeting_app/ui/model/tax_personal_info_model.dart';
import 'package:burgundy_budgeting_app/ui/screen/tax/tax_cubit.dart';
import 'package:burgundy_budgeting_app/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class TaxIncomeDetailsTab extends StatefulWidget {
  final TaxIncomeDetailsModel incomeDetailsModel;

  const TaxIncomeDetailsTab({required this.incomeDetailsModel, Key? key})
      : super(key: key);

  @override
  _TaxIncomeDetailsTabState createState() => _TaxIncomeDetailsTabState();
}

class _TaxIncomeDetailsTabState extends State<TaxIncomeDetailsTab>
    with _FlexFactors {
  late var taxCubit = BlocProvider.of<TaxCubit>(context);

  var totalAmount = 0;
  late var endIncomeDetailsModel = widget.incomeDetailsModel.copyWith();
  late var startIncomeDetailsModel = widget.incomeDetailsModel.copyWith();

  void calculateTotalAmount() {
    var amount = 0;
    for (var item in endIncomeDetailsModel.salaryPaychecks) {
      amount += item.beforeTaxAmount ?? item.afterTaxAmount ?? 0;
    }
    for (var item in endIncomeDetailsModel.incomeSources) {
      if (item.amount != null && item.isTaxable) {
        amount += item.amount!;
      }
    }
    totalAmount = amount;
  }
  late var isLimitedCoach = BlocProvider.of<HomeScreenCubit>(context)
      .currentForeignSession
      ?.access
      .isLimited ?? false;
  @override
  void initState() {
    super.initState();
    calculateTotalAmount();
  }

  @override
  Widget build(BuildContext context) {
    calculateTotalAmount();
    var canContinue = true;
    for (var item in endIncomeDetailsModel.salaryPaychecks) {
      if (item.beforeTaxAmount == null && !item.statusValue) {
        canContinue = false;
        break;
      }
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 50,
          child: Row(
            children: [
              Expanded(
                flex: flexFactors[0],
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Label(
                    text: AppLocalizations.of(context)!.income,
                    type: LabelType.TableHeader,
                  ),
                ),
              ),
              CustomVerticalDivider(),
              Expanded(
                flex: flexFactors[1],
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Label(
                    text: AppLocalizations.of(context)!.taxTreatment,
                    type: LabelType.TableHeader,
                  ),
                ),
              ),
              CustomVerticalDivider(),
              Expanded(
                flex: flexFactors[2],
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Label(
                    text: AppLocalizations.of(context)!.amount,
                    type: LabelType.TableHeader,
                  ),
                ),
              ),
              CustomVerticalDivider(),
              Expanded(
                flex: flexFactors[3],
                child: SizedBox(),
              ),
            ],
          ),
        ),
        CustomDivider(),
        for (var item in endIncomeDetailsModel.salaryPaychecks)
          _IncomeDetailsItemRow(
            item,
            isSalary: true,
            onUpdate: (newModel) {
              endIncomeDetailsModel = endIncomeDetailsModel
                  .updateWithSalary(newModel as TaxSalaryPaycheck);
              setState(() {});
            },
          ),
        for (var item in endIncomeDetailsModel.incomeSources)
          _IncomeDetailsItemRow(
            item,
            onUpdate: (newModel) {
              endIncomeDetailsModel = endIncomeDetailsModel
                  .updateWithSource(newModel as TaxIncomeDetailSource);
              setState(() {});
            },
          ),
        Container(
          height: 50,
          decoration: BoxDecoration(
            color: CustomColorScheme.mainDarkBackground,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(4),
              bottomRight: Radius.circular(4),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                flex: flexFactors[0],
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Label(
                    text: AppLocalizations.of(context)!.totalIncome,
                    type: LabelType.General,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Expanded(
                flex: flexFactors[1],
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: SizedBox(),
                ),
              ),
              Expanded(
                flex: flexFactors[2],
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  key: Key('total$totalAmount'),
                  child: Label(
                    text: NumberFormat.simpleCurrency().format(totalAmount),
                    type: LabelType.General,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Expanded(
                flex: flexFactors[3],
                child: SizedBox(),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(40.0),
          child: SizedBox(
            width: 200,
            child: ButtonItem(
              context,
              text: taxCubit.estimationStage == 4
                  ? AppLocalizations.of(context)!.apply
                  : AppLocalizations.of(context)!.continueCalculations,
              onPressed: canContinue &&!isLimitedCoach
                  ? () {
                      var canUpdate = true;
                      for (var item in endIncomeDetailsModel.salaryPaychecks) {
                        if ((item.beforeTaxAmount != null &&
                            item.afterTaxAmount != null &&
                            item.beforeTaxAmount! < item.afterTaxAmount!)) {
                          canUpdate = false;
                          break;
                        }
                      }
                      if (canUpdate) {
                        taxCubit.updateIncomeDetails(endIncomeDetailsModel);
                        startIncomeDetailsModel =
                            endIncomeDetailsModel.copyWith();
                      } else {
                        showDialog(
                          context: context,
                          builder: (_context) {
                            return ErrorAlertDialog(
                              _context,
                              message: AppLocalizations.of(context)!
                                  .beforeTaxShouldBeGreaterThanAfterTax,
                            );
                          },
                        );
                      }
                    }
                  : () {},
              enabled: canContinue,
            ),
          ),
        ),
      ],
    );
  }
}

class _IncomeDetailsItemRow extends StatefulWidget {
  final dynamic itemModel;
  final bool isSalary;
  final Function(dynamic newModel) onUpdate;

  const _IncomeDetailsItemRow(
    this.itemModel, {
    Key? key,
    this.isSalary = false,
    required this.onUpdate,
  }) : super(key: key);

  @override
  _IncomeDetailsItemRowState createState() => _IncomeDetailsItemRowState();
}

class _IncomeDetailsItemRowState extends State<_IncomeDetailsItemRow>
    with _FlexFactors {
  late var name = widget.isSalary
      ? (widget.itemModel as TaxSalaryPaycheck).name ??
          AppLocalizations.of(context)!.salaryPaycheck
      : (widget.itemModel as TaxIncomeDetailSource).name(context);

  late var amount = widget.isSalary
      ? (widget.itemModel as TaxSalaryPaycheck).afterTaxAmount ?? 0
      : (widget.itemModel as TaxIncomeDetailSource).amount;

  int? beforeTaxAmount;
  var node = FocusNode();

  @override
  Widget build(BuildContext context) {
    var hasBeforeTaxBox =
        widget.isSalary && !(widget.itemModel as TaxSalaryPaycheck).statusValue;

    return Container(
      height: 50,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: CustomColorScheme.tableBorder, width: 1.5),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: flexFactors[0],
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Label(
                    text: name,
                    type: LabelType.General,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (name == 'Salary/paycheck')
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: CustomTooltip(
                      message: AppLocalizations.of(context)!
                          .enterYearToDateBeforeTaxAmount,
                      child: Icon(
                        Icons.info_rounded,
                        color: CustomColorScheme.taxInfoTooltip,
                      ),
                    ),
                  ),
                if (name == 'Investment Income') // better 'income'
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: CustomTooltip(
                      message:
                          AppLocalizations.of(context)!.investmentIncomeTaxHint,
                      child: Icon(
                        Icons.info_rounded,
                        color: CustomColorScheme.taxInfoTooltip,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          CustomVerticalDivider(),
          Expanded(
            flex: flexFactors[1],
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 4.0,
              ),
              child: CustomTextSwitch(
                onSelected: (value) {
                  var newModel = widget.isSalary
                      ? (widget.itemModel as TaxSalaryPaycheck).copyWith(
                          setStatus: value ? 2 : 1,
                          beforeTaxAmount: null,
                          replaceBeforeTax: true,
                        )
                      : (widget.itemModel as TaxIncomeDetailSource)
                          .copyWith(status: value ? 2 : 1);
                  widget.onUpdate(newModel);
                  setState(() {});
                },
                secondOptionName: widget.itemModel.secondOptionName,
                firstOptionName: widget.itemModel.firstOptionName,
                initialSelection: widget.itemModel.statusValue,
              ),
            ),
          ),
          CustomVerticalDivider(),
          Expanded(
            flex: flexFactors[2],
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Label(
                text: NumberFormat.simpleCurrency().format(amount),
                type: LabelType.General,
              ),
            ),
          ),
          CustomVerticalDivider(),
          Expanded(
            flex: flexFactors[3],
            child: hasBeforeTaxBox
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Label(
                          text: AppLocalizations.of(context)!
                              .enterBeforeTaxAnnualAmount,
                          type: LabelType.General,
                        ),
                      ),
                      SizedBox(
                        width: 152,
                        child: InputItem(
                          value: (widget.itemModel as TaxSalaryPaycheck)
                                      .beforeTaxAmount !=
                                  null
                              ? (widget.itemModel as TaxSalaryPaycheck)
                                  .beforeTaxAmount!
                                  .numericFormattedString()
                              : null,
                          prefix: '\$ ',
                          textInputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            NumericTextFormatter(),
                            LengthLimitingTextInputFormatter(10),
                          ],
                          onChanged: (String value) {
                            var valueNew = value.replaceAll(',', '');
                            widget.onUpdate(
                                (widget.itemModel as TaxSalaryPaycheck)
                                    .copyWith(
                                        replaceBeforeTax: true,
                                        beforeTaxAmount: valueNew.isNotEmpty
                                            ? int.parse(valueNew)
                                            : null,
                                        setStatus: 1));
                            setState(() {});
                          },
                          focusNode: node,
                          onEditingComplete: () {
                            node.unfocus();
                          },
                        ),
                      ),
                    ],
                  )
                : SizedBox(),
          ),
        ],
      ),
    );
  }
}

mixin _FlexFactors {
  List<int> get flexFactors => [
        11,
        12,
        8,
        27,
      ];
}
