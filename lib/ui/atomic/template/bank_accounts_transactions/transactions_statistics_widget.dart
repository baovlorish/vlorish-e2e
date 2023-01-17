import 'package:burgundy_budgeting_app/ui/atomic/atom/label.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/largest_transactions.dart';
import 'package:burgundy_budgeting_app/ui/atomic/organizm/statistics_widget.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/bank_accounts_transactions/bank_accounts_and_statistics/bank_accounts_and_statistics_bloc.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/bank_accounts_transactions/bank_accounts_and_statistics/bank_accounts_and_statistics_events.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/bank_accounts_transactions/bank_accounts_and_statistics/bank_accounts_and_statistics_state.dart';
import 'package:burgundy_budgeting_app/ui/model/statistic_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TransactionsStatisticsWidget extends StatefulWidget {
  final bool moveStatsToTheTop;
  final Function(String) setValueToSearchBar;

  TransactionsStatisticsWidget({
    required this.moveStatsToTheTop,
    required this.setValueToSearchBar,
  });

  @override
  State<TransactionsStatisticsWidget> createState() =>
      _TransactionsStatisticsWidgetState();
}

class _TransactionsStatisticsWidgetState
    extends State<TransactionsStatisticsWidget> {
  final _largestTransactionScrollController = ScrollController();
  double? initialScrollOffset;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BankAccountsAndStatisticsBloc,
        BankAccountsAndStatisticsState>(
      builder: (context, state) => ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(
          scrollbars: true,
        ),
        child: Column(
          crossAxisAlignment: widget.moveStatsToTheTop
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Label(
                text: AppLocalizations.of(context)!.topMerchants,
                type: LabelType.Header3,
              ),
            ),
            Flexible(
              flex: 2,
              fit: widget.moveStatsToTheTop ? FlexFit.loose : FlexFit.tight,
              child: StatisticsWidget(
                key: ObjectKey(state),
                initialScrollOffset: initialScrollOffset ?? 0,
                onScrollOffsetChanged: (offset) {
                  initialScrollOffset = offset;
                },
                onTap: (String value) {
                  widget.setValueToSearchBar(value);
                  BlocProvider.of<BankAccountsAndStatisticsBloc>(context).add(
                    SearchTransactionEvent(value),
                  );
                },
                isHorizontal: widget.moveStatsToTheTop,
                withPercent: false,
                presetSum: (state is BankAccountsAndStatisticsLoaded)
                    ? state.statisticsModel.totalExpensesByTopMerchants
                    : null,
                models: (state is BankAccountsAndStatisticsLoaded)
                    ? [
                        for (var item in state.statisticsModel.merchants)
                          StatisticModel.fromMerchant(item)
                      ]
                    : [],
                emptyStateHeader: AppLocalizations.of(context)!.noMerchants,
                emptyStateDescription: AppLocalizations.of(context)!
                    .thisSectionWellDisplayMerchantsStatistics,
              ),
            ),
            if (state is BankAccountsAndStatisticsLoaded &&
                state.statisticsModel.largestTransactions.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Label(
                  text: AppLocalizations.of(context)!.topTransactions,
                  type: LabelType.Header3,
                ),
              ),
            if (state is BankAccountsAndStatisticsLoaded &&
                state.statisticsModel.largestTransactions.isNotEmpty)
              Flexible(
                flex: 1,
                fit: widget.moveStatsToTheTop ? FlexFit.loose : FlexFit.tight,
                child: Scrollbar(
                  thumbVisibility: true,
                  interactive: true,
                  controller: _largestTransactionScrollController,
                  child: SingleChildScrollView(
                    controller: _largestTransactionScrollController,
                    scrollDirection: widget.moveStatsToTheTop
                        ? Axis.horizontal
                        : Axis.vertical,
                    child: LargestTransactions(
                      transactions: state.statisticsModel.largestTransactions,
                      moveOnTop: widget.moveStatsToTheTop,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
