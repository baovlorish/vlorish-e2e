import 'package:equatable/equatable.dart';

abstract class AddRetirementState extends Equatable {
  const AddRetirementState();
}

class AddRetirementInitial extends AddRetirementState {
  AddRetirementInitial();

  @override
  List<Object?> get props => [];
}

class AddRetirementLoading extends AddRetirementState {
  AddRetirementLoading();

  @override
  List<Object?> get props => [];
}

class AddRetirementError extends AddRetirementState {
  final String error;
  final void Function()? callback;
  AddRetirementError(this.error, {this.callback});

  @override
  List<Object?> get props => [error];
}
