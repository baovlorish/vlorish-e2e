import 'dart:convert';

import 'package:burgundy_budgeting_app/ui/atomic/atom/back_button.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_date_formats.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_loading_indicator.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/label.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/text_styles.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/theme.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/button_item.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/button_item_transparent.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/editable_table_body_cell.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/error_alert_dialog.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/input_item.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/two_buttons_alert_dialog.dart';
import 'package:burgundy_budgeting_app/ui/atomic/organizm/date_picker.dart';
import 'package:burgundy_budgeting_app/ui/atomic/organizm/pick_avatar_widget.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/home_screen/home_screen.dart';
import 'package:burgundy_budgeting_app/ui/model/goal.dart';
import 'package:burgundy_budgeting_app/ui/screen/goals/add_goal/add_goal_cubit.dart';
import 'package:burgundy_budgeting_app/ui/screen/goals/add_goal/add_goal_state.dart';
import 'package:burgundy_budgeting_app/utils/extensions.dart';
import 'package:burgundy_budgeting_app/utils/form_validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddGoalLayout extends StatefulWidget {
  final Goal? editedGoal;

  const AddGoalLayout({Key? key, this.editedGoal}) : super(key: key);

  @override
  _AddGoalLayoutState createState() => _AddGoalLayoutState();
}

class _AddGoalLayoutState extends State<AddGoalLayout> {
  var isSmall = false;

  final _defaultGoalImage = 'assets/images/goal_ph.png';
  final longWidth = 514.0;
  final shortWidth = 250.0;
  final _formKey = GlobalKey<FormState>();

  var _name = '';
  var _note = '';

  var _total = 0;
  var _funded = 0;

  final _nameNode = FocusNode();
  final _noteNode = FocusNode();

  final _totalNode = FocusNode();
  final _fundedNode = FocusNode();

  late final _now;
  var _startDate = DateTime.utc(1970);
  var _targetDate = DateTime.now();

  String? _icon;

  final startDateNode = FocusNode();
  final endDateNode = FocusNode();

  final _saveButtonNode = FocusNode();
  late final AddGoalCubit _addGoalCubit;
  @override
  void initState() {
    _now = DateTime.now();
    _targetDate = DateTime(_now.year, _now.month, _now.day + 1);
    _addGoalCubit = BlocProvider.of<AddGoalCubit>(context);

    if (widget.editedGoal != null) {
      _name = widget.editedGoal!.goalName;
      _note = widget.editedGoal!.note ?? '';
      _total = widget.editedGoal!.target;
      _funded = widget.editedGoal!.funded;
      _startDate = widget.editedGoal!.startDate;
      _targetDate = widget.editedGoal!.endDate;
      _icon = widget.editedGoal!.iconUrl;
    }

    super.initState();
  }

  @override
  void dispose() {
    _nameNode.dispose();
    _noteNode.dispose();
    _totalNode.dispose();
    _fundedNode.dispose();
    startDateNode.dispose();
    endDateNode.dispose();
    super.dispose();
  }

  Widget _inputFields(
    BuildContext context, {
    CrossAxisAlignment columnCrossAxisAlignment = CrossAxisAlignment.start,
  }) =>
      Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: columnCrossAxisAlignment,
          children: [
            SizedBox(
              width: longWidth,
              child: InputItem(
                value: _name,
                autofocus: true,
                focusNode: _nameNode,
                onEditingComplete: () => _totalNode.requestFocus(),
                labelText: AppLocalizations.of(context)!.goalName,
                hintText: AppLocalizations.of(context)!.enterNameForYourGoal,
                validateFunction: FormValidators.goalNameValidateFunction,
                textInputFormatters: [LengthLimitingTextInputFormatter(20)],
                onChanged: (value) {
                  _name = value;
                },
              ),
            ),
            SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: shortWidth,
                  child: InputItem(
                    value: _total.numericFormattedString(),
                    focusNode: _totalNode,
                    onEditingComplete: () => _fundedNode.requestFocus(),
                    labelText: AppLocalizations.of(context)!.totalAmount,
                    validateFunction: (value, context) {
                      var error = FormValidators.totalAmountValidateFunction(
                          value, context);
                      if (error != null) {
                        return error;
                      } else if (_total < _funded) {
                        return AppLocalizations.of(context)!
                            .totalShouldBeGreater;
                      }
                    },
                    onChanged: (value) {
                      _total = int.parse(value.replaceAll(',', ''));
                    },
                    prefix: '\$ ',
                    textInputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      NumericTextFormatter(),
                      LengthLimitingTextInputFormatter(17),
                    ],
                  ),
                ),
                SizedBox(width: 16),
                SizedBox(
                  width: shortWidth,
                  child: InputItem(
                    value: _funded.numericFormattedString(),
                    focusNode: _fundedNode,
                    onEditingComplete: () => startDateNode.requestFocus(),
                    labelText: AppLocalizations.of(context)!.fundedAmount,
                    validateFunction: (value, context) => null,
                    prefix: '\$ ',
                    onChanged: (value) {
                      _funded = int.parse(value.replaceAll(',', ''));
                    },
                    textInputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      NumericTextFormatter(),
                      LengthLimitingTextInputFormatter(17),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: shortWidth,
                  child: DatePicker(
                    context,
                    focusNode: startDateNode,
                    value: widget.editedGoal != null
                        ? _startDate.toString()
                        : null,
                    onChanged: (value) {
                      _startDate = DateTime.tryParse(value)!;
                      endDateNode.requestFocus();
                    },
                    title: AppLocalizations.of(context)!.startDate,
                    dateFormat: CustomDateFormats.defaultDateFormat,
                    validateFunction: (value, context) {},
                  ),
                ),
                SizedBox(width: 17),
                SizedBox(
                  width: shortWidth,
                  child: DatePicker(
                    context,
                    focusNode: endDateNode,
                    value: widget.editedGoal != null
                        ? _targetDate.toString()
                        : null,
                    onChanged: (value) {
                      _targetDate = DateTime.tryParse(value)!;
                      _noteNode.requestFocus();
                    },
                    initialDate: (_startDate.isAfter(_now))
                        ? _startDate
                        : DateTime(_now.year, _now.month, _now.day + 1),
                    firstDate: (_startDate.isAfter(_now))
                        ? _startDate
                        : DateTime(_now.year, _now.month, _now.day + 1),
                    lastDate: DateTime(2100),
                    title: AppLocalizations.of(context)!.targetDate,
                    dateFormat: CustomDateFormats.defaultDateFormat,
                    validateFunction: (value, context) {
                      var error = FormValidators.targetDateValidateFunction(
                          value, context);
                      if (error != null) {
                        return error;
                      } else if (_startDate.isAfter(_targetDate)) {
                        return AppLocalizations.of(context)!
                            .targetShouldBeGreater;
                      }
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            SizedBox(
              width: longWidth,
              child: InputItem(
                value: _note,
                focusNode: _noteNode,
                onEditingComplete: () => _saveButtonNode.requestFocus(),
                labelText: AppLocalizations.of(context)!.note,
                hintText: AppLocalizations.of(context)!.addNote,
                validateFunction: (value, context) => null,
                maxLines: 5,
                textInputFormatters: [LengthLimitingTextInputFormatter(100)],
                onChanged: (value) {
                  _note = value;
                },
              ),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    isSmall = MediaQuery.of(context).size.width < 1070;

    return BlocConsumer<AddGoalCubit, AddGoalState>(
      listener: (BuildContext context, state) {
        if (state is AddGoalError) {
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
      },
      builder: (context, state) {
        return HomeScreen(
          currentTab: Tabs.Goals,
          title: AppLocalizations.of(context)!.goals,
          headerWidget: widget.editedGoal != null
              ? _buildEditHeaderPage(context)
              : _buildHeaderPage(context),
          bodyWidget: (state is AddGoalLoading)
              ? CustomLoadingIndicator()
              : Expanded(
                  child: Container(
                    color:
                        CustomColorScheme.homeBodyWidgetBackground,
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
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Label(
                                text: AppLocalizations.of(context)!.goalInfo,
                                type: LabelType.Header3,
                              ),
                              isSmall
                                  ? Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        PickAvatarWidget(
                                          image: _icon,
                                          assetImage: _defaultGoalImage,
                                          onImageSet: (pickedFile) async {
                                            _icon = base64Encode(
                                                await pickedFile.readAsBytes());
                                          },
                                          onImageValidationError: () {
                                            _addGoalCubit.emit(
                                              AddGoalError(
                                                  AppLocalizations.of(context)!
                                                      .invalidImageError),
                                            );
                                            _addGoalCubit.emit(
                                              AddGoalInitial(),
                                            );
                                          },
                                        ),
                                        _inputFields(
                                          context,
                                          columnCrossAxisAlignment:
                                              CrossAxisAlignment.center,
                                        ),
                                      ],
                                    )
                                  : Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        PickAvatarWidget(
                                            image: _icon,
                                            assetImage: _defaultGoalImage,
                                            onImageSet: (pickedFile) async {
                                              _icon = base64Encode(
                                                  await pickedFile
                                                      .readAsBytes());
                                            },
                                            onImageValidationError: () {
                                              _addGoalCubit.emit(
                                                AddGoalError(
                                                    AppLocalizations.of(
                                                            context)!
                                                        .invalidImageError),
                                              );
                                              _addGoalCubit.emit(
                                                AddGoalInitial(),
                                              );
                                            }),
                                        _inputFields(context),
                                      ],
                                    )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
        );
      },
    );
  }

  Widget _buildHeaderPage(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            CustomBackButton(
              onPressed: () {
                _addGoalCubit.navigateToGoalsPage(context);
              },
            ),
            Text(
              AppLocalizations.of(context)!.addGoal,
              style: CustomTextStyle.HeaderBoldTextStyle(context).copyWith(
                fontSize: 36.0,
              ),
            ),
          ],
        ),
        ButtonItem(
          context,
          text: AppLocalizations.of(context)!.save,
          focusNode: _saveButtonNode,
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _addGoalCubit.addGoal(
                context,
                name: _name,
                targetAmount: _total,
                fundedAmount: _funded,
                startDate: _startDate.toIso8601String(),
                targetDate: _targetDate.toIso8601String(),
                icon: _icon,
                note: _note.isNotEmpty ? _note : null,
              );
            }
          },
        )
      ],
    );
  }

  Widget _buildEditHeaderPage(BuildContext context) {
    return SingleChildScrollView(
      child: Flex(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment:
            isSmall ? MainAxisAlignment.start : MainAxisAlignment.spaceBetween,
        direction: isSmall ? Axis.vertical : Axis.horizontal,
        children: [
          Row(
            children: [
              CustomBackButton(
                onPressed: () {
                  _addGoalCubit.navigateToGoalsPage(context);
                },
              ),
              Text(
                AppLocalizations.of(context)!.editGoal,
                style: CustomTextStyle.HeaderBoldTextStyle(context).copyWith(
                  fontSize: 36.0,
                ),
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ButtonItem(
                context,
                text: AppLocalizations.of(context)!.save,
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _addGoalCubit.updateGoal(
                      context,
                      id: widget.editedGoal!.id,
                      name: _name,
                      targetAmount: _total,
                      fundedAmount: _funded,
                      startDate: _startDate.toIso8601String(),
                      targetDate: _targetDate.toIso8601String(),
                      icon: _icon != widget.editedGoal!.iconUrl ? _icon : null,
                      note: _note.isNotEmpty ? _note : null,
                    );
                  }
                },
              ),
              SizedBox(width: 20),
              ButtonItemTransparent(
                context,
                icon: ImageIcon(
                  AssetImage('assets/images/icons/archive_ic.png'),
                  color: CustomColorScheme.button,
                  size: 24,
                ),
                text: AppLocalizations.of(context)!.archiveGoal,
                onPressed: () {
                  _addGoalCubit.archiveGoal(
                    context,
                    widget.editedGoal!.id,
                  );
                },
                buttonType: TransparentButtonType.LargeText,
              ),
              SizedBox(width: 20),
              ButtonItemTransparent(
                context,
                color: CustomColorScheme.inputErrorBorder,
                icon: ImageIcon(
                  AssetImage('assets/images/icons/delete.png'),
                  color: CustomColorScheme.inputErrorBorder,
                  size: 24,
                ),
                text: AppLocalizations.of(context)!.deleteGoal,
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_context) {
                      return TwoButtonsDialog(
                        context,
                        title: AppLocalizations.of(context)!
                                .areYouSureToDeleteYour +
                            ' ${widget.editedGoal!.goalName} ' +
                            AppLocalizations.of(context)!.goal.toLowerCase() +
                            '?',
                        message:
                            AppLocalizations.of(context)!.yourDataWillBeDeleted,
                        dismissButtonText:
                            AppLocalizations.of(context)!.yesDeleteIt,
                        onDismissButtonPressed: () {
                          _addGoalCubit.deleteGoal(
                              context, widget.editedGoal!.id);
                        },
                        mainButtonText: AppLocalizations.of(context)!.no,
                        onMainButtonPressed: () {},
                      );
                    },
                  );
                },
                buttonType: TransparentButtonType.LargeText,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
