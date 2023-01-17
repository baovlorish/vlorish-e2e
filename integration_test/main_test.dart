import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:burgundy_budgeting_app/main.dart' as app;

import 'screen/auth_test.dart';
import 'screen/signin_test.dart';

void main() {
  LoginScreenTest loginScreen;
  SignInScreenTest signInScreen;
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Authentication Test', () {
    testWidgets('BAR-T1 SignUp Web with empty email', (tester) async {
      await app.main();
      signInScreen = SignInScreenTest(tester);
      await signInScreen.clickBtnSignUp();
      await signInScreen.inputEmail('test@gmail.com');
      await signInScreen.clickBtnNext();
      await signInScreen.verifyPasswordPage();
    });

    testWidgets('BAR-T2 SignUp Web with invalid email', (tester) async {
      await app.main();
      signInScreen = SignInScreenTest(tester);
      await signInScreen.clickBtnSignUp();
      await signInScreen.inputEmail('test');
      await signInScreen.clickBtnNext();
      await signInScreen.verifyErrorMessage(
          'Please enter a valid email address. Valid email address example: nameofthemail@mail.com');
    });

    testWidgets('BAR-T4 SignUp Web with email empty', (tester) async {
      await app.main();
      signInScreen = SignInScreenTest(tester);
      await signInScreen.clickBtnSignUp();
      await signInScreen.inputEmail('');
      await signInScreen.clickBtnNext();
      await signInScreen.verifyErrorMessage('Please, enter your email');
    });

    testWidgets('BAR-T5 SignUp Web with click sign-in', (tester) async {
      await app.main();
      signInScreen = SignInScreenTest(tester);
      loginScreen = LoginScreenTest(tester);
      await signInScreen.clickBtnSignUp();
      await signInScreen.clickBtnSignIn();
      await loginScreen.verifySignInPage();
    });

    testWidgets('Login Web with empty email', (tester) async {
      await app.main();
      loginScreen = LoginScreenTest(tester);
      await loginScreen.inputEmailAndPassword('', 'Abcd123!@#');
      await loginScreen.clickLoginButton();
      await loginScreen.verifyErrorMessage('Please, enter your email');
    });
    testWidgets('Login Web with empty password', (tester) async {
      await app.main();
      loginScreen = LoginScreenTest(tester);
      await loginScreen.inputEmailAndPassword('test123@gmail.com', '');
      await loginScreen.clickLoginButton();
      await loginScreen.verifyErrorMessage('Please enter your password');
    });
  });
}
