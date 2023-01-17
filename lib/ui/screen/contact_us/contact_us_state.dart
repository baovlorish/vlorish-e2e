import 'package:equatable/equatable.dart';

abstract class ContactUsState extends Equatable {
  const ContactUsState();
}

class ContactUsInitial extends ContactUsState {
  ContactUsInitial();

  @override
  List<Object?> get props => [];
}

class ContactUsLoadingState extends ContactUsState {
  ContactUsLoadingState();

  @override
  List<Object?> get props => [];
}

class ContactUsErrorState extends ContactUsState {
  ContactUsErrorState(this.error);
  final String error;
  @override
  List<Object?> get props => [error];
}

class ContactUsSuccessState extends ContactUsState {
  ContactUsSuccessState(this.message);
  final String message;
  @override
  List<Object?> get props => [message];
}

class ContactUsLoadedState extends ContactUsState {
  ContactUsLoadedState(this.email, this.name);
  final String email;
  final String name;
  @override
  List<Object?> get props => [email, name];
}
