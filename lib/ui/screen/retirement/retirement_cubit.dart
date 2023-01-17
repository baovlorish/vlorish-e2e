import 'package:burgundy_budgeting_app/core/navigator_manager.dart';
import 'package:burgundy_budgeting_app/ui/screen/retirement/retirement_state.dart';
import 'package:burgundy_budgeting_app/ui/screen/subscription/subscription_page.dart';
import 'package:burgundy_budgeting_app/utils/logger.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

class RetirementCubit extends Cubit<RetirementState> {
  final Logger logger = getLogger('RetirementCubit');

  RetirementCubit() : super(RetirementInitial()){
    logger.i('Retirement Page');
  }

  void navigateToSubscriptionsPage(BuildContext context) {
    NavigatorManager.navigateTo(context, SubscriptionPage.routeName);
  }
}
