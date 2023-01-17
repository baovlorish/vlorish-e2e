import 'package:burgundy_budgeting_app/domain/model/response/retirements_models.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_date_formats.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/label.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/dropdown_item.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/error_alert_dialog.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/two_buttons_alert_dialog.dart';
import 'package:burgundy_budgeting_app/ui/atomic/organizm/date_picker.dart';
import 'package:burgundy_budgeting_app/utils/form_validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RemoveInvestmentPopUp extends StatefulWidget {
  const RemoveInvestmentPopUp(
      {Key? key, required this.model, required this.deleteInvestment})
      : super(key: key);
  final model;
  final void Function(
    BuildContext context, {
    required DateTime sellDate,
    required Object model,
    required bool removeHistory,
  }) deleteInvestment;

  @override
  State<RemoveInvestmentPopUp> createState() => _RemoveInvestmentPopUpState();
}

class _RemoveInvestmentPopUpState extends State<RemoveInvestmentPopUp> {
  int dropDownValue = 0;
  DateTime? sellDate;
  bool removeHistory = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TwoButtonsDialog(
        context,
        height: 340,
        dismissButtonText: AppLocalizations.of(context)!.cancel,
        enableMainButton:
            (dropDownValue == 0 && sellDate != null) || dropDownValue == 1,
        onMainButtonPressed: () {
          if (_formKey.currentState!.validate()) {
            if (dropDownValue == 0 &&
                sellDate != null &&
                sellDate!.isBefore(widget.model.acquisitionDate!)) {
              showDialog(
                context: context,
                builder: (context) {
                  return ErrorAlertDialog(context,
                      message:
                          'Date of selling could\'t be less than Acquisition date. Acquisition date for ${widget.model.name} is ${widget.model.acquisitionDate!.month}/${widget.model.acquisitionDate!.year}');
                },
              );
            } else if (dropDownValue == 0) {
              widget.deleteInvestment(
                context,
                sellDate: sellDate!,
                model: widget.model,
                removeHistory: false,
              );
            } else if (dropDownValue == 1) {
              widget.deleteInvestment(
                context,
                model: widget.model,
                sellDate: DateTime(
                  widget.model.acquisitionDate!.year,
                  widget.model.acquisitionDate!.month +
                      1, //TODO: need fix later
                ),
                removeHistory: true,
              );
            }
          }
        },
        mainButtonText: AppLocalizations.of(context)!.remove,
        title: 'Are you sure to remove ${widget.model.name}?',
        bodyWidget: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 24),
              SizedBox(
                width: 400,
                child: DropdownItem(
                  initialValue: dropDownValue,
                  itemKeys: [
                    0, //keepTheRecordsOfInvestments
                    1, //deleteInvestmentHistory
                  ],
                  items: [
                    AppLocalizations.of(context)!.keepTheRecordsOfInvestments,
                    AppLocalizations.of(context)!.deleteInvestmentHistory,
                  ],
                  hintText: '',
                  callback: (value) {
                    dropDownValue = value;
                    setState(() {});
                  },
                ),
              ),
              if (dropDownValue == 0)
                Column(
                  children: [
                    SizedBox(height: 24),
                    SizedBox(
                      width: 400,
                      child: Label(
                        text: 'Please, provide the day it was sold:',
                        type: LabelType.General,
                      ),
                    ),
                    SizedBox(height: 24),
                    SizedBox(
                      width: 400,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: DatePicker(
                          title: AppLocalizations.of(context)!.dateOfSelling,
                          context,
                          value: sellDate?.toIso8601String(),
                          dateFormat: CustomDateFormats.monthAndYearDateFormat,
                          onChanged: (String value) {
                            sellDate = DateTime.parse(value);
                            setState(() {});
                          },
                          firstDate: widget.model.acquisitionDate!,
                          hint: 'MM/YYYY',
                          validateFunction:
                              FormValidators.investmentDateValidation,
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class RemoveRetirementPopUp extends StatefulWidget {
  const RemoveRetirementPopUp(
      {Key? key, required this.model, required this.deleteRetirement})
      : super(key: key);
  final RetirementModel model;
  final void Function(
    BuildContext context, {
    required DateTime sellDate,
    required RetirementModel model,
    required bool removeHistory,
  }) deleteRetirement;

  @override
  State<RemoveRetirementPopUp> createState() => _RemoveRetirementPopUpState();
}

class _RemoveRetirementPopUpState extends State<RemoveRetirementPopUp> {
  int dropDownValue = 0;
  DateTime? sellDate;
  bool removeHistory = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TwoButtonsDialog(
        context,
        height: 340,
        dismissButtonText: AppLocalizations.of(context)!.cancel,
        enableMainButton:
            (dropDownValue == 0 && sellDate != null) || dropDownValue == 1,
        onMainButtonPressed: () {
          if (_formKey.currentState!.validate()) {
            if (dropDownValue == 0 &&
                sellDate != null &&
                sellDate!.isBefore(widget.model.acquisitionDate!)) {
              showDialog(
                context: context,
                builder: (context) {
                  return ErrorAlertDialog(context,
                      message:
                          'Date of selling could\'t be less than Acquisition date. Acquisition date for ${widget.model.name} is ${widget.model.acquisitionDate!.month}/${widget.model.acquisitionDate!.year}');
                },
              );
            } else if (dropDownValue == 0) {
              widget.deleteRetirement(
                context,
                sellDate: sellDate!,
                model: widget.model,
                removeHistory: false,
              );
            } else if (dropDownValue == 1) {
              widget.deleteRetirement(
                context,
                model: widget.model,
                sellDate: DateTime(
                  widget.model.acquisitionDate!.year,
                  widget.model.acquisitionDate!.month +
                      1, //TODO: need fix later
                ),
                removeHistory: true,
              );
            }
          }
        },
        mainButtonText: AppLocalizations.of(context)!.remove,
        title: 'Are you sure to remove ${widget.model.name}?',
        bodyWidget: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 24),
              SizedBox(
                width: 400,
                child: DropdownItem(
                  initialValue: dropDownValue,
                  itemKeys: [
                    0, //keepTheRecordsOfInvestments
                    1, //deleteInvestmentHistory
                  ],
                  items: [
                    AppLocalizations.of(context)!.keepTheRecordsOfInvestments,
                    AppLocalizations.of(context)!.deleteInvestmentHistory,
                  ],
                  hintText: '',
                  callback: (value) {
                    dropDownValue = value;
                    setState(() {});
                  },
                ),
              ),
              if (dropDownValue == 0)
                Column(
                  children: [
                    SizedBox(height: 24),
                    SizedBox(
                      width: 400,
                      child: Label(
                        text: 'Please, provide the day it was sold:',
                        type: LabelType.General,
                      ),
                    ),
                    SizedBox(height: 24),
                    SizedBox(
                      width: 400,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: DatePicker(
                          title: AppLocalizations.of(context)!.dateOfSelling,
                          context,
                          value: sellDate?.toIso8601String(),
                          dateFormat: CustomDateFormats.monthAndYearDateFormat,
                          onChanged: (String value) {
                            sellDate = DateTime.parse(value);
                            setState(() {});
                          },
                          firstDate: widget.model.acquisitionDate!,
                          hint: 'MM/YYYY',
                          validateFunction:
                              FormValidators.investmentDateValidation,
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
