import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_inkwell.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_loading_indicator.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/label.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/theme.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/home_screen/home_screen.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/investments/investment_retirement_widget.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/investments/investments_layout_widget.dart';
import 'package:burgundy_budgeting_app/ui/screen/investments/investments/investments_cubit.dart';
import 'package:burgundy_budgeting_app/ui/screen/investments/investments/investments_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class InvestmentsLayout extends StatefulWidget {
  const InvestmentsLayout();

  @override
  State<InvestmentsLayout> createState() => _InvestmentsLayoutState();
}

class _InvestmentsLayoutState extends State<InvestmentsLayout> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<InvestmentsCubit, InvestmentsState>(
        listener: (context, state) {},
        builder: (context, state) {
          return HomeScreen(
            currentTab: Tabs.Investments,
            title: AppLocalizations.of(context)!.investments,
            headerWidget: InvestmentsHeader(
                isRetirement:
                    state is InvestmentsLoaded ? state.isRetirement : false),
            bodyWidget: state is InvestmentsLoaded
                ? state.isRetirement
                    ? InvestmentsRetirementWidget()
                    : InvestmentsLayoutWidget()
                : state is InvestmentsLoading
                    ? CustomLoadingIndicator()
                    : Container(),
          );
        });
  }
}

class InvestmentsHeader extends StatefulWidget {
  final bool isRetirement;

  const InvestmentsHeader({Key? key, required this.isRetirement})
      : super(key: key);

  @override
  _InvestmentsHeaderState createState() => _InvestmentsHeaderState();
}

class _InvestmentsHeaderState extends State<InvestmentsHeader> {
  late var investmentsCubit = BlocProvider.of<InvestmentsCubit>(context);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      children: [
        CustomMaterialInkWell(
          type: InkWellType.Purple,
          borderRadius: BorderRadius.circular(12),
          onTap: () async {
            await investmentsCubit.changeTopTab(isRetirement: false);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
            child: Label(
              text: 'Investments',
              type: LabelType.Header2,
              color: widget.isRetirement
                  ? CustomColorScheme.clipElementInactive
                  : null,
            ),
          ),
        ),
        CustomMaterialInkWell(
          type: InkWellType.Purple,
          borderRadius: BorderRadius.circular(12),
          onTap: () async {
            await investmentsCubit.changeTopTab(isRetirement: true);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
            child: Label(
              text: 'Retirement',
              type: LabelType.Header2,
              color: !widget.isRetirement
                  ? CustomColorScheme.clipElementInactive
                  : null,
            ),
          ),
        ),
      ],
    );
  }
}
