import 'package:burgundy_budgeting_app/ui/screen/education_center/education_center_state.dart';
import 'package:burgundy_budgeting_app/utils/logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

class EducationCenterCubit extends Cubit<EducationCenterState> {
  final Logger logger = getLogger('InvestmentsCubit');

  EducationCenterCubit({required int currentTab})
      : super(EducationCenterInitial(currentTab)) {
    logger.i('EducationCenter Page');
  }
}
