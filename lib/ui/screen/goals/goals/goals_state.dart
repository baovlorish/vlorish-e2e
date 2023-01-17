import 'package:burgundy_budgeting_app/ui/model/goal.dart';
import 'package:equatable/equatable.dart';

abstract class GoalsState extends Equatable {
  const GoalsState();
}

class GoalsInitial extends GoalsState {
  GoalsInitial();

  @override
  List<Object> get props => [];
}

class GoalsLoading extends GoalsState {
  GoalsLoading();

  @override
  List<Object> get props => [];
}

class GoalsErrorState extends GoalsState {
  final String error;
  final void Function()? callback;

  GoalsErrorState(this.error, {this.callback});

  @override
  List<Object> get props => [error];
}

class GoalsLoaded extends GoalsState {
  GoalsLoaded({
    required this.goals,
    required this.goalsByYear,
  });

  final List<Goal> goals;
  final Map<int, List<Goal>> goalsByYear;

  @override
  List<Object> get props => [goals, goalsByYear];
}
