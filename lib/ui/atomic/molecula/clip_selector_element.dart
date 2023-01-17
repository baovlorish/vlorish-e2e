import 'package:burgundy_budgeting_app/ui/atomic/atom/clip_selector.dart';
import 'package:flutter/material.dart';

class ClipSelectorElement extends StatefulWidget {
  final List<ClipSelectorData> data;
  final Function(ClipSelectorData) onPressed;
  final EdgeInsets padding;

  const ClipSelectorElement(
    this.data,
    this.onPressed, {
    this.padding = EdgeInsets.zero,
    Key? key,
  }) : super(key: key);

  @override
  _ClipSelectorElementState createState() => _ClipSelectorElementState(data);
}

class _ClipSelectorElementState extends State<ClipSelectorElement> {
  List<ClipSelectorData> data;

  _ClipSelectorElementState(this.data);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...data
            .map(
              (item) => Padding(
                padding: widget.padding,
                child: ClipSelector(
                  model: item,
                  onPressed: (val) {
                    setState(() {
                      /*var currentSelected =
                      data.firstWhere((element) => element == val);*/
                      data.forEach((element) {
                        element.selected = false;
                        if (element == val) {
                          element.selected = true;
                          widget.onPressed(element);
                          return;
                        }
                      });
                    });
                  },
                ),
              ),
            )
            .toList()
      ],
    );
  }
}
