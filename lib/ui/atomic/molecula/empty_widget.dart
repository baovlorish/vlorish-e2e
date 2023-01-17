import 'package:burgundy_budgeting_app/ui/atomic/atom/label.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/theme.dart';
import 'package:flutter/material.dart';

class EmptyWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final String iconUrl;

  const EmptyWidget(
      {Key? key,
      required this.title,
      required this.subtitle,
      required this.iconUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Center(
                child: Image.asset(
              iconUrl,
              height: 120,
            )),
            SizedBox(height: 16),
            Label(
              text: title,
              type: LabelType.HintLargeBold,
              color: CustomColorScheme.inputBorder,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            Label(
              text: subtitle,
              type: LabelType.GreyLabel,
              color: CustomColorScheme.inputBorder,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
}
