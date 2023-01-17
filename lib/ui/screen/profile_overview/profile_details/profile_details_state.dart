import 'package:burgundy_budgeting_app/ui/model/user_details_model.dart';
import 'package:equatable/equatable.dart';

abstract class ProfileDetailsState extends Equatable {
  const ProfileDetailsState();
}

class ProfileDetailsInitial extends ProfileDetailsState {
  ProfileDetailsInitial();

  @override
  List<Object> get props => [];
}

class ProfileDetailsLoading extends ProfileDetailsState {
  ProfileDetailsLoading();

  @override
  List<Object> get props => [];
}

class ProfileDetailsErrorState extends ProfileDetailsState {
  final String error;

  ProfileDetailsErrorState(this.error);

  @override
  List<Object> get props => [error];
}

class ProfileDetailsSuccessState extends ProfileDetailsState {
  final String message;

  ProfileDetailsSuccessState(this.message);

  @override
  List<Object> get props => [message];
}

class ProfileDetailsLoadedUserDataState extends ProfileDetailsState {
  final UserDetailsModel userDetailsModel;

  ProfileDetailsLoadedUserDataState(this.userDetailsModel);

  @override
  List<Object> get props => [userDetailsModel];
}

class ProfileDetailsImageSetSuccessfully extends ProfileDetailsState {
  ProfileDetailsImageSetSuccessfully();

  @override
  List<Object> get props => [];
}
