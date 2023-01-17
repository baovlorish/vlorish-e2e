import 'dart:math';

import 'package:burgundy_budgeting_app/domain/model/response/index_funds_response.dart';
import 'package:burgundy_budgeting_app/domain/model/response/retirements_models.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/back_button.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_date_formats.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_inkwell.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_loading_indicator.dart';
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
import 'package:burgundy_budgeting_app/ui/screen/investments/add_retirement/add_retirement_cubit.dart';
import 'package:burgundy_budgeting_app/ui/screen/investments/add_retirement/add_retirement_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddRetirementLayout extends StatefulWidget {
  final RetirementModel? editRetirement;

  const AddRetirementLayout({
    Key? key,
    this.editRetirement,
  }) : super(key: key);

  @override
  State<AddRetirementLayout> createState() => _AddRetirementLayoutState();
}

class _AddRetirementLayoutState extends State<AddRetirementLayout> {
  var isSmallHeader = false;
  var controller = ScrollController();

  late var isLimitedCoach = BlocProvider.of<HomeScreenCubit>(context)
          .currentForeignSession
          ?.access
          .isLimited ??
      false;

  String? _name;
  final _nameNode = FocusNode();

  double? _initialCost;
  final _costNode = FocusNode();

  DateTime? _acquisitionDate;
  final _acquisitionDateNode = FocusNode();
  int? _custodian;
  final _investTypeNode = FocusNode();
  final _custodianNode = FocusNode();
  double? _currentCost;
  final _currentCostNode = FocusNode();
  final shortWidth = 250.0;
  int? _investType;
  int? _transactionType;
  final _costTypeNode = FocusNode();
  double? _newCost;
  final _newCostNode = FocusNode();

  final _formKey = GlobalKey<FormState>();

  late final AddRetirementCubit _addRetirementCubit =
      BlocProvider.of<AddRetirementCubit>(context);

  late bool isAddScreen;

  String categoryHeader() {
    return isAddScreen ? 'Add Retirement' : 'Edit Retirement';
  }

  @override
  void initState() {
    isAddScreen = widget.editRetirement == null;
    if (!isAddScreen) {
      _name = widget.editRetirement!.name;
      _initialCost = widget.editRetirement!.initialCost;
      _currentCost = widget.editRetirement!.currentCost;
      _custodian = widget.editRetirement!.custodian;
      _acquisitionDate = widget.editRetirement!.acquisitionDate;
      _investType = widget.editRetirement!.investType;
    }
    super.initState();
  }

  var showExtraFieldInEditMode = false;

  @override
  Widget build(BuildContext context) {
    isSmallHeader = MediaQuery.of(context).size.width < 1070;

    var enabled = checkEnabled() && !isLimitedCoach;

    return BlocConsumer<AddRetirementCubit, AddRetirementState>(
        listener: (context, state) {
      if (state is AddRetirementError) {
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
                      _addRetirementCubit.navigationToInvestmentPage(context);
                    }),
                    Text(
                      categoryHeader(),
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
                                  _addRetirementCubit.addRetirement(
                                    context,
                                    name: _name!,
                                    acquisitionDate: _acquisitionDate!,
                                    initialCost: _initialCost!,
                                    currentCost: _currentCost ?? _initialCost,
                                    investType: _investType,
                                    custodian: _custodian,
                                  ),
                                }
                              : {
                                  _addRetirementCubit.updateRetirement(context,
                                      id: widget.editRetirement!.id!,
                                      name: _name!,
                                      isManual: widget.editRetirement!.isManual,
                                      acquisitionDate: _acquisitionDate!,
                                      initialCost: _initialCost!,
                                      currentCost: _currentCost!,
                                      investType: _investType,
                                      custodian: _custodian,
                                      transactions: [
                                        if (_newCost != null &&
                                            _investType != null &&
                                            showExtraFieldInEditMode)
                                          InvestmentTransaction(
                                              amount: _newCost,
                                              type: _transactionType)
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
          bodyWidget: state is AddRetirementLoading
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
                                                _investTypeNode.requestFocus(),
                                            hintText: 'Vlorish',
                                            labelText: 'Name*',
                                          ),
                                        ),
                                        SizedBox(
                                          width: isSmall ? 0 : 16,
                                          height: isSmall ? 16 : 0,
                                        ),
                                        SizedBox(
                                          width: shortWidth,
                                          child: DropdownItem<int>(
                                            initialValue: _investType,
                                            focusNode: _investTypeNode,
                                            itemKeys: [
                                              1, //Stock
                                              2, //Index Fund
                                              0 //Other
                                            ],
                                            callback: (value) {
                                              _investType = value;
                                              setState(() {});

                                              _custodianNode.requestFocus();
                                            },
                                            labelText: 'Invest type*',
                                            items: [
                                              'Stock',
                                              'Index Fund',
                                              'Other',
                                            ],
                                            hintText: 'Invest type',
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 16),
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
                                            initialValue: _custodian,
                                            focusNode: _custodianNode,
                                            itemKeys: [
                                              1, //'Guideline'
                                              2, //'Human Interest',
                                              3, //'Betterment',
                                              4, //'Wealthfront',
                                              5, //'Fidelity',
                                              6, // 'T. Rowe Price',
                                              7, //'Merril Edge',
                                              8, // 'Charles Scwab',
                                              9, // 'ADP',
                                              0, // 'Other',
                                            ],
                                            callback: (value) {
                                              _custodian = value;
                                              setState(() {});
                                              isAddScreen
                                                  ? _costNode.requestFocus()
                                                  : showExtraFieldInEditMode
                                                      ? _costTypeNode
                                                          .requestFocus()
                                                      : null;
                                            },
                                            labelText: 'Custodian*',
                                            items: [
                                              'Guideline',
                                              'Human Interest',
                                              'Betterment',
                                              'Wealthfront',
                                              'Fidelity',
                                              'T. Rowe Price',
                                              'Merril Edge',
                                              'Charles Scwab',
                                              'ADP',
                                              'Other',
                                            ],
                                            hintText:
                                                AppLocalizations.of(context)!
                                                    .select,
                                          ),
                                        ),
                                        SizedBox(
                                          width: isSmall ? 0 : 16,
                                          height: isSmall ? 16 : 0,
                                        ),
                                        SizedBox(
                                          width: shortWidth,
                                          child: InputItem(
                                            enabled: isAddScreen,
                                            value: _initialCost != null
                                                ? _initialCost!.toString()
                                                : '',
                                            focusNode: _costNode,
                                            labelText: 'Initial Value*',
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
                                        if (!isAddScreen)
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
                                                    text:
                                                        'Add changes to the Initial Value',
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
                                    if (showExtraFieldInEditMode)
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
                                              initialValue: _transactionType,
                                              focusNode: _costTypeNode,
                                              itemKeys: [
                                                1, //Sell
                                                2, //buy
                                              ],
                                              callback: (value) {
                                                _transactionType = value;
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
                                              labelText: 'New Initial value*',
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
                                    SizedBox(
                                      width: isSmall ? 0 : 16,
                                      height: isSmall ? 16 : 0,
                                    ),
                                    SizedBox(
                                      width: shortWidth,
                                      child: InputItem(
                                        value: _currentCost != null
                                            ? _currentCost!.toString()
                                            : '',
                                        focusNode: _currentCostNode,
                                        labelText:
                                            'Current value${widget.editRetirement != null ? '*' : ''}',
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
                                        onPressed: isLimitedCoach
                                            ? () {}
                                            : () async {
                                                await showDialog(
                                                  context: context,
                                                  builder: (_context) {
                                                    return RemoveRetirementPopUp(
                                                      deleteRetirement: (context,
                                                          {required RetirementModel
                                                              model,
                                                          required bool
                                                              removeHistory,
                                                          required DateTime
                                                              sellDate}) async {
                                                        await _addRetirementCubit
                                                            .deleteRetirement(
                                                                context,
                                                                model: model,
                                                                removeHistory:
                                                                    removeHistory,
                                                                sellDate:
                                                                    sellDate);
                                                      },
                                                      model: widget
                                                          .editRetirement!,
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
    if (isAddScreen) {
      return _name != null &&
          _name!.isNotEmpty &&
          _initialCost != null &&
          _acquisitionDate != null &&
          _custodian != null &&
          _investType != null;
    }
    if (showExtraFieldInEditMode) {
      return _name != null &&
          _name!.isNotEmpty &&
          _initialCost != null &&
          _acquisitionDate != null &&
          _custodian != null &&
          _newCost != null &&
          _investType != null &&
          _investType != null &&
          _currentCost != null;
    } else {
      return _name != null &&
          _name!.isNotEmpty &&
          _initialCost != null &&
          _acquisitionDate != null &&
          _custodian != null &&
          _investType != null &&
          _currentCost != null;
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
