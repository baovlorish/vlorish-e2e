import 'package:burgundy_budgeting_app/domain/model/response/retirements_models.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_inkwell.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/label.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/theme.dart';
import 'package:burgundy_budgeting_app/ui/atomic/organizm/overlay_menu.dart';
import 'package:burgundy_budgeting_app/ui/atomic/organizm/statistics_widget.dart';
import 'package:burgundy_budgeting_app/ui/model/statistic_model.dart';
import 'package:burgundy_budgeting_app/ui/screen/investments/investments/investments_cubit.dart';
import 'package:burgundy_budgeting_app/ui/screen/investments/investments/investments_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RetirementStatisticsWidget extends StatefulWidget {
  final RetirementPageModel dashboardData;
  final List<String> xMapper;

  const RetirementStatisticsWidget(this.dashboardData,
      {Key? key, required this.xMapper})
      : super(key: key);

  @override
  _RetirementStatisticsWidgetState createState() =>
      _RetirementStatisticsWidgetState();
}

class _RetirementStatisticsWidgetState
    extends State<RetirementStatisticsWidget> {
  bool withPercent = false;

  late var investmentsCubit = BlocProvider.of<InvestmentsCubit>(context);

  late var names = widget.xMapper;

  @override
  Widget build(BuildContext context) {
    var selected =
        ((investmentsCubit.state) as InvestmentsLoaded).retirementAllocations;

    var models = <StatisticModel>[];
    var totalForSelected = 0.0;
    for (var index = 1; index < 14; index++) {
      if (widget.dashboardData.models
          .any((element) => element.retirementType == index)) {
        totalForSelected += (widget.dashboardData.chartValues[index] ?? 0);
        ;
      }
    }

    StatisticModel? lastNotEmptyItem;
    var lastNotEmptyIndex=0;
    var _progress = <int>[];

    for (var index = 1; index < 14; index++) {
      if (selected.any((element) => element == index)) {
        var progress = ((widget.dashboardData.chartValues[index] ?? 0) * 100) ~/
            totalForSelected;
        var model = StatisticModel(
            amount: widget.dashboardData.chartValues[index] ?? 0,
            name: widget.dashboardData.typeMap[index] ?? '',
            color: widget.dashboardData.statisticColors[index - 1],
            totalAmount: totalForSelected,
            progress: progress);
        models.add(model);
        _progress.add(progress);
        if (progress != 0) {
          lastNotEmptyItem = model;
          lastNotEmptyIndex = models.length - 1;
        }
      }
    }
    if (lastNotEmptyItem != null) {
      var leftProgress = 0;
      for (var i=0; i<_progress.length; i++){
        if(i!=lastNotEmptyIndex){
          leftProgress+=_progress[i];
        }
      }
      models[lastNotEmptyIndex]=StatisticModel(
          amount: lastNotEmptyItem.amount,
          name: lastNotEmptyItem.name,
          color: lastNotEmptyItem.color,
          totalAmount: totalForSelected,
          progress: 100-leftProgress);
    }
    return IntrinsicWidth(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Label(
                      text: 'Retirement allocations',
                      type: LabelType.Header3,
                      fontSize: 18,
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    ModalAnchor(
                      tag: 'ira',
                      child: CustomMaterialInkWell(
                        onTap: () {
                          showOptions(selected, investmentsCubit);
                        },
                        type: InkWellType.Purple,
                        borderRadius: BorderRadius.circular(4),
                        child: Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15)),
                          child: Icon(
                            Icons.more_vert,
                            color: CustomColorScheme.text,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomMaterialInkWell(
                      type: InkWellType.Purple,
                      borderRadius: BorderRadius.circular(4),
                      onTap: () {
                        withPercent = false;
                        setState(() {});
                      },
                      child: Label(
                        text: '\$',
                        type: LabelType.Header3,
                        fontSize: 18,
                        color: withPercent
                            ? CustomColorScheme.clipElementInactive
                            : CustomColorScheme.mainDarkBackground,
                      ),
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    CustomMaterialInkWell(
                      type: InkWellType.Purple,
                      borderRadius: BorderRadius.circular(4),
                      onTap: () {
                        withPercent = true;
                        setState(() {});
                      },
                      child: Label(
                        text: '%',
                        type: LabelType.Header3,
                        fontSize: 18,
                        color: withPercent
                            ? CustomColorScheme.mainDarkBackground
                            : CustomColorScheme.clipElementInactive,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          StatisticsWidget(
              splitColumns: false,
              key: UniqueKey(),
              models: models,
              isHorizontal: true,
              emptyStateHeader: '',
              emptyStateDescription: '',
              showSumWithPercent: false,
              withPercent: withPercent),
        ],
      ),
    );
  }

  void showOptions(List<int> selected, InvestmentsCubit cubit) {
    showModal(
      ModalEntry.anchored(
        context,
        anchorAlignment: Alignment.topRight,
        modalAlignment: Alignment.topLeft,
        barrierDismissible: true,
        anchorTag: 'ira',
        tag: 'iraModal',
        child: BlocProvider<InvestmentsCubit>.value(
          value: cubit,
          child: BlocBuilder<InvestmentsCubit, InvestmentsState>(
              builder: (context, state) {
            return Container(
              color: Colors.white,
              width: 170,
              key: UniqueKey(),
              child: AllocationsSelector(selected, cubit),
            );
          }),
        ),
      ),
    );
  }
}

class AllocationsSelector extends StatefulWidget {
  final List<int> selected;
  final InvestmentsCubit cubit;

  const AllocationsSelector(
    this.selected,
    this.cubit, {
    Key? key,
  }) : super(key: key);

  @override
  _AllocationsSelectorState createState() => _AllocationsSelectorState();
}

class _AllocationsSelectorState extends State<AllocationsSelector> {
  late var selected = widget.selected;

  @override
  Widget build(BuildContext context) {
    var items = {};
    (widget.cubit.state as InvestmentsLoaded)
        .retirements!
        .typeMap
        .forEach((key, value) {
      items[key] = false;
    });
    for (var item in selected) {
      items[item] = true;
    }
    return Material(
      key: UniqueKey(),
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
                      widget.cubit.changeRetirementAllocations(
                          item.key, newValue ?? false);
                      setState(() {});
                    },
                  ),
                  Label(
                      text: (widget.cubit.state as InvestmentsLoaded)
                              .retirements!
                              .typeMap[item.key] ??
                          '',
                      type: LabelType.General),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
