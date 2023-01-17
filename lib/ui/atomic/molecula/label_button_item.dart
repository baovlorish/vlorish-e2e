import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_inkwell.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/label.dart';
import 'package:flutter/material.dart';

class LabelButtonItem extends StatelessWidget {
  final Label label;
  final VoidCallback onPressed;

  const LabelButtonItem({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return CustomMaterialInkWell(
      border: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
      type: InkWellType.Purple,
      onTap: onPressed,
      child: label,
    );
  }
}
