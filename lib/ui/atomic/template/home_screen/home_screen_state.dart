import 'package:burgundy_budgeting_app/domain/error/custom_error.dart';
import 'package:burgundy_budgeting_app/ui/model/proflie_overview_model.dart';
import 'package:equatable/equatable.dart';

abstract class HomeScreenState extends Equatable {
  const HomeScreenState();
}

class HomeScreenInitial extends HomeScreenState {
  HomeScreenInitial();

  @override
  List<Object> get props => [];
}

class HomeScreenLoading extends HomeScreenState {
  const HomeScreenLoading();

  @override
  List<Object> get props => [];
}

class HomeScreenLoaded extends HomeScreenState {
  final ProfileOverviewModel user;

  const HomeScreenLoaded(this.user);

  @override
  List<Object> get props => [user];
}

class HomeScreenError extends HomeScreenState {
  final String errorMessage;
  final Function()? callback;
  final CustomExceptionType type;

  final String? errorDialogButtonText;

  const HomeScreenError(
    this.errorMessage, {
    this.callback,
    this.errorDialogButtonText,
    this.type = CustomExceptionType.Error,
  });

  @override
  List<Object?> get props =>
      [errorMessage, callback, type, errorDialogButtonText];
}
