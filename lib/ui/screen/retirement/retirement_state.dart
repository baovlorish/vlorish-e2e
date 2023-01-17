import 'package:equatable/equatable.dart';

abstract class RetirementState extends Equatable {
  const RetirementState();
}

class RetirementInitial extends RetirementState {
  RetirementInitial();

  @override
  List<Object> get props => [];
}

class RetirementLoading extends RetirementState {
  RetirementLoading();

  @override
  List<Object> get props => [];
}
