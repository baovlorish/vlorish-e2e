import 'package:burgundy_budgeting_app/ui/atomic/atom/label.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/theme.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/button_item.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/city_field_with_suggestion.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/dropdown_item.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/editable_table_body_cell.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/input_item.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/home_screen/home_screen_cubit.dart';
import 'package:burgundy_budgeting_app/ui/model/city_model.dart';
import 'package:burgundy_budgeting_app/ui/model/tax_personal_info_model.dart';
import 'package:burgundy_budgeting_app/ui/screen/tax/tax_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PersonalInfoTab extends StatefulWidget {
  const PersonalInfoTab({
    Key? key,
    required this.personalInfoModel,
  }) : super(key: key);
  final TaxPersonalInfoModel personalInfoModel;

  @override
  State<PersonalInfoTab> createState() => _PersonalInfoTabState();
}

bool isSmall = false;

class _PersonalInfoTabState extends State<PersonalInfoTab> {
  var formKey = GlobalKey<FormState>();
  late var taxCubit = BlocProvider.of<TaxCubit>(context);
  late TaxPersonalInfoModel endPersonalInfoModel;
  late TaxPersonalInfoModel startPersonalInfoModel;


  late var isLimitedCoach = BlocProvider.of<HomeScreenCubit>(context)
      .currentForeignSession
      ?.access
      .isLimited ?? false;

  @override
  void initState() {
    endPersonalInfoModel = widget.personalInfoModel.copyWith();
    startPersonalInfoModel = widget.personalInfoModel.copyWith();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var incomesSelected = true;
    for (var item in endPersonalInfoModel.salaryPaychecks) {
      if (item.source == null) {
        incomesSelected = false;
        break;
      }
    }

    var isNotEqualModels = startPersonalInfoModel != endPersonalInfoModel;

    var canContinue = endPersonalInfoModel.stateCode != null &&
        endPersonalInfoModel.stateCode!.isNotEmpty &&
        endPersonalInfoModel.taxFilingStatus != null &&
        incomesSelected &&
        isNotEqualModels;

    isSmall = MediaQuery.of(context).size.width < 1100;

    return Column(
      children: [
        Form(
          key: formKey,
          child: Flex(
            mainAxisSize: MainAxisSize.min,
            direction: isSmall ? Axis.vertical : Axis.horizontal,
            children: [
              Flexible(
                child: ChildrenAndStateTaxBlock(
                  personalInfoModel: endPersonalInfoModel,
                  onUpdate: () {
                    setState(() {});
                  },
                ),
              ),
              Flexible(
                child: SourceOfSalaryBlock(
                  salaryPaychecks: endPersonalInfoModel.salaryPaychecks,
                  onUpdate: () {
                    setState(() {});
                  },
                ),
              ),
            ],
          ),
        ),
        Divider(
          height: 2,
          color: CustomColorScheme.generalBackground,
        ),
        SizedBox(height: 12),
        SizedBox(
          width: 200,
          child: ButtonItem(
            context,
            text: taxCubit.estimationStage == 4
                ? AppLocalizations.of(context)!.apply
                : AppLocalizations.of(context)!.continueCalculations,
            onPressed: canContinue && !isLimitedCoach
                ? () {
                    if (formKey.currentState!.validate()) {
                      BlocProvider.of<TaxCubit>(context)
                          .updatePersonalInfo(endPersonalInfoModel);
                      startPersonalInfoModel = endPersonalInfoModel.copyWith();
                    }
                    // widget.onContinueCalculation();
                  }
                : () {},
            enabled: canContinue && !isLimitedCoach,
          ),
        ),
        SizedBox(height: 12),
      ],
    );
  }
}

class ChildrenAndStateTaxBlock extends StatefulWidget {
  final TaxPersonalInfoModel personalInfoModel;
  final VoidCallback onUpdate;

  const ChildrenAndStateTaxBlock(
      {Key? key, required this.personalInfoModel, required this.onUpdate})
      : super(key: key);

  @override
  State<ChildrenAndStateTaxBlock> createState() =>
      _ChildrenAndStateTaxBlockState();
}

class _ChildrenAndStateTaxBlockState extends State<ChildrenAndStateTaxBlock> {
  @override
  Widget build(BuildContext context) {
    if(widget.personalInfoModel.taxFilingStatus==1) {
      widget.personalInfoModel.children13andYoungerCount = 0;
      widget.personalInfoModel.children17andYoungerCount = 0;
    }
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(mainAxisSize: MainAxisSize.min, children: [
            Label(
              text: AppLocalizations.of(context)!.taxFilingStatus,
              type: LabelType.General,
              fontWeight: FontWeight.bold,
            ),
            Spacer(),
            Flexible(
              child: Container(
                child: DropdownItem<int>(
                  items: [
                    AppLocalizations.of(context)!.relationshipStatusSingle,
                    AppLocalizations.of(context)!.relationshipStatusMarried,
                    AppLocalizations.of(context)!
                        .relationshipStatusHeadOfHousehold,
                  ],
                  itemKeys: [1, 2, 3],
                  hintText: 'Select',
                  initialValue: widget.personalInfoModel.taxFilingStatus,
                  callback: (value) {
                    widget.personalInfoModel.taxFilingStatus = value;
                    widget.onUpdate();
                  },
                ),
              ),
            )
          ]),
          SizedBox(height: 24),
          Row(mainAxisSize: MainAxisSize.min, children: [
            Label(
              text: AppLocalizations.of(context)!.children17AndYounger,
              type: LabelType.General,
              fontWeight: FontWeight.bold,
            ),
            Spacer(),
            Flexible(
              child: Container(
                child: DropdownItem(
                  items: [
                    '0',
                    '1',
                    '2',
                    '3',
                    '4',
                    '5',
                    '6',
                    '7',
                    '8',
                    '9',
                    '10'
                  ],
                  itemKeys: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
                  hintText: '',
                  enabled: widget.personalInfoModel.taxFilingStatus!=1,
                  initialValue:
                      widget.personalInfoModel.children17andYoungerCount,
                  validateFunction: <int>(int? value, BuildContext context) {
                    if (widget.personalInfoModel.children17andYoungerCount! <
                        widget.personalInfoModel.children13andYoungerCount!) {
                      return AppLocalizations.of(context)!
                          .taxNumberOfDependentChildrenErrorMessage;
                    } else {
                      return null;
                    }
                  },
                  callback: (value) {
                    widget.personalInfoModel.children17andYoungerCount = value;
                    widget.onUpdate();
                  },
                ),
              ),
            )
          ]),
          SizedBox(height: 24),
          Row(mainAxisSize: MainAxisSize.min, children: [
            Label(
              text: AppLocalizations.of(context)!.children13AndYounger,
              type: LabelType.General,
              fontWeight: FontWeight.bold,
            ),
            Spacer(),
            Flexible(
              child: Container(
                child: DropdownItem(
                  items: [
                    '0',
                    '1',
                    '2',
                    '3',
                    '4',
                    '5',
                    '6',
                    '7',
                    '8',
                    '9',
                    '10'
                  ],
                  enabled: widget.personalInfoModel.taxFilingStatus!=1,
                  itemKeys: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
                  hintText: AppLocalizations.of(context)!.statusName,
                  initialValue:
                      widget.personalInfoModel.children13andYoungerCount,
                  callback: (value) {
                    widget.personalInfoModel.children13andYoungerCount = value;
                    widget.onUpdate();
                  },
                ),
              ),
            )
          ]),
          SizedBox(height: 24),
          Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Label(
                  text: 'State',
                  type: LabelType.General,
                  fontWeight: FontWeight.bold,
                ),
                Spacer(),
                SizedBox(
                  width: 150,
                  child: TextFieldWithSuggestion<String>(
                    key: Key('cityModel'),
                    model: widget.personalInfoModel.stateCode,
                    unfocusWhenSuggestion: true,
                    hintText: '',
                    errorMessageEmpty: 'Please, enter a value for State',
                    errorMessageInvalid:
                        'Please, select a State from the drop-down list',
                    search: (value) => CityModel.stateCodesMap.values
                        .where(
                            (element) => element.contains(value.toUpperCase()))
                        .toList(),
                    hideOnEmpty: true,
                    maxSymbols: 15,
                    onSelectedModel: (value) {
                      widget.personalInfoModel.stateCode = value;
                      widget.onUpdate();
                    },
                  ),
                ),
              ])
        ],
      ),
    );
  }
}

class SourceOfSalaryBlock extends StatefulWidget {
  final List<TaxSalaryPaycheck> salaryPaychecks;
  final VoidCallback onUpdate;

  const SourceOfSalaryBlock(
      {Key? key, required this.salaryPaychecks, required this.onUpdate})
      : super(key: key);

  @override
  State<SourceOfSalaryBlock> createState() => _SourceOfSalaryBlockState();
}

class _SourceOfSalaryBlockState extends State<SourceOfSalaryBlock> {
  var annualSalaryFocusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          for (var item in widget.salaryPaychecks)
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(mainAxisSize: MainAxisSize.min, children: [
                  Label(
                    text:
                        AppLocalizations.of(context)!.sourceOfSalaryOrPaycheck,
                    type: LabelType.General,
                    fontWeight: FontWeight.bold,
                  ),
                  Spacer(),
                  Flexible(
                    child: Container(
                      child: DropdownItem<int>(
                        items: [
                          AppLocalizations.of(context)!.employed,
                          AppLocalizations.of(context)!.selfEmployed
                        ],
                        itemKeys: [1, 2],
                        hintText: AppLocalizations.of(context)!.sourceOfSalary,
                        initialValue: item.source,
                        callback: (value) {
                          item.source = value;
                          widget.onUpdate();
                        },
                      ),
                    ),
                  )
                ]),
                SizedBox(height: 24),
                Row(
                  children: [
                    Label(
                      text:
                          AppLocalizations.of(context)!.whatIsYourAnnualSalary,
                      type: LabelType.General,
                      fontWeight: FontWeight.bold,
                    ),
                    Spacer(),
                    Flexible(
                      flex: 3,
                      child: Container(
                        child: InputItem(
                            focusNode: annualSalaryFocusNode,
                            prefix: '\$ ',
                            value: item.annualSalary == null
                                ? '0'
                                : item.annualSalary.toString(),
                            textInputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              NumericTextFormatter(),
                              LengthLimitingTextInputFormatter(10),
                            ],
                            onChanged: (String value) {
                              var valueNew = value.replaceAll(',', '');
                              item.annualSalary =
                                  valueNew.isNotEmpty ? int.parse(valueNew) : 0;
                              widget.onUpdate();
                            },
                            onEditingComplete: () {
                              if (annualSalaryFocusNode.hasFocus) {
                                annualSalaryFocusNode.unfocus();
                              }
                            }),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 170),
              ],
            ),
        ],
      ),
    );
  }
}
