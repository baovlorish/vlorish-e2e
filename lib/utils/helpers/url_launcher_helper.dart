import 'package:burgundy_budgeting_app/domain/error/custom_error.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> openUrl({
  required String url,
  required bool launchInThisTab,
  required String exceptionMessage,
}) async {
  await canLaunch(url)
      ? await launch(
          url,
          enableJavaScript: true,
          forceSafariVC: true,
          forceWebView: true,
          webOnlyWindowName: launchInThisTab ? '_self' : null,
        )
      : throw CustomException(exceptionMessage);
}
