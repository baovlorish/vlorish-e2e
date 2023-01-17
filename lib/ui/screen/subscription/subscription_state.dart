import 'package:burgundy_budgeting_app/ui/model/subscription_plan_model.dart';
import 'package:equatable/equatable.dart';

abstract class SubscriptionState with EquatableMixin {
  SubscriptionState();
}

class SubscriptionInitial extends SubscriptionState {
  @override
  SubscriptionInitial();

  @override
  List<Object> get props => [];
}

class SubscriptionLoaded extends SubscriptionState {
  List<SubscriptionPlanModel> plans;
  final bool isCoach;

  SubscriptionPlanModel get standardPlan =>
      plans.firstWhere((element) => element.type == 0);

  SubscriptionPlanModel get premiumPlan =>
      plans.firstWhere((element) => element.type == 1);

  SubscriptionPlanModel get advisorPlan =>
      plans.firstWhere((element) => element.type == 2);

  @override
  SubscriptionLoaded(this.plans, {required this.isCoach});

  @override
  List<Object?> get props => [plans, isCoach];
}

class SubscriptionError extends SubscriptionState {
  final String error;

  @override
  SubscriptionError(this.error);

  @override
  List<Object> get props => [error];
}

class SubscriptionAlreadyExistsState extends SubscriptionState {
  final String message;

  @override
  SubscriptionAlreadyExistsState(this.message);

  @override
  List<Object> get props => [message];
}

class SubscriptionExistsSignUp extends SubscriptionState {
  @override
  SubscriptionExistsSignUp();

  @override
  List<Object> get props => [];
}
