import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_inkwell.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/label.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomSwitch extends StatefulWidget {
  final bool variable;
  final String? text;
  final void Function(bool)? callback;
  final bool textToTheRight;

  const CustomSwitch({
    Key? key,
    required this.variable,
    this.callback,
    this.text,
    this.textToTheRight = false,
  }) : super(key: key);

  @override
  _CustomSwitchState createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch> {
  bool variable = false;

  @override
  void initState() {
    variable = widget.variable;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        if (widget.text != null && !widget.textToTheRight)
          CustomMaterialInkWell(
            type: InkWellType.Purple,
            borderRadius: BorderRadius.circular(4.0),
            onTap: () {
              setState(() {
                variable = !variable;
                if (widget.callback != null) {
                  widget.callback!(variable);
                }
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Label(text: widget.text!, type: LabelType.General),
            ),
          ),
        CupertinoSwitch(
          activeColor: CustomColorScheme.button,
          value: variable,
          onChanged: (bool value) {
            setState(() {
              variable = value;
              if (widget.callback != null) {
                widget.callback!(variable);
              }
            });
          },
        ),
        if (widget.text != null && widget.textToTheRight)
          CustomMaterialInkWell(
            type: InkWellType.Purple,
            borderRadius: BorderRadius.circular(4.0),
            onTap: () {
              setState(() {
                variable = !variable;
                if (widget.callback != null) {
                  widget.callback!(variable);
                }
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Label(text: widget.text!, type: LabelType.General),
            ),
          ),
      ],
    );
  }
}

class CustomTextSwitch extends StatefulWidget {
  final String firstOptionName;
  final String secondOptionName;
  final Function(bool) onSelected;
  final bool initialSelection;

  const CustomTextSwitch(
      {Key? key,
      required this.firstOptionName,
      required this.secondOptionName,
      required this.onSelected,
      this.initialSelection = false})
      : super(key: key);

  @override
  _CustomTextSwitchState createState() => _CustomTextSwitchState();
}

class _CustomTextSwitchState extends State<CustomTextSwitch> {
  late bool selection = widget.initialSelection;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 220,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: CustomColorScheme.tableBorder),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: CustomMaterialInkWell(
                  key: UniqueKey(),
                  borderRadius: BorderRadius.circular(30),
                  type: InkWellType.Purple,
                  onTap: selection
                      ? () {
                          widget.onSelected(false);
                          selection = !selection;
                          setState(() {});
                        }
                      : null,
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                            color: !selection
                                ? CustomColorScheme.mainDarkBackground
                                : Colors.transparent),
                        color: !selection
                            ? CustomColorScheme.mainDarkBackground
                            : Colors.transparent),
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Center(
                          child: Label(
                        type: LabelType.General,
                        text: widget.firstOptionName,
                            color: !selection
                                ? Colors.white
                                : CustomColorScheme.text,
                      )),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: CustomMaterialInkWell(
                  key: UniqueKey(),
                  borderRadius: BorderRadius.circular(30),
                  type: InkWellType.Purple,
                  onTap: !selection
                      ? () {
                          widget.onSelected(true);
                          selection = !selection;
                          setState(() {});
                        }
                      : null,
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                            color: selection
                                ? CustomColorScheme.mainDarkBackground
                                : Colors.transparent),
                        color: selection
                            ? CustomColorScheme.mainDarkBackground
                            : Colors.transparent),
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Center(
                        child: Label(
                          type: LabelType.General,
                          text: widget.secondOptionName,
                          color: selection
                              ? Colors.white
                              : CustomColorScheme.text,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
