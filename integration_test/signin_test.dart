import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:burgundy_budgeting_app/main.dart' as app;
import 'screen/dashboard.dart';
import 'screen/signin.dart';
import 'screen/signup.dart';

void main() {
  SignInScreenTest signInScreen;
  SignUpScreenTest signUpScreen;
  DashboardScreenTest dashboardScreen;

  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Authentication Test', () {
    testWidgets('BAR-T1 SignUp Web with empty email', (tester) async {
      await app.main();
      signInScreen = SignInScreenTest(tester);
      signUpScreen = SignUpScreenTest(tester);
      dashboardScreen = DashboardScreenTest(tester);
      await dashboardScreen.clickLogoText();
      await signInScreen.clickBtnSignUp();
      await signUpScreen.inputEmail('test12@gmail.com');
      await signUpScreen.clickBtnNext();
      await signUpScreen.verifyPasswordPage();

      print(
          'BAR-T17 User can make password visible and invisible  after clicking on eye button');
      await dashboardScreen.clickLogoText();
      await signInScreen.clickBtnSignUp();
      await signUpScreen
          .inputEmail(signInScreen.generateRandomString(10) + '@gmail.com');
      await signUpScreen.clickBtnNext();

      await signUpScreen.inputPassword('ABV123#2');
      await signUpScreen.clickEyePassword();
      await signUpScreen.verifyPasswordShow('ABV123#2');
      await signUpScreen.clickEyePassword();
      await signUpScreen.verifyPasswordHidden('ABV123#2');

      await signUpScreen.inputConfirmPassword('ABV123#2');
      await signUpScreen.clickEyeConfirmPassword();
      await signUpScreen.verifyConfirmPasswordShow('ABV123#2');
      await signUpScreen.clickEyeConfirmPassword();
      await signUpScreen.verifyConfirmPasswordHidden('ABV123#2');

      print('T21 User can enter max128 characters in Password fields');
      await dashboardScreen.clickLogoText();
      await signInScreen.clickBtnSignUp();
      await signUpScreen
          .inputEmail(signInScreen.generateRandomString(10) + '@gmail.com');
      await signUpScreen.clickBtnNext();
      await signUpScreen.inputPassword(
          'fieldTest12345#Test12345#Test12345#Test12345#Test12345#Test12345#Test12345#Test12345#Test12345#Test12345#Test12345#Test12345#Test');
      await signUpScreen.inputConfirmPassword(
          'fieldTest12345#Test12345#Test12345#Test12345#Test12345#Test12345#Test12345#Test12345#Test12345#Test12345#Test12345#Test12345#Test');
      await signUpScreen.clickAgreeAndContinueBtn();
      await signUpScreen.verifyNotCurrentPassword(
          'fieldTest12345#Test12345#Test12345#Test12345#Test12345#Test12345#Test12345#Test12345#Test12345#Test12345#Test12345#Test12345#Test');
      await signUpScreen.verifyCurrentPassword(
          'fieldTest12345#Test12345#Test12345#Test12345#Test12345#Test12345#Test12345#Test12345#Test12345#Test12345#Test12345#Test12345#Tes');
      await signUpScreen.verifyErrorMessage(
          'Passwords do not match. Please re-enter the password.');

      print('T57 Login Web with empty email');
      await dashboardScreen.clickLogoText();
      await signInScreen.inputEmailAndPassword('', '');
      await signInScreen.clickLoginButton();
      await signInScreen.verifyErrorMessage('Please, enter your email');
      await signInScreen.verifyErrorMessage('Please enter your password');

      print('T58 Login Web with empty email');
      await dashboardScreen.clickLogoText();
      await signInScreen.inputEmailAndPassword('', 'Abcd123!@#');
      await signInScreen.clickLoginButton();
      await signInScreen.verifyErrorMessage('Please, enter your email');

      print('T58 Login Web with empty password');
      await dashboardScreen.clickLogoText();
      await signInScreen.inputEmailAndPassword('test123@gmail.com', '');
      await signInScreen.clickLoginButton();
      await signInScreen.verifyErrorMessage('Please enter your password');

      print(
          'T62 User is redirected on Sign Up flow after clicking on Sign Up button');
      await dashboardScreen.clickLogoText();
      await signInScreen.clickBtnSignUp();
      await signUpScreen.verifySignUpPage();

      print(
          'BAR-T11 User is redirected on Terms&Conditions page after clicking on Privacy link');
      await dashboardScreen.clickLogoText();
      await signInScreen.clickBtnSignUp();
      await signUpScreen
          .inputEmail(signInScreen.generateRandomString(10) + '@gmail.com');
      await signUpScreen.clickBtnNext();
      await signUpScreen.clickAndVerifyPrivacyLink();

      print(
          'BAR-T10 User is redirected on Terms&Conditions page after clicking on Terms link');
      await dashboardScreen.clickLogoText();
      await signInScreen.clickBtnSignUp();
      await signUpScreen
          .inputEmail(signInScreen.generateRandomString(10) + '@gmail.com');
      await signUpScreen.clickBtnNext();
      await signUpScreen.clickAndVerifyTermLink();
    });
  });
}
