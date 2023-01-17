import 'package:burgundy_budgeting_app/core/navigator_manager.dart';
import 'package:burgundy_budgeting_app/domain/repository/vlorish_score_repository.dart';
import 'package:burgundy_budgeting_app/ui/screen/subscription/subscription_page.dart';
import 'package:burgundy_budgeting_app/utils/logger.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

import 'fi_score_state.dart';

class FiScoreCubit extends Cubit<FiScoreState> {
  final Logger logger = getLogger('FiScoreCubit');
  final VlorishScoreRepository vlorishScoreRepository;

  FiScoreCubit(this.vlorishScoreRepository) : super(FiScoreInitial()) {
    logger.i('FiScore Page');
    load();
  }

  Future<void> load() async {
    try {
      var scoreData = await vlorishScoreRepository.getLast();
      emit(FiScoreLoaded(vlorishScoreModel: scoreData));
    } catch (e) {
      emit(FiScoreError(error: e.toString()));
      rethrow;
    }
  }

  Future<void> refresh() async {
    try {
      await vlorishScoreRepository.refresh();
      await load();
    } catch (e) {
      emit(FiScoreError(error: e.toString()));
      rethrow;
    }
  }

  void navigateToSubscriptionsPage(BuildContext context) {
    NavigatorManager.navigateTo(context, SubscriptionPage.routeName);
  }
}
