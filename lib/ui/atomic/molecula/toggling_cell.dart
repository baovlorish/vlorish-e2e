import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_inkwell.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/label.dart';
import 'package:flutter/material.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/theme.dart';

class TogglingCell extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isShown;
  final Color backgroundColor;
  final Color textColor;
  final EdgeInsets padding;
  final String? iconUrl;
  final double? width;
  final bool withCheckbox;
  final Function? onCheckboxToggled;
  final bool isChecked;

  @override
  final Key? key;

  TogglingCell(
      {
    this.key,
    required this.text,
      required this.onPressed,
      required this.isShown,
      required this.padding,
      required this.backgroundColor,
      required this.textColor,
      this.iconUrl,
      required this.isChecked,
      this.width,
      required this.withCheckbox,
      this.onCheckboxToggled,
      });

  @override
  State<TogglingCell> createState() => _TogglingCellState(isChecked, isShown);
}

class _TogglingCellState extends State<TogglingCell> {
  bool isChecked;
  bool isExpanded;

  _TogglingCellState(this.isChecked, this.isExpanded);

  @override
  Widget build(BuildContext context) {
    return ExcludeFocus(
      child: CustomMaterialInkWell(
        type: InkWellType.Grey,
        onTap: () {
          _toggleIcon();
        },
        child: Container(
          padding: widget.padding,
          width: widget.width,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: CustomColorScheme.tableBorder,
              ),
              right: BorderSide(
                color: CustomColorScheme.tableBorder,
              ),
              left: BorderSide(
                color: widget.backgroundColor,
                width: 5,
              ),
            ),
            color: widget.backgroundColor,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  if (widget.withCheckbox)
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Checkbox(
                        splashRadius: 0.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        value: isChecked,
                        onChanged: (bool? value) {
                          setState(() {
                            isChecked = value!;
                            if (widget.onCheckboxToggled != null) {
                              widget.onCheckboxToggled!(value);
                            }
                          });
                        },
                      ),
                    ),
                  if (widget.iconUrl != null)
                    Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: ImageIcon(
                        AssetImage(widget.iconUrl!),
                        color: widget.textColor,
                        size: 24,
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: Label(
                      text: widget.text,
                      type: LabelType.GeneralBold,
                      color: widget.textColor,
                    ),
                  ),
                ],
              ),
              ImageIcon(
                isExpanded
                    ? AssetImage('assets/images/icons/arrow_up.png')
                    : AssetImage('assets/images/icons/arrow.png'),
                color: CustomColorScheme.errorPopupButton,
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _toggleIcon() {
    setState(() {
      isExpanded = !isExpanded;
      widget.onPressed.call();
    });
  }
}
