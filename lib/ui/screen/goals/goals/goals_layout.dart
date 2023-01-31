import 'package:burgundy_budgeting_app/ui/atomic/atom/back_button.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_divider.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_loading_indicator.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_vertical_devider.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/label.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/theme.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/button_item.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/button_item_transparent.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/empty_widget.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/error_alert_dialog.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/inform_alert_dialog.dart';
import 'package:burgundy_budgeting_app/ui/atomic/organizm/goal_widget.dart';
import 'package:burgundy_budgeting_app/ui/atomic/organizm/period_selector.dart';
import 'package:burgundy_budgeting_app/ui/atomic/organizm/statistics_widget.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/home_screen/home_screen.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/home_screen/home_screen_cubit.dart';
import 'package:burgundy_budgeting_app/ui/model/goal.dart';
import 'package:burgundy_budgeting_app/ui/screen/goals/goals/goals_cubit.dart';
import 'package:burgundy_budgeting_app/ui/screen/goals/goals/goals_state.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GoalsLayout extends StatefulWidget {
  final bool isArchived;

  const GoalsLayout({Key? key, this.isArchived = false}) : super(key: key);

  @override
  State<GoalsLayout> createState() => _GoalsLayoutState();
}

class _GoalsLayoutState extends State<GoalsLayout> {
  List<Goal> goals = [];

  bool isSmall = false;
  bool isLarge = false;
  bool moveStatsToTheTop = false;

  String selectedYear = DateTime.now().year.toString();

  var controller = ScrollController();
  late final GoalsCubit _goalsCubit;
  late final HomeScreenCubit _homeScreenCubit;
  @override
  void initState() {
    _goalsCubit = BlocProvider.of<GoalsCubit>(context);
    _homeScreenCubit = BlocProvider.of<HomeScreenCubit>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    isSmall = MediaQuery.of(context).size.width < 1170;
    isLarge = MediaQuery.of(context).size.width > 2240;
    moveStatsToTheTop = MediaQuery.of(context).size.width < 1500;

    // if (isVerySmall && goals.length % 2 != 0) {
    //   goals
    //       .add(Container(color: CustomColorScheme.blockBackground));
    // } else if (isLarge && goals.length % 3 != 0) {
    //   goals
    //       .add(Container(color: CustomColorScheme.blockBackground));
    //   if (goals.length % 2 == 0) {
    //     goals.add(
    //         Container(color: CustomColorScheme.blockBackground));
    //   }
    // }

    return BlocConsumer<GoalsCubit, GoalsState>(
      listener: (BuildContext context, state) {
        if (state is GoalsErrorState) {
          showDialog(
            context: context,
            builder: (context) {
              return ErrorAlertDialog(
                context,
                message: state.error,
                onButtonPress: () {
                  state.callback!();
                },
              );
            },
          );
        }
      },
      builder: (context, state) {
        if (state is GoalsLoaded) {
          goals = state.goals
              .where((element) =>
                  element.endDate.year >= int.parse(selectedYear) &&
                  element.startDate.year <= int.parse(selectedYear))
              .toList();
        }

        return HomeScreen(
          currentTab: Tabs.Goals,
          title: AppLocalizations.of(context)!.goals,
          headerWidget: (state is GoalsLoaded)
              ? widget.isArchived
                  ? _buildArchivedHeaderPage(
                      context,
                      allGoals: state.goals,
                      goalsByYear: state.goalsByYear,
                      onYearChanged: () {
                        setState(() {});
                      },
                    )
                  : _buildHeaderPage(
                      context,
                      allGoals: state.goals,
                      goalsByYear: state.goalsByYear,
                      onYearChanged: () {
                        setState(() {});
                      },
                    )
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Label(
                    text: AppLocalizations.of(context)!.goals,
                    type: LabelType.Header2,
                  ),
                ),
          bodyWidget: (state is GoalsLoading)
              ? CustomLoadingIndicator()
              : (state is! GoalsLoaded)
                  ? Container()
                  : Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Container(
                          decoration: BoxDecoration(
                            color:
                                CustomColorScheme.blockBackground,
                            borderRadius: BorderRadius.circular(5),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 10.0,
                                color:
                                    CustomColorScheme.tableBorder,
                              ),
                            ],
                          ),
                          child: moveStatsToTheTop
                              ? SingleChildScrollView(
                                  primary: true,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Label(
                                          text: AppLocalizations.of(context)!
                                              .statistics,
                                          type: LabelType.Header3,
                                        ),
                                      ),
                                      StatisticsWidget(
                                        key: UniqueKey(),
                                        isHorizontal: !isLarge,
                                        withPercent: true,
                                        models: Goal.mapToStatisticModel(goals),
                                        emptyStateHeader:
                                            AppLocalizations.of(context)!
                                                .noGoals,
                                        emptyStateDescription: widget.isArchived
                                            ? AppLocalizations.of(context)!
                                                .thisSectionWellDisplayArchivedGoalsStatistics
                                            : AppLocalizations.of(context)!
                                                .thisSectionWellDisplayGoalsStatistics,
                                      ),
                                      CustomDivider(),
                                      goals.isNotEmpty
                                          ? _goalsTable(context, goals)
                                          : Center(
                                              child: EmptyWidget(
                                                iconUrl:
                                                    'assets/images/goal_ph.png',
                                                title: AppLocalizations.of(
                                                        context)!
                                                    .noGoals,
                                                subtitle: widget.isArchived
                                                    ? AppLocalizations.of(
                                                            context)!
                                                        .thisSectionWillDisplayYourArchivedGoals
                                                    : AppLocalizations.of(
                                                            context)!
                                                        .thisSectionWillDisplayYourGoals,
                                              ),
                                            ),
                                    ],
                                  ),
                                )
                              : Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: goals.isNotEmpty
                                          ? _goalsTable(context, goals)
                                          : Center(
                                              child: EmptyWidget(
                                                iconUrl:
                                                    'assets/images/goal_ph.png',
                                                title: AppLocalizations.of(
                                                        context)!
                                                    .noGoals,
                                                subtitle: widget.isArchived
                                                    ? AppLocalizations.of(
                                                            context)!
                                                        .thisSectionWillDisplayYourArchivedGoals
                                                    : AppLocalizations.of(
                                                            context)!
                                                        .thisSectionWillDisplayYourGoals,
                                              ),
                                            ),
                                    ),
                                    CustomVerticalDivider(),
                                    Expanded(
                                      flex: 1,
                                      child: SingleChildScrollView(
                                        controller: controller,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(16.0),
                                              child: Label(
                                                text: AppLocalizations.of(
                                                        context)!
                                                    .statistics,
                                                type: LabelType.Header3,
                                              ),
                                            ),
                                            StatisticsWidget(
                                              key: UniqueKey(),
                                              isHorizontal: false,
                                              withPercent: true,
                                              models: Goal.mapToStatisticModel(
                                                  goals),
                                              emptyStateHeader:
                                                  AppLocalizations.of(context)!
                                                      .noGoals,
                                              emptyStateDescription: widget
                                                      .isArchived
                                                  ? AppLocalizations.of(
                                                          context)!
                                                      .thisSectionWellDisplayArchivedGoalsStatistics
                                                  : AppLocalizations.of(
                                                          context)!
                                                      .thisSectionWellDisplayGoalsStatistics,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ),
        );
      },
    );
  }

  Widget _buildHeaderPage(
    BuildContext context, {
    required List<Goal> allGoals,
    required Map<int, List<Goal>> goalsByYear,
    required Function() onYearChanged,
  }) {
    var yearsLabel = <String>[];
    goalsByYear.forEach((key, value) {
      yearsLabel.add(key.toString());
    });
    selectedYear = DateTime.now().year.toString();

    var content = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Label(
              text: AppLocalizations.of(context)!.goals,
              type: LabelType.Header2,
            ),
            if (!isSmall) SizedBox(width: 80),
            PeriodSelector(
              Key('1'),
              isSmall: true,
              defaultPosition:
                  yearsLabel.isNotEmpty && yearsLabel.contains(selectedYear)
                      ? yearsLabel.indexOf(selectedYear)
                      : 0,
              labelTexts: yearsLabel.isNotEmpty
                  ? yearsLabel
                  : [DateTime.now().year.toString()],
              onPressed: (selectedPosition) {
                selectedYear = yearsLabel.isNotEmpty
                    ? yearsLabel[selectedPosition]
                    : DateTime.now().year.toString();
                onYearChanged();
              },
            ),
          ],
        ),
        Row(
          children: [
            ButtonItemTransparent(
              context,
              icon: ImageIcon(
                AssetImage('assets/images/icons/archive_ic.png'),
                color: CustomColorScheme.button,
                size: 24,
              ),
              text: AppLocalizations.of(context)!.archivedGoals,
              onPressed: () {
                _goalsCubit.navigateToArchivedGoals(context);
              },
              buttonType: TransparentButtonType.LargeText,
            ),
            SizedBox(width: 20),
            if (_homeScreenCubit.currentForeignSession?.access.isReadOnly !=
                true)
              ButtonItem(
                context,
                text: AppLocalizations.of(context)!.addGoal,
                onPressed: () {
                  _goalsCubit.navigateToAddGoalPage(
                    context,
                    () => showDialog(
                      context: context,
                      builder: (_) {
                        return InformAlertDialog(
                          context,
                          title: AppLocalizations.of(context)!
                              .youCouldHaveOnly8ActiveGoals,
                        );
                      },
                    ),
                  );
                },
                buttonType: ButtonType.SmallText,
              ),
          ],
        ),
      ],
    );

    return isSmall
        ? SingleChildScrollView(
            clipBehavior: Clip.antiAlias,
            scrollDirection: Axis.horizontal,
            child: content)
        : content;
  }

  Widget _buildArchivedHeaderPage(
    BuildContext context, {
    required List<Goal> allGoals,
    required Map<int, List<Goal>> goalsByYear,
    required Function() onYearChanged,
  }) {
    var yearsLabel = <String>[];
    if (goalsByYear.isNotEmpty) {
      goalsByYear.forEach((key, value) {
        yearsLabel.add(key.toString());
      });
    }

    selectedYear = DateTime.now().year.toString();
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        16.0,
        0.0,
        16.0,
        16.0,
      ),
      child: Row(
        children: [
          CustomBackButton(
            onPressed: () {
              _goalsCubit.navigateToGoalsPage(context);
            },
          ),
          Label(
            text: AppLocalizations.of(context)!.archivedGoals,
            type: LabelType.Header2,
          ),
          if (!isSmall) SizedBox(width: 80),
          PeriodSelector(
            Key('2'),
            isSmall: true,
            defaultPosition:
                yearsLabel.isNotEmpty && yearsLabel.contains(selectedYear)
                    ? yearsLabel.indexOf(selectedYear)
                    : 0,
            labelTexts: yearsLabel.isNotEmpty
                ? yearsLabel
                : [DateTime.now().year.toString()],
            onPressed: (selectedPosition) {
              selectedYear = yearsLabel.isNotEmpty
                  ? yearsLabel[selectedPosition]
                  : DateTime.now().year.toString();
              onYearChanged();
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Widget _goalsTable(BuildContext context, List<Goal> goals) {
    var goalsWidgets = <Widget>[];

    goals.forEach((goal) {
      goalsWidgets.add(GoalSpacerWidget(
        goalWidget: GoalWidget(goal: goal, isActive: !widget.isArchived),
        isSmall: isSmall,
        index: goals.indexOf(goal) + 1,
        isLarge: isLarge,
        countOfGoals: goals.length + 1,
      ));
    });

    return Container(
      key: UniqueKey(),
      color: CustomColorScheme.blockBackground,
      child: GridView.count(
        shrinkWrap: true,
        dragStartBehavior: DragStartBehavior.down,
        childAspectRatio: 346 / 318,
        crossAxisCount: isLarge
            ? 3
            : isSmall
                ? 1
                : 2,
        children: goalsWidgets,
      ),
    );
  }
}

class GoalSpacerWidget extends StatelessWidget {
  final GoalWidget goalWidget;
  final bool isSmall;
  final bool isLarge;
  final int countOfGoals;
  final int index;

  const GoalSpacerWidget({
    Key? key,
    required this.isSmall,
    required this.isLarge,
    required this.countOfGoals,
    required this.index,
    required this.goalWidget,
  }) : super(key: key);

  double rightPadding(
    int index,
    bool isSmall,
    bool isLarge,
    int countOfGoals,
  ) {
    if (isSmall && countOfGoals == index) {
      return 0.0;
    } else if (isLarge && countOfGoals != index && index % 3 != 0) {
      return 1.0;
    } else if (!isSmall && !isLarge && index % 2 != 0) {
      return 1.0;
    } else {
      return 0.0;
    }
  }

  double bottomPadding(
    int index,
    bool isSmall,
    bool isLarge,
    int countOfGoals,
  ) {
    if (isSmall && countOfGoals - 1 != index) {
      return 1.0;
    } else if (isLarge) {
      return 1.0;
    } else if (!isLarge && !isSmall) {
      return 1.0;
    } else {
      return 0.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(
              width: rightPadding(index, isSmall, isLarge, countOfGoals),
              color: CustomColorScheme.dividerColor),
          bottom: BorderSide(
              width: bottomPadding(index, isSmall, isLarge, countOfGoals),
              color: CustomColorScheme.dividerColor),
        ),
      ),
      child: goalWidget,
    );
  }
}
