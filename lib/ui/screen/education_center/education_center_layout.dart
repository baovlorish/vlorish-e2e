import 'package:burgundy_budgeting_app/core/navigator_manager.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/label.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/theme.dart';
import 'package:burgundy_budgeting_app/ui/atomic/organizm/annual_monthly_switcher.dart';
import 'package:burgundy_budgeting_app/ui/atomic/organizm/category_guideline_tab.dart';
import 'package:burgundy_budgeting_app/ui/atomic/organizm/education_center_widgets.dart';
import 'package:burgundy_budgeting_app/ui/atomic/organizm/side_menu_widget.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/home_screen/home_screen.dart';
import 'package:burgundy_budgeting_app/ui/screen/education_center/education_center_cubit.dart';
import 'package:burgundy_budgeting_app/ui/screen/education_center/education_center_page.dart';
import 'package:burgundy_budgeting_app/ui/screen/education_center/education_center_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EducationCenterLayout extends StatefulWidget {
  const EducationCenterLayout();

  @override
  State<EducationCenterLayout> createState() => _EducationCenterLayoutState();
}

class _EducationCenterLayoutState extends State<EducationCenterLayout> {
  late var sideMenuNames = [
    AppLocalizations.of(context)!.vlorishAppDemo,
    AppLocalizations.of(context)!.vlorishCategoriesGuideline,
    AppLocalizations.of(context)!.budgetingTipsAndTricks,
    AppLocalizations.of(context)!.faqs,
  ];

  late var sideMenuItems = List.generate(
    4,
    (index) => SideMenuData(
      name: sideMenuNames[index],
      onTap: () {
        NavigatorManager.navigateTo(
          context,
          EducationCenterPage.routeName,
          params: {
            'tab': index.toString(),
          },
        );
      },
    ),
  );

  var isPersonal = true;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EducationCenterCubit, EducationCenterState>(
        listener: (context, state) {},
        builder: (context, state) {
          return HomeScreen(
            currentTab: Tabs.AppbarHelp,
            headerWidget: LayoutBuilder(builder: (context, constraints) {
              if (state.tab == 1 && constraints.maxWidth < 700) {
                return Wrap(
                  direction: Axis.vertical,
                  children: [
                    Label(
                      text: AppLocalizations.of(context)!.educationCenter,
                      type: LabelType.Header2,
                    ),
                    TwoOptionSwitcher(
                      options: [
                        AppLocalizations.of(context)!.personalBudget,
                        AppLocalizations.of(context)!.businessBudget,
                      ],
                      onPressed: () {
                        isPersonal = !isPersonal;
                        setState(() {});
                      },
                      isFirstItemSelected: isPersonal,
                    ),
                    if (state.tab == 1) SizedBox(width: 270)
                  ],
                );
              } else {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Label(
                      text: AppLocalizations.of(context)!.educationCenter,
                      type: LabelType.Header2,
                    ),
                    Spacer(),
                    if (state.tab == 1)
                      TwoOptionSwitcher(
                        options: [
                          AppLocalizations.of(context)!.personalBudget,
                          AppLocalizations.of(context)!.businessBudget,
                        ],
                        onPressed: () {
                          isPersonal = !isPersonal;
                          setState(() {});
                        },
                        isFirstItemSelected: isPersonal,
                        isDirectionVertical: true,
                        spacing: 0,
                      ),
                    if (state.tab == 1) SizedBox(width: 273)
                  ],
                );
              }
            }),
            title: AppLocalizations.of(context)!.educationCenter,
            bodyWidget: Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 10.0,
                              color: CustomColorScheme.tableBorder,
                            ),
                          ],
                        ),
                        padding: EdgeInsets.all(12),
                        child: _currentTabWidget(state.tab),
                      ),
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    SideMenuWidget(
                      currentTab: state.tab,
                      items: sideMenuItems,
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _currentTabWidget(int i) {
    var widget;
    switch (i) {
      case 1:
        if (isPersonal) {
          widget = PersonalCategoryGuidelineWidget();
        } else {
          widget = BusinessCategoryGuidelineWidget();
        }
        break;
      case 2:
        widget = BudgetingTipsWidget();
        break;
      case 3:
        widget = FAQsWidget();
        break;
      default:
        widget = Container();
    }
    return Stack(
      children: [
        Container(color: Colors.white, child: Column()),
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Label(
                text: sideMenuItems[i].name,
                type: LabelType.Header3,
              ),
              widget,
            ],
          ),
        ),
      ],
    );
  }
}
