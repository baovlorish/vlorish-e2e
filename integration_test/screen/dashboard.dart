import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:html' as html;

class DashboardScreenTest {
  const DashboardScreenTest(this.tester);

  final WidgetTester tester;

  Future<void> clickLogoText() async {
    await tester.pumpAndSettle();
    final iconText = find.byType(IconButton).first;
    await tester.tap(iconText);
    await tester.pumpAndSettle(const Duration(seconds: 2));
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
}
