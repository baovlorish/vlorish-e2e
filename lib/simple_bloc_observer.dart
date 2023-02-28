
import 'package:burgundy_budgeting_app/utils/logger.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

class SimpleBlocObserver extends BlocObserver {
  Logger logger = getLogger('BlocObserver');
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    if (kDebugMode) {
      logger.i('${bloc.runtimeType} $change');
    }
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    if (kDebugMode) {
      logger.i(bloc.runtimeType);
      logger.e(error);
      logger.e(stackTrace);
    }
  }
}