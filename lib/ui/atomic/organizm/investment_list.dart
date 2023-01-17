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
    with InvestmentFlexFactors {
  late InvestmentsCubit investmentCubit =
      BlocProvider.of<InvestmentsCubit>(context);
  late List<InvestmentModel> investments;
  late RetirementPageModel? retirements =
      (investmentCubit.state as InvestmentsLoaded).retirements;
  late bool isRetirement =
      (investmentCubit.state as InvestmentsLoaded).isRetirement;
  late int retirementTab =
      (investmentCubit.state as InvestmentsLoaded).retirementTab;
  late var isLimitedCoach = BlocProvider.of<HomeScreenCubit>(context)
      .currentForeignSession
      ?.access
      .isLimited ?? false;

  @override
  void initState() {
    investmentCubit = BlocProvider.of<InvestmentsCubit>(context);
    investments = (investmentCubit.state as InvestmentsLoaded).investments!;
    super.initState();
  }

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
                //mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center, //maybe not
                children: [
                  Expanded(
                    flex: listOfFlexFactorsHeader[0],
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Label(
                        text: isRetirement
                            ? 'Invest Type'
                            : investments.first.address != null
                                ? AppLocalizations.of(context)!.propertyName
                                : AppLocalizations.of(context)!.companyName,
                        type: LabelType.TableHeader,
                        color: CustomColorScheme.tableHeaderText,
                      ),
                    ),
                  ),
                  if (isRetirement)
                    Expanded(
                      flex: listOfFlexFactorsHeader[1],
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Label(
                          text: 'Custodian',
                          type: LabelType.TableHeader,
                          color: CustomColorScheme.tableHeaderText,
                        ),
                      ),
                    ),
                  if (!isRetirement && investments.first.brokerage != null)
                    Expanded(
                      flex: listOfFlexFactorsHeader[1],
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Label(
                          text: AppLocalizations.of(context)!.brokerage,
                          type: LabelType.TableHeader,
                          color: CustomColorScheme.tableHeaderText,
                        ),
                      ),
                    )
                  else if (!isRetirement && investments.first.address != null)
                    Expanded(
                      flex: listOfFlexFactorsHeader[1],
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Label(
                          text: AppLocalizations.of(context)!.address,
                          type: LabelType.TableHeader,
                          color: CustomColorScheme.tableHeaderText,
                        ),
                      ),
                    )
                  else if (!isRetirement && investments.first.exchange != null)
                    Expanded(
                      flex: listOfFlexFactorsHeader[1],
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
                    flex: listOfFlexFactorsHeader[2],
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Label(
                        text: isRetirement
                            ? 'Initial value'
                            : AppLocalizations.of(context)!.cost,
                        type: LabelType.TableHeader,
                        color: CustomColorScheme.tableHeaderText,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: listOfFlexFactorsHeader[3],
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
                    flex: listOfFlexFactorsHeader[4],
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
                    child: isLimitedCoach? SizedBox() : TextButtonWithIcon(
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

class _InvestmentItemState extends State<InvestmentItem>
    with InvestmentFlexFactors {
  double get percent => widget.item != null
      ? 100 *
          (widget.item!.currentCost! - widget.item!.initialCost!) /
          widget.item!.initialCost!
      : 100 *
          (widget.retirement!.currentCost! - widget.retirement!.initialCost!) /
          widget.retirement!.initialCost!;
  late var isLimitedCoach = BlocProvider.of<HomeScreenCubit>(context)
      .currentForeignSession
      ?.access
      .isLimited ?? false;
  var exchangeMap = {
    1: 'Coinbase',
    2: 'Gemini',
    3: 'Binance',
    0: 'Other',
  };

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
          Expanded(
            flex: listOfFlexFactorsHeader[0],
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Label(
                      text: widget.item != null
                          ? widget.item!.name!
                          : investToString(
                              context, widget.retirement!.investType ?? 0),
                      type: LabelType.General,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                if (widget.item?.isManual ??
                    widget.retirement?.isManual ??
                    false)
                  Padding(
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
                  ),
              ],
            ),
          ),
          if (widget.item?.brokerage != null)
            Expanded(
              flex: listOfFlexFactorsHeader[1],
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Label(
                  text: brokerageToString(context, widget.item!.brokerage!),
                  type: LabelType.General,
                ),
              ),
            )
          else if (widget.item?.address != null)
            Expanded(
              flex: listOfFlexFactorsHeader[1],
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Label(
                  text: widget.item!.address!,
                  type: LabelType.General,
                ),
              ),
            )
          else if (widget.item?.exchange != null)
            Expanded(
              flex: listOfFlexFactorsHeader[1],
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Label(
                  text: exchangeMap[widget.item!.exchange] ?? '',
                  type: LabelType.General,
                ),
              ),
            )
          else if (widget.item == null)
            Expanded(
              flex: listOfFlexFactorsHeader[1],
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Label(
                  text: custodianToString(
                      context, widget.retirement!.custodian ?? 0),
                  type: LabelType.General,
                ),
              ),
            ),
          Expanded(
            flex: listOfFlexFactorsHeader[2],
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
            flex: listOfFlexFactorsHeader[3],
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
            flex: listOfFlexFactorsItem[4],
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
            flex: listOfFlexFactorsItem[5],
            child: Row(
              children: [
                if ((widget.item?.id != null && widget.item!.isManual) ||
                    (widget.retirement?.id != null &&
                        widget.retirement!.isManual))
                  CustomTooltip(
                    message: AppLocalizations.of(context)!.edit,
                    child: CustomMaterialInkWell(
                      borderRadius: BorderRadius.circular(22),
                      type: InkWellType.Purple,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: isLimitedCoach? SizedBox() :  ImageIcon(
                          AssetImage(
                            'assets/images/icons/edit_ic.png',
                          ),
                          color: CustomColorScheme.mainDarkBackground,
                          size: 24,
                        ),
                      ),
                      onTap: () => widget.editInvestment(
                          widget.item?.id! ?? widget.retirement!.id!),
                    ),
                  ),
                SizedBox(width: 16),
                CustomTooltip(
                  message: AppLocalizations.of(context)!.delete,
                  child: CustomMaterialInkWell(
                    borderRadius: BorderRadius.circular(22),
                    type: InkWellType.Purple,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: isLimitedCoach? SizedBox() : ImageIcon(
                        AssetImage(
                          'assets/images/icons/delete.png',
                        ),
                        color: CustomColorScheme.mainDarkBackground,
                        size: 24,
                      ),
                    ),
                    onTap:  () => widget
                        .removeInvestment(widget.item ?? widget.retirement!),
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

  String custodianToString(BuildContext context, int custodian) {
    switch (custodian) {
      case 1:
        return 'Guideline';
      case 2:
        return 'Human Interest';
      case 3:
        return 'Betterment';
      case 4:
        return 'Wealthfront';
      case 5:
        return 'Fidelity';
      case 6:
        return 'T. Rowe Price';
      case 7:
        return 'Merril Edge';
      case 8:
        return 'Charles Scwab';
      case 9:
        return 'ADP';
      case 0:
        return 'Other';
      default:
        return AppLocalizations.of(context)!.unknown;
    }
  }

  String investToString(BuildContext context, int custodian) {
    switch (custodian) {
      case 1:
        return 'Stock';
      case 2:
        return 'Index Fund';
      default:
        return 'Other';
    }
  }
}

mixin InvestmentFlexFactors {
  List<int> get listOfFlexFactorsItem => [25, 25, 25, 20, 35, 15];

  List<int> get listOfFlexFactorsHeader => [25, 25, 25, 20, 50];
}
