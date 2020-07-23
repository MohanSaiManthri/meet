part of 'login_bloc.dart';

abstract class LoginState extends Equatable {
  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {
  @override
  List<Object> get props => [];
}

class Authenticating extends LoginState {}

class AuthenticatedSuccessfully extends LoginState {
  final bool doesSuccessfullyAuthenticated;

  AuthenticatedSuccessfully({this.doesSuccessfullyAuthenticated});

  @override
  List<Object> get props => [doesSuccessfullyAuthenticated];
}

class AuthenticationFailed extends LoginState {
  final String message;

  AuthenticationFailed({@required this.message});

  @override
  List<Object> get props => [message];
}
