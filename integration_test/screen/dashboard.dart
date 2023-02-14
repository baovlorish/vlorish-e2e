import 'dart:ui';

import 'package:burgundy_budgeting_app/ui/atomic/atom/back_button.dart';
import 'package:burgundy_budgeting_app/ui/screen/category_management/category_management_cubit.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/appbar_item.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/avatar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:url_launcher/url_launcher.dart';
import '../lib/test_lib_common.dart';
import 'dart:html' as html;

class DashboardScreenTest {
  const DashboardScreenTest(this.tester);

  final WidgetTester tester;

  Future<void> clickLogoText() async {
    await tester.pumpAndSettle();
    final iconText = find.byType(Image).first;
    await tester.tap(iconText);
    await tester.pumpAndSettle(const Duration(seconds: 2));
  }

  Future<void> clickBack() async {
    final NavigatorState navigator = tester.state(find.byType(Navigator));
    navigator.pop();
    await tester.pump();
  }

  Future<void> openUrl(String url) async {
    //html.window.open(url, "_self");
    var urllaunchable =
        await canLaunch(url); //canLaunch is from url_launcher package
    if (urllaunchable) {
      await launch(url); //launch is from url_launcher package to launch URL
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> clickButton(String btnName, WidgetTester tester,
      {String context = ''}) async {
    await tester.pumpAndSettle(const Duration(seconds: 2));
    final btnSignIn = find.text(btnName).first;
    await tapSomething(
        tester, btnSignIn, addContext(context, 'click Btn ' + btnName));
    await tester.pumpAndSettle();
  }

  Future<void> clickLogoutButton(WidgetTester tester,
      {String context = ''}) async {
    await tester.pumpAndSettle();
    final iconText = find.byType(AppBarItem).at(5);
    await tapSomething(
        tester, iconText, addContext(context, 'Click on btn Logout'));
    await tester.pumpAndSettle(const Duration(seconds: 2));
  }

  Future<void> clickProfileIcon(WidgetTester tester,
      {String context = ''}) async {
    await tester.pumpAndSettle(const Duration(seconds: 15));
    print(find.byType(AvatarWidget).toString());
    final avatar = find.byType(AvatarWidget).first;
    await tapSomething(
        tester, avatar, addContext(context, 'Click on btn avatar'));
    await tester.pumpAndSettle(const Duration(seconds: 2));
  }

  Future<void> clickAccountsTransactionsIconCards(WidgetTester tester,
      {String context = ''}) async {
    await tester.pumpAndSettle();
    final iconText = find.byType(AppBarItem).at(1);
    await tapSomething(tester, iconText,
        addContext(context, 'Click on btn Accounts & Transactions'));
    await tester.pumpAndSettle(const Duration(seconds: 2));
  }
}
