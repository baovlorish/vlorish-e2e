import 'package:burgundy_budgeting_app/ui/atomic/atom/label.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/theme.dart';
import 'package:flutter/material.dart';

class GoogleButtonItem extends TextButton {
  final String text;
  final BuildContext context;
  @override
  final VoidCallback onPressed;

  GoogleButtonItem(this.context, {required this.text, required this.onPressed})
      : super(
          onPressed: () => onPressed,
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: CustomColorScheme.inputFill,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: CustomColorScheme.text),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    ImageIcon(
                      AssetImage('assets/images/icons/google_fill.png'),
                      color: CustomColorScheme.text,
                      size: 24,
                    ),
                    SizedBox(
                      width: 12,
                    ),
                  ],
                ),
                Label(
                    text: text,
                    type: LabelType.LargeButton,
                    color: CustomColorScheme.text),
              ],
            ),
          ),
        );
}
