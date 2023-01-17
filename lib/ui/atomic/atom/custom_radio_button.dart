import 'package:burgundy_budgeting_app/ui/atomic/atom/label.dart';
import 'package:flutter/material.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/theme.dart';

class CustomRadioButton extends StatelessWidget {
  final String title;
  final void Function() onTap;
  final Object value;
  final Object? groupValue;

  CustomRadioButton({
    Key? key,
    required this.title,
    required this.groupValue,
    required this.value,
    required this.onTap,
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
            Label(text: title, type: LabelType.General,),
            SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}
