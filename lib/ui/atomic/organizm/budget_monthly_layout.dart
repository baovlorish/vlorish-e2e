import 'package:burgundy_budgeting_app/ui/atomic/molecula/expanded_two_axis_scrollable_widget.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/month_dashboard.dart';
import 'package:burgundy_budgeting_app/ui/atomic/organizm/toggling_rows_table.dart';
import 'package:flutter/material.dart';

class BudgetMonthlyLayout extends StatefulWidget {
  final TableData tableData;
  final DashboardData dashboardData;
  final double? verticalScrollOffset;
  final double? horizontalScrollOffset;
  final Function(double) onVerticalScrollOffset;
  final Function(double) onHorizontalScrollOffset;
  final VoidCallback? onUnbudgeted;

  const BudgetMonthlyLayout({
    required this.tableData,
    required this.dashboardData,
    this.verticalScrollOffset,
    this.horizontalScrollOffset,
    required this.onVerticalScrollOffset,
    required this.onHorizontalScrollOffset,
    required this.onUnbudgeted,
  });

  @override
  State<BudgetMonthlyLayout> createState() => _BudgetMonthlyLayoutState();
}

class _BudgetMonthlyLayoutState extends State<BudgetMonthlyLayout> {
  @override
  Widget build(BuildContext context) {
    var isSmall = MediaQuery.of(context).size.width < 1400;
    return ExpandedTwoAxisScrollableWidget(
      padding: 18.0,
      horizontalScrollOffset: widget.horizontalScrollOffset ?? 0,
      verticalScrollOffset: widget.verticalScrollOffset ?? 0,
      onHorizontalScrollOffset: (value) {
        widget.onHorizontalScrollOffset(value);
      },
      onVerticalScrollOffset: (value) {
        widget.onVerticalScrollOffset(value);
      },
      hasBackground: true,
      child: Flex(
        direction: isSmall ? Axis.vertical : Axis.horizontal,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isSmall)
            MonthDashboard(
              isVertical: !isSmall,
              data: widget.dashboardData,
              onUnbudgeted: widget.onUnbudgeted,
            ),
          TogglingRowsTable(
            tableData: widget.tableData,
          ),
          if (!isSmall)
            MonthDashboard(
              isVertical: !isSmall,
              data: widget.dashboardData,
              onUnbudgeted: widget.onUnbudgeted,
            ),
        ],
      ),
    );
  }
}
