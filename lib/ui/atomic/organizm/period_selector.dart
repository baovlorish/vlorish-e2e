import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_inkwell.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/label.dart';
import 'package:flutter/material.dart';

class PeriodSelector extends StatefulWidget {
  final List<String> labelTexts;
  final int defaultPosition;
  final Function(int position) onPressed;
  final bool isSmall;

  const PeriodSelector(Key key,
      {required this.labelTexts,
      required this.defaultPosition,
      required this.onPressed,
      required this.isSmall})
      : super(key: key);

  @override
  State<PeriodSelector> createState() => _PeriodSelectorState(defaultPosition);
}

class _PeriodSelectorState extends State<PeriodSelector> {
  int position;

  _PeriodSelectorState(this.position);

  @override
  Widget build(BuildContext context) {
    return Row(
      key: ObjectKey(position.hashCode),
      children: [
        CustomMaterialInkWell(
          type: InkWellType.Purple,
          borderRadius: BorderRadius.circular(4.0),
          onTap: position == 0
              ? null
              : () {
                  setState(
                    () {
                      position--;
                      widget.onPressed.call(position);
                    },
                  );
                },
          child: ImageIcon(
            AssetImage('assets/images/icons/left.png'),
            color: position == 0
                ? Color.fromRGBO(201, 162, 185, 1)
                : Color.fromRGBO(72, 0, 41, 1),
            size: 26.0,
          ),
        ),
        SizedBox(
          width: widget.isSmall ? 80.0 : 135,
          child: Center(
            child: Label(
              type: LabelType.Header3,
              text: widget.labelTexts[position],
            ),
          ),
        ),
        CustomMaterialInkWell(
          type: InkWellType.Purple,
          borderRadius: BorderRadius.circular(4.0),
          onTap: position == widget.labelTexts.length - 1
              ? null
              : () {
                  setState(
                    () {
                      position++;
                      widget.onPressed.call(position);
                    },
                  );
                },
          child: ImageIcon(AssetImage('assets/images/icons/right.png'),
              size: 26.0,
              color: position == widget.labelTexts.length - 1
                  ? Color.fromRGBO(201, 162, 185, 1)
                  : Color.fromRGBO(72, 0, 41, 1)),
        ),
      ],
    );
  }
}
