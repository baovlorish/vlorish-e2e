import 'package:burgundy_budgeting_app/domain/model/response/plan_response.dart';

class SubscriptionPlanModel {
  final String name;
  final int type;
  final Price monthly;
  final Price yearly;

  SubscriptionPlanModel({
    required this.name,
    required this.type,
    required this.monthly,
    required this.yearly
  });

  bool get isPremiumOrHigher => type > 0;

  factory SubscriptionPlanModel.fromResponse(PlanResponse response) => SubscriptionPlanModel(
    name: response.name,
    type: response.type,
    monthly: response.prices.firstWhere((element) => element.recurringType==1),
    yearly: response.prices.firstWhere((element) => element.recurringType==2),
  );
}