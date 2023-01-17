import 'package:burgundy_budgeting_app/ui/atomic/atom/theme.dart';
import 'package:flutter/material.dart';

class InformHint extends StatelessWidget {
  final String message;

  InformHint({
    this.message = '',
  });

  @override
  Widget build(BuildContext context) {
    return message.isEmpty
        ? SizedBox()
        : Tooltip(
            message: message,
            child: Icon(
              Icons.info,
              color: CustomColorScheme.greyInkWell,
            ),
          );
  }
}
