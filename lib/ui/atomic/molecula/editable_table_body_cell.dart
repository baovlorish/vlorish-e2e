import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_indicator_widget.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_inkwell.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/label.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/text_styles.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/theme.dart';
import 'package:burgundy_budgeting_app/ui/atomic/organizm/overlay_menu.dart';
import 'package:burgundy_budgeting_app/ui/atomic/organizm/toggling_rows_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

enum CellMovement { stay, right, left, up, down, unfocus }

class EditableTableBodyCell extends StatefulWidget {
  @override
  final Key? key;
  final String text;
  final EdgeInsets padding;
  final Color backgroundColor;
  final Color? sideColor;
  final Color textColor;
  final bool isFirstInRow;
  final bool isBold;
  final LabelType labelType;
  final double? width;
  final Color? cellBorderColor;
  final bool hasRightBorder;
  final Function(
    dynamic,
  ) changeValue;
  final bool isNumeric;
  final bool isFocused;
  final CellIndex editableCellIndex;
  final Function(CellIndex) onFocused;
  final Function(CellIndex, CellMovement) onRequestMovement;
  final bool showManualIndicator;
  final void Function(PointerDownEvent)? onPointerDown;
  final void Function()? onDoubleTapOrEqual;
  final ValueNotifier<bool> showMemoNotifier;
  final void Function(PointerEvent)? onExit;
  final void Function(PointerEvent)? onEnter;
  final String? cellTag;
  final bool showFormulaIndicator;

  const EditableTableBodyCell({
    required this.key,
    required this.text,
    required this.padding,
    this.sideColor,
    required this.backgroundColor,
    required this.textColor,
    required this.isFirstInRow,
    this.isBold = false,
    required this.hasRightBorder,
    required this.labelType,
    required this.changeValue,
    required this.isNumeric,
    required this.onFocused,
    this.width,
    required this.showManualIndicator,
    required this.isFocused,
    required this.editableCellIndex,
    this.onPointerDown,
    required this.showMemoNotifier,
    this.onExit,
    this.onEnter,
    this.cellTag,
    this.onDoubleTapOrEqual,
    this.cellBorderColor,
    required this.showFormulaIndicator,
    required this.onRequestMovement,
  });

  @override
  State<EditableTableBodyCell> createState() =>
      _EditableTableBodyCellState(text);
}

class _EditableTableBodyCellState extends State<EditableTableBodyCell> {
  String text;
  var isUnfocusEventHandled = false;
  var showCursorOnEnter = true;
  late TextEditingController controller;
  var cursorVisible = false;
  late var node = FocusNode(
    onKey: (FocusNode node, RawKeyEvent evt) {
      if (!cursorVisible && evt.isKeyPressed(LogicalKeyboardKey.backspace)) {
        controller.text = '';
        cursorVisible = true;
        setState(() {});
      }
      if (widget.onDoubleTapOrEqual != null &&
              evt.isKeyPressed(LogicalKeyboardKey.equal) ||
          evt.isKeyPressed(LogicalKeyboardKey.numpadEqual)) {
        widget.onDoubleTapOrEqual?.call();
        return KeyEventResult.handled;
      } else if (evt.isKeyPressed(LogicalKeyboardKey.enter) &&
          showCursorOnEnter) {
        cursorVisible = true;
        showCursorOnEnter = false;
        setState(() {});
        return KeyEventResult.handled;
      } else if (evt.isKeyPressed(LogicalKeyboardKey.enter) ||
          evt.isKeyPressed(LogicalKeyboardKey.numpadEnter) ||
          evt.isKeyPressed(LogicalKeyboardKey.arrowDown)) {
        requestMovement(CellMovement.down);
        return KeyEventResult.handled;
      } else if (evt.isKeyPressed(LogicalKeyboardKey.arrowLeft)) {
        if (cursorVisible) {
          return KeyEventResult.ignored;
        } else {
          requestMovement(CellMovement.left);
          return KeyEventResult.handled;
        }
      } else if (evt.isKeyPressed(LogicalKeyboardKey.arrowUp)) {
        requestMovement(CellMovement.up);
        return KeyEventResult.handled;
      } else if (evt.isKeyPressed(LogicalKeyboardKey.arrowRight)) {
        if (cursorVisible) {
          return KeyEventResult.ignored;
        } else {
          requestMovement(CellMovement.right);
          return KeyEventResult.handled;
        }
      } else if (evt.isKeyPressed(LogicalKeyboardKey.tab)) {
        requestMovement(CellMovement.right);
        return KeyEventResult.handled;
      } else {
        return KeyEventResult.ignored;
      }
    },
  );

  void finishEditing() {
    if (controller.text.isEmpty) {
      //if user erased text and unfocused,
      // it sets to 0 if numeric or to initial otherwise
      if(widget.isNumeric) {
        controller.text = '0';
        widget.changeValue(0);
      } else {
        controller.text = widget.text;
      }
      setState(() {});
    } else if (controller.text != widget.text) {
      widget.changeValue(widget.isNumeric
          ? int.parse(controller.text.replaceAll(',', '').replaceAll('\$', ''))
          : controller.text);
    }
  }

  void requestMovement(CellMovement direction) {
    finishEditing();
    widget.onRequestMovement(widget.editableCellIndex, direction);
    isUnfocusEventHandled = true;
  }

  _EditableTableBodyCellState(this.text);

  @override
  void initState() {
    super.initState();
    if (widget.isFocused) {
      node.requestFocus();
      widget.onFocused(widget.editableCellIndex);
    }
    controller = TextEditingController(text: text);
    node.addListener(
      () {
        if (!node.hasFocus) {
          if (widget.isNumeric && controller.text.isNotEmpty) {
            controller.text = NumberFormat('#,###').format(int.parse(
                controller.text.replaceAll(',', '').replaceAll('\$', '')));
          } else if(widget.isNumeric && controller.text.isEmpty) {
            controller.text = '0';
            widget.changeValue(0);
          }
          cursorVisible = false;
          if (controller.text.isEmpty) {
            controller.text = widget.text;
          }
          setState(() {});
          if (!isUnfocusEventHandled) {
            requestMovement(CellMovement.unfocus);
          } else {
            isUnfocusEventHandled = false;
          }
        } else {
          showCursorOnEnter = true;
          widget.onFocused(widget.editableCellIndex);
          if (widget.isNumeric) {
            controller.text =
                controller.text.replaceAll(',', '').replaceAll('\$', '');
          }
          setState(() {});
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isFocused) node.requestFocus();

    var cellBorderColor = (widget.isFocused || node.hasFocus)
        ? CustomColorScheme.errorPopupButton
        : widget.cellBorderColor;
    return MouseRegion(
      onEnter: widget.onEnter,
      onExit: widget.onExit,
      child: Container(
        width: widget.width,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: cellBorderColor ?? CustomColorScheme.tableBorder,
            ),
            right: BorderSide(
              color: cellBorderColor ??
                  (widget.hasRightBorder
                      ? CustomColorScheme.tableBorder
                      : Colors.transparent),
            ),
            left: cellBorderColor != null
                ? BorderSide(
                    color: cellBorderColor,
                  )
                : widget.sideColor != null
                    ? BorderSide(
                        color: widget.sideColor!,
                      )
                    : BorderSide.none,
            top: cellBorderColor != null
                ? BorderSide(
                    color: cellBorderColor,
                  )
                : BorderSide.none,
          ),
          color: widget.backgroundColor,
        ),
        child: MaybeModalAnchor(
          tag: widget.cellTag,
          child: Listener(
            onPointerDown: widget.onPointerDown,
            child: ValueListenableBuilder<bool>(
                valueListenable: widget.showMemoNotifier,
                builder: (context, showMemoIndicator, _) {
                  return Stack(
                    children: [
                      CustomMaterialInkWell(
                        focusNode: FocusNode(),
                        canRequestFocus: false,
                        onTap: () {
                          FocusScope.of(context).nextFocus();
                        },
                        onDoubleTap: () {
                          controller.selection = TextSelection(
                              baseOffset: 0,
                              extentOffset: controller.text.length);
                        },
                        type: InkWellType.Transparent,
                        child: TextFormField(
                          enableInteractiveSelection: true,
                          onChanged: (String value) {
                            if (widget.text.isNotEmpty && !cursorVisible) {
                              controller.text =
                                  value.substring(value.length - 1);
                              controller.selection = TextSelection.collapsed(
                                  offset: controller.text.length);
                              setState(() {});
                            }
                            showCursorOnEnter = false;
                            cursorVisible = true;
                            if (widget.isNumeric &&
                                value.length > 1 &&
                                value[0] == '0') {
                              controller.text = value.substring(1);
                              controller.selection = TextSelection.collapsed(
                                  offset: controller.text.length);
                              setState(() {});
                            }
                          },
                          onEditingComplete: () {
                            /*stub to ignore default callback*/
                          },
                          showCursor: cursorVisible,
                          focusNode: node,
                          autofocus: widget.isFocused,
                          controller: controller,
                          style: CustomTextStyle.LabelTextStyle(context)
                              .copyWith(
                                  decoration: TextDecoration.underline,
                                  decorationStyle: TextDecorationStyle.dotted,
                                  color: widget.textColor,
                                  fontWeight: widget.isBold
                                      ? FontWeight.bold
                                      : FontWeight.normal),
                          inputFormatters: [
                            FilteringTextInputFormatter.singleLineFormatter,
                            if (widget.isNumeric)
                              FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(
                                widget.isNumeric ? 8 : 20),
                          ],
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            contentPadding: widget.padding,
                            prefix: widget.isBold
                                ? Text('\$',
                                    style: TextStyle(
                                      color: widget.textColor,
                                    ))
                                : null,
                            suffix: Padding(
                              padding: const EdgeInsets.only(right: 6.0),
                              child: widget.showManualIndicator
                                  ? CustomIndicatorWidget(
                                      color:
                                          CustomColorScheme.errorPopupButton,
                                      child: Text(
                                        'M',
                                        style: CustomTextStyle.LabelTextStyle(
                                                context)
                                            .copyWith(
                                                decoration:
                                                    TextDecoration.none,
                                                fontWeight: FontWeight.bold,
                                                color: CustomColorScheme
                                                    .tableWhiteText),
                                      ),
                                    )
                                  : null,
                            ),
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          if (showMemoIndicator)
                            Container(
                              alignment: Alignment.topRight,
                              child: CustomIndicatorWidget(
                                size: 12,
                                padding: EdgeInsets.only(top: 2),
                                color: Colors.transparent,
                                child: Icon(
                                  Icons.comment,
                                  color: CustomColorScheme
                                      .tableExpensesBusinessText,
                                  size: 12,
                                ),
                              ),
                            ),
                          if (widget.showFormulaIndicator)
                            Container(
                              alignment: Alignment.topRight,
                              child: CustomIndicatorWidget(
                                size: 12,
                                padding: EdgeInsets.only(top: 2),
                                color: CustomColorScheme.goalColor2,
                                child: Text(
                                  'f',
                                  style: TextStyle(
                                    color: CustomColorScheme.tableWhiteText,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  );
                }),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    node.dispose();
    super.dispose();
  }
}

class NumericTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    } else if (newValue.text.compareTo(oldValue.text) != 0) {
      var selectionIndexFromTheRight =
          newValue.text.length - newValue.selection.end;
      var f = NumberFormat('#,###');
      final number =
          int.parse(newValue.text.replaceAll(f.symbols.GROUP_SEP, ''));
      final newString = f.format(number);
      return TextEditingValue(
        text: newString,
        selection: TextSelection.collapsed(
            offset: newString.length - selectionIndexFromTheRight),
      );
    } else {
      return newValue;
    }
  }
}

class DecoratedNumericTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    } else if (newValue.text.compareTo(oldValue.text) != 0) {
      var selectionIndexFromTheRight =
          newValue.text.length - newValue.selection.end;
      var f = NumberFormat('#,###');
      final number =
          int.parse(newValue.text.replaceAll(f.symbols.GROUP_SEP, ''));
      final newString = '\$' + f.format(number);
      return TextEditingValue(
        text: newString,
        selection: TextSelection.collapsed(
            offset: newString.length - selectionIndexFromTheRight),
      );
    } else {
      return newValue;
    }
  }
}

class DecimalTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final regEx = RegExp(r'^\d*\.?\d{0,2}');
    var newString = regEx.stringMatch(newValue.text);
    return newString == newValue.text ? newValue : oldValue;
  }
}
