import 'package:burgundy_budgeting_app/ui/atomic/atom/label.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/text_styles.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/theme.dart';
import 'package:flutter/material.dart';

class DropdownItem<ValueType> extends StatefulWidget {
  final String? labelText;
  final String? errorText;
  final String hintText;
  final List<String> items;
  final List<ValueType>? itemKeys;
  final String? Function<ValueType>(ValueType?, BuildContext)? validateFunction;
  final Function callback;
  final ValueType? initialValue;
  final bool enabled;
  final bool isSmall;
  final FocusNode? focusNode;
  final bool autofocus;

  @override
  final Key? key;

  DropdownItem({
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
  });

  @override
  State<StatefulWidget> createState() => _DropdownItemState();
}

class _DropdownItemState<ValueType> extends State<DropdownItem<ValueType>> {
  @override
  Widget build(BuildContext context) {
    var items = getItems(widget.items);

    return Column(
      key: widget.key,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!widget.isSmall && widget.labelText != null)
          Label(text: widget.labelText!, type: LabelType.General),
        if (!widget.isSmall && widget.labelText != null) SizedBox(height: 10),
        DropdownButtonFormField(
          autofocus: widget.autofocus,
          focusNode: widget.focusNode,
          value: widget.initialValue,
          dropdownColor: CustomColorScheme.inputFill,
          focusColor: Colors.transparent,
          icon: ImageIcon(
            AssetImage('assets/images/icons/dropdown.png'),
            size: 24,
            color: widget.enabled
                ? CustomColorScheme.mainDarkBackground
                : CustomColorScheme.dividerColor,
          ),
          items: items,
          style: CustomTextStyle.DropDownTextStyle(context),
          isExpanded: true,
          selectedItemBuilder: (BuildContext context) {
            return widget.items.map<Widget>(
              (String text) {
                return Text(text, overflow: TextOverflow.ellipsis);
              },
            ).toList();
          },
          validator: (ValueType? value) {
            if (widget.validateFunction != null) {
              return widget.validateFunction!(value, context);
            }
          },
          onChanged: widget.enabled
              ? (ValueType? value) {
                  setState(
                    () {
                      if (value != null) {
                        widget.callback(value);
                      }
                    },
                  );
                }
              : null,
          decoration: InputDecoration(
            errorText: widget.errorText,
            isDense: widget.isSmall,
            contentPadding: widget.isSmall
                ? const EdgeInsets.all(12.0)
                : const EdgeInsets.all(16.0),
            fillColor: CustomColorScheme.inputFill,
            filled: true,
            focusColor: Colors.transparent,
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
              width: 2.0,
              color: CustomColorScheme.button,
            )),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  width: 2.0,
                  color: CustomColorScheme.inputErrorBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: CustomColorScheme.inputBorder),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: CustomColorScheme.inputErrorBorder),
            ),
            border: OutlineInputBorder(
              borderSide:
                  BorderSide(color: CustomColorScheme.inputBorder),
            ),
            errorMaxLines: 3,
            errorStyle: CustomTextStyle.ErrorTextStyle(context),
            hintText: widget.hintText,
            hintStyle: CustomTextStyle.HintTextStyle(context),
          ),
        ),
      ],
    );
  }

  List<DropdownMenuItem<ValueType>> getItems(List<String> values) {
    var keys = widget.itemKeys ??
        List.generate(values.length, (index) => index as ValueType);
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
