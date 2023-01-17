import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_inkwell.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_tooltip.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/theme.dart';
import 'package:flutter/material.dart';

class ArrowButtons extends StatefulWidget {
  const ArrowButtons({
    Key? key,
    required this.onPressedFirstButton,
    required this.onPressedSecondButton,
    this.firstButtonTooltip,
    this.secondButtonTooltip,
    this.iconSize,
  }) : super(key: key);

  final void Function()? onPressedFirstButton;
  final void Function()? onPressedSecondButton;

  final String? firstButtonTooltip;
  final String? secondButtonTooltip;

  final double? iconSize;

  @override
  State<ArrowButtons> createState() => _ArrowButtonsState();
}

class _ArrowButtonsState extends State<ArrowButtons> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomIconButton(
          callback: widget.onPressedFirstButton,
          icon: Icons.undo_rounded,
          iconSize: widget.iconSize,
          tooltip: widget.firstButtonTooltip,
        ),
        SizedBox(width: 8),
        CustomIconButton(
          callback: widget.onPressedSecondButton,
          icon: Icons.redo_rounded,
          iconSize: widget.iconSize,
          tooltip: widget.secondButtonTooltip,
        ),
      ],
    );
  }
}

class CustomIconButton extends StatefulWidget {
  const CustomIconButton({
    Key? key,
    required this.icon,
    required this.callback,
    required this.tooltip,
    this.iconSize,
  }) : super(key: key);

  final IconData icon;
  final double? iconSize;
  final void Function()? callback;
  final String? tooltip;

  @override
  State<CustomIconButton> createState() => _CustomIconButtonState();
}

class _CustomIconButtonState extends State<CustomIconButton> {
  @override
  Widget build(BuildContext context) {
    return CustomTooltip(
      message: widget.tooltip,
      key: UniqueKey(),
      child: CustomMaterialInkWell(
        type: InkWellType.Purple,
        borderRadius: BorderRadius.circular(40),
        onTap: widget.callback,
        child: Icon(
          widget.icon,
          color: widget.callback != null
              ? CustomColorScheme.mainDarkBackground
              : CustomColorScheme.inputBorder,
          size: widget.iconSize ?? 32,
        ),
      ),
    );
  }
}
