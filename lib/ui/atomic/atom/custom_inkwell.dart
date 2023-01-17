import 'package:burgundy_budgeting_app/ui/atomic/atom/theme.dart';
import 'package:flutter/material.dart';

enum InkWellType {
  White,
  Purple,
  Grey,
  Red,
  Transparent,
}

class CustomMaterialInkWell extends StatefulWidget {
  final Widget child;
  final InkWellType? type;
  final Color materialColor;
  final void Function()? onTap;
  final void Function(TapDownDetails)? onTapDown;
  final void Function()? onDoubleTap;
  final ShapeBorder? border;
  final BorderRadius? borderRadius;
  final FocusNode? focusNode;
  final Color? splashColor;
  final bool canRequestFocus;

  CustomMaterialInkWell({
    Key? key,
    required this.child,
    required this.type,
    this.onTap,
    this.border,
    this.materialColor = Colors.transparent,
    this.borderRadius,
    this.onDoubleTap,
    this.focusNode,
    this.onTapDown,
    this.splashColor,
    this.canRequestFocus = true,
  }) : super(key: key);

  @override
  State<CustomMaterialInkWell> createState() => _CustomMaterialInkWellState();
}

class _CustomMaterialInkWellState extends State<CustomMaterialInkWell> {
  late Color color;
  Function()? onTap;

  @override
  void didChangeDependencies() {
    if (widget.type == InkWellType.White) {
      color = CustomColorScheme.whiteInkWell;
    } else if (widget.type == InkWellType.Purple) {
      color = CustomColorScheme.purpleInkWell;
    } else if (widget.type == InkWellType.Grey) {
      color = CustomColorScheme.greyInkWell;
    } else if (widget.type == InkWellType.Red) {
      color = CustomColorScheme.redInkWell;
    } else if (widget.type == InkWellType.Transparent) {
      color = Colors.transparent;
    }
    // without this onTapDown won't work
    onTap = widget.onTap;
    if (widget.onTapDown != null && onTap == null) {
      onTap = () {};
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: widget.borderRadius,
      color: widget.materialColor,
      child: InkWell(
        canRequestFocus: widget.canRequestFocus,
        focusNode: widget.focusNode,
        borderRadius: widget.borderRadius,
        customBorder: widget.border,
        focusColor: color,
        hoverColor: color,
        splashColor: widget.splashColor ?? color,
        highlightColor: color,
        onTap: onTap,
        radius: 80,
        onTapDown: widget.onTapDown,
        onDoubleTap: widget.onDoubleTap,
        child: widget.child,
      ),
    );
  }
}
