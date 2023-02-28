import 'package:burgundy_budgeting_app/ui/model/vlorish_score_model.dart';
import 'package:equatable/equatable.dart';

abstract class FiScoreState extends Equatable {
  const FiScoreState();
}

class FiScoreInitial extends FiScoreState {
  FiScoreInitial();

  @override
  List<Object> get props => [];
}

class FiScoreLoading extends FiScoreState {
  FiScoreLoading();

  @override
  List<Object> get props => [];
}

class FiScoreError extends FiScoreState {
  FiScoreError({required this.error});
  final String error;

  @override
  List<Object?> get props => [error];
}

class FiScoreLoaded extends FiScoreState {
  FiScoreLoaded({required this.vlorishScoreModel});
  final VlorishScoreModel vlorishScoreModel;
  @override
  List<Object> get props => [vlorishScoreModel];
}

class FiScoreRefreshing extends FiScoreLoaded {
  FiScoreRefreshing({required super.vlorishScoreModel});

  @override
  List<Object> get props => [vlorishScoreModel];
}
