import 'package:burgundy_budgeting_app/domain/error/custom_error.dart';
import 'package:burgundy_budgeting_app/domain/model/general/roles.dart';
import 'package:burgundy_budgeting_app/domain/repository/subscription_repository.dart';
import 'package:burgundy_budgeting_app/domain/repository/user_repository.dart';
import 'package:burgundy_budgeting_app/domain/service/subscription_manager.dart';
import 'package:burgundy_budgeting_app/ui/screen/subscription/subscription_state.dart';
import 'package:burgundy_budgeting_app/utils/logger.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

class SubscriptionCubit extends Cubit<SubscriptionState> {
  final Logger logger = getLogger('SubscriptionCubit');
  final SubscriptionRepository repository;
  final UserRepository userRepository;
  final String generalErrorMessage = 'Sorry, something went wrong';
  final bool isSignUp;

  UserRole? role;
  int availableIndex=6;

  SubscriptionCubit(this.repository, this.userRepository,
      {required this.isSignUp})
      : super(SubscriptionInitial()) {
    logger.i('Subscription Cubit');
    if (isSignUp) {
      checkSubscription();
    } else {
      loadPlans();
    }
  }

  Future<void> updateRole() async {
    await userRepository.updateUserData();
    var user = await userRepository.getUserData();
    role = user.role;
    availableIndex = user.registrationStep;
  }

  void loadPlans() async {
    await updateRole();
    try {
      var plans = await repository.getPlans();
      emit(
        SubscriptionLoaded(plans,
          isCoach: role?.isCoach == true,
        ),
      );
    } on DioError catch (e) {
      logger.e('Subscription Page Dio Error $e');
      emit(SubscriptionError(generalErrorMessage));
    } catch (e) {
      emit(SubscriptionError(e.toString()));
      rethrow;
    }
  }

  Future<void> subscribe(String priceId) async {
    var loadedState = (state as SubscriptionLoaded);
    try {
      var sessionId =
          await repository.getCheckoutSessionId(priceId, isSignUp: isSignUp);
      redirectToCheckout(sessionId);
    } on DioError catch (e) {
      logger.e('Subscription Page Dio Error $e');
      emit(SubscriptionError(generalErrorMessage));
    } catch (e) {
      if (e is CustomException) {
        emit(SubscriptionAlreadyExistsState(e.message));
        emit(loadedState);
      } else {
        logger.e('$e');
        emit(SubscriptionError(e.toString()));
        emit(loadedState);
      }
      rethrow;
    }
  }

  Future<void> checkSubscription() async {
    var prevState = state;
    try {
      var userData = await userRepository.getProfileOverview();
      if (userData.subscription != null &&
          userData.subscription!.creditCardLastFourDigits != null) {
        await updateRole();
        emit(SubscriptionExistsSignUp());
      } else {
        loadPlans();
      }
    } catch (e) {
      logger.e('$e');
      emit(SubscriptionError(e.toString()));
      emit(prevState);
      rethrow;
    }
  }
}
