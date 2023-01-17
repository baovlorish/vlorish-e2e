import 'package:equatable/equatable.dart';

abstract class AddInvestmentState extends Equatable {
  const AddInvestmentState();
}

class AddInvestmentInitial extends AddInvestmentState {
  AddInvestmentInitial();

  @override
  List<Object?> get props => [];
}

class AddInvestmentLoading extends AddInvestmentState {
  AddInvestmentLoading();

  @override
  List<Object?> get props => [];
}

class AddInvestmentError extends AddInvestmentState {
  final String error;
  final void Function()? callback;
  AddInvestmentError(this.error, {this.callback});

  @override
  List<Object?> get props => [error];
}
