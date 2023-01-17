import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_inkwell.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/label.dart';
import 'package:flutter/material.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/theme.dart';

class ClipSelectorData {
  Key key;
  String title;
  bool selected;
  EdgeInsets padding;

  ClipSelectorData({
    required this.key,
    required this.title,
    required this.selected,
    this.padding = const EdgeInsets.symmetric(horizontal: 25.0, vertical: 5.0),
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ClipSelectorData &&
          runtimeType == other.runtimeType &&
          title == other.title &&
          key == other.key &&
          selected == other.selected;

  @override
  int get hashCode => key.hashCode ^ title.hashCode ^ selected.hashCode;

  @override
  String toString() {
    return 'ClipSelectorData{key: $key, title: $title, selected: $selected}';
  }
}

class ClipSelector extends StatefulWidget {
  final ClipSelectorData model;
  final Function(ClipSelectorData) onPressed;

  const ClipSelector({required this.model, required this.onPressed});

  @override
  _ClipSelectorState createState() => _ClipSelectorState();
}

class _ClipSelectorState extends State<ClipSelector> {
  final double radiusCircle = 20.0;

  @override
  Widget build(BuildContext context) {
    return CustomMaterialInkWell(
      borderRadius: BorderRadius.circular(radiusCircle),
      materialColor: widget.model.selected
          ? CustomColorScheme.mainDarkBackground
          : CustomColorScheme.clipElementInactive,
      type: widget.model.selected ? InkWellType.Purple : InkWellType.White,
      onTap: () {
        setState(() {
          widget.onPressed(widget.model);
        });
      },
      child: Padding(
        padding: widget.model.padding,
        child: Label(
          text: widget.model.title,
          type: LabelType.GeneralBold,
          color: Colors.white,
        ),
      ),
    );
  }
}
