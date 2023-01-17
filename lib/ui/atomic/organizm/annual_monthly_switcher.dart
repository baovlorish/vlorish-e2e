import 'package:burgundy_budgeting_app/ui/atomic/molecula/annual_monthly_button.dart';
import 'package:flutter/material.dart';

class TwoOptionSwitcher extends StatefulWidget {
  final bool isFirstItemSelected;
  final VoidCallback onPressed;
  final List<String> options;
  final double spacing;
  final bool isDirectionVertical;

  const TwoOptionSwitcher(
      {required this.isFirstItemSelected,
      required this.onPressed,
      required this.options,
      this.spacing = 20,
      this.isDirectionVertical = false});

  @override
  State<TwoOptionSwitcher> createState() =>
      _TwoOptionSwitcherState(isFirstItemSelected);
}

class _TwoOptionSwitcherState extends State<TwoOptionSwitcher> {
  bool isFirsrItemSelected;
  late BoxConstraints constraints;

  _TwoOptionSwitcherState(this.isFirsrItemSelected);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      direction: widget.isDirectionVertical ? Axis.vertical : Axis.horizontal,
      key: Key(
          widget.options.toString() + widget.isFirstItemSelected.toString()),
      spacing: widget.spacing,
      children: [
        TabSelectorButton(
          onPressed: () {
            widget.onPressed.call();
            setState(
              () {
                isFirsrItemSelected = !isFirsrItemSelected;
              },
            );
          },
          isSelected: isFirsrItemSelected,
          labelText: widget.options[0],
        ),
        TabSelectorButton(
          onPressed: () {
            widget.onPressed.call();
            setState(
              () {
                isFirsrItemSelected = !isFirsrItemSelected;
              },
            );
          },
          isSelected: !isFirsrItemSelected,
          labelText: widget.options[1],
        ),
      ],
    );
  }
}
