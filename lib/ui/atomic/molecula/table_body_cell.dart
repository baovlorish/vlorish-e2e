import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_indicator_widget.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_inkwell.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/label.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/text_styles.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/theme.dart';
import 'package:burgundy_budgeting_app/ui/atomic/organizm/overlay_menu.dart';
import 'package:flutter/material.dart';

import '../atom/custom_tooltip.dart';

class TableBodyCell extends StatefulWidget {
  final String text;
  final EdgeInsets padding;
  final Color backgroundColor;
  final Color? sideColor;
  final Color textColor;
  final bool isFirstInRow;
  final bool isBold;
  final LabelType labelType;
  final double? width;
  final bool hasRightBorder;
  final String? iconUrl;
  final String? tooltipMessage;
  final bool ignoreFirstInRowProperty;
  final VoidCallback? onTap;
  final VoidCallback? onDoubleTap;
  final bool hasBottomBorder;
  final void Function(PointerDownEvent)? onPointerDown;
  final VoidCallback? expandAll;
  @override
  final Key? key;
  final bool showManualIndicator;
  final ValueNotifier<bool> showMemoNotifier;

  final bool hasHoverColor;
  final void Function(PointerEvent)? onExit;
  final void Function(PointerEvent)? onEnter;
  final String? cellTag;
  final bool? isShouldExpand;
  final MainAxisAlignment? mainAxisAlignment;

  const TableBodyCell({
    required this.text,
    required this.padding,
    this.sideColor,
    this.iconUrl,
    required this.backgroundColor,
    required this.textColor,
    required this.isFirstInRow,
    this.isBold = false,
    required this.hasRightBorder,
    required this.labelType,
    this.width,
    this.ignoreFirstInRowProperty = false,
    required this.hasBottomBorder,
    this.tooltipMessage,
    this.onTap,
    this.onDoubleTap,
    this.key,
    this.onPointerDown,
    required this.showManualIndicator,
    required this.showMemoNotifier,
    this.hasHoverColor = true,
    this.onExit,
    this.onEnter,
    this.cellTag,
    this.mainAxisAlignment,
    this.expandAll,
    this.isShouldExpand,
  });

  @override
  State<TableBodyCell> createState() => _TableBodyCellState();
}

class _TableBodyCellState extends State<TableBodyCell> {
  String? tag;

  @override
  Widget build(BuildContext context) {
    return ExcludeFocus(
      child: MouseRegion(
        onEnter: widget.onEnter,
        onExit: widget.onExit,
        child: Container(
          width: widget.width,
          decoration: BoxDecoration(
            border: widget.isFirstInRow
                ? Border(
                    bottom: BorderSide(
                      color: widget.hasBottomBorder
                          ? CustomColorScheme.tableBorder
                          : Colors.transparent,
                    ),
                    right: BorderSide(
                      color: widget.hasRightBorder
                          ? CustomColorScheme.tableBorder
                          : Colors.transparent,
                    ),
                    left: BorderSide(
                      color: widget.sideColor ?? widget.backgroundColor,
                      width: 5,
                    ),
                  )
                : Border(
                    bottom: BorderSide(
                      color: widget.hasBottomBorder
                          ? CustomColorScheme.tableBorder
                          : Colors.transparent,
                    ),
                    right: BorderSide(
                      color: widget.hasRightBorder
                          ? CustomColorScheme.tableBorder
                          : Colors.transparent,
                    ),
                  ),
            color: widget.backgroundColor,
          ),
          child: Listener(
            onPointerDown: widget.onPointerDown != null
                ? (event) {
                    widget.onPointerDown!(event);
                    tag = widget.cellTag;
                  }
                : null,
            child: ValueListenableBuilder<bool>(
              valueListenable: widget.showMemoNotifier,
              builder: (context, showMemoIndicator, _) {
                return MaybeModalAnchor(
                  tag: showMemoIndicator ? widget.cellTag : tag,
                  child: Stack(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: CustomMaterialInkWell(
                              materialColor: widget.backgroundColor,
                              type: widget.hasHoverColor
                                  ? InkWellType.Grey
                                  : InkWellType.Transparent,
                              onTap:
                                  widget.onTap != null ? widget.onTap! : null,
                              onDoubleTap: widget.onDoubleTap != null
                                  ? widget.onDoubleTap!
                                  : null,
                              splashColor: CustomColorScheme.button,
                              child: Column(children: [
                                widget.tooltipMessage != null
                                    ? CustomTooltip(
                                        message: widget.tooltipMessage!,
                                        child: Padding(
                                          padding: widget.padding,
                                          child: _iconWithLabel(),
                                        ),
                                      )
                                    : Padding(
                                        padding: widget.padding,
                                        child: _iconWithLabel(),
                                      ),
                              ]),
                            ),
                          ),
                          if (widget.expandAll != null)
                            CustomMaterialInkWell(
                              type: InkWellType.Grey,
                              onTap: () {
                                widget.expandAll!();
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 8.0),
                                child: ImageIcon(
                                  widget.isShouldExpand!
                                      ? AssetImage(
                                          'assets/images/icons/arrow_up.png')
                                      : AssetImage(
                                          'assets/images/icons/arrow.png'),
                                  color: CustomColorScheme.errorPopupButton,
                                  size: 24,
                                ),
                              ),
                            ),
                          if (widget.showManualIndicator)
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: CustomIndicatorWidget(
                                color: CustomColorScheme.errorPopupButton,
                                child: Text(
                                  'M',
                                  style: CustomTextStyle.LabelTextStyle(context)
                                      .copyWith(
                                          decoration: TextDecoration.none,
                                          fontWeight: FontWeight.bold,
                                          color:
                                              CustomColorScheme.tableWhiteText),
                                ),
                              ),
                            ),
                        ],
                      ),
                      if (showMemoIndicator)
                        Container(
                          alignment: Alignment.topRight,
                          child: CustomIndicatorWidget(
                            size: 16,
                            padding: EdgeInsets.only(top: 2),
                            color: Colors.transparent,
                            child: Icon(
                              Icons.comment,
                              color:
                                  CustomColorScheme.tableExpensesBusinessText,
                              size: 12,
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _iconWithLabel() {
    return Row(
      mainAxisAlignment: widget.mainAxisAlignment!,
      children: [
        widget.iconUrl != null
            ? Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: ImageIcon(
                  AssetImage(widget.iconUrl!),
                  color: widget.textColor,
                  size: 24,
                ),
              )
            : SizedBox.shrink(),
        Label(
          text: widget.text,
          type: widget.labelType,
          color: widget.textColor,
          fontWeight: !widget.ignoreFirstInRowProperty
              ? widget.isFirstInRow || widget.isBold
                  ? FontWeight.w600
                  : FontWeight.w400
              : FontWeight.w400,
        ),
      ],
    );
  }
}
