import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_inkwell.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_loading_indicator.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_tooltip.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_vertical_devider.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/label.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/text_styles.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/theme.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/error_alert_dialog.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/success_alert_dialog.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/home_screen/home_screen.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/home_screen/home_screen_cubit.dart';
import 'package:burgundy_budgeting_app/ui/model/vlorish_score_model.dart';
import 'package:burgundy_budgeting_app/ui/screen/fi_score/fi_score_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'fi_score_state.dart';

class FiScoreLayout extends StatefulWidget {
  const FiScoreLayout();

  @override
  State<FiScoreLayout> createState() => _FiScoreLayoutState();
}

class _FiScoreLayoutState extends State<FiScoreLayout> {
  late final FiScoreCubit _fiScoreCubit;

  late var isLimitedCoach = BlocProvider.of<HomeScreenCubit>(context)
      .currentForeignSession
      ?.access
      .isLimited ?? false;

  @override
  void initState() {
    _fiScoreCubit = BlocProvider.of<FiScoreCubit>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final textListInterpretation = [
      AppLocalizations.of(context)!.fiScoreOfZero,
      AppLocalizations.of(context)!.fiScoreOfOne,
      AppLocalizations.of(context)!.fiScoreOfTwo,
      AppLocalizations.of(context)!.fiScoreOfThree,
      AppLocalizations.of(context)!.fiScoreOfFour,
      AppLocalizations.of(context)!.fiScoreOfFive,
    ];
    final textListScoreMeaning = [
      '',
      AppLocalizations.of(context)!.unstable,
      AppLocalizations.of(context)!.somewhatUnstable,
      AppLocalizations.of(context)!.somewhatStable,
      AppLocalizations.of(context)!.stable,
      AppLocalizations.of(context)!.secure,
    ];
    var isSmall = MediaQuery.of(context).size.width < 1165;
    var isMediumOrSmall = MediaQuery.of(context).size.width < 1600;
    return BlocConsumer<FiScoreCubit, FiScoreState>(listener: (context, state) {
      if (state is FiScoreError) {
        showDialog(
          context: context,
          builder: (context) {
            return ErrorAlertDialog(
              context,
              message: state.error,
            );
          },
        );
      }
    }, builder: (context, state) {
      return HomeScreen(
        currentTab: Tabs.FIScore,
        title: AppLocalizations.of(context)!.fiScore,
        headerWidget: Row(
          children: [
            Label(
              text: AppLocalizations.of(context)!.yourVlorishScore,
              type: LabelType.Header2,
            ),
            Spacer(),
          ],
        ),
        bodyWidget: (state is! FiScoreLoaded)
            ? CustomLoadingIndicator()
            : Expanded(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Container(
                    decoration: BoxDecoration(
                      color: CustomColorScheme.blockBackground,
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 10.0,
                          color: CustomColorScheme.tableBorder,
                        ),
                      ],
                    ),
                    child: SingleChildScrollView(
                      primary: true,
                      child: Flex(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          direction:
                              isMediumOrSmall ? Axis.vertical : Axis.horizontal,
                          children: [
                            Flex(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              direction:
                                  isSmall ? Axis.vertical : Axis.horizontal,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(
                                      maxWidth: 700,
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        IntrinsicHeight(
                                          child: Row(
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                child: Container(
                                                  width: 4,
                                                  color:
                                                      CustomColorScheme.button,
                                                ),
                                              ),
                                              Flexible(
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 16.0),
                                                  child: Label(
                                                    text: AppLocalizations.of(
                                                            context)!
                                                        .fiScoreIntroText,
                                                    type: LabelType.General,
                                                    softWrap: true,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 32),
                                        FIScoreCategoryChart(state
                                            .vlorishScoreModel
                                            .vlorishScoreComponents),
                                        SizedBox(height: 32),
                                        Label(
                                            text: AppLocalizations.of(context)!
                                                .fiScoreSummary,
                                            type: LabelType.Header3),
                                        SizedBox(
                                          height: 16,
                                        ),
                                        IntrinsicHeight(
                                          child: Row(
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                child: Container(
                                                  width: 4,
                                                  color:
                                                      CustomColorScheme.button,
                                                ),
                                              ),
                                              Flexible(
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 16.0),
                                                  child: RichText(
                                                    text: TextSpan(children: [
                                                      TextSpan(children: [
                                                        TextSpan(
                                                          text: AppLocalizations.of(context)!
                                                              .fiScorePieChartTextPart1,
                                                          style:
                                                          CustomTextStyle.LabelTextStyle(
                                                              context),
                                                        ),
                                                        TextSpan(
                                                          text: ' ' +
                                                              state.vlorishScoreModel
                                                                  .totalVlorishScore!
                                                                  .toString(),
                                                          style: CustomTextStyle
                                                              .LabelBoldTextStyle(context),
                                                        ),
                                                        TextSpan(
                                                          text: ' ' +
                                                              AppLocalizations.of(context)!
                                                                  .fiScorePieChartTextPart2,
                                                          style:
                                                          CustomTextStyle.LabelTextStyle(
                                                              context),
                                                        ),
                                                        TextSpan(
                                                          text: ' ' +
                                                              AppLocalizations.of(context)!
                                                                  .fiScorePieChartTextPart3 +
                                                              '',
                                                          style:
                                                          CustomTextStyle.LabelTextStyle(
                                                              context),
                                                        ),
                                                        TextSpan(
                                                          text: ' ' +
                                                              textListScoreMeaning[state
                                                                  .vlorishScoreModel
                                                                  .totalVlorishScore!],
                                                          style: CustomTextStyle
                                                              .LabelBoldTextStyle(context),
                                                        )
                                                      ]),
                                                      TextSpan(
                                                        text: '. ' +AppLocalizations
                                                                .of(context)!
                                                            .fiScoreTextScorePart1,
                                                        style: CustomTextStyle
                                                            .LabelTextStyle(
                                                                context),
                                                      ),
                                                      TextSpan(
                                                        text: ' ' +
                                                            state
                                                                .vlorishScoreModel
                                                                .totalVlorishScore!
                                                                .toString(),
                                                        style: CustomTextStyle
                                                            .LabelBoldTextStyle(
                                                                context),
                                                      ),
                                                      TextSpan(
                                                        text: ' ' +
                                                            AppLocalizations.of(
                                                                    context)!
                                                                .fiScoreTextScorePart2,
                                                        style: CustomTextStyle
                                                            .LabelTextStyle(
                                                                context),
                                                      ),
                                                      TextSpan(
                                                        text: ' ' +
                                                            textListInterpretation[state
                                                                .vlorishScoreModel
                                                                .totalVlorishScore!] + '. ',
                                                        style: CustomTextStyle
                                                            .LabelBoldTextStyle(
                                                                context),
                                                      ),
                                                    ]),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                if (!isSmall)
                                  ConstrainedBox(
                                      constraints: BoxConstraints(
                                          minHeight: 100, minWidth: 30),
                                      child: CustomVerticalDivider(
                                        color: CustomColorScheme.tableBorder,
                                      )),
                                Container(
                                  width: 300,
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Label(
                                              text:
                                                  AppLocalizations.of(context)!
                                                      .vlorishScore,
                                              type: LabelType.Header3),
                                          if(!isLimitedCoach)
                                          CustomTooltip(
                                            message: 'Refresh score',
                                            child: Container(
                                              height: 38,
                                              width: 38,
                                              decoration: BoxDecoration(
                                                  color: CustomColorScheme
                                                      .mainDarkBackground,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          19)),
                                              child: Align(
                                                alignment: Alignment.topCenter,
                                                child: CustomMaterialInkWell(
                                                    type: InkWellType.White,
                                                    onTap: () async {
                                                      await _fiScoreCubit
                                                          .refresh()
                                                          .then((value) =>
                                                              showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (context) {
                                                                  return SuccessAlertDialog(
                                                                    context,
                                                                    title:
                                                                        'Refreshed',
                                                                  );
                                                                },
                                                              ));
                                                    },
                                                    child: Icon(
                                                      Icons.refresh_rounded,
                                                      size: 38,
                                                      color: Colors.white,
                                                    )),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      SfCircularChart(
                                        margin: EdgeInsets.zero,
                                        palette: [
                                          CustomColorScheme.button,
                                          Color.fromRGBO(234, 237, 243, 1),
                                        ],
                                        annotations: [
                                          CircularChartAnnotation(
                                            widget: Label(
                                              text: state.vlorishScoreModel
                                                  .totalVlorishScore
                                                  .toString(),
                                              type: LabelType.Header3,
                                            ),
                                          )
                                        ],
                                        series: <CircularSeries>[
                                          RadialBarSeries<_ChartData, String>(
                                            maximumValue: 5,
                                            animationDuration: 0,
                                            selectionBehavior:
                                                SelectionBehavior(
                                                    enable: false),
                                            innerRadius: '80%',
                                            radius: '80%',
                                            dataSource: <_ChartData>[
                                              _ChartData(state.vlorishScoreModel
                                                  .totalVlorishScore!)
                                            ],
                                            xValueMapper:
                                                (_ChartData data, _) => '',
                                            yValueMapper:
                                                (_ChartData data, _) => data.y,
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            if (isMediumOrSmall)
                              VlorishScoreDisclaimerWidget()
                            else
                              Flexible(child: VlorishScoreDisclaimerWidget())
                          ]),
                    ),
                  ),
                ),
              ),
      );
    });
  }
}

class _ChartData {
  final int y;

  _ChartData(this.y);
}

class FIScoreCategoryChart extends StatelessWidget {
  const FIScoreCategoryChart(this.vlorishScoreComponents, {Key? key})
      : super(key: key);
  final List<VlorishScoreComponents>? vlorishScoreComponents;

  static const _textMap = <String>[
    'Income',
    'Spending',
    'NetWorth',
    'Retirement',
    'Investment',
//    'Cash savings'
  ];

  @override
  Widget build(BuildContext context) {
    final _colorMap = <Color>[
      CustomColorScheme.button,
      CustomColorScheme.goalColor5,
      CustomColorScheme.tableExpensesBusinessText,
      CustomColorScheme.goalColor7,
      CustomColorScheme.goalColor4,
      CustomColorScheme.pendingStatusColor,
    ];
    // we got unsorted list of components
    vlorishScoreComponents!
        .sort((a, b) => a.profileCategory!.compareTo(b.profileCategory!));

    return Column(
      children: [
        for (int i = 0; i < vlorishScoreComponents!.length; i++)
          FiScoreCategoryChartRow(
            profileCategory: vlorishScoreComponents![i].profileCategory,
            score: vlorishScoreComponents![i].score!,
            categoryName: _textMap[i],
            nextStarNeeded: vlorishScoreComponents![i].nextStarNeeded,
            categoryColor: _colorMap[i],
          )
      ],
    );
  }
}

class FiScoreCategoryChartRow extends StatelessWidget with _FlexFactors {
  const FiScoreCategoryChartRow({
    Key? key,
    required this.categoryName,
    required this.categoryColor,
    required this.nextStarNeeded,
    required this.score,
    required this.profileCategory,
  }) : super(key: key);

  final String categoryName;
  final Color categoryColor;
  final double? nextStarNeeded;
  final int score;
  final int? profileCategory;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          Expanded(
              flex: flexFactors[0],
              child: Label(text: categoryName, type: LabelType.GeneralBold)),
          for (int i = 1; i <= 5; i++)
            Expanded(
              flex: flexFactors[1],
              child: Row(
                children: [
                  Expanded(
                    flex: 8,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: CustomTooltip(
                        message: i - 1 == score && nextStarNeeded != null
                            ? nextStarNeeded! > 0
                                ? '${NumberFormat.compactSimpleCurrency().format(nextStarNeeded)} more'
                                : '${NumberFormat.compactSimpleCurrency().format(nextStarNeeded).replaceRange(1, 2, '')} less'
                            : null,
                        preferBelow: true,
                        child: Container(
                          height: 10,
                          color: i <= score
                              ? categoryColor
                              : CustomColorScheme.tableBorder,
                        ),
                      ),
                    ),
                  ),
                  Spacer(flex: 2)
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class VlorishScoreDisclaimerWidget extends StatefulWidget {
  const VlorishScoreDisclaimerWidget({Key? key}) : super(key: key);

  @override
  State<VlorishScoreDisclaimerWidget> createState() =>
      _VlorishScoreDisclaimerWidgetState();
}

class _VlorishScoreDisclaimerWidgetState
    extends State<VlorishScoreDisclaimerWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Label(
              text: AppLocalizations.of(context)!.vlorishScoreDisclaimer,
              type: LabelType.Header3),
          SizedBox(height: 16),
          IntrinsicHeight(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                    width: 4,
                    color: CustomColorScheme.button,
                  ),
                ),
                Flexible(
                  child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: RichText(
                        text: TextSpan(
                            text: AppLocalizations.of(context)!
                                    .caveatEmptorDisclaimerLabel +
                                ' ',
                            style: CustomTextStyle.LabelBoldTextStyle(context),
                            children: [
                              TextSpan(
                                  text: AppLocalizations.of(context)!
                                      .caveatEmptorDisclaimerDescription,
                                  style:
                                      CustomTextStyle.LabelTextStyle(context))
                            ]),
                      )),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          IntrinsicHeight(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                    width: 4,
                    color: CustomColorScheme.button,
                  ),
                ),
                Flexible(
                  child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: RichText(
                        text: TextSpan(
                            text: AppLocalizations.of(context)!
                                    .anonymousDisclaimerLabel +
                                ' ',
                            style: CustomTextStyle.LabelBoldTextStyle(context),
                            children: [
                              TextSpan(
                                  text: AppLocalizations.of(context)!
                                      .anonymousDisclaimerDescription,
                                  style:
                                      CustomTextStyle.LabelTextStyle(context))
                            ]),
                      )),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          IntrinsicHeight(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                    width: 4,
                    color: CustomColorScheme.button,
                  ),
                ),
                Flexible(
                  child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: RichText(
                        text: TextSpan(
                            text: AppLocalizations.of(context)!
                                    .realTimeDisclaimerLabel +
                                ' ',
                            style: CustomTextStyle.LabelBoldTextStyle(context),
                            children: [
                              TextSpan(
                                  text: AppLocalizations.of(context)!
                                      .realTimeDisclaimerDescription,
                                  style:
                                      CustomTextStyle.LabelTextStyle(context))
                            ]),
                      )),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          IntrinsicHeight(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                    width: 4,
                    color: CustomColorScheme.button,
                  ),
                ),
                Flexible(
                  child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: RichText(
                        text: TextSpan(
                            text: AppLocalizations.of(context)!
                                    .assumptionsDisclaimerLabel +
                                ' ',
                            style: CustomTextStyle.LabelBoldTextStyle(context),
                            children: [
                              TextSpan(
                                  text: AppLocalizations.of(context)!
                                      .assumptionsDisclaimerDescription,
                                  style:
                                      CustomTextStyle.LabelTextStyle(context))
                            ]),
                      )),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          IntrinsicHeight(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                    width: 4,
                    color: CustomColorScheme.button,
                  ),
                ),
                Flexible(
                  child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: RichText(
                        text: TextSpan(
                            text: AppLocalizations.of(context)!
                                    .limitationsDisclaimerLabel +
                                ' ',
                            style: CustomTextStyle.LabelBoldTextStyle(context),
                            children: [
                              TextSpan(
                                  text: AppLocalizations.of(context)!
                                      .limitationsDisclaimerDescription,
                                  style:
                                      CustomTextStyle.LabelTextStyle(context))
                            ]),
                      )),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

enum VlorishScoreProfileCategoryEnum {
  Income,
  Spending,
  NetWorth,
  Retirement,
  Investment,
  Savings,
}

mixin _FlexFactors {
  List<int> get flexFactors => [15, 10];
}
