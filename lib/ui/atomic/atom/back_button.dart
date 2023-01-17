import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_inkwell.dart';
import 'package:flutter/material.dart';

class CustomBackButton extends StatelessWidget {
  final void Function()? onPressed;
  final double? size;

  const CustomBackButton({required this.onPressed, this.size = 40});

  @override
  Widget build(BuildContext context) {
    return CustomMaterialInkWell(
      border: CircleBorder(),
      type: InkWellType.Purple,
      onTap: onPressed,
      child: Icon(
        Icons.arrow_back_rounded,
        size: size,
      ),
    );
  }
}
