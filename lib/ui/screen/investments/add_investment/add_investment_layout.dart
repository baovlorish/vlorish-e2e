import 'dart:math';

import 'package:burgundy_budgeting_app/domain/model/response/index_funds_response.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/back_button.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_date_formats.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_inkwell.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_loading_indicator.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_radio_button.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/label.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/text_styles.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/theme.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/button_item.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/dropdown_item.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/editable_table_body_cell.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/error_alert_dialog.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/input_item.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/label_button_item.dart';
import 'package:burgundy_budgeting_app/ui/atomic/organizm/date_picker.dart';
import 'package:burgundy_budgeting_app/ui/atomic/organizm/remove_investment_popup.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/home_screen/home_screen.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/home_screen/home_screen_cubit.dart';
import 'package:burgundy_budgeting_app/ui/screen/investments/add_investment/add_investment_cubit.dart';
import 'package:burgundy_budgeting_app/ui/screen/investments/add_investment/add_investment_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddInvestmentLayout extends StatefulWidget {
  final InvestmentModel? editInvestment;

  const AddInvestmentLayout({
    Key? key,
    this.editInvestment,
  }) : super(key: key);

  @override
  State<AddInvestmentLayout> createState() => _AddInvestmentLayoutState();
}

class _AddInvestmentLayoutState extends State<AddInvestmentLayout> {
  var isSmallHeader = false;
  var controller = ScrollController();

  late var isReadOnlyAdvisor = BlocProvider.of<HomeScreenCubit>(context)
          .currentForeignSession
          ?.access
          .isReadOnly ??
      false;

  String? _name;
  final _nameNode = FocusNode();

  double? _initialCost;
  final _costNode = FocusNode();

  DateTime? _acquisitionDate;
  final _acquisitionDateNode = FocusNode();

  String? _details;
  final _detailsNode = FocusNode();

  double? _currentCost;
  final _currentCostNode = FocusNode();

  final shortWidth = 250.0;

  int? _costType;
  final _costTypeNode = FocusNode();
  int? _usageType = 1; //personal by default
  double? _newCost;
  final _newCostNode = FocusNode();

  final _formKey = GlobalKey<FormState>();

  late final AddInvestmentCubit _addInvestmentCubit =
      BlocProvider.of<AddInvestmentCubit>(context);

  late bool isAddScreen;
  late final bool hasBrokerage = _addInvestmentCubit.currentInvestmentGroup ==
          InvestmentGroup.Stocks ||
      _addInvestmentCubit.currentInvestmentGroup == InvestmentGroup.IndexFunds;

  late final bool isProperty =
      _addInvestmentCubit.currentInvestmentGroup == InvestmentGroup.Property;
  late final bool isOther = _addInvestmentCubit.currentInvestmentGroup ==
      InvestmentGroup.OtherInvestments;
  late final bool isCrypto = _addInvestmentCubit.currentInvestmentGroup ==
      InvestmentGroup.Cryptocurrencies;
  late final bool isStartUp =
      _addInvestmentCubit.currentInvestmentGroup == InvestmentGroup.StartUps;

  String categoryHeader(InvestmentGroup group) {
    if (group == InvestmentGroup.Stocks) {
      return isAddScreen ? 'Add a Stock' : 'Edit a Stock';
    } else if (group == InvestmentGroup.IndexFunds) {
      return isAddScreen ? 'Add an Index Fund' : 'Edit an Index Fund';
    } else if (group == InvestmentGroup.Cryptocurrencies) {
      return isAddScreen ? 'Add a Cryptocurrency' : 'Edit a Cryptocurrency';
    } else if (group == InvestmentGroup.Property) {
      return isAddScreen ? 'Add a Inv. Properties' : 'Edit a Inv. Properties';
    } else if (group == InvestmentGroup.StartUps) {
      return isAddScreen ? 'Add a Startup' : 'Edit a Startup';
    } else if (group == InvestmentGroup.OtherInvestments) {
      return isAddScreen
          ? 'Add an Other Investment'
          : 'Edit an Other Investment';
    } else {
      return isAddScreen ? 'Add an Investment' : 'Edit an Investment';
    }
  }

  @override
  void initState() {
    isAddScreen = widget.editInvestment == null;
    if (!isAddScreen) {
      _name = widget.editInvestment!.name;
      _initialCost = widget.editInvestment!.initialCost;
      _currentCost = widget.editInvestment!.currentCost;
      _details = widget.editInvestment!.details;
      _acquisitionDate = widget.editInvestment!.acquisitionDate;
      _usageType = widget.editInvestment!.usageType;
    }
    super.initState();
  }

  var showExtraFieldInEditMode = false;

  @override
  Widget build(BuildContext context) {
    isSmallHeader = MediaQuery.of(context).size.width < 1070;

    var enabled = checkEnabled() && !isReadOnlyAdvisor;

    return BlocConsumer<AddInvestmentCubit, AddInvestmentState>(
        listener: (context, state) {
      if (state is AddInvestmentError) {
        showDialog(
          context: context,
          builder: (context) {
            return ErrorAlertDialog(
              context,
              message: state.error,
            );
          },
        );
      }
    }, builder: (context, state) {
      return HomeScreen(
          headerWidget: SingleChildScrollView(
            child: Flex(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: isSmallHeader
                  ? MainAxisAlignment.start
                  : MainAxisAlignment.spaceBetween,
              direction: isSmallHeader ? Axis.vertical : Axis.horizontal,
              children: [
                Row(
                  children: [
                    CustomBackButton(onPressed: () {
                      _addInvestmentCubit.navigationToInvestmentPage(context);
                    }),
                    Text(
                      categoryHeader(
                          _addInvestmentCubit.currentInvestmentGroup),
                      style:
                          CustomTextStyle.HeaderBoldTextStyle(context).copyWith(
                        fontSize: 36.0,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 130,
                      child: ButtonItem(context,
                          text: isAddScreen
                              ? AppLocalizations.of(context)!.add
                              : AppLocalizations.of(context)!.save,
                          enabled: enabled, onPressed: () {
                        if (enabled) {
                          isAddScreen
                              ? {
                                  _addInvestmentCubit.addInvestment(
                                    context,
                                    name: _name!,
                                    details: _details,
                                    usageType: _usageType,
                                    acquisitionDate: _acquisitionDate!,
                                    initialCost: _initialCost!,
                                    currentCost: _currentCost ?? _initialCost,
                                    investmentType: _addInvestmentCubit
                                        .currentInvestmentGroup.index,
                                  ),
                                }
                              : {
                                  _addInvestmentCubit.updateInvestment(context,
                                      id: widget.editInvestment!.id!,
                                      name: _name!,
                                      isManual: widget.editInvestment!.isManual,
                                      acquisitionDate: _acquisitionDate!,
                                      details: _details,
                                      usageType: _usageType,
                                      investmentType:
                                          widget.editInvestment!.investmentType,
                                      initialCost: _initialCost!,
                                      currentCost: _currentCost!,
                                      transactions: [
                                        if (_newCost != null &&
                                            _costType != null &&
                                            showExtraFieldInEditMode)
                                          InvestmentTransaction(
                                              amount: _newCost, type: _costType)
                                      ]),
                                };
                        }
                      }),
                    ),
                  ],
                )
              ],
            ),
          ),
          currentTab: Tabs.Investments,
          bodyWidget: state is AddInvestmentLoading
              ? CustomLoadingIndicator()
              : Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(17),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 28, horizontal: 20),
                      decoration: BoxDecoration(
                        color: CustomColorScheme.blockBackground,
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 10.0,
                            color: CustomColorScheme.tableBorder,
                          ),
                        ],
                      ),
                      child: LayoutBuilder(builder: (context, constraints) {
                        var isSmall = constraints.maxWidth < 850;
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SingleChildScrollView(
                              controller: controller,
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Flex(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      direction: isSmall
                                          ? Axis.vertical
                                          : Axis.horizontal,
                                      children: [
                                        SizedBox(
                                          width: min(
                                              516, constraints.maxWidth - 30),
                                          child: InputItem(
                                            value: _name,
                                            focusNode: _nameNode,
                                            textInputFormatters: [
                                              LengthLimitingTextInputFormatter(
                                                  20),
                                            ],
                                            onChanged: (value) {
                                              _name = value;
                                              setState(() {});
                                            },
                                            onEditingComplete: () =>
                                                _detailsNode.requestFocus(),
                                            hintText: 'Vlorish',
                                            labelText: (isProperty
                                                    ? AppLocalizations.of(
                                                            context)!
                                                        .propertyName
                                                    : AppLocalizations.of(
                                                            context)!
                                                        .companyName) +
                                                '*',
                                          ),
                                        ),
                                        SizedBox(
                                          width: isSmall ? 0 : 16,
                                          height: isSmall ? 16 : 0,
                                        ),
                                        if (isOther)
                                          SizedBox(
                                            width: shortWidth,
                                            child: DropdownItem<String>(
                                              initialValue: _details,
                                              focusNode: _detailsNode,
                                              itemKeys: [
                                                AppLocalizations.of(context)!
                                                    .otherInvestments,
                                                AppLocalizations.of(context)!
                                                    .cashHeldAtBrokerageOrExchanges,
                                                AppLocalizations.of(context)!
                                                    .bondsAndCDs,
                                                AppLocalizations.of(context)!
                                                    .loansReceivableFromOthers,
                                                AppLocalizations.of(context)!
                                                    .goldMetals,
                                                AppLocalizations.of(context)!
                                                    .otherPreciousMedal,
                                                AppLocalizations.of(context)!
                                                    .domains,
                                                AppLocalizations.of(context)!
                                                    .otherDigitalAssets
                                              ],
                                              callback: (value) {
                                                _details = value;
                                                setState(() {});

                                                isAddScreen
                                                    ? _costNode.requestFocus()
                                                    : showExtraFieldInEditMode
                                                        ? _costTypeNode
                                                            .requestFocus()
                                                        : null;
                                              },
                                              labelText:
                                                  AppLocalizations.of(context)!
                                                          .otherType +
                                                      '*',
                                              items: [
                                                AppLocalizations.of(context)!
                                                    .otherInvestments,
                                                AppLocalizations.of(context)!
                                                    .cashHeldAtBrokerageOrExchanges,
                                                AppLocalizations.of(context)!
                                                    .bondsAndCDs,
                                                AppLocalizations.of(context)!
                                                    .loansReceivableFromOthers,
                                                AppLocalizations.of(context)!
                                                    .goldMetals,
                                                AppLocalizations.of(context)!
                                                    .otherPreciousMedal,
                                                AppLocalizations.of(context)!
                                                    .domains,
                                                AppLocalizations.of(context)!
                                                    .otherDigitalAssets
                                              ],
                                              hintText:
                                                  AppLocalizations.of(context)!
                                                      .chooseTheOtherType,
                                            ),
                                          ),
                                        if (isCrypto)
                                          SizedBox(
                                            width: shortWidth,
                                            child: DropdownItem<String>(
                                              initialValue: _details,
                                              focusNode: _detailsNode,
                                              itemKeys: [
                                                'Coinbase', //fixme: localization
                                                'Gemini',
                                                'Binance',
                                                'Other',
                                              ],
                                              callback: (value) {
                                                _details = value;
                                                setState(() {});
                                                isAddScreen
                                                    ? _costNode.requestFocus()
                                                    : showExtraFieldInEditMode
                                                        ? _costTypeNode
                                                            .requestFocus()
                                                        : null;
                                              },
                                              labelText: 'Exchange*',
                                              items: [
                                                'Coinbase',
                                                'Gemini',
                                                'Binance',
                                                'Other',
                                              ],
                                              hintText:
                                                  AppLocalizations.of(context)!
                                                      .select,
                                            ),
                                          ),
                                        if (hasBrokerage)
                                          SizedBox(
                                            width: shortWidth,
                                            child: DropdownItem<String>(
                                              initialValue: _details,
                                              focusNode: _detailsNode,
                                              itemKeys: [
                                                AppLocalizations.of(context)!
                                                    .robinhood,
                                                AppLocalizations.of(context)!
                                                    .webull,
                                                AppLocalizations.of(context)!
                                                    .fidelity,
                                                AppLocalizations.of(context)!
                                                    .charleshwab,
                                                AppLocalizations.of(context)!
                                                    .tdAmeritrade,
                                                AppLocalizations.of(context)!
                                                    .etrade,
                                                AppLocalizations.of(context)!
                                                    .allyInvest,
                                                AppLocalizations.of(context)!
                                                    .interactiveBrokers,
                                                AppLocalizations.of(context)!
                                                    .other,
                                              ],
                                              callback: (value) {
                                                _details = value;
                                                setState(() {});

                                                isAddScreen
                                                    ? _costNode.requestFocus()
                                                    : showExtraFieldInEditMode
                                                        ? _costTypeNode
                                                            .requestFocus()
                                                        : null;
                                              },
                                              labelText:
                                                  AppLocalizations.of(context)!
                                                          .brokerage +
                                                      '*',
                                              items: [
                                                AppLocalizations.of(context)!
                                                    .robinhood,
                                                AppLocalizations.of(context)!
                                                    .webull,
                                                AppLocalizations.of(context)!
                                                    .fidelity,
                                                AppLocalizations.of(context)!
                                                    .charleshwab,
                                                AppLocalizations.of(context)!
                                                    .tdAmeritrade,
                                                AppLocalizations.of(context)!
                                                    .etrade,
                                                AppLocalizations.of(context)!
                                                    .allyInvest,
                                                AppLocalizations.of(context)!
                                                    .interactiveBrokers,
                                                AppLocalizations.of(context)!
                                                    .other,
                                              ],
                                              hintText:
                                                  AppLocalizations.of(context)!
                                                      .chooseTheBrokerageType,
                                            ),
                                          )
                                        else if (isProperty)
                                          Padding(
                                            padding: isSmall
                                                ? const EdgeInsets.only(top: 0)
                                                : const EdgeInsets.all(28),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                CustomRadioButton(
                                                  title: AppLocalizations.of(
                                                          context)!
                                                      .personal,
                                                  value: 1,
                                                  groupValue: _usageType,
                                                  onTap: () => setState(() {
                                                    _usageType = 1;
                                                  }),
                                                ),
                                                SizedBox(width: 24),
                                                CustomRadioButton(
                                                  title: AppLocalizations.of(
                                                          context)!
                                                      .business,
                                                  value: 2,
                                                  groupValue: _usageType,
                                                  onTap: () => setState(() {
                                                    _usageType = 2;
                                                  }),
                                                ),
                                              ],
                                            ),
                                          ),
                                      ],
                                    ),
                                    SizedBox(height: 16),
                                    if (isProperty)
                                      SizedBox(
                                        width:
                                            min(516, constraints.maxWidth - 30),
                                        child: InputItem(
                                          enabled: true,
                                          value: _details,
                                          labelText: 'Property address*',
                                          textInputFormatters: [
                                            LengthLimitingTextInputFormatter(
                                                20),
                                          ],
                                          onChanged: (value) {
                                            _details = value;
                                            setState(() {});
                                          },
                                        ),
                                      ),
                                    if (isProperty) SizedBox(height: 16),
                                    Flex(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      direction: isSmall
                                          ? Axis.vertical
                                          : Axis.horizontal,
                                      children: [
                                        SizedBox(
                                          width: shortWidth,
                                          child: InputItem(
                                            enabled: isAddScreen,
                                            value: _initialCost != null
                                                ? _initialCost!.toString()
                                                : '',
                                            focusNode: _costNode,
                                            labelText: 'Cost*',
                                            prefix: '\$ ',
                                            onEditingComplete: () =>
                                                setState(() {
                                              _currentCostNode.requestFocus();
                                            }),
                                            textInputFormatters: [
                                              FilteringTextInputFormatter.allow(
                                                  RegExp(r'\d*\.?')),
                                              LengthLimitingTextInputFormatter(
                                                  13),
                                              if (_costNode.hasFocus)
                                                DecimalTextInputFormatter(),
                                            ],
                                            onChanged: (value) {
                                              if (value == '') {
                                                _initialCost = null;
                                              } else {
                                                _initialCost =
                                                    double.tryParse(value);
                                              }
                                              setState(() {});
                                            },
                                          ),
                                        ),
                                        isSmall
                                            ? SizedBox(
                                                height: 16,
                                              )
                                            : SizedBox(
                                                width: 16,
                                              ),
                                        SizedBox(
                                          width: shortWidth,
                                          child: DatePicker(
                                            enabled: isAddScreen,
                                            title: AppLocalizations.of(context)!
                                                    .acquisitionDate +
                                                '*',
                                            context,
                                            value: _acquisitionDate != null
                                                ? _acquisitionDate!
                                                    .toIso8601String()
                                                : '',
                                            dateFormat: CustomDateFormats
                                                .monthAndYearDateFormat,
                                            onChanged: (String value) {
                                              _acquisitionDate =
                                                  DateTime.parse(value);
                                              setState(() {});
                                            },
                                            lastDate: DateTime.now(),
                                            focusNode: _acquisitionDateNode,
                                            hint: 'MM/YYYY',
                                          ),
                                        ),
                                        SizedBox(width: 16),
                                        if (!isAddScreen && !isProperty)
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 18.0),
                                            child: CustomMaterialInkWell(
                                              type: InkWellType.Purple,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.add_circle_rounded,
                                                    color: CustomColorScheme
                                                        .menuBackgroundActive,
                                                  ),
                                                  SizedBox(width: 4),
                                                  Label(
                                                    text: isCrypto
                                                        ? 'Update cost basis'
                                                        : 'Add changes to the cost',
                                                    type: LabelType.Button,
                                                    color: CustomColorScheme
                                                        .menuBackgroundActive,
                                                  )
                                                ],
                                              ),
                                              onTap: () {
                                                showExtraFieldInEditMode =
                                                    !showExtraFieldInEditMode;
                                                setState(() {});
                                              },
                                            ),
                                          )
                                      ],
                                    ),
                                    SizedBox(height: 16),
                                    if (showExtraFieldInEditMode && !isProperty)
                                      Flex(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        direction: isSmall
                                            ? Axis.vertical
                                            : Axis.horizontal,
                                        children: [
                                          SizedBox(
                                            width: shortWidth,
                                            child: DropdownItem<int>(
                                              initialValue: _costType,
                                              focusNode: _costTypeNode,
                                              itemKeys: [
                                                1, //Sell
                                                2, //buy
                                              ],
                                              callback: (value) {
                                                _costType = value;
                                                setState(() {});
                                              },
                                              items: [
                                                AppLocalizations.of(context)!
                                                    .sold,
                                                AppLocalizations.of(context)!
                                                    .bought,
                                              ],
                                              hintText:
                                                  AppLocalizations.of(context)!
                                                      .costTypeHint,
                                              labelText: ' ',
                                            ),
                                          ),
                                          isSmall
                                              ? SizedBox(
                                                  height: 16,
                                                )
                                              : SizedBox(
                                                  width: 16,
                                                ),
                                          SizedBox(
                                            width: shortWidth,
                                            child: InputItem(
                                              value: _newCost != null
                                                  ? _newCost!.toString()
                                                  : '',
                                              focusNode: _newCostNode,
                                              labelText: 'New cost*',
                                              prefix: '\$ ',
                                              textInputFormatters: [
                                                FilteringTextInputFormatter
                                                    .allow(RegExp(r'\d*\.?')),
                                                LengthLimitingTextInputFormatter(
                                                    13),
                                                if (_newCostNode.hasFocus)
                                                  DecimalTextInputFormatter(),
                                              ],
                                              onChanged: (value) {
                                                _newCost = double.parse(
                                                    value.replaceAll(',', ''));
                                                setState(() {});
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    SizedBox(height: 16),
                                    SizedBox(
                                      width: shortWidth,
                                      child: InputItem(
                                        value: _currentCost != null
                                            ? _currentCost!.toString()
                                            : '',
                                        focusNode: _currentCostNode,
                                        labelText:
                                            'Current value${isProperty || widget.editInvestment != null ? '*' : ''}',
                                        prefix: '\$ ',
                                        textInputFormatters: [
                                          FilteringTextInputFormatter.allow(
                                              RegExp(r'\d*\.?')),
                                          LengthLimitingTextInputFormatter(13),
                                          if (_currentCostNode.hasFocus)
                                            DecimalTextInputFormatter(),
                                        ],
                                        onChanged: (value) {
                                          if (value == '') {
                                            _currentCost = null;
                                          } else {
                                            _currentCost =
                                                double.tryParse(value);
                                          }
                                          setState(() {});
                                        },
                                      ),
                                    ),
                                    SizedBox(height: 16),
                                    if (!isAddScreen)
                                      LabelButtonItem(
                                        label: Label(
                                          text: AppLocalizations.of(context)!
                                              .removeAsset,
                                          type: LabelType.LinkLarge,
                                          fontSize: 16,
                                        ),
                                        onPressed: isReadOnlyAdvisor
                                            ? () {}
                                            : () async {
                                                await showDialog(
                                                  context: context,
                                                  builder: (_context) {
                                                    return RemoveInvestmentPopUp(
                                                      deleteInvestment: (context,
                                                          {required model,
                                                          required bool
                                                              removeHistory,
                                                          required DateTime
                                                              sellDate}) async {
                                                        await _addInvestmentCubit
                                                            .deleteInvestment(
                                                                context,
                                                                model: model,
                                                                removeHistory:
                                                                    removeHistory,
                                                                sellDate:
                                                                    sellDate);
                                                      },
                                                      model: widget
                                                          .editInvestment!,
                                                    );
                                                  },
                                                );
                                              },
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                    ),
                  ),
                ),
          title: AppLocalizations.of(context)!.investment);
    });
  }

  bool checkEnabled() {
    if (isProperty) {
      return _usageType != null &&
          _details != null &&
          _name != null &&
          _name!.isNotEmpty &&
          _details!.isNotEmpty &&
          _acquisitionDate != null &&
          _initialCost != null &&
          _currentCost != null;
    } else if (hasBrokerage && widget.editInvestment == null) {
      return _name != null &&
          _name!.isNotEmpty &&
          _initialCost != null &&
          _acquisitionDate != null &&
          _details != null;
    } else if (hasBrokerage && showExtraFieldInEditMode) {
      return _name != null &&
          _name!.isNotEmpty &&
          _initialCost != null &&
          _acquisitionDate != null &&
          _details != null &&
          _newCost != null &&
          _costType != null &&
          _currentCost != null;
    } else if (hasBrokerage && !showExtraFieldInEditMode) {
      return _name != null &&
          _name!.isNotEmpty &&
          _initialCost != null &&
          _acquisitionDate != null &&
          _details != null &&
          _currentCost != null;
    } else if (isCrypto && widget.editInvestment == null) {
      return _name != null &&
          _name!.isNotEmpty &&
          _initialCost != null &&
          _acquisitionDate != null &&
          _details != null;
    } else if (isCrypto && !showExtraFieldInEditMode) {
      return _name != null &&
          _name!.isNotEmpty &&
          _initialCost != null &&
          _acquisitionDate != null &&
          _details != null &&
          _currentCost != null;
    } else if (isCrypto && showExtraFieldInEditMode) {
      return _name != null &&
          _name!.isNotEmpty &&
          _initialCost != null &&
          _acquisitionDate != null &&
          _details != null &&
          _newCost != null &&
          _costType != null &&
          _currentCost != null;
    } else if (isOther && widget.editInvestment == null) {
      return _name != null &&
          _name!.isNotEmpty &&
          _initialCost != null &&
          _acquisitionDate != null &&
          _details != null;
    } else if (isOther && !showExtraFieldInEditMode) {
      return _name != null &&
          _name!.isNotEmpty &&
          _initialCost != null &&
          _acquisitionDate != null &&
          _details != null &&
          _currentCost != null;
    } else if (isOther && showExtraFieldInEditMode) {
      return _name != null &&
          _name!.isNotEmpty &&
          _initialCost != null &&
          _acquisitionDate != null &&
          _details != null &&
          _newCost != null &&
          _costType != null &&
          _currentCost != null;
    } else if (isStartUp && widget.editInvestment == null) {
      return _name != null &&
          _name!.isNotEmpty &&
          _initialCost != null &&
          _acquisitionDate != null;
    } else if (isStartUp && !showExtraFieldInEditMode) {
      return _name != null &&
          _name!.isNotEmpty &&
          _initialCost != null &&
          _acquisitionDate != null &&
          _currentCost != null;
    } else if (isStartUp && showExtraFieldInEditMode) {
      return _name != null &&
          _name!.isNotEmpty &&
          _initialCost != null &&
          _acquisitionDate != null &&
          _newCost != null &&
          _costType != null &&
          _currentCost != null;
    } else {
      return true;
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
