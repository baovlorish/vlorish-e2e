import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:burgundy_budgeting_app/main.dart' as app;

import 'screen/auth_test.dart';
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

      print('BAR-T2 SignUp Web with invalid email');
      await signUpScreen.clickBtnSignIn();
      await signInScreen.clickBtnSignUp();
      await signUpScreen.inputEmail('test');
      await signUpScreen.clickBtnNext();
      await signUpScreen.verifyErrorMessage(
          'Please enter a valid email address. Valid email address example: nameofthemail@mail.com');

      print('BAR-T4 SignUp Web with email empty');
      await signUpScreen.inputEmail('');
      await signUpScreen.clickBtnNext();
      await signUpScreen.verifyErrorMessage('Please, enter your email');

      print('BAR-T5 SignUp Web with click sign-in');
      await signUpScreen.clickBtnSignIn();
      await signInScreen.verifySignInPage();

      print(
          'BAR-T6 User see error message on SignUp page if email is already exists in database');
      await signInScreen.clickBtnSignUp();
      await signUpScreen.inputEmail('farah.ali1021@gmail.com');
      await signUpScreen.clickBtnNext();
      await signUpScreen.verifyErrorMessage(
          'This email has already been taken by some other user. Please try using another email address');

      print(
          'BAR-T8 User see error message if Password fields are empty after clicking “Agree & Continue” button');

      await signUpScreen
          .inputEmail(signInScreen.generateRandomString(10) + '@gmail.com');
      await signUpScreen.clickBtnNext();
      await signUpScreen.inputPassword('');
      await signUpScreen.inputConfirmPassword('');
      await signUpScreen.clickAgreeAndContinueBtn();
      // await signUpScreen.verifyErrorMessage('Please enter your password');
      // await signUpScreen.verifyErrorMessage('Please confirm your password');

      print(
          'BAR-T9 User see error message if Confirm Password fields is empty');
      await signUpScreen.clickBtnSignIn();
      await signInScreen.clickBtnSignUp();
      await signUpScreen
          .inputEmail(signInScreen.generateRandomString(10) + '@gmail.com');
      await signUpScreen.clickBtnNext();
      await signUpScreen.inputPassword('Test124\$');
      await signUpScreen.inputConfirmPassword('');
      await signUpScreen.clickAgreeAndContinueBtn();
      //await signUpScreen.verifyErrorMessage('Please confirm your password');

      print('BAR-T9 User see error message if he Password fields is empty');
      await signUpScreen.clickBtnSignIn();
      await signInScreen.clickBtnSignUp();
      await signUpScreen
          .inputEmail(signInScreen.generateRandomString(10) + '@gmail.com');
      await signUpScreen.clickBtnNext();
      await signUpScreen.inputPassword('');
      await signUpScreen.inputConfirmPassword('Test124\$');
      await signUpScreen.clickAgreeAndContinueBtn();
      //await signUpScreen.verifyErrorMessage('Please enter your password');

      print(
          'BAR-T10 User is redirected on Terms&Conditions page after clicking on Terms link');
      await signUpScreen.clickBtnSignIn();
      await signInScreen.clickBtnSignUp();
      await signUpScreen
          .inputEmail(signInScreen.generateRandomString(10) + '@gmail.com');
      await signUpScreen.clickBtnNext();
      await signUpScreen.clickAndVerifyTermLink();

      print('Login Web with empty email');
      await signUpScreen.clickBtnSignIn();
      await signInScreen.inputEmailAndPassword('', 'Abcd123!@#');
      await signInScreen.clickLoginButton();
      await signInScreen.verifyErrorMessage('Please, enter your email');

      print('Login Web with empty password');
      await signInScreen.inputEmailAndPassword('test123@gmail.com', '');
      await signInScreen.clickLoginButton();
      await signInScreen.verifyErrorMessage('Please enter your password');
    });
  });
}
