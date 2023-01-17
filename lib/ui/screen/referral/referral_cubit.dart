import 'package:burgundy_budgeting_app/domain/model/response/referral_response.dart';
import 'package:burgundy_budgeting_app/domain/repository/referral_repository.dart';
import 'package:burgundy_budgeting_app/ui/screen/referral/referral_state.dart';
import 'package:burgundy_budgeting_app/utils/logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

class ReferralCubit extends Cubit<ReferralState> {
  final Logger logger = getLogger('Referral Cubit');

  final ReferralRepository referralRepository;

  ReferralCubit(this.referralRepository) : super(ReferralInitial()) {
    getReferral();
  }

  Future<void> getReferral() async {
    try {
      var referralModel = await referralRepository.getReferrals();
      emit(ReferralLoaded(referralModel));
    } catch (e) {
      emit(ReferralError(e.toString()));
      emit(ReferralLoaded(ReferralResponse(
        links: [''],
        earned: 0,
        paid: 0,
      )));
      rethrow;
    }
  }

  Future<ReferralSSOResponse> getReferralSSo() async {
    var prevState = state;
    try {
      return await referralRepository.getReferralsSSO();
    } catch (e) {
      emit(ReferralError(e.toString()));
      emit(prevState);
      rethrow;
    }
  }
}
