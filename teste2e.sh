rm /integration_test/output-temp.txt
flutter drive --driver test_driver/integration_test_driver.dart --target integration_test/signin_test.dart -d chrome |./integration_test/testout.sh
flutter drive --driver test_driver/integration_test_driver.dart --target integration_test/signup_test.dart -d chrome |./integration_test/testout.sh
flutter drive --driver test_driver/integration_test_driver.dart --target integration_test/forgot_password_test.dart -d chrome |./integration_test/testout.sh
flutter drive --driver test_driver/integration_test_driver.dart --target integration_test/personal_budget_test.dart -d chrome |./integration_test/testout.sh
flutter drive --driver test_driver/integration_test_driver.dart --target integration_test/profile_test.dart -d chrome |./integration_test/testout.sh