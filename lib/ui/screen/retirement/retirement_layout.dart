import 'package:burgundy_budgeting_app/ui/atomic/template/home_screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RetirementLayout extends StatefulWidget {
  const RetirementLayout();

  @override
  State<RetirementLayout> createState() => _RetirementLayoutState();
}

class _RetirementLayoutState extends State<RetirementLayout> {
  @override
  Widget build(BuildContext context) {
    return HomeScreen(
      bodyWidget: Container(),
      currentTab: Tabs.Retirement,
      title: AppLocalizations.of(context)!.retirement,
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
