import 'package:burgundy_budgeting_app/ui/atomic/atom/label.dart';
import 'package:flutter/material.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/theme.dart';

class RoutesBar extends StatelessWidget {
  final List<Widget> children;

  const RoutesBar({required this.children});

  @override
  Widget build(BuildContext context) {
    var items = <Widget>[];
    for (var item in children) {
      items.add(item);
      items.add(
        Label(
          text: ' > ',
          type: LabelType.General,
        ),
      );
    }
    items.removeLast();

    return Container(
      width: double.infinity,
      color: CustomColorScheme.blockBackground,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 80),
          child: Row(
            children: items,
          ),
        ),
      ),
    );
  }
}
