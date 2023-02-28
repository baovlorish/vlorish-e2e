import 'package:burgundy_budgeting_app/domain/model/response/index_funds_response.dart';
import 'package:burgundy_budgeting_app/domain/model/response/retirements_models.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_indicator_widget.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_inkwell.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_tooltip.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/label.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/maybe_scrollable_widget.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/text_styles.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/theme.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/text_button_with_icon.dart';
import 'package:burgundy_budgeting_app/ui/atomic/organizm/remove_investment_popup.dart';
import 'package:burgundy_budgeting_app/ui/atomic/organizm/tax_statistics_widget.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/home_screen/home_screen_cubit.dart';
import 'package:burgundy_budgeting_app/ui/screen/investments/investments/investments_cubit.dart';
import 'package:burgundy_budgeting_app/ui/screen/investments/investments/investments_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

enum _ViewInvestmentType {
  Brokerage,
  Property,
  Other,
  Crypto,
  StartUp;

  static _ViewInvestmentType? fromInvestmentGroup(InvestmentGroup group) {
    if (group == InvestmentGroup.Stocks || group == InvestmentGroup.IndexFunds) return _ViewInvestmentType.Brokerage;
    if (group == InvestmentGroup.Property) return _ViewInvestmentType.Property;
    if (group == InvestmentGroup.OtherInvestments) return _ViewInvestmentType.Other;
    if (group == InvestmentGroup.Cryptocurrencies) return _ViewInvestmentType.Crypto;
    if (group == InvestmentGroup.StartUps) return _ViewInvestmentType.StartUp;
    return null;
  }

}

class InvestmentList extends StatefulWidget {
  final double width;

  const InvestmentList({
    Key? key,
    required this.showPopUpCallback,
    required this.width,
  }) : super(key: key);
  final void Function() showPopUpCallback;

  @override
  State<InvestmentList> createState() => _InvestmentListState();
}

class _InvestmentListState extends State<InvestmentList>
    with _InvestmentFlexFactors {
  late InvestmentsCubit investmentCubit =
      BlocProvider.of<InvestmentsCubit>(context);
  late List<InvestmentModel> investments;
  late RetirementPageModel? retirements =
      (investmentCubit.state as InvestmentsLoaded).retirements;
  late bool isRetirement =
      (investmentCubit.state as InvestmentsLoaded).isRetirement;
  late int retirementTab =
      (investmentCubit.state as InvestmentsLoaded).retirementTab;
  late var isReadOnlyAdvisor = BlocProvider.of<HomeScreenCubit>(context)
          .currentForeignSession
          ?.access
          .isReadOnly ??
      false;


  _ViewInvestmentType? investmentType;

  bool get hasBrokerage => investmentType == _ViewInvestmentType.Brokerage;

  bool get isProperty => investmentType == _ViewInvestmentType.Property;

  bool get isOther => investmentType == _ViewInvestmentType.Other;

  bool get isCrypto => investmentType == _ViewInvestmentType.Crypto;

  bool get isStartUp => investmentType == _ViewInvestmentType.StartUp;

  @override
  void initState() {
    super.initState();
    investmentCubit = BlocProvider.of<InvestmentsCubit>(context);
    investments = (investmentCubit.state as InvestmentsLoaded).investments!;
    if (investments.isNotEmpty && !isRetirement) {
      investmentType = _ViewInvestmentType.fromInvestmentGroup(investments.first.investmentGroup);
    }
  }

  static const manualIconPlaceholder = SizedBox.square(dimension: 30);

  @override
  Widget build(BuildContext context) {
    var shouldScroll = widget.width < 1000;
    return MaybeScrollableWidget(
      scrollDirection: Axis.horizontal,
      shouldScrollWhen: shouldScroll,
      child: SizedBox(
        width: shouldScroll ? 1000 : widget.width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 40,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: CustomColorScheme.tableBorder),
                  top: BorderSide(color: CustomColorScheme.tableBorder),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center, //maybe not
                children: [
                  if (isRetirement) manualIconPlaceholder,
                  isRetirement
                      ? Expanded(
                          flex: _brokerageFlex,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Label(
                              text: 'Custodian',
                              type: LabelType.TableHeader,
                              color: CustomColorScheme.tableHeaderText,
                            ),
                          ),
                        )
                      : Expanded(
                          flex: _companyNameFlex,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Label(
                              text: isProperty
                                  ? AppLocalizations.of(context)!.propertyName
                                  : AppLocalizations.of(context)!.companyName,
                              type: LabelType.TableHeader,
                              color: CustomColorScheme.tableHeaderText,
                            ),
                          ),
                        ),
                  if (hasBrokerage)
                    Expanded(
                      flex: _brokerageFlex,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Label(
                          text: AppLocalizations.of(context)!.brokerage,
                          type: LabelType.TableHeader,
                          color: CustomColorScheme.tableHeaderText,
                        ),
                      ),
                    )
                  else if (isProperty)
                    Expanded(
                      flex: _brokerageFlex,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Label(
                          text: AppLocalizations.of(context)!.address,
                          type: LabelType.TableHeader,
                          color: CustomColorScheme.tableHeaderText,
                        ),
                      ),
                    )
                  else if (isCrypto)
                    Expanded(
                      flex: _brokerageFlex,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Label(
                          text: 'Exchange',
                          type: LabelType.TableHeader,
                          color: CustomColorScheme.tableHeaderText,
                        ),
                      ),
                    ),
                  Expanded(
                    flex: _costFlex,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Label(
                        text: isRetirement ? 'Initial value' : AppLocalizations.of(context)!.cost,
                        type: LabelType.TableHeader,
                        color: CustomColorScheme.tableHeaderText,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: _acquisitionNameFlex,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Label(
                        text: AppLocalizations.of(context)!.acquisitionDate,
                        type: LabelType.TableHeader,
                        color: CustomColorScheme.tableHeaderText,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: _currentValueFlex,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Label(
                        text: AppLocalizations.of(context)!.currentValue,
                        type: LabelType.TableHeader,
                        color: CustomColorScheme.tableHeaderText,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            for (int index = 0;
                index <
                    (isRetirement
                            ? retirements!.modelsOfType(retirementTab)
                            : investments)
                        .length;
                index++)
              InvestmentItem(
                  item: isRetirement ? null : investments[index],
                  retirement: isRetirement
                      ? retirements!.modelsOfType(retirementTab)[index]
                      : null,
                  editInvestment: (String id) {
                    isRetirement
                        ? investmentCubit.navigateToEditRetirementPage(context,
                            model:
                                retirements!.modelsOfType(retirementTab)[index])
                        : investmentCubit.navigateToEditInvestmentPage(context,
                            investment: investments[index]);
                  },
                  removeInvestment: (model) {
                    showDialog(
                        context: context,
                        builder: (_context) {
                          return RemoveInvestmentPopUp(
                              model: model,
                              deleteInvestment: (context,
                                  {required model,
                                  required bool removeHistory,
                                  required DateTime sellDate}) {
                                investmentCubit.deleteInvestmentOrRetirement(
                                    context,
                                    model: model,
                                    removeHistory: removeHistory,
                                    sellDate: sellDate);
                              });
                        });
                  }),
            if (investments.length < 50)
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0, bottom: 16.0),
                  child: SizedBox(
                    width: 130,
                    child: isReadOnlyAdvisor
                        ? SizedBox()
                        : TextButtonWithIcon(
                            iconData: Icons.add_circle_rounded,
                            text: AppLocalizations.of(context)!.addAnother,
                            buttonColor: CustomColorScheme.menuBackgroundActive,
                            onTap: () => widget.showPopUpCallback(),
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

class InvestmentItem extends StatefulWidget {
  const InvestmentItem({
    Key? key,
    this.item,
    this.retirement,
    required this.editInvestment,
    required this.removeInvestment,
  }) : super(key: key);

  final InvestmentModel? item;
  final RetirementModel? retirement;
  final void Function(String id) editInvestment;
  final void Function(Object model) removeInvestment;

  @override
  State<InvestmentItem> createState() => _InvestmentItemState();
}

class _InvestmentItemState extends State<InvestmentItem> with _InvestmentFlexFactors {
  double get percent => widget.item != null
      ? 100 *
          (widget.item!.currentCost! - widget.item!.initialCost!) /
          widget.item!.initialCost!
      : 100 *
          (widget.retirement!.currentCost! - widget.retirement!.initialCost!) /
          widget.retirement!.initialCost!;
  late var isReadOnlyAdvisor = BlocProvider.of<HomeScreenCubit>(context)
          .currentForeignSession
          ?.access
          .isReadOnly ??
      false;

  late final isManual = widget.item?.isManual ?? widget.retirement?.isManual ?? false;

  late final isRetirement = widget.retirement != null;

  Widget get manualIconOrPlaceHolder => !isManual
      ? _InvestmentListState.manualIconPlaceholder
      : Padding(
          padding: const EdgeInsets.only(left: 6.0),
          child: CustomIndicatorWidget(
            color: CustomColorScheme.errorPopupButton,
            child: Text(
              'M',
              style: CustomTextStyle.LabelTextStyle(context).copyWith(
                  decoration: TextDecoration.none,
                  fontWeight: FontWeight.bold,
                  color: CustomColorScheme.tableWhiteText),
            ),
          ),
        );

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: CustomColorScheme.tableBorder),
        ),
      ),
      height: 50,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          isRetirement
              ? manualIconOrPlaceHolder
              : Expanded(
                  flex: _companyNameFlex,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Label(
                            text: widget.item!.name!,
                            type: LabelType.General,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      manualIconOrPlaceHolder,
                    ],
                  ),
                ),
          if (widget.item?.details != null &&
              widget.item!.investmentGroup != InvestmentGroup.OtherInvestments)
            Expanded(
              flex: _brokerageFlex,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Label(
                  text: widget.item!.details!,
                  type: LabelType.General,
                ),
              ),
            )
          else if (widget.item == null)
            Expanded(
              flex: _brokerageFlex,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Label(
                  text: widget.retirement!.custodian!,
                  type: LabelType.General,
                ),
              ),
            ),
          Expanded(
            flex: _costFlex,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Label(
                text: widget.item?.initialCost.toString() ??
                    widget.retirement!.initialCost.toString(),
                type: LabelType.General,
              ),
            ),
          ),
          Expanded(
            flex: _acquisitionNameFlex,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Label(
                text: DateFormat('MM/yyyy').format(
                    widget.item?.acquisitionDate! ??
                        widget.retirement!.acquisitionDate!),
                type: LabelType.General,
              ),
            ),
          ),
          Expanded(
            flex: _costValueFlex,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Row(
                children: [
                  Label(
                    text: widget.item?.currentCost.toString() ??
                        widget.retirement!.currentCost.toString(),
                    type: LabelType.General,
                  ),
                  SizedBox(width: 8),
                  if (percent != 0)
                    GrowthWithPercentageWidget(
                      growth: percent,
                      currencyFormat: true,
                    ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: _editDeleteValueFlex,
            child: isReadOnlyAdvisor
                ? const SizedBox()
                : Row(
                    children: [
                      if ((widget.item?.id != null && widget.item!.isManual) ||
                          (widget.retirement?.id != null && widget.retirement!.isManual))
                        CustomTooltip(
                          message: AppLocalizations.of(context)!.edit,
                          child: CustomMaterialInkWell(
                            borderRadius: BorderRadius.circular(22),
                            type: InkWellType.Purple,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ImageIcon(
                                AssetImage(
                                  'assets/images/icons/edit_ic.png',
                                ),
                                color: CustomColorScheme.mainDarkBackground,
                                size: 24,
                              ),
                            ),
                            onTap: () => widget.editInvestment(widget.item?.id! ?? widget.retirement!.id!),
                          ),
                        ),
                      SizedBox(width: 16),
                      if (isManual)
                        CustomTooltip(
                          message: AppLocalizations.of(context)!.delete,
                          child: CustomMaterialInkWell(
                            borderRadius: BorderRadius.circular(22),
                            type: InkWellType.Purple,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ImageIcon(
                                AssetImage(
                                  'assets/images/icons/delete.png',
                                ),
                                color: CustomColorScheme.mainDarkBackground,
                                size: 24,
                              ),
                            ),
                            onTap: () => widget.removeInvestment(widget.item ?? widget.retirement!),
                          ),
                        ),
                    ],
                  ),
          )
        ],
      ),
    );
  }

  String brokerageToString(BuildContext context, int brokerage) {
    switch (brokerage) {
      case 0:
        return AppLocalizations.of(context)!.other;
      case 1:
        return AppLocalizations.of(context)!.robinhood;
      case 2:
        return AppLocalizations.of(context)!.webull;
      case 3:
        return AppLocalizations.of(context)!.fidelity;
      case 4:
        return AppLocalizations.of(context)!.charleshwab;
      case 5:
        return AppLocalizations.of(context)!.tdAmeritrade;
      case 6:
        return AppLocalizations.of(context)!.etrade;
      case 7:
        return AppLocalizations.of(context)!.allyInvest;
      case 8:
        return AppLocalizations.of(context)!.interactiveBrokers;
      default:
        return AppLocalizations.of(context)!.unknown;
    }
  }
}

mixin _InvestmentFlexFactors {
  static const _companyName = 25;
  static const _brokerage = 25;
  static const _cost = 25;
  static const _acquisitionName = 20;

  static const _costValue = 35;
  static const _editDeleteValue = 15;

  static const _currentValue = _costValue + _editDeleteValue;

  final _companyNameFlex = _companyName;
  final _brokerageFlex = _brokerage;
  final _costFlex = _cost;
  final _acquisitionNameFlex = _acquisitionName;

  final _costValueFlex = _costValue;
  final _editDeleteValueFlex = _editDeleteValue;

  final _currentValueFlex = _currentValue;
}
