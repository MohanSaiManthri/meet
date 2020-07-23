import 'package:equatable/equatable.dart';

class RegisterEntity extends Equatable {
  final String userEmail;
  final String userName;
  final String userPhoto;
  final String userDOB;
  final String userPassword;

  const RegisterEntity(
      {this.userEmail, this.userName, this.userPhoto, this.userDOB, this.userPassword});

  @override
  List<Object> get props => [userEmail, userName, userDOB, userPassword, userPhoto];
}
