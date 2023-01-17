import 'package:flutter/material.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/theme.dart';

class CollapsedMenuButtonItem extends TextButton {

  final BuildContext context;
  @override
  final VoidCallback onPressed;
  final bool isSelected;
  final String assetUrl;

  CollapsedMenuButtonItem(this.context,
      {required this.onPressed, this.isSelected = false, required this.assetUrl})
      : super(
    onPressed: () => onPressed,
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Container(
        height: 44,
        width: 44,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          color: isSelected
              ? CustomColorScheme.menuBackgroundActive
              : Colors.transparent,
        ),
        child: Center(
          child: ImageIcon(
            AssetImage(assetUrl),
            color: isSelected
                ? CustomColorScheme.textSelectedColorMenu
                : CustomColorScheme.textColorMenu,
            size: 24,
          ),
        ),
      ),
    ),
  );
}
