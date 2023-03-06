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

  late TaxCreditsAndAdjustmentModel currentCreditsAndAdjustmentModel =
      widget.creditsAndAdjustmentModel;

  late var isReadOnlyAdvisor = BlocProvider.of<HomeScreenCubit>(context)
      .currentForeignSession
      ?.access
      .isReadOnly ?? false;

  @override
  void didUpdateWidget(TaxCreditsAndAdjustmentTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    currentCreditsAndAdjustmentModel = widget.creditsAndAdjustmentModel;
  }

  bool get buttonEnabled => widget.creditsAndAdjustmentModel != currentCreditsAndAdjustmentModel;

  bool get hasChildrenThirteenOrYounger =>
      (widget.personalInfoModel.children13andYoungerCount !=
          null &&
          widget.personalInfoModel.children13andYoungerCount! > 0);

  bool get hasChildrenSeventeenOrYounger =>
      (widget.personalInfoModel.children17andYoungerCount != null &&
          widget.personalInfoModel.children17andYoungerCount! > 0);

  bool get hasChildren => hasChildrenThirteenOrYounger || hasChildrenSeventeenOrYounger;

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
          incomeAdjustments: currentCreditsAndAdjustmentModel.incomeAdjustments,
          onUpdate: (IncomeAdjustments model) => setState(() =>
              currentCreditsAndAdjustmentModel = currentCreditsAndAdjustmentModel.copyWith(incomeAdjustments: model)),
          onUpdateTiles: (bool isExpanded) => setState(
              () => selectedExpansionTile = isExpanded ? _TaxCreditsTile.IncomeAdjustments : _TaxCreditsTile.none),
          selectedIndex: selectedExpansionTile,
          tileColor:CustomColorScheme.tableExpenseBackground,
          enabled: !isReadOnlyAdvisor,
          taxCubit: taxCubit,
        ),
        ItemizedDeductionsExpansionTile(
          itemizedDeductions: currentCreditsAndAdjustmentModel.itemizedDeductions,
          onUpdate: (ItemizedDeductions model) => setState(() =>
              currentCreditsAndAdjustmentModel = currentCreditsAndAdjustmentModel.copyWith(itemizedDeductions: model)),
          onUpdateTiles: (bool isExpanded) => setState(
              () => selectedExpansionTile = isExpanded ? _TaxCreditsTile.ItemizedDeductions : _TaxCreditsTile.none),
          selectedIndex: selectedExpansionTile,
          enabled: !isReadOnlyAdvisor,
          tileColor: CustomColorScheme.tableNetWorthBackground,
        ),
        QBIDeductionExpansionTile(
          qualifiedBusinessIncomeDeduction:
              currentCreditsAndAdjustmentModel.qualifiedBusinessIncomeDeduction,
          onUpdateTiles: (bool isExpanded) =>
              setState(() => selectedExpansionTile = isExpanded ? _TaxCreditsTile.QBIDeduction : _TaxCreditsTile.none),
          selectedIndex: selectedExpansionTile,
          tileColor: CustomColorScheme.QBIDeduction,
          onUpdate: (model) {},
          enabled: !isReadOnlyAdvisor,
        ),
        TaxCreditExpansionTile(
          taxFilingStatus: widget.personalInfoModel.taxFilingStatus!,
          hasChildren: hasChildren,
          taxCredits: currentCreditsAndAdjustmentModel.taxCredits,
          incomAdjustments: currentCreditsAndAdjustmentModel.incomeAdjustments,
          onUpdate: (TaxCredits model) => setState(
              () => currentCreditsAndAdjustmentModel = currentCreditsAndAdjustmentModel.copyWith(taxCredits: model)),
          onUpdateTiles: (bool isExpanded) =>
              setState(() => selectedExpansionTile = isExpanded ? _TaxCreditsTile.TaxCredit : _TaxCreditsTile.none),
          selectedIndex: selectedExpansionTile,
          enabled: !isReadOnlyAdvisor,
          tileColor: CustomColorScheme.legendUnfilled,
          taxCubit: taxCubit,
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
                  enabled: buttonEnabled && !isReadOnlyAdvisor,
                  onPressed: buttonEnabled && !isReadOnlyAdvisor
                      ? () {
                          taxCubit.updateCreditsAndAdjustment(currentCreditsAndAdjustmentModel);
                        }
                      : () {},
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

abstract class CalculationExpansionTile<T> extends StatelessWidget{
  final void Function(T) onUpdate;
  final void Function(bool isExpanded) onUpdateTiles;
  final bool enabled;
  final Color tileColor;

  const CalculationExpansionTile({
    required this.onUpdate,
    required this.onUpdateTiles,
    required this.enabled,
    required this.tileColor,
    super.key,
  });
}

class IncomeAdjustmentsExpansionTile extends CalculationExpansionTile<IncomeAdjustments>{
  const IncomeAdjustmentsExpansionTile({
    super.key,
    required this.incomeAdjustments,
    required this.selectedIndex,
    required this.taxCubit,
    required super.onUpdate,
    required super.onUpdateTiles,
    required super.enabled,
    required super.tileColor,
  });

  final IncomeAdjustments incomeAdjustments;
  final _TaxCreditsTile selectedIndex;
  final TaxCubit taxCubit;

  int get calculateTotal =>
        (incomeAdjustments.selfEmployedHealthInsurance +
                incomeAdjustments.hsaContribution +
                incomeAdjustments
                    .retirementContributionsNotDeductedFromPaycheck +
                incomeAdjustments.studentInterestPaidDuringTheYear +
                incomeAdjustments.halfOfSelfEmploymentTaxesPaid +
                incomeAdjustments.other)
            .round();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: tileColor,
        border: Border(
          top: BorderSide(color: CustomColorScheme.tableBorder, width: 2),
          left: BorderSide(
            width: 4,
            color: tileColor,
          ),
        ),
      ),
      child: ExpansionTile(
        trailing: ImageIcon(
          selectedIndex == _TaxCreditsTile.IncomeAdjustments
              ? AssetImage('assets/images/icons/arrow_up.png')
              : AssetImage('assets/images/icons/arrow.png'),
          color: CustomColorScheme.errorPopupButton,
          size: 24,
        ),
        // expandedAlignment: Alignment.topLeft,
        expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
        initiallyExpanded:
            selectedIndex == _TaxCreditsTile.IncomeAdjustments,
        onExpansionChanged: (bool expanded) => onUpdateTiles(expanded),
        title: Label(
          type: LabelType.General,
          fontWeight: FontWeight.w600,
          text: 'Income Adjustments',
        ),
        children: [
          _RowInputItem(
            enabled: enabled,
              title: 'Self employed health insurance',
              value: incomeAdjustments.selfEmployedHealthInsurance,
              onUpdateValue: (int value) => onUpdate(incomeAdjustments.copyWith(selfEmployedHealthInsurance: value))),
          _RowInputItem(
              enabled: enabled,
              title: 'HSA contribution',
              value: incomeAdjustments.hsaContribution,
              onUpdateValue: (int value) => onUpdate(incomeAdjustments.copyWith(hsaContribution: value))),
          _RowInputItem(
              enabled: enabled,
              title: 'Retirement contributions not deducted from paycheck',
              value: incomeAdjustments
                  .retirementContributionsNotDeductedFromPaycheck,
              onUpdateValue: (int value) => onUpdate(incomeAdjustments.copyWith(retirementContributionsNotDeductedFromPaycheck: value))),
          _RowLabelItem(
            title: 'Student interest paid during the year',
            value: incomeAdjustments.studentInterestPaidDuringTheYear,
          ),
          _RowInputItem(
              enabled: enabled,
              title: 'Student loan interest paid',
              value: incomeAdjustments.studentLoanInterestPaid,
              onUpdateValue: (int value) async => onUpdate(
                  incomeAdjustments.copyWith(
                      studentLoanInterestPaid: value,
                      studentInterestPaidDuringTheYear: await taxCubit.getStudentInterestPaid(value)),
                )),
          _RowLabelItem(
            title: '50% of self-employment taxes paid',
            value: incomeAdjustments.halfOfSelfEmploymentTaxesPaid,
          ),
          _RowInputItem(
              enabled: enabled,
              title: 'Other',
              value: incomeAdjustments.other,
              onUpdateValue: (int value) => onUpdate(incomeAdjustments.copyWith(other: value))),
          _RowLabelItem(
            title: 'Total income adjustments',
            value: calculateTotal,
            rowColor: tileColor,
          ),
        ],
      ),
    );
  }
}

class ItemizedDeductionsExpansionTile extends CalculationExpansionTile<ItemizedDeductions>{
  const ItemizedDeductionsExpansionTile({
    super.key,
    required this.itemizedDeductions,
    required this.selectedIndex,
    required super.onUpdate,
    required super.onUpdateTiles,
    required super.enabled,
    required super.tileColor,
  });

  final ItemizedDeductions itemizedDeductions;
  final _TaxCreditsTile selectedIndex;

  int get calculateTotal => (itemizedDeductions.mortgageInterestPaid +
            itemizedDeductions.propertyTaxPayments +
            itemizedDeductions.charitableContributions +
            itemizedDeductions.otherItemizedDeduction)
        .round();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: tileColor,
        border: Border(
          top: BorderSide(color: CustomColorScheme.tableBorder, width: 2),
          left: BorderSide(
            width: 4,
            color: tileColor,
          ),
        ),
      ),
      child: ExpansionTile(
        trailing: ImageIcon(
          selectedIndex == _TaxCreditsTile.ItemizedDeductions
              ? AssetImage('assets/images/icons/arrow_up.png')
              : AssetImage('assets/images/icons/arrow.png'),
          color: CustomColorScheme.errorPopupButton,
          size: 24,
        ),
        expandedAlignment: Alignment.topLeft,
        expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
        initiallyExpanded:
            selectedIndex == _TaxCreditsTile.ItemizedDeductions,
        onExpansionChanged: (expanded) => onUpdateTiles(expanded),
        title: Label(
          type: LabelType.General,
          fontWeight: FontWeight.w600,
          text: 'Itemized deductions',
        ),
        children: [
          _RowInputItem(
              enabled: enabled,
              title: 'Mortgage interest paid',
              value: itemizedDeductions.mortgageInterestPaid,
              onUpdateValue: (int value) => onUpdate(itemizedDeductions.copyWith(mortgageInterestPaid: value))),
          _RowInputItem(
              enabled: enabled,
              title: 'Property tax payments',
              value: itemizedDeductions.propertyTaxPayments,
              onUpdateValue: (int value) => onUpdate(itemizedDeductions.copyWith(propertyTaxPayments: value))),
          _RowInputItem(
              enabled:enabled,
              title: 'Charitable contributions',
              value: itemizedDeductions.charitableContributions,
              onUpdateValue: (int value) => onUpdate(itemizedDeductions.copyWith(charitableContributions: value))),
          _RowInputItem(
            enabled: enabled,
            title: 'Other itemized deduction (deductible portion only)',
            value: itemizedDeductions.otherItemizedDeduction,
            onUpdateValue: (int value) => onUpdate(itemizedDeductions.copyWith(otherItemizedDeduction: value)),
          ),
          _RowLabelItem(
            title: 'Total Itemized Deductions',
            value: calculateTotal,
            rowColor: tileColor,
          ),
          _RowLabelItem(
            title: 'Compare to Standard deduction',
            value: itemizedDeductions.compareToStandardDeduction,
            rowColor: tileColor,
          ),
        ],
      ),
    );
  }
}

class QBIDeductionExpansionTile extends CalculationExpansionTile<int>{
  final int qualifiedBusinessIncomeDeduction;
  final _TaxCreditsTile selectedIndex;

  const QBIDeductionExpansionTile({
    super.key,
    required this.qualifiedBusinessIncomeDeduction,
    required this.selectedIndex,
    required super.onUpdate,
    required super.onUpdateTiles,
    required super.enabled,
    required super.tileColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: tileColor,
        border: Border(
          top: BorderSide(color: CustomColorScheme.tableBorder, width: 2),
          left: BorderSide(
            width: 4,
            color: tileColor,
          ),
        ),
      ),
      child: ExpansionTile(
        trailing: ImageIcon(
          selectedIndex == _TaxCreditsTile.QBIDeduction
              ? AssetImage('assets/images/icons/arrow_up.png')
              : AssetImage('assets/images/icons/arrow.png'),
          color: CustomColorScheme.errorPopupButton,
          size: 24,
        ),
        expandedAlignment: Alignment.topLeft,
        expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
        initiallyExpanded: selectedIndex == _TaxCreditsTile.QBIDeduction,
        onExpansionChanged: (expanded) => onUpdateTiles(expanded),
        title: Label(
          type: LabelType.General,
          fontWeight: FontWeight.w600,
          text: 'QBI Deduction',
        ),
        children: [
          _RowLabelItem(
            title: 'Qualified business income deduction',
            value: qualifiedBusinessIncomeDeduction,
          ),
        ],
      ),
    );
  }
}

class TaxCreditExpansionTile extends CalculationExpansionTile<TaxCredits>{


  final TaxCredits taxCredits;
  final int taxFilingStatus;
  final _TaxCreditsTile selectedIndex;
  final IncomeAdjustments incomAdjustments;
  final bool hasChildren;
  final TaxCubit taxCubit;


  const TaxCreditExpansionTile({
    super.key,
    required this.taxCredits,
    required this.selectedIndex,
    required this.incomAdjustments,
    required this.taxFilingStatus,
    required this.hasChildren,
    required this.taxCubit,
    required super.enabled,
    required super.onUpdate,
    required super.onUpdateTiles,
    required super.tileColor,
  });

  int get calculateTotal => (taxCredits.childTaxCredit +
            taxCredits.childAndDependentCareCredit +
            taxCredits.energyCredit +
            taxCredits.electricVehicleCredit +
            taxCredits.otherTaxCredit)
        .round();


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: tileColor,
        border: Border(
          top: BorderSide(color: CustomColorScheme.tableBorder, width: 2),
          left: BorderSide(width: 4, color: tileColor),
          bottom: BorderSide(color: CustomColorScheme.tableBorder, width: 2),
        ),
      ),
      child: ExpansionTile(
        trailing: ImageIcon(
          selectedIndex == _TaxCreditsTile.TaxCredit
              ? AssetImage('assets/images/icons/arrow_up.png')
              : AssetImage('assets/images/icons/arrow.png'),
          color: CustomColorScheme.errorPopupButton,
          size: 24,
        ),
        expandedAlignment: Alignment.topLeft,
        expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
        initiallyExpanded: selectedIndex == _TaxCreditsTile.TaxCredit,
        onExpansionChanged: (expanded) => onUpdateTiles(expanded),
        title: Label(
          type: LabelType.General,
          fontWeight: FontWeight.w600,
          text: 'Tax Credits',
        ),
        children: [
          _RowLabelItem(
            title: 'Child tax credit',
            value: taxCredits.childTaxCredit,
          ),
          _RowLabelItem(
            title: 'Child & dependent care credit',
            value: taxCredits.childAndDependentCareCredit,
          ),
          _RowInputItem(
            enabled: taxFilingStatus != 1 && hasChildren && enabled,
            title: 'Total eligible childcare expenses',
            value: taxCredits.totalEligibleChildcareExpenses,
            onUpdateValue: (int value) async => onUpdate(taxCredits.copyWith(
                  totalEligibleChildcareExpenses: value,
                  childAndDependentCareCredit:
                  await taxCubit.getChildAndDependentCareCredit(incomAdjustments, value))),
          ),
          _RowInputItem(
            enabled: enabled,
            title: 'Energy Credit',
            value: taxCredits.energyCredit,
            onUpdateValue: (int value) => onUpdate(taxCredits.copyWith(energyCredit: value)),
          ),
          _RowInputItem(
            enabled:enabled,
            title: 'Electric Vehicle Credit',
            value: taxCredits.electricVehicleCredit,
            onUpdateValue: (int value) => onUpdate(taxCredits.copyWith(electricVehicleCredit: value)),
          ),
          _RowInputItem(
            enabled: enabled,
            title: 'Other Tax Credit',
            value: taxCredits.otherTaxCredit,
            onUpdateValue: (int value) => onUpdate(taxCredits.copyWith(otherTaxCredit: value)),
          ),
          _RowLabelItem(
            title: 'Total Credits',
            value: calculateTotal,
            rowColor: tileColor,
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
                      setState(() => widget.onUpdateValue(
                          valueNew.isNotEmpty ? int.parse(valueNew) : 0));
                    },
                    onEditingComplete: () => setState(() => widget.onUpdateValue(
                          valueNew.isNotEmpty ? int.parse(valueNew) : 0)),
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
