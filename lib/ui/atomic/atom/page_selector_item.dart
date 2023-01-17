import 'package:burgundy_budgeting_app/ui/atomic/molecula/button_item.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/button_item_transparent.dart';
import 'package:flutter/material.dart';

class PageSelectorItem extends StatelessWidget {
  final int number;
  final bool isSelected;
  final void Function(int) callback;

  PageSelectorItem({
    required this.number,
    required this.isSelected,
    required this.callback,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: isSelected
          ? ButtonItem(
              context,
              text: number.toString(),
              onPressed: () => callback(number),
              buttonType: ButtonType.SmallText,
            )
          : ButtonItemTransparent(
              context,
              text: number.toString(),
              onPressed: () => callback(number),
              buttonType: TransparentButtonType.SmallText,
            ),
    );
  }
}
