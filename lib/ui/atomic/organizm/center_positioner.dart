import 'package:flutter/material.dart';

class CenterPositioner extends StatelessWidget {
  final Widget child;
  late final int paddingWeight;
  late final int contentWeight;

  CenterPositioner({required this.child}) {
    paddingWeight = 2;
    contentWeight = paddingWeight * 6;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(flex: paddingWeight, child: SizedBox()),
        Expanded(flex: contentWeight, child: child),
        Expanded(flex: paddingWeight, child: SizedBox())
      ],
    );
  }
}
