import 'package:burgundy_budgeting_app/domain/error/custom_error.dart';
import 'package:burgundy_budgeting_app/ui/model/invitations_page_model.dart';
import 'package:burgundy_budgeting_app/ui/model/requests_page_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

abstract class ManageUsersState extends Equatable {
  const ManageUsersState();
}

class ManageUsersInitial extends ManageUsersState {
  ManageUsersInitial();

  @override
  List<Object?> get props => [];
}

abstract class ManageUsersLoading extends ManageUsersState {}

class ManageUsersError extends ManageUsersState {
  final String errorMessage;
  final VoidCallback? callback;
  final CustomExceptionType type;
  final bool? isInvitation;
  final String? errorDialogButtonText;

  const ManageUsersError(
    this.errorMessage, {
    this.callback,
    this.errorDialogButtonText,
    this.type = CustomExceptionType.Error,
    this.isInvitation,
  });

  @override
  List<Object?> get props =>
      [errorMessage, callback, type, errorDialogButtonText, isInvitation];
}

class ManageUsersLoaded extends ManageUsersState {
  final InvitationsPageModel invitationsPageModel;
  final RequestsPageModel requestsPageModel;
  final bool shouldUpdateUserData;

  ManageUsersLoaded(
      {required this.invitationsPageModel,
      required this.requestsPageModel,
      this.shouldUpdateUserData = false});

  @override
  List<Object?> get props =>
      [invitationsPageModel, requestsPageModel, shouldUpdateUserData];

  ManageUsersLoaded copyWith(
          {InvitationsPageModel? invitationsPageModel,
          RequestsPageModel? requestsPageModel,
          bool? shouldUpdateUserData}) =>
      ManageUsersLoaded(
          invitationsPageModel:
              invitationsPageModel ?? this.invitationsPageModel,
          requestsPageModel: requestsPageModel ?? this.requestsPageModel,
          shouldUpdateUserData:
              shouldUpdateUserData ?? this.shouldUpdateUserData);
}
