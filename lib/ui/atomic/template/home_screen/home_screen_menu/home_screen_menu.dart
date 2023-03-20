import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_divider.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/theme.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/expandable_menu_item.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/side_menu_button_item.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/home_screen/home_screen.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/home_screen/home_screen_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'home_screen_menu_cubit.dart';

class HomeScreenMenu extends StatefulWidget {
  final Tabs? currentTab;

  const HomeScreenMenu({
    Key? key,
    required this.currentTab,
  }) : super(key: key);

  @override
  _HomeScreenMenuState createState() => _HomeScreenMenuState();
}

class _HomeScreenMenuState extends State<HomeScreenMenu> {
  bool isMenuExpanded = true;
  bool firstItemExpanded = true;
  var collapseMenu = false;
  List<Widget> _menuItems = [];
  var scrollController = ScrollController();
  late final HomeScreenCubit homeScreenCubit;
  late final HomeScreenMenuCubit homeScreenMenuCubit;

  @override
  void initState() {
    super.initState();
    homeScreenCubit = BlocProvider.of<HomeScreenCubit>(context);
    homeScreenMenuCubit = BlocProvider.of<HomeScreenMenuCubit>(context);
    homeScreenCubit.setCurrentTab(widget.currentTab);

    isMenuExpanded = homeScreenMenuCubit.state.isMenuExpanded;
    firstItemExpanded = homeScreenMenuCubit.state.firstItemExpanded;
  }

  @override
  Widget build(BuildContext context) {
    _menuItems = [
      if (isMenuExpanded)
        ExpandableMenuItem(
          order: 0,
          titleText: AppLocalizations.of(context)!.budget,
          initiallyExpanded: firstItemExpanded,
          assetUrl: 'assets/images/icons/active.png',
          onExpansionChanged: (value) {
            setState(() {
              firstItemExpanded = value;
            });
            homeScreenMenuCubit.toggleFirstItem(value);
          },
          children: [
            SideMenuButtonItem(
              context,
              order: 1,
              text: AppLocalizations.of(context)!.personal,
              isSelected: widget.currentTab == Tabs.BudgetPersonal,
              onPressed: () {
                if (!(widget.currentTab == Tabs.BudgetPersonal)) {
                  homeScreenCubit.navigateToBudgetPersonalPage(context);
                }
              },
            ),
            SideMenuButtonItem(
              context,
              order: 2,
              text: AppLocalizations.of(context)!.business,
              isSelected: widget.currentTab == Tabs.BudgetBusiness,
              onPressed: () {
                if (!(widget.currentTab == Tabs.BudgetBusiness)) {
                  homeScreenCubit.navigateToBudgetBusinessPage(context);
                }
              },
            ),
          ],
        ),
      if (!isMenuExpanded)
        SideMenuButtonItem(
          context,
          order: 3,
          isSmall: true,
          isSelected:
              widget.currentTab == Tabs.BudgetPersonal || widget.currentTab == Tabs.BudgetBusiness,
          assetUrl: 'assets/images/icons/active.png',
          onPressed: () {
            if (!(widget.currentTab == Tabs.BudgetPersonal)) {
              homeScreenCubit.navigateToBudgetPersonalPage(context);
            }
          },
        ),
      SideMenuButtonItem(
        context,
        order: 4,
        isSmall: !isMenuExpanded,
        assetUrl: 'assets/images/icons/debts_active.png',
        text: AppLocalizations.of(context)!.debt,
        isSelected: widget.currentTab == Tabs.Debt,
        onPressed: () {
          if (!(widget.currentTab == Tabs.Debt)) {
            homeScreenCubit.navigateToDebtsPersonalPage(context);
          }
        },
      ),
      SideMenuButtonItem(
        context,
        order: 5,
        isSmall: !isMenuExpanded,
        assetUrl: 'assets/images/icons/24_accounts_active.png',
        text: AppLocalizations.of(context)!.netWorth,
        isSelected: widget.currentTab == Tabs.NetWorth,
        onPressed: () {
          if (!(widget.currentTab == Tabs.NetWorth)) {
            homeScreenCubit.navigateToNetWorthPage(context);
          }
        },
      ),
      SideMenuButtonItem(
        context,
        order: 6,
        isSmall: !isMenuExpanded,
        assetUrl: 'assets/images/icons/default.png',
        text: AppLocalizations.of(context)!.goals,
        isSelected: widget.currentTab == Tabs.Goals,
        onPressed: () {
          if (!(widget.currentTab == Tabs.Goals)) {
            homeScreenCubit.navigateToGoalsPage(context);
          }
        },
      ),
      SideMenuButtonItem(
        context,
        order: 7,
        isSmall: !isMenuExpanded,
        assetUrl: 'assets/images/icons/tax_active.png',
        text: AppLocalizations.of(context)!.tax,
        isSelected: widget.currentTab == Tabs.Tax,
        onPressed: () {
          if (!(widget.currentTab == Tabs.Tax)) {
            homeScreenCubit.navigateToTaxPage(context);
          }
        },
      ),
      SideMenuButtonItem(
        context,
        order: 8,
        isSmall: !isMenuExpanded,
        assetUrl: 'assets/images/icons/investments_active.png',
        text: AppLocalizations.of(context)!.investments,
        isSelected: widget.currentTab == Tabs.Investments,
        onPressed: () {
          if (!(widget.currentTab == Tabs.Investments)) {
            homeScreenCubit.navigateToInvestmentsPage(context);
          }
        },
      ),
      /*SideMenuButtonItem(
        context,
        order: 9,
        isSmall: !isMenuExpanded,
        assetUrl: 'assets/images/icons/retirement_active.png',
        text: AppLocalizations.of(context)!.retirement,
        isSelected: widget.currentTab == Tabs.Retirement,
        onPressed: () {
          if (!(widget.currentTab == Tabs.Retirement)) {
            homeScreenCubit.navigateToRetirementPage(context);
          }
        },
      ),*/
      SideMenuButtonItem(
        context,
        order: 11,
        isSmall: !isMenuExpanded,
        assetUrl: 'assets/images/icons/score_active.png',
        text: AppLocalizations.of(context)!.fiScore,
        isSelected: widget.currentTab == Tabs.FIScore,
        onPressed: () {
          if (!(widget.currentTab == Tabs.FIScore)) {
            homeScreenCubit.navigateToFiScorePage(context);
          }
        },
      ),
      CustomDivider(
        color: CustomColorScheme.menuBackgroundActive,
      )
    ];

    return Container(
      color: CustomColorScheme.mainDarkBackground,
      width: isMenuExpanded ? 220 : 80,
      child: FocusTraversalGroup(
        policy: OrderedTraversalPolicy(),
        child: Column(
          children: [
            CustomDivider(
              color: CustomColorScheme.menuBackgroundActive,
            ),
            Expanded(
              child: Theme(
                data: Theme.of(context).copyWith(
                  scrollbarTheme: ScrollbarThemeData(
                    thumbColor: MaterialStateProperty.all(Colors.white),
                    thickness: MaterialStateProperty.all(4),
                    trackVisibility: MaterialStateProperty.all(true),
                  ),
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: _menuItems,
                  ),
                ),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomDivider(
                  color: CustomColorScheme.menuBackgroundActive,
                ),
                SideMenuButtonItem(context,
                    order: 12,
                    isSmall: true,
                    assetUrl: isMenuExpanded
                        ? 'assets/images/icons/ic_24_arrow_back.png'
                        : 'assets/images/icons/ic_24_arrow.png', onPressed: () {
                  setState(() {
                    isMenuExpanded = !isMenuExpanded;

                    homeScreenMenuCubit.toggleIsMenuExpanded(isMenuExpanded);
                  });
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
