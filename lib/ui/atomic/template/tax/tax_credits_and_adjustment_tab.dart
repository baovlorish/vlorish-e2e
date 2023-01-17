import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_tooltip.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_vertical_devider.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/label.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/theme.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/button_item.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/editable_table_body_cell.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/input_item.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/home_screen/home_screen_cubit.dart';
import 'package:burgundy_budgeting_app/ui/model/tax_credits_and_adjustment_model.dart';
import 'package:burgundy_budgeting_app/ui/model/tax_personal_info_model.dart';
import 'package:burgundy_budgeting_app/ui/screen/tax/tax_cubit.dart';
import 'package:burgundy_budgeting_app/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum _TaxCreditsTile {
  none,
  IncomeAdjustments,
  ItemizedDeductions,
  QBIDeduction,
  TaxCredit
}

class TaxCreditsAndAdjustmentTab extends StatefulWidget {
  final TaxCreditsAndAdjustmentModel creditsAndAdjustmentModel;
  final TaxPersonalInfoModel personalInfoModel;

  const TaxCreditsAndAdjustmentTab({
    Key? key,
    required this.creditsAndAdjustmentModel,
    required this.personalInfoModel,
  }) : super(key: key);

  @override
  State<TaxCreditsAndAdjustmentTab> createState() =>
      _TaxCreditsAndAdjustmentTabState();
}

class _TaxCreditsAndAdjustmentTabState extends State<TaxCreditsAndAdjustmentTab>
    with _FlexFactors {
  late var taxCubit = BlocProvider.of<TaxCubit>(context);
  var selectedExpansionTile = _TaxCreditsTile.IncomeAdjustments;

  late TaxCreditsAndAdjustmentModel endCreditsAndAdjustmentModel =
      widget.creditsAndAdjustmentModel.copyWith();
  late TaxCreditsAndAdjustmentModel startCreditsAndAdjustmentModel =
      widget.creditsAndAdjustmentModel.copyWith();
  late var isLimitedCoach = BlocProvider.of<HomeScreenCubit>(context)
      .currentForeignSession
      ?.access
      .isLimited ?? false;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: Key(selectedExpansionTile.toString()),
      children: [
        SizedBox(
          height: 50,
          child: Row(
            children: [
              Expanded(
                flex: flexFactors[0],
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Label(
                    text: 'EXPENSE',
                    type: LabelType.TableHeader,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: CustomVerticalDivider(),
              ),
              Expanded(
                flex: flexFactors[1],
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Label(
                    text: AppLocalizations.of(context)!.amount,
                    type: LabelType.TableHeader,
                  ),
                ),
              ),
            ],
          ),
        ),
        IncomeAdjustmentsExpansionTile(
          incomeAdjustments: endCreditsAndAdjustmentModel.incomeAdjustments,
          onUpdate: () {
            setState(() {});
          },
          onUpdateTiles: (bool isExpanded) {
            if (isExpanded) {
              selectedExpansionTile = _TaxCreditsTile.IncomeAdjustments;
            } else {
              selectedExpansionTile = _TaxCreditsTile.none;
            }
          },
          selectedIndex: selectedExpansionTile,
        ),
        ItemizedDeductionsExpansionTile(
          itemizedDeductions: endCreditsAndAdjustmentModel.itemizedDeductions,
          onUpdate: () {
            setState(() {});
          },
          onUpdateTiles: (bool isExpanded) {
            if (isExpanded) {
              selectedExpansionTile = _TaxCreditsTile.ItemizedDeductions;
            } else {
              selectedExpansionTile = _TaxCreditsTile.none;
            }
          },
          selectedIndex: selectedExpansionTile,
        ),
        QBIDeductionExpansionTile(
          qualifiedBusinessIncomeDeduction:
              endCreditsAndAdjustmentModel.qualifiedBusinessIncomeDeduction,
          onUpdate: () {
            setState(() {});
          },
          onUpdateTiles: (bool isExpanded) {
            if (isExpanded) {
              selectedExpansionTile = _TaxCreditsTile.QBIDeduction;
            } else {
              selectedExpansionTile = _TaxCreditsTile.none;
            }
          },
          selectedIndex: selectedExpansionTile,
        ),
        TaxCreditExpansionTile(
          taxFilingStatus: widget.personalInfoModel.taxFilingStatus!,
          hasChildren: (widget.personalInfoModel.children13andYoungerCount !=
                      null &&
                  widget.personalInfoModel.children13andYoungerCount! > 0) ||
              (widget.personalInfoModel.children17andYoungerCount != null &&
                  widget.personalInfoModel.children17andYoungerCount! > 0),
          taxCredits: endCreditsAndAdjustmentModel.taxCredits,
          incomAdjustments: endCreditsAndAdjustmentModel.incomeAdjustments,
          onUpdate: () {
            setState(() {});
          },
          onUpdateTiles: (bool isExpanded) {
            if (isExpanded) {
              selectedExpansionTile = _TaxCreditsTile.TaxCredit;
            } else {
              selectedExpansionTile = _TaxCreditsTile.none;
            }
          },
          selectedIndex: selectedExpansionTile,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: SizedBox(
                width: 200,
                child: ButtonItem(
                  context,
                  text: taxCubit.estimationStage == 4
                      ? AppLocalizations.of(context)!.apply
                      : AppLocalizations.of(context)!.done,
                  enabled: !isLimitedCoach,
                  onPressed: isLimitedCoach? (){} : () {
                    taxCubit.updateCreditsAndAdjustment(
                        endCreditsAndAdjustmentModel);
                    startCreditsAndAdjustmentModel =
                        endCreditsAndAdjustmentModel.copyWith();
                  },
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}

mixin _FlexFactors {
  List<int> get flexFactors => [10, 10];
}

class IncomeAdjustmentsExpansionTile extends StatefulWidget {
  const IncomeAdjustmentsExpansionTile({
    Key? key,
    required this.incomeAdjustments,
    required this.onUpdate,
    required this.onUpdateTiles,
    required this.selectedIndex,
  }) : super(key: key);

  final IncomeAdjustments incomeAdjustments;
  final _TaxCreditsTile selectedIndex;
  final VoidCallback onUpdate;
  final void Function(bool isExpanded) onUpdateTiles;

  @override
  State<IncomeAdjustmentsExpansionTile> createState() =>
      _IncomeAdjustmentsExpansionTileState();
}

class _IncomeAdjustmentsExpansionTileState
    extends State<IncomeAdjustmentsExpansionTile> with _FlexFactors {
  var totalIncomeAdjustment = 0;
  var categoryColor = CustomColorScheme.tableExpenseBackground;

  void calculateTotal() {
    totalIncomeAdjustment =
        (widget.incomeAdjustments.selfEmployedHealthInsurance +
                widget.incomeAdjustments.hsaContribution +
                widget.incomeAdjustments
                    .retirementContributionsNotDeductedFromPaycheck +
                widget.incomeAdjustments.studentInterestPaidDuringTheYear +
                widget.incomeAdjustments.halfOfSelfEmploymentTaxesPaid +
                widget.incomeAdjustments.other)
            .round();
  }

  @override
  void initState() {
    calculateTotal();
    super.initState();
  }

  late var taxCubit = BlocProvider.of<TaxCubit>(context);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: categoryColor,
        border: Border(
          top: BorderSide(color: CustomColorScheme.tableBorder, width: 2),
          left: BorderSide(
            width: 4,
            color: categoryColor,
          ),
        ),
      ),
      child: ExpansionTile(
        trailing: ImageIcon(
          widget.selectedIndex == _TaxCreditsTile.IncomeAdjustments
              ? AssetImage('assets/images/icons/arrow_up.png')
              : AssetImage('assets/images/icons/arrow.png'),
          color: CustomColorScheme.errorPopupButton,
          size: 24,
        ),
        // expandedAlignment: Alignment.topLeft,
        expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
        initiallyExpanded:
            widget.selectedIndex == _TaxCreditsTile.IncomeAdjustments,
        onExpansionChanged: (bool expanded) {
          widget.onUpdateTiles(expanded);
          widget.onUpdate();
        },
        title: Label(
          type: LabelType.General,
          fontWeight: FontWeight.w600,
          text: 'Income Adjustments',
        ),
        children: [
          _RowInputItem(
              title: 'Self employed health insurance',
              value: widget.incomeAdjustments.selfEmployedHealthInsurance,
              onUpdateValue: (int value) {
                widget.incomeAdjustments.selfEmployedHealthInsurance = value;
                widget.onUpdate();
                calculateTotal();
                setState(() {});
              }),
          _RowInputItem(
              title: 'HSA contribution',
              value: widget.incomeAdjustments.hsaContribution,
              onUpdateValue: (int value) {
                widget.incomeAdjustments.hsaContribution = value;
                widget.onUpdate();
                calculateTotal();
                setState(() {});
              }),
          _RowInputItem(
              title: 'Retirement contributions not deducted from paycheck',
              value: widget.incomeAdjustments
                  .retirementContributionsNotDeductedFromPaycheck,
              onUpdateValue: (int value) {
                widget.incomeAdjustments
                    .retirementContributionsNotDeductedFromPaycheck = value;
                widget.onUpdate();
                calculateTotal();
                setState(() {});
              }),
          _RowLabelItem(
            title: 'Student interest paid during the year',
            value: widget.incomeAdjustments.studentInterestPaidDuringTheYear,
          ),
          _RowInputItem(
              title: 'Student loan interest paid',
              value: widget.incomeAdjustments.studentLoanInterestPaid,
              onUpdateValue: (int value) async {
                widget.incomeAdjustments.studentLoanInterestPaid = value;
                widget.incomeAdjustments.studentInterestPaidDuringTheYear =
                    await taxCubit.getStudentInterestPaid(value);
                widget.onUpdate();
                calculateTotal();
                setState(() {});
              }),
          _RowLabelItem(
            title: '50% of self-employment taxes paid',
            value: widget.incomeAdjustments.halfOfSelfEmploymentTaxesPaid,
          ),
          _RowInputItem(
              title: 'Other',
              value: widget.incomeAdjustments.other,
              onUpdateValue: (int value) {
                widget.incomeAdjustments.other = value;
                widget.onUpdate();
                calculateTotal();
                setState(() {});
              }),
          _RowLabelItem(
            title: 'Total income adjustments',
            value: totalIncomeAdjustment,
            rowColor: categoryColor,
          ),
        ],
      ),
    );
  }
}

class ItemizedDeductionsExpansionTile extends StatefulWidget {
  const ItemizedDeductionsExpansionTile({
    Key? key,
    required this.itemizedDeductions,
    required this.onUpdate,
    required this.onUpdateTiles,
    required this.selectedIndex,
  }) : super(key: key);

  final ItemizedDeductions itemizedDeductions;
  final _TaxCreditsTile selectedIndex;

  final void Function() onUpdate;
  final void Function(bool isExpanded) onUpdateTiles;

  @override
  State<ItemizedDeductionsExpansionTile> createState() =>
      _ItemizedDeductionsExpansionTileState();
}

class _ItemizedDeductionsExpansionTileState
    extends State<ItemizedDeductionsExpansionTile> {
  var isExpanded = false;

  var totalItemizedDeductions = 0;

  void calculateTotal() {
    totalItemizedDeductions = (widget.itemizedDeductions.mortgageInterestPaid +
            widget.itemizedDeductions.propertyTaxPayments +
            widget.itemizedDeductions.charitableContributions +
            widget.itemizedDeductions.otherItemizedDeduction)
        .round();
  }

  @override
  void initState() {
    calculateTotal();
    super.initState();
  }

  var categoryColor = CustomColorScheme.tableNetWorthBackground;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: categoryColor,
        border: Border(
          top: BorderSide(color: CustomColorScheme.tableBorder, width: 2),
          left: BorderSide(
            width: 4,
            color: categoryColor,
          ),
        ),
      ),
      child: ExpansionTile(
        trailing: ImageIcon(
          widget.selectedIndex == _TaxCreditsTile.ItemizedDeductions
              ? AssetImage('assets/images/icons/arrow_up.png')
              : AssetImage('assets/images/icons/arrow.png'),
          color: CustomColorScheme.errorPopupButton,
          size: 24,
        ),
        expandedAlignment: Alignment.topLeft,
        expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
        initiallyExpanded:
            widget.selectedIndex == _TaxCreditsTile.ItemizedDeductions,
        onExpansionChanged: (expanded) {
          widget.onUpdateTiles(expanded);
          widget.onUpdate();
        },
        title: Label(
          type: LabelType.General,
          fontWeight: FontWeight.w600,
          text: 'Itemized deductions',
        ),
        children: [
          _RowInputItem(
              title: 'Mortgage interest paid',
              value: widget.itemizedDeductions.mortgageInterestPaid,
              onUpdateValue: (int value) {
                widget.itemizedDeductions.mortgageInterestPaid = value;
                widget.onUpdate();
                calculateTotal();
                setState(() {});
              }),
          _RowInputItem(
              title: 'Property tax payments',
              value: widget.itemizedDeductions.propertyTaxPayments,
              onUpdateValue: (int value) {
                widget.itemizedDeductions.propertyTaxPayments = value;
                widget.onUpdate();
                calculateTotal();
                setState(() {});
              }),
          _RowInputItem(
              title: 'Charitable contributions',
              value: widget.itemizedDeductions.charitableContributions,
              onUpdateValue: (int value) {
                widget.itemizedDeductions.charitableContributions = value;
                widget.onUpdate();
                calculateTotal();
                setState(() {});
              }),
          _RowInputItem(
            title: 'Other itemized deduction (deductible portion only)',
            value: widget.itemizedDeductions.otherItemizedDeduction,
            onUpdateValue: (int value) {
              widget.itemizedDeductions.otherItemizedDeduction = value;
              widget.onUpdate();
              calculateTotal();
              setState(() {});
            },
          ),
          _RowLabelItem(
            title: 'Total Itemized Deductions',
            value: totalItemizedDeductions,
            rowColor: categoryColor,
          ),
          _RowLabelItem(
            title: 'Compare to Standard deduction',
            value: widget.itemizedDeductions.compareToStandardDeduction,
            rowColor: categoryColor,
          ),
        ],
      ),
    );
  }
}

class QBIDeductionExpansionTile extends StatefulWidget {
  final int qualifiedBusinessIncomeDeduction;
  final _TaxCreditsTile selectedIndex;

  final void Function() onUpdate;
  final void Function(bool isExpanded) onUpdateTiles;

  const QBIDeductionExpansionTile({
    Key? key,
    required this.qualifiedBusinessIncomeDeduction,
    required this.onUpdate,
    required this.onUpdateTiles,
    required this.selectedIndex,
  }) : super(key: key);

  @override
  State<QBIDeductionExpansionTile> createState() =>
      _QBIDeductionExpansionTileState();
}

class _QBIDeductionExpansionTileState extends State<QBIDeductionExpansionTile> {
  var categoryColor = CustomColorScheme.QBIDeduction;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: categoryColor,
        border: Border(
          top: BorderSide(color: CustomColorScheme.tableBorder, width: 2),
          left: BorderSide(
            width: 4,
            color: categoryColor,
          ),
        ),
      ),
      child: ExpansionTile(
        trailing: ImageIcon(
          widget.selectedIndex == _TaxCreditsTile.QBIDeduction
              ? AssetImage('assets/images/icons/arrow_up.png')
              : AssetImage('assets/images/icons/arrow.png'),
          color: CustomColorScheme.errorPopupButton,
          size: 24,
        ),
        expandedAlignment: Alignment.topLeft,
        expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
        initiallyExpanded: widget.selectedIndex == _TaxCreditsTile.QBIDeduction,
        onExpansionChanged: (expanded) {
          widget.onUpdateTiles(expanded);
          widget.onUpdate();
        },
        title: Label(
          type: LabelType.General,
          fontWeight: FontWeight.w600,
          text: 'QBI Deduction',
        ),
        children: [
          _RowLabelItem(
            title: 'Qualified business income deduction',
            value: widget.qualifiedBusinessIncomeDeduction,
          ),
        ],
      ),
    );
  }
}

class TaxCreditExpansionTile extends StatefulWidget {
  final TaxCredits taxCredits;
  final int taxFilingStatus;
  final _TaxCreditsTile selectedIndex;

  final void Function() onUpdate;
  final void Function(bool isExpanded) onUpdateTiles;

  final IncomeAdjustments incomAdjustments;

  final bool hasChildren;

  const TaxCreditExpansionTile({
    Key? key,
    required this.taxCredits,
    required this.onUpdate,
    required this.onUpdateTiles,
    required this.selectedIndex,
    required this.incomAdjustments,
    required this.taxFilingStatus,
    required this.hasChildren,
  }) : super(key: key);

  @override
  State<TaxCreditExpansionTile> createState() => _TaxCreditExpansionTileState();
}

class _TaxCreditExpansionTileState extends State<TaxCreditExpansionTile> {
  var totalCredits = 0;
  var categoryColor = CustomColorScheme.legendUnfilled;

  void calculateTotal() {
    totalCredits = (widget.taxCredits.childTaxCredit +
            widget.taxCredits.childAndDependentCareCredit +
            widget.taxCredits.energyCredit +
            widget.taxCredits.electricVehicleCredit +
            widget.taxCredits.otherTaxCredit)
        .round();
  }

  @override
  void initState() {
    calculateTotal();
    super.initState();
  }

  late var taxCubit = BlocProvider.of<TaxCubit>(context);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: categoryColor,
        border: Border(
          top: BorderSide(color: CustomColorScheme.tableBorder, width: 2),
          left: BorderSide(width: 4, color: categoryColor),
          bottom: BorderSide(color: CustomColorScheme.tableBorder, width: 2),
        ),
      ),
      child: ExpansionTile(
        trailing: ImageIcon(
          widget.selectedIndex == _TaxCreditsTile.TaxCredit
              ? AssetImage('assets/images/icons/arrow_up.png')
              : AssetImage('assets/images/icons/arrow.png'),
          color: CustomColorScheme.errorPopupButton,
          size: 24,
        ),
        expandedAlignment: Alignment.topLeft,
        expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
        initiallyExpanded: widget.selectedIndex == _TaxCreditsTile.TaxCredit,
        onExpansionChanged: (expanded) {
          widget.onUpdateTiles(expanded);
          widget.onUpdate();
        },
        title: Label(
          type: LabelType.General,
          fontWeight: FontWeight.w600,
          text: 'Tax Credits',
        ),
        children: [
          _RowLabelItem(
            title: 'Child tax credit',
            value: widget.taxCredits.childTaxCredit,
          ),
          _RowLabelItem(
            title: 'Child & dependent care credit',
            value: widget.taxCredits.childAndDependentCareCredit,
          ),
          _RowInputItem(
            enabled: widget.taxFilingStatus != 1 && widget.hasChildren,
            title: 'Total eligible childcare expenses',
            value: widget.taxCredits.totalEligibleChildcareExpenses,
            onUpdateValue: (int value) async {
              widget.taxCredits.totalEligibleChildcareExpenses = value;
              widget.taxCredits.childAndDependentCareCredit =
                  await taxCubit.getChildAndDependentCareCredit(
                      widget.incomAdjustments, value);
              widget.onUpdate();
              calculateTotal();
              setState(() {});
            },
          ),
          _RowInputItem(
            title: 'Energy Credit',
            value: widget.taxCredits.energyCredit,
            onUpdateValue: (int value) {
              widget.taxCredits.energyCredit = value;
              widget.onUpdate();
              calculateTotal();
              setState(() {});
            },
          ),
          _RowInputItem(
            title: 'Electric Vehicle Credit',
            value: widget.taxCredits.electricVehicleCredit,
            onUpdateValue: (int value) {
              widget.taxCredits.electricVehicleCredit = value;
              widget.onUpdate();
              calculateTotal();
              setState(() {});
            },
          ),
          _RowInputItem(
            title: 'Other Tax Credit',
            value: widget.taxCredits.otherTaxCredit,
            onUpdateValue: (int value) {
              widget.taxCredits.otherTaxCredit = value;
              widget.onUpdate();
              calculateTotal();
              setState(() {});
            },
          ),
          _RowLabelItem(
            title: 'Total Credits',
            value: totalCredits,
            rowColor: categoryColor,
          ),
        ],
      ),
    );
  }
}

class _RowInputItem extends StatefulWidget {
  const _RowInputItem({
    Key? key,
    required this.title,
    required this.value,
    required this.onUpdateValue,
    this.enabled = true,
  }) : super(key: key);

  final bool enabled;
  final String title;
  final num value;
  final void Function(int value) onUpdateValue;

  @override
  State<_RowInputItem> createState() => _RowInputItemState();
}

class _RowInputItemState extends State<_RowInputItem> with _FlexFactors {
  var valueNew;

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 65,
      padding: const EdgeInsets.only(
        left: 16,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: CustomColorScheme.tableBorder, width: 2),
        ),
      ),
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: flexFactors[0],
              child: Row(
                children: [
                  Label(text: widget.title, type: LabelType.GeneralBold),
                  if (widget.title == 'Other')
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: CustomTooltip(
                        message:
                            'Other adjustments such as moving expenses, educator expenses, etc.',
                        child: Icon(
                          Icons.info_rounded,
                          color: CustomColorScheme.taxInfoTooltip,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: CustomVerticalDivider(),
            ),
            Expanded(
              flex: flexFactors[1],
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                child: SizedBox(
                  width: 40,
                  child: InputItem(
                    enabled: widget.enabled,
                    prefix: '\$ ',
                    value: widget.value.numericFormattedString(),
                    textInputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      NumericTextFormatter(),
                      LengthLimitingTextInputFormatter(10),
                    ],
                    onChanged: (String value) {
                      valueNew = value.replaceAll(',', '');
                      widget.onUpdateValue(
                          valueNew.isNotEmpty ? int.parse(valueNew) : 0);
                      setState(() {});
                    },
                    onEditingComplete: () {
                      widget.onUpdateValue(
                          valueNew.isNotEmpty ? int.parse(valueNew) : 0);
                      setState(() {});
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RowLabelItem extends StatelessWidget with _FlexFactors {
  const _RowLabelItem(
      {Key? key, required this.title, required this.value, this.rowColor})
      : super(key: key);

  final String title;
  final num value;
  final Color? rowColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.only(left: 16),
      decoration: BoxDecoration(
        color: rowColor ?? Colors.white,
        border: Border(
          top: BorderSide(color: CustomColorScheme.tableBorder, width: 2),
        ),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Expanded(
              flex: flexFactors[0],
              child: Row(
                children: [
                  Label(text: title, type: LabelType.GeneralBold),
                  if (title == 'Child & dependent care credit')
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: CustomTooltip(
                        message:
                            'Include costs associated with up to 2 children aged 13\nand younger and other eligible dependent expenses.',
                        child: Icon(
                          Icons.info_rounded,
                          color: CustomColorScheme.taxInfoTooltip,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(
              width: 24,
              child: CustomVerticalDivider(),
            ),
            Flexible(
              flex: flexFactors[1],
              child: Label(
                type: LabelType.General,
                text: '\$${value.numericFormattedString()}',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
