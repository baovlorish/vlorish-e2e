import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_inkwell.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/label.dart';
import 'package:flutter/material.dart';

class TextButtonWithIcon extends StatefulWidget {
  const TextButtonWithIcon(
      {Key? key,
      required this.text,
      required this.onTap,
      required this.buttonColor,
      required this.iconData,
      this.type = InkWellType.Purple})
      : super(key: key);

  final String text;
  final void Function()? onTap;
  final Color buttonColor;
  final IconData iconData;
  final InkWellType? type;
  @override
  State<TextButtonWithIcon> createState() => _TextButtonWithIconState();
}

class _TextButtonWithIconState extends State<TextButtonWithIcon> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 18.0),
      child: CustomMaterialInkWell(
        type: InkWellType.Purple,
        borderRadius: BorderRadius.circular(10),
        onTap: widget.onTap,
        child: Row(
          children: [
            Icon(
              widget.iconData,
              color: widget.buttonColor,
            ),
            SizedBox(width: 4),
            Label(
              text: widget.text,
              type: LabelType.Button,
              color: widget.buttonColor,
            )
          ],
        ),
      ),
    );
  }
}
