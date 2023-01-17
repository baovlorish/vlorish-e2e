import 'package:equatable/equatable.dart';

abstract class AddGoalState extends Equatable {
  const AddGoalState();
}

class AddGoalInitial extends AddGoalState {
  AddGoalInitial();

  @override
  List<Object> get props => [];
}

class AddGoalLoading extends AddGoalState {
  AddGoalLoading();

  @override
  List<Object> get props => [];
}

class AddGoalError extends AddGoalState {
  final String error;
  final void Function()? callback;
  AddGoalError(this.error, {this.callback});

  @override
  List<Object> get props => [error];
}
