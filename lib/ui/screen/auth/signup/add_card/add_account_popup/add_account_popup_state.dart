import 'package:burgundy_budgeting_app/domain/repository/accounts_transactions_repository.dart';
import 'package:equatable/equatable.dart';

abstract class AddAccountPopupState extends Equatable {
  const AddAccountPopupState();
}

class AddAccountPopupInitialState extends AddAccountPopupState {
  AddAccountPopupInitialState();

  @override
  List<Object> get props => [];
}

class AddAccountPopupLoadingState extends AddAccountPopupState {
  AddAccountPopupLoadingState();

  @override
  List<Object> get props => [];
}

class AddAccountPopupGeneralErrorState extends AddAccountPopupState {
  final String errorMessage;

  AddAccountPopupGeneralErrorState(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

class AddAccountPopupValidateState extends AddAccountPopupState {
  final bool isValid;
  AddAccountPopupValidateState(this.isValid);

  @override
  List<Object> get props => [isValid];
}

class AddAccountPopupAccountErrorState extends AddAccountPopupState {
  final List<AddPlaidAccountError> errors;

  List<String> get errorIds => [for (var item in errors) item.id];

  AddAccountPopupAccountErrorState({
    required this.errors,
  });

  @override
  List<Object?> get props => [errors];
}
