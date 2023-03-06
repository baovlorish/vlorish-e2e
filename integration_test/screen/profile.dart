import 'dart:math';

import 'package:burgundy_budgeting_app/core/navigator_manager.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_inkwell.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/label.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/appbar_item.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/button_item.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/input_item.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/home_screen/home_screen.dart';
import 'package:burgundy_budgeting_app/ui/screen/profile_overview/profile_overview_page.dart';
import 'package:burgundy_budgeting_app/ui/screen/profile_overview/profile_overview_state.dart';
import 'package:burgundy_budgeting_app/ui/screen/profile_overview/profile_overview_layout.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/avatar_widget.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/back_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/theme.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../lib/test_lib_common.dart';

const String genderBtn = 'Gender';
const List<String> genderOptions = [
  'Male',
  'Female',
  'Gender Neutral',
  'Decline to Answer',
  'Relationship Status',
];

const String relationshipStatusBtn = 'Relationship Status';
const List<String> relationshipOptions = [
  'Single',
  'Married',
  'Divorced',
  'Other',
];

const String dependentsBtn = 'Dependents';
const List<String> dependentOptions = [
  '1',
  '2',
  '3',
  '4',
  '5',
  'More than 5 dependents',
];

const String educationBtn = 'Education';
const List<String> educationOptions = [
  'High School',
  'College',
  'Bachelor’s Degree',
  'Master’s Degree',
  'PhD',
];
const String employmentBtn = 'Employment';
const List<String> employOptions = [
  'Employee',
  'Employee with side gig',
  'Freelancer',
  'Independent contractor',
  'Small business owner with employees',
  'Small business owner w/no employees',
  'Rideshare and delivery apps drivers',
  'Unemployed',
  'Retired',
  'Student',
];

const String occupationBtn = 'Occupation';
const List<String> occupationOptions = [
  'Youtube and social media professionals',
  'Copywriting and content creators',
  'E-commerce professionals',
  'Photography, graphic design, and other creatives',
  'Other digital economy entrepreneurs',
  'Education and teaching',
  'Childcare and related services',
  'Healthcare professionals',
  'Finance professionals',
  'Venture capital and angel investors',
  'Management consulting',
  'Sales and marketing jobs',
  'Admin and support jobs',
  'Legal professionals',
  'Software developers',
  'Computer science jobs',
  'Data science and analytics',
  'IT and network administration',
  'Other technology careers',
  'Rideshare and delivery apps drivers',
  'Truckers and long-haul drivers',
  'Architecture and engineering',
  'Real estate and housing',
  'Manufacturing, assembly, and distribution',
  'Retail and food service employees',
  'TV, media, and publishing careers',
  'Skilled trade jobs',
  'Coaching and personal development',
  'Personal care services',
  'Independent product distributors',
  'Sports and leisure jobs',
  'Construction jobs',
  'Community and social services',
  'Other government and not-profit jobs',
  'Other',
];

class ProfileScreenTest {
  const ProfileScreenTest(this.tester);

  final WidgetTester tester;

  Future<void> clickDropdownButton(String dropdownName, WidgetTester tester,
      {String context = ''}) async {
    await tester.pumpAndSettle(const Duration(seconds: 2));
    final assetImage = AssetImage('assets/images/icons/dropdown.png');
    final imageIconFinder = find.byWidgetPredicate((widget) {
      if (widget is ImageIcon) {
        if (widget.image is AssetImage && widget.image == assetImage) {
          return true;
        }
      }
      return false;
    });
    switch (dropdownName) {
      case genderBtn:
        await tapSomething(tester, imageIconFinder.at(0),
            addContext(context, 'Click on dropdow btn $dropdownName'));
        break;
      case relationshipStatusBtn:
        await tapSomething(tester, imageIconFinder.at(1),
            addContext(context, 'Click on dropdow btn $dropdownName'));
        break;
      case dependentsBtn:
        await tapSomething(tester, imageIconFinder.at(2),
            addContext(context, 'Click on dropdow btn $dropdownName'));
        break;
      case educationBtn:
        await tapSomething(tester, imageIconFinder.at(4),
            addContext(context, 'Click on dropdow btn $dropdownName'));
        break;
      case employmentBtn:
        await tapSomething(tester, imageIconFinder.at(5),
            addContext(context, 'Click on dropdow btn $dropdownName'));
        break;
      case occupationBtn:
        await tapSomething(tester, imageIconFinder.at(6),
            addContext(context, 'Click on dropdow btn $dropdownName'));
        break;
    }
    await tester.pumpAndSettle();
  }

  Future<void> verifySelectDropdown(
      String dropdownName, String valueSelect, WidgetTester tester,
      {String context = ''}) async {
    await tester.pumpAndSettle(const Duration(seconds: 5));
    await tapSomething(tester, find.text(valueSelect).last,
        addContext(context, 'Click on value $valueSelect of $dropdownName'));
  }

  Future<void> verifyProfilePage(WidgetTester tester,
      {String context = ''}) async {
    await tester.pumpAndSettle(const Duration(seconds: 7));
    final finder = find.byType(Title).last;
    final titleWidget = tester.firstWidget<Title>(finder);
    await htExpect(tester, titleWidget.title, 'Profile Overview',
        reason:
            ('Verify-' + context + '- Profile Overview title page is visible'));
    await tester.pumpAndSettle();
  }

  Future<void> verifyProfileDetailtPage(WidgetTester tester,
      {String context = ''}) async {
    await tester.pumpAndSettle(const Duration(seconds: 15));
    await htExpect(tester, find.text('Personal Details'), findsOneWidget,
        reason:
            ('Verify-' + context + '-' + 'Personal Details Title is visible'));
    await htExpect(tester, find.text('First Name'), findsOneWidget,
        reason: ('Verify-' + context + '-' + 'First Name text is visible'));
    await htExpect(tester, find.text('Date of birth'), findsOneWidget,
        reason: ('Verify-' + context + '-' + 'Date of birth text is visible'));
    await tester.pumpAndSettle();
  }

  Future<void> clickProfileDetailsButton(WidgetTester tester,
      {String context = ''}) async {
    await tester.pumpAndSettle();
    final profileButton = find.widgetWithText(Label, 'Profile details');
    await tapSomething(tester, profileButton,
        addContext(context, 'Click on btn Profile Details'));
    await tester.pumpAndSettle(const Duration(seconds: 2));
  }

  Future<void> inputUpdateName(
      String firstName, String lastName, WidgetTester tester,
      {String context = ''}) async {
    await tester.pumpAndSettle();
    final first = find.byType(InputItem).at(0);
    final last = find.byType(InputItem).at(1);
    await writeSomething(
        tester, first, firstName, addContext(context, 'Input First Name'));
    await writeSomething(
        tester, last, lastName, addContext(context, 'Input Last Name'));
    await tester.pumpAndSettle(const Duration(seconds: 20));
  }

  Future<void> verifyNameUpdate(
      String firstName, String lastName, WidgetTester tester,
      {String context = ''}) async {
    await tester.pumpAndSettle(const Duration(seconds: 10));
    await htExpect(tester, find.text(firstName), findsOneWidget,
        reason: ('Verify-' + context + '-' + 'First Name is visible'));
    await htExpect(tester, find.text(lastName), findsOneWidget,
        reason: ('Verify-' + context + '-' + 'Last Name text is visible'));
    await tester.pumpAndSettle();
  }

  Future<void> inputFirstName(String firstName, WidgetTester tester,
      {String context = ''}) async {
    await tester.pumpAndSettle();
    final first = find.byType(InputItem).at(0);
    await writeSomething(
        tester, first, firstName, addContext(context, 'Input First Name'));
    await tester.pumpAndSettle(const Duration(seconds: 10));
  }

  Future<void> inputLastName(String lastName, WidgetTester tester,
      {String context = ''}) async {
    await tester.pumpAndSettle();
    final last = find.byType(InputItem).at(1);
    await writeSomething(
        tester, last, lastName, addContext(context, 'Input Last Name'));
    await tester.pumpAndSettle(const Duration(seconds: 10));
  }

  Future<void> clickUpdateProfileButton(WidgetTester tester,
      {String context = ''}) async {
    await tester.pumpAndSettle();
    final updateButton = find.text('Update');
    await tapSomething(tester, updateButton,
        addContext(context, 'Click on btn Update Profile Button'));
    await tester.pumpAndSettle(const Duration(seconds: 2));
  }

  Future<void> inputUpdatePassword(
      String oldPassword, String newPassord, WidgetTester tester,
      {String context = ''}) async {
    await tester.pumpAndSettle();
    final oldPass = find.byType(InputItem).at(0);
    final newPass = find.byType(InputItem).at(1);
    await writeSomething(tester, oldPass, oldPassword,
        addContext(context, 'Input Old Password'));
    await writeSomething(
        tester, newPass, newPassord, addContext(context, 'Input New Password'));
    await tester.pumpAndSettle(const Duration(seconds: 2));
  }

  Future<void> clickUpdatePasswordButton(WidgetTester tester,
      {String context = ''}) async {
    await tester.pumpAndSettle();
    final updateButton = find.text('Update password');
    // await tester.tap(updateButton);
    await tapSomething(tester, updateButton,
        addContext(context, 'Click on btn Update Password'));
    await tester.pumpAndSettle(const Duration(seconds: 2));
  }

  Future<void> clickContinueButton(WidgetTester tester,
      {String context = ''}) async {
    await tester.pumpAndSettle(const Duration(seconds: 15));
    final continueBtn = find.text('Continue');
    await tapSomething(
        tester, continueBtn, addContext(context, 'Click on btn Continue'));
    await tester.pumpAndSettle(const Duration(seconds: 2));
  }

  Future<void> clickBackButton(WidgetTester tester,
      {String context = ''}) async {
    await tester.pumpAndSettle(const Duration(seconds: 2));
    final btnBackIcon = find.byIcon(Icons.arrow_back_rounded);
    await tapSomething(
        tester, btnBackIcon, addContext(context, 'Click on btn BackIcon'));
    await tester.pumpAndSettle();
  }

  Future<void> clickEyePassword(int index, WidgetTester tester,
      {String context = ''}) async {
    await tester.pumpAndSettle(const Duration(seconds: 2));
    final btnNext = find.byType(IconButton).at(index);
    await tapSomething(tester, btnNext, addContext(context, 'Click on Eye'));
    await tester.pumpAndSettle();
  }

  Future<void> verifyPasswordShow(String pass, WidgetTester tester,
      {String context = ''}) async {
    final finder = find.byType(TextField).first;
    final input = tester.firstWidget<TextField>(finder);
    expect(input.obscureText, false);
    final findtext = find.text(pass);
    await htExpect(tester, findtext, findsOneWidget,
        reason: ('Verify-' + context + '- Show Password text is visible'));
  }

  Future<void> verifyPasswordHidden(String pass, WidgetTester tester,
      {String context = ''}) async {
    final finder = find.byType(TextField).first;
    final input = tester.firstWidget<TextField>(finder);
    expect(input.obscureText, true);
    await htExpect(tester, input.obscureText, true,
        reason: ('Verify-' + context + '- Password is NOT visible'));
  }

  Future<void> verifyNewPasswordMax128Char(
      String pass128, String pass129, WidgetTester tester,
      {String context = ''}) async {
    final findtext128 = find.text(pass128);
    await htExpect(tester, findtext128, findsOneWidget,
        reason: ('Verify-' + context + '- Password Max 128 Chars is visible'));
    final findtext129 = find.text(pass129);
    await htExpect(tester, findtext129, findsNothing,
        reason:
            ('Verify-' + context + '- Password Max 129 Chars is NOT visible'));
  }

  Future<void> verifyShowMessage(String msg, WidgetTester tester,
      {String context = ''}) async {
    await tester.pumpAndSettle(const Duration(seconds: 15));
    await htExpect(tester, find.text(msg), findsOneWidget,
        reason: ('Verify-' + context + '-' + msg + ' text is visible'));
    await tester.pumpAndSettle(const Duration(seconds: 2));
  }

  Future<void> verifyHideMessage(String msg, WidgetTester tester,
      {String context = ''}) async {
    await tester.pumpAndSettle(const Duration(seconds: 10));
    await htExpect(tester, find.text(msg), findsNothing,
        reason: ('Verify-' + context + '-' + msg + ' text is NOT visible'));
    await tester.pumpAndSettle(const Duration(seconds: 2));
  }

  Future<void> clickPopupButton(String btnText, WidgetTester tester,
      {String context = ''}) async {
    await tester.pumpAndSettle(const Duration(seconds: 15));
    final updateButton = find.text(btnText);
    await tapSomething(tester, updateButton,
        addContext(context, 'Click on btn ' + btnText + ' Button'));
    await tester.pumpAndSettle(const Duration(seconds: 2));
  }

  Future<void> clickButton(String btn, WidgetTester tester,
      {String context = ''}) async {
    await tester.pumpAndSettle();
    final updateButton = find.text(btn);
    // await tester.tap(updateButton);
    await tapSomething(
        tester, updateButton, addContext(context, 'Click on btn ' + btn));
    await tester.pumpAndSettle(const Duration(seconds: 2));
  }

  Future<void> verifyMessageErrorIsVisible(String msg, WidgetTester tester,
      {String context = ''}) async {
    final text = tester.widget<Text>(find.text(msg));
    expect(text.style?.color, CustomColorScheme.inputErrorBorder);
    await htExpect(
        tester, text.style?.color, CustomColorScheme.inputErrorBorder,
        reason: ("Verify-" + context + "-" + msg + ' error is visible'));
    await tester.pumpAndSettle(const Duration(seconds: 2));
  }

  Future<void> scrollThePage() async {
    await tester.dragUntilVisible(
      find.text('Close account'), // what you want to find
      find.byKey(ValueKey('LabelButtonItem')), // widget you want to scroll
      const Offset(-500, 0), // delta to move
    );
  }

  Future<void> selectCity(String searchCityName,
      String selectSuggestionCityName, WidgetTester tester,
      {String context = ''}) async {
    await tester.pumpAndSettle();
    final typeAheadFinder = find.byType(TypeAheadFormField);
    await tester.tap(typeAheadFinder);
    await tester.enterText(typeAheadFinder, searchCityName);
    await tester.pumpAndSettle(const Duration(seconds: 10));

    final suggestionFinder = find.text(selectSuggestionCityName);
    await tester.tap(suggestionFinder);
    await tester.pumpAndSettle(const Duration(seconds: 10));
  }
}
