import 'package:burgundy_budgeting_app/ui/atomic/atom/hint_widget.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/input_decoration_mixin.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/label.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/text_styles.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/version_two_color_scheme.dart';
import 'package:burgundy_budgeting_app/utils/extensions.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class DropdownItem<T> extends StatefulWidget {
  final String? labelText;
  final String? errorText;
  final String hintText;
  final List<String> items;
  final List<T>? itemKeys;
  final String? Function<T>(T?, BuildContext)? validateFunction;
  final Function callback;
  final T? initialValue;
  final bool enabled;

  // todo: (andreyK) remove unneeded params
  final bool isSmall;
  final FocusNode? focusNode;
  final bool autofocus;
  final String? tooltipText;

  @override
  final Key? key;

  const DropdownItem({
    this.labelText,
    required this.items,
    required this.hintText,
    required this.callback,
    this.validateFunction,
    this.initialValue,
    this.enabled = true,
    this.itemKeys,
    this.key,
    this.isSmall = false,
    this.focusNode,
    this.autofocus = false,
    this.errorText,
    this.tooltipText,
  });

  @override
  State<StatefulWidget> createState() => _DropdownItemState();
}

class _DropdownItemState<T> extends State<DropdownItem<T>> with InputDecorationMixin {
  bool get showLabel => !widget.isSmall && widget.labelText != null;

  bool get showTooltip => widget.tooltipText != null;

  static const dropdownMenuOffset = Offset(-20, -16);

  late final items = getItems(widget.items);

  late var selectedValue = widget.initialValue;

  void onChanged(T? value) {
    if (value == null) return;
    setState(() {
      selectedValue = value;
      isValid = true;
      widget.callback(value);
    });
  }

  @override
  Widget build(BuildContext context) => MouseRegion(
    onEnter: (_) => setState(() => isHovered = true),
    onExit: (_) => setState(() => isHovered = false),
    child: Column(
          key: widget.key,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showLabel)
              Row(
                children: [
                  Label(text: widget.labelText!, type: LabelType.GeneralNew),
                  SizedBox(width: 8),
                  if (showTooltip) HintWidget(hint: widget.tooltipText!)
                ],
              ),
            if (!widget.isSmall && widget.labelText != null) SizedBox(height: 10),
            DropdownButtonFormField2<T>(
              alignment: AlignmentDirectional.centerStart,
              autofocus: widget.autofocus,
              focusNode: widget.focusNode,
              value: widget.initialValue,
              menuItemStyleData: MenuItemStyleData(
                padding: InputDecorationMixin.contentPadding,
                overlayColor: MaterialStateProperty.resolveWith(
                  (states) {
                    if (states.hasHovered) return VersionTwoColorScheme.PinkBackground;
                    return VersionTwoColorScheme.White;
                  },
                ),
              ),
              dropdownStyleData: DropdownStyleData(
                scrollPadding: EdgeInsets.zero,
                padding: EdgeInsets.zero,
                offset: dropdownMenuOffset,
                decoration: BoxDecoration(
                  color: VersionTwoColorScheme.White,
                  borderRadius: borderRadius,
                ),
              ),
              iconStyleData: IconStyleData(icon: Icon(Icons.keyboard_arrow_down), iconSize: 28),
              items: items,
              style: CustomTextStyle.DropDownTextStyle(context),
              isExpanded: true,
              selectedItemBuilder: (_) =>
                  widget.items.map<Widget>((text) => Text(text, overflow: TextOverflow.ellipsis)).toList(),
              validator: (T? value) => widget.validateFunction?.call(value, context),
              onChanged: onChanged,
              decoration: InputDecoration(
                errorText: widget.errorText,
                contentPadding: InputDecorationMixin.contentPadding,
                fillColor: fillColor,
                filled: true,
                focusColor: focusColor,
                border: border,
                enabledBorder: enabledBorder,
                focusedBorder: focusedBorder,
                errorBorder: errorBorder,
                focusedErrorBorder: focusedErrorBorder,
                errorMaxLines: 3,
                errorStyle: errorStyle(context),
                hintText: widget.hintText,
                hintStyle: hintStyle(context),
              ),
            ),
          ],
        ),
  );

  List<DropdownMenuItem<T>> getItems(List<String> values) {
    var keys = widget.itemKeys ?? List.generate(values.length, (index) => index as T);
    return List.generate(
      keys.length,
      (index) => DropdownMenuItem(
        value: keys[index],
        child: Text(
          values[index],
          overflow: TextOverflow.visible,
          style: CustomTextStyle.DropDownTextStyle(context),
        ),
      ),
    );
  }
}
