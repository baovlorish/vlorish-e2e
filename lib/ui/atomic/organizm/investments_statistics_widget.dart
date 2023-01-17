import 'dart:collection';

import 'package:burgundy_budgeting_app/domain/model/response/index_funds_response.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_inkwell.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/label.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/theme.dart';
import 'package:burgundy_budgeting_app/ui/atomic/organizm/overlay_menu.dart';
import 'package:burgundy_budgeting_app/ui/atomic/organizm/statistics_widget.dart';
import 'package:burgundy_budgeting_app/ui/model/statistic_model.dart';
import 'package:burgundy_budgeting_app/ui/screen/investments/investments/investments_cubit.dart';
import 'package:burgundy_budgeting_app/ui/screen/investments/investments/investments_state.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InvestmentsStatisticsWidget extends StatefulWidget {
  final InvestmentsDashboardModel dashboardData;

  const InvestmentsStatisticsWidget(this.dashboardData, {Key? key})
      : super(key: key);

  @override
  _InvestmentsStatisticsWidgetState createState() =>
      _InvestmentsStatisticsWidgetState();
}

class _InvestmentsStatisticsWidgetState
    extends State<InvestmentsStatisticsWidget> {
  bool withPercent = false;

  late var investmentsCubit = BlocProvider.of<InvestmentsCubit>(context);

  var hintMap = {
    'Index/funds': 'Includes Index funds, ETFs and mutual funds',
    'Inv. Properties': 'Real Estate only. Excludes residential',
    'Startups': 'Angel investments, startup financing, crowdfunded investments',
    'Other':
        'All other investments that are not covered in other asset types above',
  };

  var names = [
    'Stocks',
    'Index/funds',
    'Cryptocurrency',
    'Inv. Properties',
    'Startups',
    'Other',
  ];

  double calculateSelectedTotal(List<bool> selected) {
    var sumOfSelected = 0.0;
    for (var index = 0; index < selected.length; index++) {
      if (selected[index] &&
          widget.dashboardData.items
              .any((element) => element.type == index + 1)) {
        sumOfSelected += widget.dashboardData.items
            .firstWhere((element) => element.type == index + 1)
            .currentCost;
      }
    }
    if (sumOfSelected == 0) return 1;
    return sumOfSelected;
  }

  List<int> calculatePercents(List<bool> selected, double totalForSelected) {
    var percents = <int>[];
    var afterDotPercents = <int, int>{};

    var items = <InvestmentsDashboardItem>[];
    if (selected.length > widget.dashboardData.items.length) {
      for (var i = 0; i < selected.length; i++) {
        var dashboardItem = InvestmentsDashboardItem(
          type: i + 1,
          currentCost: 0,
          initialCost: 0,
        );
        if (widget.dashboardData.items.contains(dashboardItem)) {
          items.add(widget.dashboardData.items
              .firstWhere((element) => element.type == i + 1));
        } else {
          items.add(dashboardItem);
        }
      }
    } else {
      items = [...widget.dashboardData.items];
    }

    for (var index = 0; index < selected.length; index++) {
      var element = items.firstWhere((element) => element.type == index + 1);

      percents.add((element.currentCost * 100) ~/ totalForSelected);

      var afterDotElementPercent =
          ((element.currentCost * 100) / totalForSelected) % 1 * 100 ~/ 1;

      if (afterDotElementPercent != 0 && selected[index]) {
        afterDotPercents.putIfAbsent(index, () => afterDotElementPercent);
      }
    }
    var selectedPercents = <int>[];
    for (var index = 0; index < selected.length; index++) {
      if (selected[index]) {
        selectedPercents.add(percents[index]);
      } else {
        selectedPercents.add(0);
      }
    }

    var sortedKeys = afterDotPercents.keys.toList(growable: false)
      ..sort((k1, k2) =>
          afterDotPercents[k1]!.compareTo(afterDotPercents[k2] as int));

    var sortedMap = LinkedHashMap.fromIterable(sortedKeys.reversed,
        key: (k) => k, value: (k) => afterDotPercents[k]);

    var sortedMapForCorrectingPercents = sortedMap.keys.toList();

    if (selected.where((item) => item == true).isNotEmpty &&
        totalForSelected > 1) {
      while (selectedPercents.sum < 100) {
        for (var i in sortedMapForCorrectingPercents) {
          selectedPercents[i]++;
          if (selectedPercents.sum == 100) break;
        }
      }
    }
    return selectedPercents;
  }

  @override
  Widget build(BuildContext context) {
    var selected =
        ((investmentsCubit.state) as InvestmentsLoaded).selectedAllocations;

    var models = <StatisticModel>[];
    var totalForSelected = calculateSelectedTotal(selected);
    var percents = calculatePercents(selected, totalForSelected);

    for (var index = 0; index < selected.length; index++) {
      if (selected[index]) {
        if (widget.dashboardData.items
            .any((element) => element.type == index + 1)) {
          var element = widget.dashboardData.items
              .firstWhere((element) => element.type == index + 1);

          models.add(
            StatisticModel(
                amount: element.currentCost,
                name: names[index],
                hint: hintMap[names[index]],
                color: widget.dashboardData.statisticColors[index],
                totalAmount: totalForSelected,
                progress: percents[index]),
          );
        } else {
          models.add(
            StatisticModel(
                amount: 0,
                name: names[index],
                hint: hintMap[names[index]],
                color: widget.dashboardData.statisticColors[index],
                totalAmount: 0,
                progress: 0),
          );
        }
      }
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
                      text: 'Asset allocations',
                      type: LabelType.Header3,
                      fontSize: 18,
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    ModalAnchor(
                      tag: 'ia',
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

  void showOptions(List<bool> selected, InvestmentsCubit cubit) {
    showModal(
      ModalEntry.anchored(
        context,
        anchorAlignment: Alignment.topRight,
        modalAlignment: Alignment.topLeft,
        barrierDismissible: true,
        anchorTag: 'ia',
        tag: 'iaModal',
        child: BlocProvider<InvestmentsCubit>.value(
          value: cubit,
          child: BlocBuilder<InvestmentsCubit, InvestmentsState>(
              builder: (context, state) {
            return Container(
              color: Colors.white,
              width: 170,
              key: UniqueKey(),
              child: AllocationsSelector(
                  (state as InvestmentsLoaded).selectedAllocations, cubit),
            );
          }),
        ),
      ),
    );
  }
}

class AllocationsSelector extends StatefulWidget {
  final List<bool> selected;
  final InvestmentsCubit cubit;

  const AllocationsSelector(this.selected, this.cubit, {Key? key})
      : super(key: key);

  @override
  _AllocationsSelectorState createState() => _AllocationsSelectorState();
}

class _AllocationsSelectorState extends State<AllocationsSelector> {
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
                      widget.cubit.changeAllocations(
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
