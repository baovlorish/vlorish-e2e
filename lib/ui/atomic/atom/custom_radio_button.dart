import 'package:burgundy_budgeting_app/ui/atomic/atom/label.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/version_two_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/theme.dart';
// todo: (andreyK) remove
class CustomRadioButton extends StatelessWidget {
  final String title;
  final void Function() onTap;
  final Object value;
  final Object? groupValue;
  final TextOverflow? titleTextOverflow;

  const CustomRadioButton({
    Key? key,
    required this.title,
    required this.groupValue,
    required this.value,
    required this.onTap,
    this.titleTextOverflow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: CustomColorScheme.dividerInkWell,
      focusColor: CustomColorScheme.dividerInkWell,
      highlightColor: CustomColorScheme.dividerInkWell,
      hoverColor: CustomColorScheme.dividerInkWell,
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ExcludeFocus(
              child: Radio(
                groupValue: groupValue,
                value: value,
                onChanged: (_) => onTap(),
              ),
            ),
            SizedBox(width: 12),
            Label(
                text: title,
                type: LabelType.General,
                overflow: titleTextOverflow),
            SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}

class CustomRadioButtonNew extends StatefulWidget {
  final String title;
  final void Function() onTap;
  final Object value;
  final Object? groupValue;
  final TextOverflow? titleTextOverflow;

  const CustomRadioButtonNew({
    Key? key,
    required this.title,
    required this.groupValue,
    required this.value,
    required this.onTap,
    this.titleTextOverflow,
  }) : super(key: key);

  @override
  State<CustomRadioButtonNew> createState() => _CustomRadioButtonNewState();
}

class _CustomRadioButtonNewState extends State<CustomRadioButtonNew> {
  bool get isSelected => widget.value == widget.groupValue;

  final defaultBorderColor = VersionTwoColorScheme.Border;

  final hoverColor = VersionTwoColorScheme.PurpleColor;

  final selectedBorderColor = VersionTwoColorScheme.Green;

  Color get borderColor {
    if (isSelected) return selectedBorderColor;
    if (isHovered) return hoverColor;
    return defaultBorderColor;
  }

  final borderRadius = BorderRadius.circular(100);

  var isHovered = false;

  final radioActiveColor = VersionTwoColorScheme.SelectedColor;

  static const innerPadding =  EdgeInsets.symmetric(vertical: 8.0, horizontal: 20);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => widget.onTap()) ,
      child: MouseRegion(
        onEnter: (_) => setState(() => isHovered = true),
        onExit: (_) => setState(() => isHovered = false),
        child: DecoratedBox(
          decoration: BoxDecoration(border: Border.all(color: borderColor), borderRadius: borderRadius),
          child: Padding(
            padding: innerPadding,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ExcludeFocus(
                  child: Radio(
                    fillColor: MaterialStateProperty.resolveWith((_) {
                      if (isSelected) return radioActiveColor;
                      if (isHovered) return hoverColor;
                      return defaultBorderColor;
                    }),
                    overlayColor: MaterialStateProperty.resolveWith((_) {
                      if (isSelected) return radioActiveColor;
                      if (isHovered) return hoverColor;
                      return defaultBorderColor;
                    }),
                    groupValue: widget.groupValue,
                    value: widget.value,
                    onChanged: (_) => widget.onTap(),
                  ),
                ),
                SizedBox(width: 10),
                Label(text: widget.title, type: LabelType.General, overflow: widget.titleTextOverflow),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
