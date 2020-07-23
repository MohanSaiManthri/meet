part of 'register_bloc.dart';

abstract class RegisterState extends Equatable {
  @override
  List<Object> get props => [];
}

class RegisterInitial extends RegisterState {
  @override
  List<Object> get props => [];
}

class Registering extends RegisterState {}

class RegistrationSuccessful extends RegisterState {
  final bool doesSuccessfullyRegistered;

  RegistrationSuccessful({this.doesSuccessfullyRegistered});

  @override
  List<Object> get props => [doesSuccessfullyRegistered];
}

class RegistrationFailed extends RegisterState {
  final String message;

  RegistrationFailed({@required this.message});

  @override
  List<Object> get props => [message];
}
