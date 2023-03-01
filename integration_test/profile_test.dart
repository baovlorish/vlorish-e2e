import 'dart:io';
import './lib/test_lib_common.dart';
import './lib/test_lib_const.dart';
import './lib/function_common.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:burgundy_budgeting_app/main.dart' as app;
import 'screen/dashboard.dart';
import 'screen/signin.dart';
import 'screen/budget.dart';
import 'screen/profile.dart';

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
            'BAR_T186 User is redirected on Profile flow page after clicking on Profile icon',
            '',
            'STARTED');
        await dashboardScreen.clickProfileIcon(tester);
        await profileScreen.verifyProfilePage(tester);
        await htLogd(
            tester,
            'BAR_T186 User is redirected on Profile flow page after clicking on Profile icon',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Failed BAR-T186 User is redirected on Profile flow page after clicking on Profile icon',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'BAR_T103 New Password field contains at least 8 characters',
            '',
            'STARTED');
        await dashboardScreen.clickProfileIcon(tester);
        await profileScreen.verifyProfilePage(tester);
        await profileScreen.inputUpdatePassword(passLogin, 'Test13@', tester);
        await profileScreen.clickUpdatePasswordButton(tester);
        await profileScreen.verifyMessageErrorIsVisible(
            'contains at least 8 characters', tester,
            context: context);
        await htLogd(
            tester,
            'BAR_T103 New Password field contains at least 8 characters',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Failed BAR-T103 New Password field contains at least 8 characters',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'BAR_T104 User can make password visible after clicking on "eye" button',
            '',
            'STARTED');
        await dashboardScreen.clickProfileIcon(tester);
        await profileScreen.verifyProfilePage(tester);
        await profileScreen.inputUpdatePassword(passLogin, '', tester);
        await profileScreen.clickEyePassword(0, tester);
        await profileScreen.verifyPasswordShow(passLogin, tester);

        await htLogd(
            tester,
            'BAR_T104 User can make password visible after clicking on "eye" button',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Failed BAR-T104 User can make password visible after clicking on "eye" button',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'BAR_T105 User can make password invisible after clicking on “eye” button if password is visible',
            '',
            'STARTED');
        await dashboardScreen.clickProfileIcon(tester);
        await profileScreen.verifyProfilePage(tester);
        await profileScreen.inputUpdatePassword(passLogin, '', tester);
        await profileScreen.clickEyePassword(0, tester);
        await profileScreen.verifyPasswordShow(passLogin, tester);
        await profileScreen.clickEyePassword(0, tester);
        await profileScreen.verifyPasswordHidden(passLogin, tester);

        await htLogd(
            tester,
            'BAR_T105 User can make password invisible after clicking on “eye” button if password is visible',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Failed BAR-T105 User can make password invisible after clicking on “eye” button if password is visible',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'BAR_T106 User can enter max 128 characters in Password fields',
            '',
            'STARTED');
        final pass128 =
            'Test128#Test128#Test128#Test128#Test128#Test128#Test128#Test128#Test128#Test128#Test128#Test128#Test128#Test128#Test128#Test128#';
        final passGreaterThan128 =
            'Test128#Test128#Test128#Test128#Test128#Test128#Test128#Test128#Test128#Test128#Test128#Test128#Test128#Test128#Test128#Test128#9';
        await dashboardScreen.clickProfileIcon(tester);
        await profileScreen.verifyProfilePage(tester);
        await profileScreen.inputUpdatePassword(
            passLogin, passGreaterThan128, tester);
        await profileScreen.clickEyePassword(1, tester);
        await profileScreen.verifyNewPasswordMax128Char(
            pass128, passGreaterThan128, tester);
        await htLogd(
            tester,
            'BAR_T106 User can enter max 128 characters in Password fields',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Failed BAR-T106 User can enter max 128 characters in Password fields',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'BAR_T107 User sees error message and can not update password if password does not contain 1 special char',
            '',
            'STARTED');
        await dashboardScreen.clickProfileIcon(tester);
        await profileScreen.inputUpdatePassword(passLogin, 'Test1234', tester);
        await profileScreen.clickUpdatePasswordButton(tester);
        await profileScreen.verifyMessageErrorIsVisible(
            'contains at least one number (0-9) and a symbol', tester,
            context: context);
        await htLogd(
            tester,
            'BAR_T107 User sees error message and can not update password if password does not contain 1 special char',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Failed BAR-T107 User sees error message and can not update password if password does not contain 1 special char',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'BAR_T108 User sees error message and can not update password if password does not contain 1 number',
            '',
            'STARTED');
        await dashboardScreen.clickProfileIcon(tester);
        await profileScreen.inputUpdatePassword(
            passLogin, 'testPassword@', tester);
        await profileScreen.clickUpdatePasswordButton(tester);
        await profileScreen.verifyMessageErrorIsVisible(
            'contains at least one number (0-9) and a symbol', tester,
            context: context);
        await htLogd(
            tester,
            'BAR_T108 User sees error message and can not update password if password does not contain 1 number',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Failed BAR-T108 User sees error message and can not update password if password does not contain 1 number',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'BAR_T109 User sees error message and can not update password if password does not contain 1 uppercase',
            '',
            'STARTED');
        await dashboardScreen.clickProfileIcon(tester);
        await profileScreen.inputUpdatePassword(
            passLogin, 'password@123', tester);
        await profileScreen.clickUpdatePasswordButton(tester);
        await profileScreen.verifyMessageErrorIsVisible(
            'contains both lower (a-z) and upper case letters (A-Z)', tester,
            context: context);
        await htLogd(
            tester,
            'BAR_T109 User sees error message and can not update password if password does not contain 1 uppercase',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Failed BAR-T109 User sees error message and can not update password if password does not contain 1 uppercase',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'BAR_T110 User sees error message and can not update password if password does not contain 1 lowercase',
            '',
            'STARTED');
        await dashboardScreen.clickProfileIcon(tester);
        await profileScreen.inputUpdatePassword(
            passLogin, 'TESTPASSWORD', tester);
        await profileScreen.clickUpdatePasswordButton(tester);
        await profileScreen.verifyMessageErrorIsVisible(
            'contains both lower (a-z) and upper case letters (A-Z)', tester,
            context: context);
        await htLogd(
            tester,
            'BAR_T110 User sees error message and can not update password if password does not contain 1 lowercase',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Failed BAR-T110 User sees error message and can not update password if password does not contain 1 lowercase',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'BAR_T111 User can not update password if current password is invalid',
            '',
            'STARTED');
        await dashboardScreen.clickProfileIcon(tester);
        await profileScreen.inputUpdatePassword(
            'Test@123456', 'Pass@123456', tester);
        await profileScreen.clickUpdatePasswordButton(tester);
        await profileScreen.verifyShowMessage('Error!', tester);
        await profileScreen.verifyShowMessage(
            'Password does not match with the current password. Please re-enter the password',
            tester);
        await profileScreen.clickPopupButton('Try again', tester);
        await htLogd(
            tester,
            'BAR_T111 User can not update password if current password is invalid',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Failed BAR-T111 User can not update password if current password is invalid',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'BAR_T112 Check that Unsubscribe pop-up appears after clicking on "Close account" button',
            '',
            'STARTED');
        await dashboardScreen.clickProfileIcon(tester);
        await profileScreen.scrollThePage();
        await profileScreen.clickButton('Close account', tester);
        await profileScreen.verifyShowMessage(
            'Are you sure you want to close your Vlorish account?', tester);
        await htLogd(
            tester,
            'BAR_T112 Check that Unsubscribe pop-up appears after clicking on "Close account" button',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Failed BAR-T112 Check that Unsubscribe pop-up appears after clicking on "Close account" button',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'BAR_T113 Unsubscribe Popup is closed after clicking on "No" button on "Close account" pop up',
            '',
            'STARTED');
        await dashboardScreen.clickProfileIcon(tester);
        await profileScreen.scrollThePage();
        await profileScreen.clickButton('Close account', tester);
        await profileScreen.verifyShowMessage(
            'Are you sure you want to close your Vlorish account?', tester);
        await profileScreen.clickButton('No', tester);
        await profileScreen.verifyHideMessage(
            'Are you sure you want to close your Vlorish account?', tester);
        await htLogd(
            tester,
            'BAR_T113 Unsubscribe Popup is closed after clicking on "No" button on "Close account" pop up',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Failed BAR-T113 Unsubscribe Popup is closed after clicking on "No" button on "Close account" pop up',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'BAR_T117 User sees error message if password fields are empty',
            '',
            'STARTED');
        await dashboardScreen.clickProfileIcon(tester);
        await profileScreen.inputUpdatePassword('', '', tester);
        await profileScreen.clickUpdatePasswordButton(tester);
        await profileScreen.verifyMessageErrorIsVisible(
            'Please enter your current password', tester);
        await profileScreen.verifyMessageErrorIsVisible(
            'contains at least 8 characters', tester);
        await profileScreen.verifyMessageErrorIsVisible(
            'contains both lower (a-z) and upper case letters (A-Z)', tester);
        await profileScreen.verifyMessageErrorIsVisible(
            'contains at least one number (0-9) and a symbol', tester);
        await htLogd(
            tester,
            'BAR_T117 User sees error message if password fields are empty',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Failed BAR-T117 User sees error message if password fields are empty',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'BAR_T118 User sees error message if one of the password field is empty',
            '',
            'STARTED');
        await dashboardScreen.clickProfileIcon(tester);
        await profileScreen.inputUpdatePassword('', 'Test@12345', tester);
        await profileScreen.clickUpdatePasswordButton(tester);
        await profileScreen.verifyMessageErrorIsVisible(
            'Please enter your current password', tester);
        await profileScreen.inputUpdatePassword(passLogin, '', tester);
        await profileScreen.clickUpdatePasswordButton(tester);
        await profileScreen.verifyMessageErrorIsVisible(
            'contains at least 8 characters', tester);
        await profileScreen.verifyMessageErrorIsVisible(
            'contains both lower (a-z) and upper case letters (A-Z)', tester);
        await profileScreen.verifyMessageErrorIsVisible(
            'contains at least one number (0-9) and a symbol', tester);
        await htLogd(
            tester,
            'BAR_T118 User sees error message if one of the password field is empty',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Failed BAR-T118 User sees error message if one of the password field is empty',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'BAR_T185 User sees error message if current password does not match with the existing password',
            '',
            'STARTED');
        final pass = getRandomString(3) + getRandomNumber(3) + 'aB@';
        await dashboardScreen.clickProfileIcon(tester);
        await profileScreen.verifyProfilePage(tester);
        await profileScreen.inputUpdatePassword(pass, '', tester);
        await profileScreen.clickUpdatePasswordButton(tester);
        await profileScreen.verifyShowMessage(
            'Password does not match with the current password. Please re-enter the password',
            tester,
            context: context);
        await htLogd(
            tester,
            'BAR_T185 User sees error message if current password does not match with the existing password',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Failed BAR-T185 User sees error message if current password does not match with the existing password',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'BAR_T188 Check that user can update “City” and “State” fields',
            '',
            'STARTED');
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
        await profileScreen.selectCity(
            'San Francisco', 'San Francisco, CA', tester);
        await profileScreen.clickUpdateProfileButton(tester);
        await profileScreen.verifyShowMessage('Success!', tester);
        await dashboardScreen.clickButton('Continue', tester);
        await htLogd(
            tester,
            'BAR_T188 Check that user can update “City” and “State” fields',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Failed BAR-T188 Check that user can update “City” and “State” fields',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'BAR_T189 Check that user can select Gender', '', 'STARTED');

        await dashboardScreen.clickProfileIcon(tester);
        await profileScreen.verifyProfilePage(tester);
        await profileScreen.clickProfileDetailsButton(tester);
        await profileScreen.verifyProfileDetailtPage(tester);
        final genderOption = genderOptions;
        for (int i = 0; i < genderOption.length; i++) {
          await profileScreen.clickDropdownButton(genderBtn, tester);
          await profileScreen.verifySelectDropdown(
              genderBtn, genderOption[i], tester);
        }

        await htLogd(tester, 'BAR_T189 Check that user can select Gender', '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Failed BAR-T189 Check that user can select Gender',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'BAR_T190 Check that user can select Relationship Status',
            '',
            'STARTED');

        await dashboardScreen.clickProfileIcon(tester);
        await profileScreen.verifyProfilePage(tester);
        await profileScreen.clickProfileDetailsButton(tester);
        await profileScreen.verifyProfileDetailtPage(tester);
        final relationshipOption = relationshipOptions;
        for (int i = 0; i < relationshipOption.length; i++) {
          await profileScreen.clickDropdownButton(
              relationshipStatusBtn, tester);
          await profileScreen.verifySelectDropdown(
              relationshipStatusBtn, relationshipOption[i], tester);
        }

        await htLogd(
            tester,
            'BAR_T190 Check that user can select Relationship Status',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Failed BAR-T190 Check that user can select Relationship Status',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'BAR_T191 Check that user can select Education', '', 'STARTED');

        await dashboardScreen.clickProfileIcon(tester);
        await profileScreen.verifyProfilePage(tester);
        await profileScreen.clickProfileDetailsButton(tester);
        await profileScreen.verifyProfileDetailtPage(tester);
        final educationOption = educationOptions;
        for (int i = 0; i < educationOption.length; i++) {
          await profileScreen.clickDropdownButton(educationBtn, tester);
          await profileScreen.verifySelectDropdown(
              educationBtn, educationOption[i], tester);
        }

        await htLogd(tester, 'BAR_T191 Check that user can select Education',
            '', 'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Failed BAR-T191 Check that user can select Education',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'BAR_T192 Check that user can select Employment', '', 'STARTED');

        await dashboardScreen.clickProfileIcon(tester);
        await profileScreen.verifyProfilePage(tester);
        await profileScreen.clickProfileDetailsButton(tester);
        await profileScreen.verifyProfileDetailtPage(tester);
        final employOption = employOptions;
        for (int i = 0; i < employOption.length; i++) {
          await profileScreen.clickDropdownButton(employmentBtn, tester);
          await profileScreen.verifySelectDropdown(
              employmentBtn, employOption[i], tester);
        }

        await htLogd(tester, 'BAR_T192 Check that user can select Employment',
            '', 'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Failed BAR-T192 Check that user can select Employment',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'BAR_T193 Check that user can select Occupation', '', 'STARTED');

        await dashboardScreen.clickProfileIcon(tester);
        await profileScreen.verifyProfilePage(tester);
        await profileScreen.clickProfileDetailsButton(tester);
        await profileScreen.verifyProfileDetailtPage(tester);
        final occupationOption = occupationOptions;
        for (int i = 0; i < occupationOption.length; i++) {
          await profileScreen.clickDropdownButton(occupationBtn, tester);
          await profileScreen.verifySelectDropdown(
              occupationBtn, occupationOption[i], tester);
        }
        await htLogd(tester, 'BAR_T193 Check that user can select Occupation',
            '', 'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Failed BAR-T193 Check that user can select Occupation',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'BAR_T195 Check that user can select Dependents', '', 'STARTED');

        await dashboardScreen.clickProfileIcon(tester);
        await profileScreen.verifyProfilePage(tester);
        await profileScreen.clickProfileDetailsButton(tester);
        await profileScreen.verifyProfileDetailtPage(tester);
        final dependentOption = dependentOptions;
        for (int i = 0; i < dependentOption.length; i++) {
          await profileScreen.clickDropdownButton(dependentsBtn, tester);
          await profileScreen.verifySelectDropdown(
              dependentsBtn, dependentOption[i], tester);
        }
        await htLogd(tester, 'BAR_T195 Check that user can select Dependents',
            '', 'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Failed BAR-T195 Check that user can select Dependents',
            '',
            'FINISHED');
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
        await profileScreen.verifyShowMessage(
            'Please enter your first name', tester);
        await profileScreen.inputFirstName(getRandomCharacter(1), tester);
        await profileScreen.clickUpdateProfileButton(tester);
        await profileScreen.verifyShowMessage('Success!', tester);
        await profileScreen.clickButton('Continue', tester);
        await profileScreen.verifyHideMessage(
            'Please enter your first name', tester);

        await htLogd(
            tester,
            'BAR_T198 Check that error message disappears after entering min 1 character in First name field',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Error BAR-T198 Check that error message disappears after entering min 1 character in First name field',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'BAR_T199 Check that user can enter max 50 characters in First name field',
            '',
            'STARTED');

        final fName50Char =
            'NameNameNameNameNameNameNameNameNameNameNameName50';
        await dashboardScreen.clickProfileIcon(tester);
        await profileScreen.verifyProfilePage(tester);
        await profileScreen.clickProfileDetailsButton(tester);
        await profileScreen.verifyProfileDetailtPage(tester);
        await profileScreen.inputFirstName(fName50Char, tester);
        await profileScreen.clickUpdateProfileButton(tester);
        await profileScreen.verifyShowMessage(
            'First name should be up to 32 characters', tester);
        await profileScreen.verifyShowMessage('Success!', tester);
        await htLogd(
            tester,
            'BAR_T199 Check that user can enter max 50 characters in First name field',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Error BAR-T199 Check that user can enter max 50 characters in First name field',
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
        await profileScreen.verifyShowMessage(
            'Please enter your last name', tester);
        await profileScreen.inputLastName(getRandomCharacter(1), tester);
        await profileScreen.clickUpdateProfileButton(tester);
        await profileScreen.verifyShowMessage('Success!', tester);
        await profileScreen.clickButton('Continue', tester);
        await profileScreen.verifyHideMessage(
            'Please enter your last name', tester);

        await htLogd(
            tester,
            'BAR_T200 Check that error message disappears after entering min 1 character in Last name field',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Error BAR-T200 Check that error message disappears after entering min 1 character in Last name field',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'BAR_T201 Check that user can enter max 50 characters in Last name field',
            '',
            'STARTED');

        final lName50Char =
            'NameNameNameNameNameNameNameNameNameNameNameName50';
        await dashboardScreen.clickProfileIcon(tester);
        await profileScreen.verifyProfilePage(tester);
        await profileScreen.clickProfileDetailsButton(tester);
        await profileScreen.verifyProfileDetailtPage(tester);
        await profileScreen.inputLastName(lName50Char, tester);
        await profileScreen.clickUpdateProfileButton(tester);
        await profileScreen.verifyShowMessage(
            'First name should be up to 32 characters', tester);
        await profileScreen.verifyShowMessage('Success!', tester);
        await htLogd(tester, 'BAR_T201 ', '', 'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Error BAR-T201 Check that user can enter max 50 characters in Last name field',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'BAR_T202 Check that user can enter any symbols in First name field',
            '',
            'STARTED');

        await dashboardScreen.clickProfileIcon(tester);
        await profileScreen.verifyProfilePage(tester);
        await profileScreen.clickProfileDetailsButton(tester);
        await profileScreen.verifyProfileDetailtPage(tester);
        await profileScreen.inputFirstName(getRandomSymbolString(10), tester);
        await profileScreen.clickUpdateProfileButton(tester);
        await profileScreen.verifyShowMessage('Success!', tester);
        await profileScreen.clickButton('Continue', tester);

        await htLogd(
            tester,
            'BAR_T202 Check that user can enter any symbols in First name field',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Error BAR-T202 Check that user can enter any symbols in First name field',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'BAR_T203 Check that user can enter any symbols in Last name field',
            '',
            'STARTED');

        await dashboardScreen.clickProfileIcon(tester);
        await profileScreen.verifyProfilePage(tester);
        await profileScreen.clickProfileDetailsButton(tester);
        await profileScreen.verifyProfileDetailtPage(tester);
        await profileScreen.inputLastName(getRandomSymbolString(10), tester);
        await profileScreen.clickUpdateProfileButton(tester);
        await profileScreen.verifyShowMessage('Success!', tester);
        await profileScreen.clickButton('Continue', tester);

        await htLogd(
            tester,
            'BAR_T203 Check that user can enter any symbols in Last name field',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Error BAR-T203 Check that user can enter any symbols in Last name field',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'BAR_T2024 Check that user sees error message if enter digits in  First name field',
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
            'Error BAR-T204 Check that user sees error message if enter digits in  First name field',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'BAR_T2025 Check that user sees error message if enter digits in Last name field',
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
            'Error BAR-T205 Check that user sees error message if enter digits in Last name field',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'BAR_T98 Check that user can update “First Name” and “Last Name” fields',
            '',
            'STARTED');

        await dashboardScreen.clickProfileIcon(tester);
        await profileScreen.verifyProfilePage(tester);
        await profileScreen.clickProfileDetailsButton(tester);
        await profileScreen.verifyProfileDetailtPage(tester);
        await profileScreen.inputUpdateName(
            'fNameUpdate', 'lNameUpdate', tester);
        await profileScreen.clickUpdateProfileButton(tester);
        await profileScreen.verifyShowMessage('Success!', tester);
        await profileScreen.clickButton('Continue', tester);
        await profileScreen.clickBackButton(tester);
        await profileScreen.verifyNameUpdate(
            'fNameUpdate', 'lNameUpdate', tester);
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

      try {
        await htLogdDirect(
            'BAR_T99 Check that user can update password', '', 'STARTED');
        await personalBudgetScreen.clickPersonalTab(tester);
        await dashboardScreen.clickProfileIcon(tester);
        await profileScreen.verifyProfilePage(tester);
        await profileScreen.inputUpdatePassword(
            passLogin, 'Hello@1234', tester);
        await profileScreen.clickUpdatePasswordButton(tester);
        await profileScreen.verifyShowMessage('Success!', tester);
        await dashboardScreen.clickLogoText();
        await dashboardScreen.clickLogoutButton(tester);
        await signInScreen.inputEmailAndPassword(emailLogin, passLogin, tester,
            context: context);
        await signInScreen.clickLoginButton(tester);
        await signInScreen.verifyErrorMessage(
            'The password is incorrect. Please check the password and try again',
            tester,
            context: context);
        await signInScreen.inputEmailAndPassword(
            emailLogin, 'Hello@1234', tester,
            context: context);
        await signInScreen.clickLoginButton(tester);
        await personalBudgetScreen.verifyPersonalBudgetPage(tester);
        await dashboardScreen.clickProfileIcon(tester);
        await profileScreen.verifyProfilePage(tester);
        await profileScreen.inputUpdatePassword(
            'Hello@1234', passLogin, tester);
        await profileScreen.clickUpdatePasswordButton(tester);
        await profileScreen.verifyShowMessage('Success!', tester);
        await dashboardScreen.clickLogoText();

        await htLogd(tester, 'BAR_T99 Check that user can update password', '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Failed BAR-T99 Check that user can update password',
            '',
            'FINISHED');
      }
    });
  });
}
