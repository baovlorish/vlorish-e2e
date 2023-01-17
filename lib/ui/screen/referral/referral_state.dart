import 'package:burgundy_budgeting_app/domain/model/response/referral_response.dart';
import 'package:equatable/equatable.dart';

abstract class ReferralState with EquatableMixin {
  ReferralState();
}

class ReferralInitial extends ReferralState {
  ReferralInitial();

  @override
  List<Object?> get props => [];
}

class ReferralLoaded extends ReferralState {
  final ReferralResponse referralResponse;

  ReferralLoaded(this.referralResponse);

  @override
  List<Object?> get props => [referralResponse];
}

class ReferralError extends ReferralState {
  final String error;

  ReferralError(this.error);

  @override
  List<Object?> get props => [error];
}
