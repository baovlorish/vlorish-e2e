import 'package:burgundy_budgeting_app/ui/model/proflie_overview_model.dart';
import 'package:equatable/equatable.dart';

abstract class ProfileOverviewState extends Equatable {
  const ProfileOverviewState();
}

class ProfileOverviewInitial extends ProfileOverviewState {
  ProfileOverviewInitial();

  @override
  List<Object> get props => [];
}

class ProfileOverviewLoading extends ProfileOverviewState {
  ProfileOverviewLoading();

  @override
  List<Object> get props => [];
}

class ProfileOverviewError extends ProfileOverviewState {
  final String error;

  ProfileOverviewError(this.error);

  @override
  List<Object> get props => [error];
}

class ProfileOverviewLoaded extends ProfileOverviewState {
  final ProfileOverviewModel model;
  final bool isPasswordLoading;

  ProfileOverviewLoaded(this.model, {this.isPasswordLoading = false});

  @override
  List<Object> get props => [model, isPasswordLoading];
}

class PasswordChangedSuccessfully extends ProfileOverviewState {
  PasswordChangedSuccessfully();

  @override
  List<Object> get props => [];
}
