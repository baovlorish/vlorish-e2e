import 'dart:ui';

import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_inkwell.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/appbar_item.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/avatar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:url_launcher/url_launcher.dart';
// ignore: avoid_relative_lib_imports
import '../lib/test_lib_common.dart';
import 'dart:html' as html;

class DashboardScreenTest {
  const DashboardScreenTest(this.tester);

  final WidgetTester tester;

  Future<void> clickLogoText() async {
    await tester.pumpAndSettle();
    final logoFinder =
        find.descendant(of: find.byType(CustomMaterialInkWell), matching: find.byType(Image));
    await tester.tap(logoFinder);
    await tester.pumpAndSettle(const Duration(seconds: 2));
  }

  Future<void> clickBack() async {
    final NavigatorState navigator = tester.state(find.byType(Navigator));
    navigator.pop();
    await tester.pump();
  }

  Future<void> openUrl(String url) async {
    //html.window.open(url, "_self");
    var urllaunchable = await canLaunch(url); //canLaunch is from url_launcher package
    if (urllaunchable) {
      await launch(url); //launch is from url_launcher package to launch URL
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> clickButton(String btnName, WidgetTester tester, {String context = ''}) async {
    await tester.pumpAndSettle(const Duration(seconds: 2));
    final btnSignIn = find.text(btnName).first;
    await tapSomething(tester, btnSignIn, addContext(context, 'click Btn ' + btnName));
    await tester.pumpAndSettle();
  }

  Future<void> clickLogoutButton(WidgetTester tester, {String context = ''}) async {
    await tester.pumpAndSettle();
    final iconText = find.byType(AppBarItem).at(5);
    await tapSomething(tester, iconText, addContext(context, 'Click on btn Logout'));
    await tester.pumpAndSettle(const Duration(seconds: 2));
  }

  Future<void> clickProfileIcon(WidgetTester tester, {String context = ''}) async {
    await tester.pumpAndSettle(const Duration(seconds: 15));
    print(find.byType(AvatarWidget).toString());
    final avatar = find.byType(AvatarWidget).first;
    await tapSomething(tester, avatar, addContext(context, 'Click on btn avatar'));
    await tester.pumpAndSettle(const Duration(seconds: 5));
  }

  Future<void> clickAccountsTransactionsIconCards(WidgetTester tester,
      {String context = ''}) async {
    await tester.pumpAndSettle();
    final appBarItem = find.byWidgetPredicate((widget) =>
        widget is AppBarItem && widget.iconUrl == 'assets/images/icons/card_default.png');
    await tester.tap(appBarItem);
    await tester.pump();
    await tester.pumpAndSettle(const Duration(seconds: 2));
  }
}
