import 'dart:io';
import '../lib/test_lib_common.dart';
import '../lib/test_lib_const.dart';
import '../lib/function_common.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:burgundy_budgeting_app/main.dart' as app;
import '../ver1/screen/dashboard.dart';
import '../screen/signin.dart';
import '../ver1/screen/budget.dart';
import '../ver1/screen/profile.dart';

const String testDescription = 'Profile Page Test';
var fName = getRandomString(10);
var lName = getRandomString(10);
void main() async {
  SignInScreenTest signInScreen;
  DashboardScreenTest dashboardScreen;
  BudgetScreenTest personalBudgetScreen;
  ProfileScreenTest profileScreen;
  await htTestInit(description: testDescription);
  group('Profile Page', () {
    testWidgets('Profile test', (tester, [String? context]) async {
      await app.main();
      signInScreen = SignInScreenTest(tester);
      dashboardScreen = DashboardScreenTest(tester);
      personalBudgetScreen = BudgetScreenTest(tester);
      profileScreen = ProfileScreenTest(tester);
      context = context ?? '';

      await dashboardScreen.clickLogoText();
      await signInScreen.inputEmailAndPassword(emailLogin, passLogin, tester);
      await signInScreen.clickLoginButton(tester);
      await personalBudgetScreen.verifyPersonalBudgetPage(tester);

      try {
        await htLogdDirect(
            'BAR_T188 Check that user can update “City” and “State” fields', '', 'STARTED');
        await dashboardScreen.clickProfileIcon(tester);
        await profileScreen.verifyProfilePage(tester);
        await profileScreen.clickProfileDetailsButton(tester);
        await profileScreen.verifyProfileDetailtPage(tester);
        await profileScreen.selectCity('new york', 'New York, NY', tester);
        await profileScreen.clickUpdateProfileButton(tester);
        await profileScreen.verifyShowMessage('Success!', tester);
        await dashboardScreen.clickButton('Continue', tester);
        await profileScreen.clickBackButton(tester);
        await profileScreen.clickProfileDetailsButton(tester);
        await profileScreen.verifyProfileDetailtPage(tester);
        await profileScreen.verifyShowMessage('New York, NY', tester);
        await profileScreen.selectCity('San Francisco', 'San Francisco, CA', tester);
        await profileScreen.clickUpdateProfileButton(tester);
        await profileScreen.verifyShowMessage('Success!', tester);
        await dashboardScreen.clickButton('Continue', tester);
        await htLogd(tester, 'BAR_T188 Check that user can update “City” and “State” fields', '',
            'FINISHED');
      } catch (e) {
        await htLogd(tester, 'Failed BAR-T188 Check that user can update “City” and “State” fields',
            '', 'FINISHED');
      }

      try {
        await htLogdDirect('BAR_T189 Check that user can select Gender', '', 'STARTED');

        await dashboardScreen.clickProfileIcon(tester);
        await profileScreen.verifyProfilePage(tester);
        await profileScreen.clickProfileDetailsButton(tester);
        await profileScreen.verifyProfileDetailtPage(tester);
        final genderOption = genderOptions;
        for (int i = 0; i < genderOption.length; i++) {
          await profileScreen.clickDropdownButton(genderBtn, tester);
          await profileScreen.verifySelectDropdown(genderBtn, genderOption[i], tester);
        }

        await htLogd(tester, 'BAR_T189 Check that user can select Gender', '', 'FINISHED');
      } catch (e) {
        await htLogd(tester, 'Failed BAR-T189 Check that user can select Gender', '', 'FINISHED');
      }

      try {
        await htLogdDirect(
            'BAR_T190 Check that user can select Relationship Status', '', 'STARTED');

        await dashboardScreen.clickProfileIcon(tester);
        await profileScreen.verifyProfilePage(tester);
        await profileScreen.clickProfileDetailsButton(tester);
        await profileScreen.verifyProfileDetailtPage(tester);
        final relationshipOption = relationshipOptions;
        for (int i = 0; i < relationshipOption.length; i++) {
          await profileScreen.clickDropdownButton(relationshipStatusBtn, tester);
          await profileScreen.verifySelectDropdown(
              relationshipStatusBtn, relationshipOption[i], tester);
        }

        await htLogd(
            tester, 'BAR_T190 Check that user can select Relationship Status', '', 'FINISHED');
      } catch (e) {
        await htLogd(tester, 'Failed BAR-T190 Check that user can select Relationship Status', '',
            'FINISHED');
      }

      try {
        await htLogdDirect('BAR_T191 Check that user can select Education', '', 'STARTED');

        await dashboardScreen.clickProfileIcon(tester);
        await profileScreen.verifyProfilePage(tester);
        await profileScreen.clickProfileDetailsButton(tester);
        await profileScreen.verifyProfileDetailtPage(tester);
        final educationOption = educationOptions;
        for (int i = 0; i < educationOption.length; i++) {
          await profileScreen.clickDropdownButton(educationBtn, tester);
          await profileScreen.verifySelectDropdown(educationBtn, educationOption[i], tester);
        }

        await htLogd(tester, 'BAR_T191 Check that user can select Education', '', 'FINISHED');
      } catch (e) {
        await htLogd(
            tester, 'Failed BAR-T191 Check that user can select Education', '', 'FINISHED');
      }

      try {
        await htLogdDirect('BAR_T192 Check that user can select Employment', '', 'STARTED');

        await dashboardScreen.clickProfileIcon(tester);
        await profileScreen.verifyProfilePage(tester);
        await profileScreen.clickProfileDetailsButton(tester);
        await profileScreen.verifyProfileDetailtPage(tester);
        final employOption = employOptions;
        for (int i = 0; i < employOption.length; i++) {
          await profileScreen.clickDropdownButton(employmentBtn, tester);
          await profileScreen.verifySelectDropdown(employmentBtn, employOption[i], tester);
        }

        await htLogd(tester, 'BAR_T192 Check that user can select Employment', '', 'FINISHED');
      } catch (e) {
        await htLogd(
            tester, 'Failed BAR-T192 Check that user can select Employment', '', 'FINISHED');
      }

      try {
        await htLogdDirect('BAR_T193 Check that user can select Occupation', '', 'STARTED');

        await dashboardScreen.clickProfileIcon(tester);
        await profileScreen.verifyProfilePage(tester);
        await profileScreen.clickProfileDetailsButton(tester);
        await profileScreen.verifyProfileDetailtPage(tester);
        final occupationOption = occupationOptions;
        for (int i = 0; i < occupationOption.length; i++) {
          await profileScreen.clickDropdownButton(occupationBtn, tester);
          await profileScreen.verifySelectDropdown(occupationBtn, occupationOption[i], tester);
        }
        await htLogd(tester, 'BAR_T193 Check that user can select Occupation', '', 'FINISHED');
      } catch (e) {
        await htLogd(
            tester, 'Failed BAR-T193 Check that user can select Occupation', '', 'FINISHED');
      }

      try {
        await htLogdDirect('BAR_T195 Check that user can select Dependents', '', 'STARTED');

        await dashboardScreen.clickProfileIcon(tester);
        await profileScreen.verifyProfilePage(tester);
        await profileScreen.clickProfileDetailsButton(tester);
        await profileScreen.verifyProfileDetailtPage(tester);
        final dependentOption = dependentOptions;
        for (int i = 0; i < dependentOption.length; i++) {
          await profileScreen.clickDropdownButton(dependentsBtn, tester);
          await profileScreen.verifySelectDropdown(dependentsBtn, dependentOption[i], tester);
        }
        await htLogd(tester, 'BAR_T195 Check that user can select Dependents', '', 'FINISHED');
      } catch (e) {
        await htLogd(
            tester, 'Failed BAR-T195 Check that user can select Dependents', '', 'FINISHED');
      }

      try {
        await htLogdDirect(
            'BAR_T198 Check that error message disappears after entering min 1 character in First name field',
            '',
            'STARTED');

        await dashboardScreen.clickProfileIcon(tester);
        await profileScreen.verifyProfilePage(tester);
        await profileScreen.clickProfileDetailsButton(tester);
        await profileScreen.verifyProfileDetailtPage(tester);
        await profileScreen.inputFirstName('', tester);
        await profileScreen.clickUpdateProfileButton(tester);
        await profileScreen.verifyShowMessage('Please enter your first name', tester);
        await profileScreen.inputFirstName(getRandomCharacter(1), tester);
        await profileScreen.clickUpdateProfileButton(tester);
        await profileScreen.verifyShowMessage('Success!', tester);
        await profileScreen.clickButton('Continue', tester);
        await profileScreen.verifyHideMessage('Please enter your first name', tester);

        await htLogd(
            tester,
            'BAR_T198 Check that error message disappears after entering min 1 character in First name field',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Failed BAR-T198 Check that error message disappears after entering min 1 character in First name field',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'BAR_T199 Check that user can enter max 50 characters in First name field',
            '',
            'STARTED');

        final fName50Char = 'NameNameNameNameNameNameNameNameNameNameNameName50';
        await dashboardScreen.clickProfileIcon(tester);
        await profileScreen.verifyProfilePage(tester);
        await profileScreen.clickProfileDetailsButton(tester);
        await profileScreen.verifyProfileDetailtPage(tester);
        await profileScreen.inputFirstName(fName50Char, tester);
        await profileScreen.clickUpdateProfileButton(tester);
        await profileScreen.verifyShowMessage('First name should be up to 32 characters', tester);
        await profileScreen.verifyShowMessage('Success!', tester);
        await htLogd(
            tester,
            'BAR_T199 Check that user can enter max 50 characters in First name field',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Failed BAR-T199 Check that user can enter max 50 characters in First name field',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'BAR_T200 Check that error message disappears after entering min 1 character in Last name field',
            '',
            'STARTED');

        await dashboardScreen.clickProfileIcon(tester);
        await profileScreen.verifyProfilePage(tester);
        await profileScreen.clickProfileDetailsButton(tester);
        await profileScreen.verifyProfileDetailtPage(tester);
        await profileScreen.inputLastName('', tester);
        await profileScreen.clickUpdateProfileButton(tester);
        await profileScreen.verifyShowMessage('Please enter your last name', tester);
        await profileScreen.inputLastName(getRandomCharacter(1), tester);
        await profileScreen.clickUpdateProfileButton(tester);
        await profileScreen.verifyShowMessage('Success!', tester);
        await profileScreen.clickButton('Continue', tester);
        await profileScreen.verifyHideMessage('Please enter your last name', tester);

        await htLogd(
            tester,
            'BAR_T200 Check that error message disappears after entering min 1 character in Last name field',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Failed BAR-T200 Check that error message disappears after entering min 1 character in Last name field',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'BAR_T201 Check that user can enter max 50 characters in Last name field',
            '',
            'STARTED');

        final lName50Char = 'NameNameNameNameNameNameNameNameNameNameNameName50';
        await dashboardScreen.clickProfileIcon(tester);
        await profileScreen.verifyProfilePage(tester);
        await profileScreen.clickProfileDetailsButton(tester);
        await profileScreen.verifyProfileDetailtPage(tester);
        await profileScreen.inputLastName(lName50Char, tester);
        await profileScreen.clickUpdateProfileButton(tester);
        await profileScreen.verifyShowMessage('First name should be up to 32 characters', tester);
        await profileScreen.verifyShowMessage('Success!', tester);
        await htLogd(tester, 'BAR_T201 ', '', 'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Failed BAR-T201 Check that user can enter max 50 characters in Last name field',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'BAR_T202 Check that user can enter any symbols in First name field', '', 'STARTED');

        await dashboardScreen.clickProfileIcon(tester);
        await profileScreen.verifyProfilePage(tester);
        await profileScreen.clickProfileDetailsButton(tester);
        await profileScreen.verifyProfileDetailtPage(tester);
        await profileScreen.inputFirstName(getRandomSymbolString(10), tester);
        await profileScreen.clickUpdateProfileButton(tester);
        await profileScreen.verifyShowMessage('Success!', tester);
        await profileScreen.clickButton('Continue', tester);

        await htLogd(tester, 'BAR_T202 Check that user can enter any symbols in First name field',
            '', 'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Failed BAR-T202 Check that user can enter any symbols in First name field',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'BAR_T203 Check that user can enter any symbols in Last name field', '', 'STARTED');

        await dashboardScreen.clickProfileIcon(tester);
        await profileScreen.verifyProfilePage(tester);
        await profileScreen.clickProfileDetailsButton(tester);
        await profileScreen.verifyProfileDetailtPage(tester);
        await profileScreen.inputLastName(getRandomSymbolString(10), tester);
        await profileScreen.clickUpdateProfileButton(tester);
        await profileScreen.verifyShowMessage('Success!', tester);
        await profileScreen.clickButton('Continue', tester);

        await htLogd(tester, 'BAR_T203 Check that user can enter any symbols in Last name field',
            '', 'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Failed BAR-T203 Check that user can enter any symbols in Last name field',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'BAR_T204 Check that user sees error message if enter digits in  First name field',
            '',
            'STARTED');

        await dashboardScreen.clickProfileIcon(tester);
        await profileScreen.verifyProfilePage(tester);
        await profileScreen.clickProfileDetailsButton(tester);
        await profileScreen.verifyProfileDetailtPage(tester);
        await profileScreen.inputFirstName(getRandomNumber(5), tester);
        await profileScreen.clickUpdateProfileButton(tester);
        await profileScreen.verifyShowMessage('Success!', tester);
        await profileScreen.clickButton('Continue', tester);
        await profileScreen.verifyShowMessage(
            "The goal's name should include at least 1 character. Please re-enter the goal's name",
            tester);

        await htLogd(
            tester,
            'BAR_T204 Check that user sees error message if enter digits in  First name field',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Failed BAR-T204 Check that user sees error message if enter digits in  First name field',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'BAR_T205 Check that user sees error message if enter digits in Last name field',
            '',
            'STARTED');

        await dashboardScreen.clickProfileIcon(tester);
        await profileScreen.verifyProfilePage(tester);
        await profileScreen.clickProfileDetailsButton(tester);
        await profileScreen.verifyProfileDetailtPage(tester);
        await profileScreen.inputLastName(getRandomNumber(5), tester);
        await profileScreen.clickUpdateProfileButton(tester);
        await profileScreen.verifyShowMessage('Success!', tester);
        await profileScreen.clickButton('Continue', tester);
        await profileScreen.verifyShowMessage(
            "The goal's name should include at least 1 character. Please re-enter the goal's name",
            tester);

        await htLogd(
            tester,
            'BAR_T205 Check that user sees error message if enter digits in Last name field',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Failed BAR-T205 Check that user sees error message if enter digits in Last name field',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect('BAR_T208 Check that user can update "Dependents”', '', 'STARTED');

        await dashboardScreen.clickProfileIcon(tester);
        await profileScreen.verifyProfilePage(tester);
        await profileScreen.clickProfileDetailsButton(tester);
        await profileScreen.verifyProfileDetailtPage(tester);
        final dependentOption = dependentOptions;
        for (int i = 1; i < dependentOption.length; i++) {
          await profileScreen.clickDropdownButton(dependentsBtn, tester);
          await profileScreen.verifySelectDropdown(dependentsBtn, dependentOption[i], tester);
          await profileScreen.clickUpdateProfileButton(tester);
          await profileScreen.clickContinueButton(tester);
          await profileScreen.verifyShowMessage(dependentOption[i], tester);
        }

        await htLogd(tester, 'BAR_T208 Check that user can update "Dependents”', '', 'FINISHED');
      } catch (e) {
        await htLogd(
            tester, 'Failed BAR-T208 Check that user can update "Dependents”', '', 'FINISHED');
      }

      try {
        await htLogdDirect(
            'BAR_T209 Check that user can update "Relationships status”', '', 'STARTED');

        await dashboardScreen.clickProfileIcon(tester);
        await profileScreen.verifyProfilePage(tester);
        await profileScreen.clickProfileDetailsButton(tester);
        await profileScreen.verifyProfileDetailtPage(tester);
        final relationshipOption = relationshipOptions;
        for (int i = 1; i < relationshipOption.length; i++) {
          await profileScreen.clickDropdownButton(relationshipStatusBtn, tester);
          await profileScreen.verifySelectDropdown(
              relationshipStatusBtn, relationshipOption[i], tester);
          await profileScreen.clickUpdateProfileButton(tester);
          await profileScreen.clickContinueButton(tester);
          await profileScreen.verifyShowMessage(relationshipOption[i], tester);
        }

        await htLogd(
            tester, 'BAR_T209 Check that user can update "Relationships status”', '', 'FINISHED');
      } catch (e) {
        await htLogd(tester, 'Failed BAR-T209 Check that user can update "Relationships status”',
            '', 'FINISHED');
      }

      try {
        await htLogdDirect('BAR_T210 Check that user can update "Education”', '', 'STARTED');

        await dashboardScreen.clickProfileIcon(tester);
        await profileScreen.verifyProfilePage(tester);
        await profileScreen.clickProfileDetailsButton(tester);
        await profileScreen.verifyProfileDetailtPage(tester);
        final educationOption = educationOptions;
        for (int i = 1; i < educationOption.length; i++) {
          await profileScreen.clickDropdownButton(educationBtn, tester);
          await profileScreen.verifySelectDropdown(educationBtn, educationOption[i], tester);
          await profileScreen.clickUpdateProfileButton(tester);
          await profileScreen.clickContinueButton(tester);
          await profileScreen.verifyShowMessage(educationOption[i], tester);
        }

        await htLogd(tester, 'BAR_T210 Check that user can update "Education”', '', 'FINISHED');
      } catch (e) {
        await htLogd(
            tester, 'Failed BAR-T210 Check that user can update "Education”', '', 'FINISHED');
      }

      try {
        await htLogdDirect('BAR_T211 Check that user can update "Employment”', '', 'STARTED');

        await dashboardScreen.clickProfileIcon(tester);
        await profileScreen.verifyProfilePage(tester);
        await profileScreen.clickProfileDetailsButton(tester);
        await profileScreen.verifyProfileDetailtPage(tester);
        final employOption = employOptions;
        for (int i = 1; i < employOption.length; i++) {
          await profileScreen.clickDropdownButton(employmentBtn, tester);
          await profileScreen.verifySelectDropdown(employmentBtn, employOption[i], tester);
          await profileScreen.clickUpdateProfileButton(tester);
          await profileScreen.clickContinueButton(tester);
          await profileScreen.verifyShowMessage(employOption[i], tester);
        }

        await htLogd(tester, 'BAR_T211 Check that user can update "Employment”', '', 'FINISHED');
      } catch (e) {
        await htLogd(
            tester, 'Failed BAR-T211 Check that user can update "Employment”', '', 'FINISHED');
      }

      try {
        await htLogdDirect('BAR_T212 Check that user can update "Occupation”', '', 'STARTED');

        await dashboardScreen.clickProfileIcon(tester);
        await profileScreen.verifyProfilePage(tester);
        await profileScreen.clickProfileDetailsButton(tester);
        await profileScreen.verifyProfileDetailtPage(tester);
        final occupationOption = occupationOptions;
        await profileScreen.verifyShowMessage(occupationOption[0], tester);
        for (int i = 1; i < occupationOption.length; i++) {
          await profileScreen.clickDropdownButton(occupationBtn, tester);
          await profileScreen.verifySelectDropdown(occupationBtn, occupationOption[i], tester);
          await profileScreen.clickUpdateProfileButton(tester);
          await profileScreen.clickContinueButton(tester);
          await profileScreen.verifyShowMessage(occupationOption[i], tester);
        }
        await profileScreen.clickDropdownButton(occupationBtn, tester);
        await profileScreen.verifySelectDropdown(occupationBtn, occupationOption[0], tester);
        await profileScreen.clickUpdateProfileButton(tester);
        await profileScreen.clickContinueButton(tester);

        await htLogd(tester, 'BAR_T212 Check that user can update "Occupation”', '', 'FINISHED');
      } catch (e) {
        await htLogd(
            tester, 'Failed BAR-T212 Check that user can update "Occupation”', '', 'FINISHED');
      }

      try {
        await htLogdDirect('BAR_T213 Check that user can update "Gender”', '', 'STARTED');

        await dashboardScreen.clickProfileIcon(tester);
        await profileScreen.verifyProfilePage(tester);
        await profileScreen.clickProfileDetailsButton(tester);
        await profileScreen.verifyProfileDetailtPage(tester);
        final genderOption = genderOptions;
        await profileScreen.verifyShowMessage(genderOption[0], tester);
        for (int i = 1; i < genderOption.length; i++) {
          await profileScreen.clickDropdownButton(genderBtn, tester);
          await profileScreen.verifySelectDropdown(genderBtn, genderOption[i], tester);
          await profileScreen.clickUpdateProfileButton(tester);
          await profileScreen.clickContinueButton(tester);
          await profileScreen.verifyShowMessage(genderOption[i], tester);
        }
        await profileScreen.clickDropdownButton(genderBtn, tester);
        await profileScreen.verifySelectDropdown(genderBtn, genderOption[0], tester);
        await profileScreen.clickUpdateProfileButton(tester);
        await profileScreen.clickContinueButton(tester);

        await htLogd(tester, 'BAR_T213 Check that user can update "Gender”', '', 'FINISHED');
      } catch (e) {
        await htLogd(tester, 'Failed BAR-T213 Check that user can update "Gender”', '', 'FINISHED');
      }

      try {
        await htLogdDirect('BAR_T214 Check that user can update "Gender”', '', 'STARTED');

        await dashboardScreen.clickProfileIcon(tester);
        await profileScreen.verifyProfilePage(tester);
        await profileScreen.clickProfileDetailsButton(tester);
        await profileScreen.verifyProfileDetailtPage(tester);
        final genderOption = genderOptions;
        await profileScreen.verifyShowMessage(genderOption[0], tester);
        for (int i = 1; i < genderOption.length; i++) {
          await profileScreen.clickDropdownButton(genderBtn, tester);
          await profileScreen.verifySelectDropdown(genderBtn, genderOption[i], tester);
          await profileScreen.clickUpdateProfileButton(tester);
          await profileScreen.clickContinueButton(tester);
          await profileScreen.verifyShowMessage(genderOption[i], tester);
        }
        await profileScreen.clickDropdownButton(genderBtn, tester);
        await profileScreen.verifySelectDropdown(genderBtn, genderOption[0], tester);
        await profileScreen.clickUpdateProfileButton(tester);
        await profileScreen.clickContinueButton(tester);

        await htLogd(tester, 'BAR_T214 Check that user can update "Gender”', '', 'FINISHED');
      } catch (e) {
        await htLogd(tester, 'Failed BAR-T214 Check that user can update "Gender”', '', 'FINISHED');
      }

      try {
        await htLogdDirect('BAR_T98 Check that user can update “First Name” and “Last Name” fields',
            '', 'STARTED');

        await dashboardScreen.clickProfileIcon(tester);
        await profileScreen.verifyProfilePage(tester);
        await profileScreen.clickProfileDetailsButton(tester);
        await profileScreen.verifyProfileDetailtPage(tester);
        await profileScreen.inputUpdateName('fNameUpdate', 'lNameUpdate', tester);
        await profileScreen.clickUpdateProfileButton(tester);
        await profileScreen.verifyShowMessage('Success!', tester);
        await profileScreen.clickButton('Continue', tester);
        await profileScreen.clickBackButton(tester);
        await profileScreen.verifyNameUpdate('fNameUpdate', 'lNameUpdate', tester);
        await profileScreen.clickProfileDetailsButton(tester);
        await profileScreen.verifyProfileDetailtPage(tester);
        await profileScreen.inputUpdateName('Bao', 'Test', tester);
        await profileScreen.clickUpdateProfileButton(tester);
        await profileScreen.verifyShowMessage('Success!', tester);
        await profileScreen.clickButton('Continue', tester);
        await profileScreen.clickBackButton(tester);
        await profileScreen.verifyNameUpdate('Bao', 'Test', tester);

        await htLogd(
            tester,
            'BAR_T98 Check that user can update “First Name” and “Last Name” fields',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Failed BAR-T98 Check that user can update “First Name” and “Last Name” fields',
            '',
            'FINISHED');
      }
    });
  });
}
