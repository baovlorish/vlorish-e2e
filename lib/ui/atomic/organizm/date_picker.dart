import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_date_formats.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/label.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/text_styles.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class DatePicker extends StatefulWidget {
  final BuildContext context;
  final Function(String) onChanged;
  final String? title;
  final String hint;
  final DateFormat dateFormat;
  final String? Function(String?, BuildContext context)? validateFunction;
  late final DateTime initialDate;
  late final DateTime firstDate;
  late final DateTime lastDate;
  final String? value;
  final FocusNode? focusNode;

  final bool isSmall;
  final bool enabled;

  // todo fix initialDate vs value issue

  DatePicker(
    this.context, {
    Key? key,
    required this.onChanged,
    required this.dateFormat,
    this.title,
    this.validateFunction,
    this.focusNode,
    this.hint = 'MM/DD/YY',
    this.value,
    this.isSmall = false,
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
    this.enabled = true,
  }) : super(key: key ?? UniqueKey()) {
    this.firstDate =
        dateFormat.pattern == CustomDateFormats.monthAndYearDateFormat.pattern
            ? DateTime(1930)
            : firstDate ?? DateTime.fromMillisecondsSinceEpoch(1);
    this.lastDate =
        dateFormat.pattern == CustomDateFormats.monthAndYearDateFormat.pattern
            ? DateTime.now()
            : lastDate ?? DateTime(2100);
    this.initialDate = initialDate ??
        (this.lastDate.isBefore(DateTime.now())
            ? this.lastDate
            : DateTime.now());
  }

  @override
  _DatePickerState createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  late final controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.value != null && widget.value!.isNotEmpty) {
      controller.text = widget.dateFormat.format(DateTime.parse(widget.value!));
    }
  }

  void pickDate() async {
    var _datePickerController = DateRangePickerController();
    _datePickerController.view = DateRangePickerView.decade;

    var picked;
    widget.dateFormat.pattern ==
            CustomDateFormats.monthAndYearDateFormat.pattern
        ? await showDialog(
            builder: (BuildContext context) {
              return Center(
                child: Container(
                  color: Colors.white,
                  height: 340,
                  width: 300,
                  child: StatefulBuilder(
                    builder: (context, setState) => SfDateRangePicker(
                      yearCellStyle: DateRangePickerYearCellStyle(
                        leadingDatesTextStyle: const TextStyle(
                            color: Colors.black, fontSize: 12.0),
                      ),
                      headerHeight: 50,
                      navigationDirection:
                          DateRangePickerNavigationDirection.vertical,
                      navigationMode: DateRangePickerNavigationMode.none,
                      showNavigationArrow: true,
                      allowViewNavigation: _datePickerController.view !=
                          DateRangePickerView.year,
                      view: DateRangePickerView.decade,
                      showActionButtons: true,
                      initialDisplayDate: widget.initialDate,
                      minDate: widget.firstDate,
                      maxDate: widget.lastDate,
                      controller: _datePickerController,
                      onCancel: () {
                        if (_datePickerController.view ==
                            DateRangePickerView.year) {
                          setState(() {
                            _datePickerController.view =
                                DateRangePickerView.decade;
                          });
                        } else {
                          Navigator.pop(context);
                        }
                      },
                      onSubmit: (Object? value) {
                        picked = value;
                        Navigator.pop(context);
                      },
                      onViewChanged: (args) {
                        if (args.view != DateRangePickerView.decade) {
                          setState(() {});
                        }
                      },
                    ),
                  ),
                ),
              );
            },
            context: widget.context)
        : picked = await showDatePicker(
            context: context,
            initialDate: widget.initialDate,
            firstDate: widget.firstDate,
            lastDate: widget.lastDate,
          );
    if (picked != null) {
      controller.text = widget.dateFormat.format(picked);
      widget.onChanged(picked.toIso8601String());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!widget.isSmall && widget.title != null)
          Label(
            text: widget.title!,
            type: LabelType.General,
          ),
        if (!widget.isSmall) SizedBox(height: 10),
        SizedBox(
          height: widget.isSmall ? 40 : null,
          child: TextFormField(
            onFieldSubmitted: (value) => pickDate(),
            onTap: pickDate,
            onChanged: (value) {
              setState(() {
                widget.onChanged(value);
              });
            },
            controller: controller,
            readOnly: true,
            enabled: widget.enabled,
            validator: (value) {
              if (widget.validateFunction != null) {
                return widget.validateFunction!(value, context);
              }
            },
            decoration: InputDecoration(
              contentPadding: widget.isSmall
                  ? const EdgeInsets.all(12.0)
                  : const EdgeInsets.all(16.0),
              hintText: widget.hint,
              suffixIcon: ExcludeFocus(
                child: IconButton(
                  onPressed: null,
                  iconSize: widget.isSmall ? 20 : 24,
                  icon: ImageIcon(
                    AssetImage('assets/images/icons/calendar.png'),
                    color: widget.enabled
                        ? CustomColorScheme.button
                        : CustomColorScheme.inputBorder,
                    size: widget.isSmall ? 20 : 24,
                  ),
                ),
              ),
              fillColor: CustomColorScheme.inputFill,
              filled: true,
              errorMaxLines: 3,
              hintStyle: CustomTextStyle.HintTextStyle(context),
              errorStyle: CustomTextStyle.ErrorTextStyle(context),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 2.0,
                  color: CustomColorScheme.button,
                ),
              ),
              disabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: CustomColorScheme.inputBorder,
                ),
                borderRadius: BorderRadius.circular(5.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: CustomColorScheme.inputBorder,
                ),
                borderRadius: BorderRadius.circular(5.0),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: CustomColorScheme.inputErrorBorder,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    width: 2.0, color: CustomColorScheme.inputErrorBorder),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
