part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();
}

class RequestFirebaseToHandleEmailSignIn extends LoginEvent {
  final String email;
  final String password;

  const RequestFirebaseToHandleEmailSignIn(
      {@required this.email, @required this.password});
  @override
  List<Object> get props => [email, password];

  @override
  String toString() => "Requesting Firebase to handle the email sign in ";
}
