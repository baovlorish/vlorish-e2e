import 'dart:html' as html;

import 'package:burgundy_budgeting_app/core/application.dart';
import 'package:burgundy_budgeting_app/core/di_provider.dart';
import 'package:burgundy_budgeting_app/domain/network/api_client.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

Future<void> main() async {
  await DiProvider().init();
  WidgetsFlutterBinding.ensureInitialized();
  html.document.onContextMenu.listen((event) => event.preventDefault());
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: HydratedStorage.webStorageDirectory,
  );

  final packageInfo = await PackageInfo.fromPlatform();

  await SentryFlutter.init(
    (options) => options
      ..dsn = ApiClient.ENV_SENTRY_DNS
      ..environment = ApiClient.ENV_SENTRY
      ..release = '${packageInfo.version} (${packageInfo.version})',
    appRunner: () => runApp(Application()),
  );
}
