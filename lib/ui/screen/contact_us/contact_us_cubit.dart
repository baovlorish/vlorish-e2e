import 'package:burgundy_budgeting_app/domain/model/general/support_ticket.dart';
import 'package:burgundy_budgeting_app/domain/repository/auth_repository.dart';
import 'package:burgundy_budgeting_app/domain/repository/user_repository.dart';
import 'package:burgundy_budgeting_app/ui/screen/contact_us/contact_us_state.dart';
import 'package:burgundy_budgeting_app/utils/logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

class ContactUsCubit extends Cubit<ContactUsState> {
  final Logger logger = getLogger('ContactUsCubit');
  final AuthRepository authRepository;
  final UserRepository userRepository;

  ContactUsCubit({
    required this.authRepository,
    required this.userRepository,
  }) : super(ContactUsInitial()) {
    logger.i('ContactUsCubit Page');
    load();
  }

  Future<void> load() async {
    try {
      var userData = await userRepository.getProfileOverview();
      emit(ContactUsLoadedState(userData.subscription!.customerEmail!,
          '${userData.firstName} ${userData.lastName}'));
    } catch (e) {
      emit(ContactUsErrorState(e.toString()));
      emit(ContactUsLoadedState('', ''));
      rethrow;
    }
  }

  Future<void> createTicket({
    required String email,
    required String subject,
    required String? phone,
    required String name,
    required int code,
  }) async {
    var prevState = state;
    try {
      await userRepository.createSupportTicket(SupportTicketModel(
          email: email,
          name: name,
          subject: subject,
          phone: phone,
          code: code));
      emit(ContactUsSuccessState('Thanks for Your message. We’ve received your support request and someone form our team will be in touch soon'));
      emit(prevState);
    } catch (e) {
      //todo fix cors error issue. error appears, though tickets are created
      emit(ContactUsSuccessState('Thanks for Your message. We’ve received your support request and someone form our team will be in touch soon'));
      emit(prevState);
    }
  }
}
