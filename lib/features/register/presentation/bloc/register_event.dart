part of 'register_bloc.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();
}

class RequestFirebaseToHandleRegistration extends RegisterEvent {
  final String email;
  final String password;
  final String name;
  final String dob;
  final String photoUrl;

  const RequestFirebaseToHandleRegistration({
    @required this.email,
    @required this.password,
    @required this.name,
    @required this.dob,
    this.photoUrl,
  });
  @override
  List<Object> get props => [email, password, name, dob, photoUrl];

  @override
  String toString() => "Requesting Firebase to handle the registration";
}
