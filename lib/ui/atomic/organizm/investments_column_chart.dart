import 'package:burgundy_budgeting_app/domain/model/response/index_funds_response.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_inkwell.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/label.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/theme.dart';
import 'package:burgundy_budgeting_app/ui/atomic/organizm/overlay_menu.dart';
import 'package:burgundy_budgeting_app/ui/screen/investments/investments/investments_cubit.dart';
import 'package:burgundy_budgeting_app/ui/screen/investments/investments/investments_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class InvestmentsColumnChart extends StatefulWidget {
  final InvestmentsDashboardModel data;

  const InvestmentsColumnChart({Key? key, required this.data})
      : super(key: key);

  @override
  State<InvestmentsColumnChart> createState() => _InvestmentsColumnChartState();
}

class _InvestmentsColumnChartState extends State<InvestmentsColumnChart> {
  late var investmentsCubit = BlocProvider.of<InvestmentsCubit>(context);
  late var items = List.from(widget.data.items);

  late var xMapper = [
    'Stocks',
    'Index\nfunds',
    'Crypto\ncurrency',
    'Inv.\nProperties',
    'Startups',
    'Other',
  ];

  @override
  Widget build(BuildContext context) {
    var selected = ((investmentsCubit.state) as InvestmentsLoaded)
        .selectedInvestmentsGrowth;

    var data = <InvestmentsChartData>[];
    for (var index = 0; index < selected.length; index++) {
      if (selected[index]) {
        if (widget.data.items.any((element) => element.type == index + 1)) {
          var element = widget.data.items
              .firstWhere((element) => element.type == index + 1);
          data.add(InvestmentsChartData(element.currentCost));
        } else {
          data.add(InvestmentsChartData.empty());
        }
      }
    }

    var mapper = <String>[];
    for (var index = 0; index < selected.length; index++) {
      if (selected[index]) {
        mapper.add(xMapper[index]);
      }
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Label(
                type: LabelType.Header3,
                text: 'Investments growth',
                fontSize: 18,
              ),
            ),
            ModalAnchor(
              tag: 'ig',
              child: CustomMaterialInkWell(
                onTap: () {
                  showOptions(selected, investmentsCubit);
                },
                type: InkWellType.Purple,
                borderRadius: BorderRadius.circular(4),
                child: Container(
                  height: 30,
                  width: 30,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(15)),
                  child: Icon(
                    Icons.more_vert,
                    color: CustomColorScheme.text,
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          width: 520,
          height: 320,
          child: Stack(
            children: [
              if (widget.data.items.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 48.0),
                    child: Label(
                      text: AppLocalizations.of(context)!.noData,
                      type: LabelType.HintLargeBold,
                      color: CustomColorScheme.inputBorder,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              SfCartesianChart(
                primaryXAxis: CategoryAxis(),
                primaryYAxis: NumericAxis(
                  numberFormat: NumberFormat.compactSimpleCurrency(),
                ),
                series: <ChartSeries<InvestmentsChartData, String>>[
                  ColumnSeries<InvestmentsChartData, String>(
                    dataSource: data,
                    xValueMapper: (InvestmentsChartData data, index) =>
                        mapper[index],
                    yValueMapper: (InvestmentsChartData data, _) => data.value,
                    color: CustomColorScheme.errorPopupButton,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  void showOptions(List<bool> selected, InvestmentsCubit cubit) {
    showModal(
      ModalEntry.anchored(
        context,
        anchorAlignment: Alignment.topRight,
        modalAlignment: Alignment.topLeft,
        barrierDismissible: true,
        anchorTag: 'ig',
        tag: 'igModal',
        child: BlocProvider<InvestmentsCubit>.value(
          value: cubit,
          child: BlocBuilder<InvestmentsCubit, InvestmentsState>(
              builder: (context, state) {
            return Container(
              color: Colors.white,
              width: 170,
              key: UniqueKey(),
              child: InvestmentGrowthSelector(
                  (state as InvestmentsLoaded).selectedInvestmentsGrowth,
                  cubit),
            );
          }),
        ),
      ),
    );
  }
}

class InvestmentGrowthSelector extends StatefulWidget {
  final List<bool> selected;
  final InvestmentsCubit cubit;

  const InvestmentGrowthSelector(this.selected, this.cubit, {Key? key})
      : super(key: key);

  @override
  _InvestmentGrowthSelectorState createState() =>
      _InvestmentGrowthSelectorState();
}

class _InvestmentGrowthSelectorState extends State<InvestmentGrowthSelector> {
  late var selected = widget.selected;

  @override
  Widget build(BuildContext context) {
    var items = {
      'Stocks': selected[0],
      'Index/funds': selected[1],
      'Cryptocurrency': selected[2],
      'Inv. Properties': selected[3],
      'Startups': selected[4],
      'Other': selected[5],
    };
    return Material(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var item in items.entries.toList())
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Row(
                children: [
                  Checkbox(
                    splashRadius: 0.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    value: item.value,
                    onChanged: (newValue) {
                      widget.cubit.changeInvestmentGrowth(
                          items.entries
                              .toList()
                              .indexWhere((element) => element.key == item.key),
                          newValue ?? false);
                    },
                  ),
                  Label(text: item.key, type: LabelType.General),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class InvestmentsChartData {
  InvestmentsChartData(
    this.value,
  );

  factory InvestmentsChartData.empty() => InvestmentsChartData(0);

  final double value;
}
