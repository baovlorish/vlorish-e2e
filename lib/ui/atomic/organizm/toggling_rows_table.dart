import 'package:burgundy_budgeting_app/ui/atomic/atom/label.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/theme.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/editable_table_body_cell.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/table_body_cell.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/toggling_cell.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:collection/src/iterable_extensions.dart';

class TogglingRowsTable extends StatefulWidget {
  final TableData tableData;
  /// This variable used allowing Editable Cells
  final bool allowEditableCells;
  /// If [allowEditableCells] is set to false, it overrides isEditable property of all cells in the [TogglingRowsTable]
  const TogglingRowsTable({
    Key? key,
    required this.tableData,  this.allowEditableCells = true ,
  }) : super(key: key);

  @override
  _TogglingRowsTableState createState() => _TogglingRowsTableState();
}

class _TogglingRowsTableState extends State<TogglingRowsTable> {
  CellIndex? focusedEditableCellIndex;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FocusTraversalGroup(
      policy: OrderedTraversalPolicy(),
      child: Column(
        children: [
          rowDataToTableRow(
              widget.tableData.header, widget.tableData.minColumnWidths,
              expandAll: widget.tableData.expandAll,
              isShouldExpand: widget.tableData.shouldExpand),
          ...rowDataWithPossibleChildrenToTableRow(
              widget.tableData.listChildRow, widths: widget.tableData.minColumnWidths),
        ],
      ),
    );
  }

  Widget rowDataToTableRow(RowData input, List<double>? widths,
      {bool isGroupHeader = false,
      VoidCallback? expandAll,
      bool? isShouldExpand}) {
    return SizedBox(
      height: 49,
      child: Row(
        // todo figure out better key strategy
        // non expandable rows with object keys cause budget memo to crash
        key: input.key ?? (input.isExpandable ? ObjectKey(input) : null),
        children: List.generate(
          input.cells.length,
          (index) {
            if (index == 0 && input.children.isNotEmpty) {
              return TogglingCell(
                    key: Key(
                        input.expanded.toString() + input.cells.first.cellText),
                    text: input.cells[index].cellText,
                    isShown: input.expanded,
                    iconUrl: input.cells[index].iconUrl,
                    backgroundColor: input.backgroundColor,
                    padding: input.cells[index].padding ?? input.cellPadding,
                    textColor: input.textColor,
                    withCheckbox: input.withCheckBox,
                    isChecked: input.isChecked ?? false,
                    onCheckboxToggled: (value) {
                      if (input.onCheckboxToggled != null) {
                        input.onCheckboxToggled!(value);
                        setState(() {});
                      }
                    },
                    width: widths != null ? widths[index] : null,
                    onPressed: () {
                      setState(
                        () {
                          input.onPressed!();
                        },
                      );
                    },
                  );
            } else {
              return widget.allowEditableCells &&
                        input.cells[index].isEditable
                    ? EditableTableBodyCell(
                        key: input.cells[index].key,
                        text: input.cells[index].cellText,
                        sideColor: input.cells[index].sideColor,
                        isFocused:
                            input.cells[index].index == focusedEditableCellIndex,
                        // because incrementing [currentEditableCellIndex] happens in cell declaration
                        // we have to set [isLast] property after [editableCellIndex] property
                        editableCellIndex: input.cells[index].index,
                        showFormulaIndicator:
                            input.cells[index].showFormulaIndicator,
                        onFocused: (index) {
                          focusedEditableCellIndex = index;
                        },
                        cellBorderColor: input.cells[index].hasError
                            ? CustomColorScheme.inputErrorBorder
                            : input.cells[index].isHighlighted
                                ? CustomColorScheme.errorPopupButton
                                : null,
                        textColor:
                            input.cells[index].textColor ?? input.textColor,
                        backgroundColor: input.cells[index].backgroundColor ??
                            input.backgroundColor,
                        padding: input.cells[index].padding ?? input.cellPadding,
                        hasRightBorder: input.cells[index].hasRightBorder,
                        isBold: input.children.isNotEmpty || input.isBold,
                        isFirstInRow: index == 0,
                        labelType: input.labelType,
                        width: widths != null ? widths[index] : 100,
                        changeValue: (value) {
                          if (input.cells[index].changeValue != null) {
                            input.cells[index].changeValue!(value);
                          }
                        },
                        onRequestMovement: (cellIndex, CellMovement direction) {
                          resolveMovement(cellIndex, direction);
                        },
                        isNumeric: input.cells[index].isNumeric,
                        showManualIndicator:
                            input.cells[index].showManualIndicator,
                        showMemoNotifier: input.cells[index].showMemoNotifier ??
                            ValueNotifier<bool>(false),
                        onPointerDown: input.cells[index].onPointerDown,
                        onEnter: input.cells[index].onEnter,
                        onExit: input.cells[index].onExit,
                        cellTag: input.cells[index].cellTag,
                        onEqualSignPressed: input.cells[index].onEqualSignPressed == null
                            ? null
                            : () => setState(() {
                                  focusedEditableCellIndex = null;
                                  input.cells[index].onEqualSignPressed!.call();
                                }),
                      )
                    : TableBodyCell(
                        mainAxisAlignment: input.cells[index].mainAxisAlignment,
                        key: input.cells[index].key,
                        text: input.cells[index].cellText,
                        sideColor: input.cells[index].sideColor,
                        expandAll: (expandAll != null && index == 0)
                            ? () {
                                 expandAll();
                                 setState(() {

                                 });
                              }
                            : null,
                        hasHoverColor: input.cells[index].onTap != null ||
                            input.cells[index].onDoubleTap != null,
                        textColor:
                            input.cells[index].textColor ?? input.textColor,
                        backgroundColor: input.cells[index].backgroundColor ??
                            input.backgroundColor,
                        padding: input.cells[index].padding ?? input.cellPadding,
                        hasRightBorder: input.cells[index].hasRightBorder,
                        hasBottomBorder: input.hasBottomBorder ?? true,
                        ignoreFirstInRowProperty:
                            input.cells[index].ignoreFirstInRowProperty ?? false,
                        isBold: input.cells[index].isBold ??
                            input.children.isNotEmpty || input.isBold,
                        isFirstInRow: index == 0,
                        labelType:
                            input.cells[index].labelType ?? input.labelType,
                        width: widths != null ? widths[index] : 100,
                        iconUrl: input.cells[index].iconUrl,
                        tooltipMessage: input.cells[index].tooltipMessage,
                        onTap: input.cells[index].onTap ??
                            (isGroupHeader
                                ? () {
                                    setState(
                                      () {
                                        input.onPressed!();
                                      },
                                    );
                                  }
                                : null),
                        onDoubleTap: input.cells[index].onDoubleTap,
                        onPointerDown: input.cells[index].onPointerDown,
                        showManualIndicator:
                            input.cells[index].showManualIndicator,
                        showMemoNotifier: input.cells[index].showMemoNotifier ??
                            ValueNotifier<bool>(false),
                        onEnter: input.cells[index].onEnter,
                        onExit: input.cells[index].onExit,
                        cellTag: input.cells[index].cellTag,
                        isShouldExpand: isShouldExpand,
                      );
            }
          },
        ),
      ),
    );
  }

  List<Widget> rowDataWithPossibleChildrenToTableRow(List<RowData> input,
      {List<double>? widths}) {
    var output = <Widget>[];
    for (var i = 0; i < input.length; i++) {
      output.add(
        rowDataToTableRow(input[i], widths,
            isGroupHeader: input[i].children.isNotEmpty),
      );
      if (!input[i].expanded) continue;
      for (var j = 0; j < input[i].children.length; j++) {
        output.add(
          rowDataToTableRow(input[i].children[j], widths),
        );
      }
    }
    return output;
  }

  void resolveMovement(CellIndex cellIndex, CellMovement direction) {
    if (direction == CellMovement.unfocus) {
      focusedEditableCellIndex = null;
    } else if (direction == CellMovement.left) {
      focusedEditableCellIndex = widget.tableData.getLeft(cellIndex);
    } else if (direction == CellMovement.up) {
      focusedEditableCellIndex = widget.tableData.getUp(cellIndex);
    } else if (direction == CellMovement.down) {
      focusedEditableCellIndex = widget.tableData.getDown(cellIndex);
    } else {
      focusedEditableCellIndex = widget.tableData.getRight(cellIndex);
    }
    setState(() {});
  }
}

class TableData {
  RowData header;
  List<RowData> listChildRow;
  List<double>? minColumnWidths;
  VoidCallback? expandAll;

  TableData({
    required this.header,
    required this.listChildRow,
    this.minColumnWidths,
    this.expandAll,
  }) {
    var index = 0;
    for (var row in allRows) {
      row.index = index;
      index++;
      for (var cell in row.cells) {
        cell.index = CellIndex(row: row.index, column: row.cells.indexOf(cell));
      }
    }
  }

  int get columnCount => header.cells.length;

  List<RowData> get allRows {
    var result = [header];
    for (var row in listChildRow) {
      result.add(row);
      for (var childRow in row.children) {
        result.add(childRow);
      }
    }
    return result;
  }

  List<RowData> get visibleRows {
    var result = [header];
    for (var row in listChildRow) {
      result.add(row);
      if (row.expanded) {
        for (var childRow in row.children) {
          result.add(childRow);
        }
      }
    }
    return result;
  }

  bool get shouldExpand {
    var shouldExpand = false;
    for (var i = 0; i < listChildRow.length; i++) {
      if (listChildRow[i].expanded) {
        shouldExpand = true;
        break;
      } else {
        shouldExpand = false;
      }
    }
    return shouldExpand;
  }

  CellIndex getLeft(CellIndex cellIndex) {
    var currentRow = allRows[cellIndex.row];
    for (var index = cellIndex.column - 1; index >= 0; index--) {
      if (currentRow.cells[index].isEditable) {
        return currentRow.cells[index].index;
      } else {
        continue;
      }
    }
    return cellIndex;
  }

  CellIndex getRight(CellIndex cellIndex) {
    var currentRow = allRows[cellIndex.row];
    for (var index = cellIndex.column + 1; index < columnCount; index++) {
      if (currentRow.cells[index].isEditable) {
        return currentRow.cells[index].index;
      } else {
        continue;
      }
    }
    return cellIndex;
  }

  CellIndex getUp(CellIndex cellIndex) {
    for (var index = cellIndex.row - 1; index > 0; index--) {
      var prevRow =
          visibleRows.firstWhereOrNull((element) => element.index == index);
      if (prevRow != null && prevRow.cells[cellIndex.column].isEditable) {
        return prevRow.cells[cellIndex.column].index;
      }
    }
    return cellIndex;
  }

  CellIndex getDown(CellIndex cellIndex) {
    for (var index = cellIndex.row + 1; index < allRows.length; index++) {
      var nextRow =
          visibleRows.firstWhereOrNull((element) => element.index == index);
      if (nextRow != null && nextRow.cells[cellIndex.column].isEditable) {
        return nextRow.cells[cellIndex.column].index;
      }
    }
    return cellIndex;
  }
}

class RowData {
  final List<CellData> cells;
  final List<RowData> children;
  VoidCallback? onPressed;
  bool expanded;
  final LocalKey? key;
  final Color backgroundColor;
  final Color textColor;
  final EdgeInsets cellPadding;
  final bool isBold;
  final LabelType labelType;
  Function? toggleExpanded;
  Function? expandedAll;
  final bool withCheckBox;
  final Function? onCheckboxToggled;
  final bool? isChecked;
  final bool? hasBottomBorder;

  late final int index;

  bool get isExpandable => children.isNotEmpty;

  RowData({
    this.key,
    required this.cells,
    this.children = const <RowData>[],
    this.backgroundColor = const Color.fromRGBO(255, 238, 238, 1),
    this.onPressed,
    this.withCheckBox = false,
    this.onCheckboxToggled,
    this.textColor = const Color.fromRGBO(33, 33, 33, 1),
    this.cellPadding = const EdgeInsets.all(12),
    this.isBold = false,
    this.isChecked,
    this.labelType = LabelType.General,
    this.expanded = false,
    this.toggleExpanded,
    this.expandedAll,
    this.hasBottomBorder,
  }) {
    onPressed = () {
      if (children.isNotEmpty) {
        expanded = !expanded;
        if (toggleExpanded != null) {
          toggleExpanded!(expanded);
        }
      }
    };
  }
}

class CellData {
  final Key? key;
  final String cellText;
  final Color? textColor;
  final bool isEditable;
  final Color? backgroundColor;
  final Color? sideColor;
  final LabelType? labelType;
  final bool hasRightBorder;
  final bool? isBold;
  final bool? ignoreFirstInRowProperty;
  final double? width;
  final String? iconUrl;
  final Function? changeValue;
  final bool isNumeric;
  final EdgeInsets? padding;
  final String? tooltipMessage;
  final bool isFocused;
  final VoidCallback? onTap;
  final VoidCallback? onDoubleTap;
  final VoidCallback? onEqualSignPressed;
  final bool showManualIndicator;
  final bool showFormulaIndicator;
  final void Function(PointerDownEvent)? onPointerDown;
  final ValueNotifier<bool>? showMemoNotifier;
  final void Function(PointerEvent)? onExit;
  final void Function(PointerEvent)? onEnter;
  final String? cellTag;
  final bool hasError;
  final bool isHighlighted;
  final MainAxisAlignment? mainAxisAlignment;
  late final CellIndex index;

  CellData(
    this.cellText, {
    this.key,
    this.hasError = false,
    this.textColor,
    this.isEditable = false,
    this.iconUrl,
    this.ignoreFirstInRowProperty,
    this.hasRightBorder = true,
    this.backgroundColor,
    this.sideColor,
    this.width,
    this.isBold,
    this.changeValue,
    this.labelType,
    this.padding,
    this.isFocused = false,
    this.isNumeric = true,
    this.tooltipMessage,
    this.onTap,
    this.showManualIndicator = false,
    this.showFormulaIndicator = false,
    this.onDoubleTap,
    this.onEqualSignPressed,
    this.onPointerDown,
    this.showMemoNotifier,
    this.onExit,
    this.onEnter,
    this.cellTag,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.isHighlighted = false,
  });
}

class CellIndex with EquatableMixin {
  final int row;
  final int column;

  CellIndex({required this.row, required this.column});

  @override
  List<Object?> get props => [row, column];

  @override
  String toString() => '[$row, $column]';
}
