import 'package:burgundy_budgeting_app/ui/atomic/atom/version_two_color_scheme.dart';
import 'package:burgundy_budgeting_app/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'label.dart';

class CustomTextSwitch extends StatefulWidget {
  final String firstOptionName;
  final String secondOptionName;
  final VoidCallback onSelected;
  final bool initialSelection;
  final bool enabled;
  final FocusNode? firstOptionFocusNode;
  final FocusNode? secondOptionFocusNode;

  const CustomTextSwitch({
    Key? key,
    required this.firstOptionName,
    required this.secondOptionName,
    required this.onSelected,
    this.initialSelection = false,
    this.enabled = true,
    this.firstOptionFocusNode,
    this.secondOptionFocusNode,
  }) : super(key: key);

  @override
  _CustomTextSwitchState createState() => _CustomTextSwitchState();
}

class _CustomTextSwitchState extends State<CustomTextSwitch> {
  late bool selection = widget.initialSelection;

  bool get canCallbackFirstElement => selection && widget.enabled;
  bool get canCallbackSecondElement => !selection && widget.enabled;

  void changeValue() => setState(() {
        widget.onSelected();
        selection = !selection;
      });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: VersionTwoColorScheme.White),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _SwitchElement(
            isSelected: selection,
            onTapCallback: canCallbackFirstElement ? () => changeValue() : null,
            text: widget.firstOptionName,
            enabled: widget.enabled,
            focusNode: widget.firstOptionFocusNode,
          ),
          _SwitchElement(
            isSelected: !selection,
            onTapCallback: canCallbackSecondElement ? () => changeValue() : null,
            text: widget.secondOptionName,
            enabled: widget.enabled,
            focusNode: widget.secondOptionFocusNode,
          )
        ],
      ),
    );
  }
}

class _SwitchElement extends StatelessWidget {
  final FocusNode? focusNode;
  final bool isSelected;
  final void Function()? onTapCallback;
  final String text;
  final bool enabled;

  const _SwitchElement({
    Key? key,
    required this.isSelected,
    required this.onTapCallback,
    required this.text,
    required this.enabled,
    this.focusNode,
  }) : super(key: key);

  static const labelPadding = EdgeInsets.symmetric(vertical: 8.0, horizontal: 15.0);

  Color get selectColor => isSelected ? VersionTwoColorScheme.Black : VersionTwoColorScheme.White;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(30),
      color: isSelected ? VersionTwoColorScheme.White : VersionTwoColorScheme.GreyElement,
      child: InkWell(
        focusNode: focusNode,
        hoverColor: VersionTwoColorScheme.GreyElement,
        overlayColor: MaterialStateProperty.resolveWith((states) {
          if (isSelected && states.hasHovered) return VersionTwoColorScheme.GreyHover;
        }),
        borderRadius: BorderRadius.circular(30),
        onTap: onTapCallback,
        child: Padding(
          padding: labelPadding,
          child: Label(
            type: LabelType.NewSmallTextStyle,
            text: text,
            color: selectColor,
            softWrap: false,
          ),
        ),
      ),
    );
  }
}
