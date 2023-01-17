import 'package:burgundy_budgeting_app/ui/atomic/atom/label.dart';
import 'package:flutter/material.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/theme.dart';

class FeatureWidget extends StatelessWidget {
  final String featureName;

  const FeatureWidget({Key? key, required this.featureName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        children: [
          Icon(
            Icons.circle,
            color: CustomColorScheme.button,
            size: 10,
          ),
          SizedBox(width: 8),
          Label(
            text: featureName,
            type: LabelType.General,
          ),
        ],
      ),
    );
  }
}
