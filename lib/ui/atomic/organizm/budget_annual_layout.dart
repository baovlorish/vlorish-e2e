import 'package:burgundy_budgeting_app/ui/atomic/atom/theme.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/expanded_two_axis_scrollable_widget.dart';
import 'package:burgundy_budgeting_app/ui/atomic/organizm/toggling_rows_table.dart';
import 'package:burgundy_budgeting_app/ui/screen/budget/budget_bloc.dart';
import 'package:burgundy_budgeting_app/ui/screen/budget/budget_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BudgetAnnualLayout extends StatefulWidget {
  final TableData tableData;
  final double? verticalScrollOffset;
  final double? horizontalScrollOffset;
  final Function(double) onVerticalScrollOffset;
  final Function(double) onHorizontalScrollOffset;

  const BudgetAnnualLayout({
    this.verticalScrollOffset,
    this.horizontalScrollOffset,
    required this.tableData,
    required this.onVerticalScrollOffset,
    required this.onHorizontalScrollOffset,
  });

  @override
  State<BudgetAnnualLayout> createState() => _BudgetAnnualLayoutState();
}

class _BudgetAnnualLayoutState extends State<BudgetAnnualLayout> {
  @override
  Widget build(BuildContext context) {
    var budgetBloc = BlocProvider.of<BudgetBloc>(context);
    return ExpandedTwoAxisScrollableWidget(
      horizontalScrollOffset: widget.horizontalScrollOffset ?? 0,
      verticalScrollOffset: widget.verticalScrollOffset ?? 0,
      onHorizontalScrollOffset: (value) {
        widget.onHorizontalScrollOffset(value);
      },
      onVerticalScrollOffset: (value) {
        widget.onVerticalScrollOffset(value);
      },
      padding: 16.0,
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: IntrinsicWidth(
          child: Column(children: [
            if (budgetBloc.state is BudgetAnnualLoadedState)
              (budgetBloc.state as BudgetAnnualLoadedState)
                      .showCopyMonthAnimation
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: SizedBox(
                        height: 16,
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(
                            Radius.circular(4),
                          ),
                          child: LinearProgressIndicator(),
                        ),
                      ),
                    )
                  : SizedBox(),
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    blurRadius: 6.0,
                    color: CustomColorScheme.tableBorder,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5.0),
                child: TogglingRowsTable(
                  tableData: widget.tableData,
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
