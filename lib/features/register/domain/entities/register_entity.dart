import 'dart:collection';

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

  HashMap<String, dynamic> toJson() => HashMap.of({
        keyUserEmail: userEmail,
        keyUserName: userName,
        keyUserPhoto: userPhoto,
        keyUserDOB: userDOB,
        keyUserPasswords: userPassword,
      });

  factory RegisterEntity.fromJson(Map<String, dynamic> rawData) => RegisterEntity(
        userName: rawData[keyUserName].toString(),
        userEmail: rawData[keyUserEmail].toString(),
        userPhoto: rawData[keyUserPhoto].toString(),
        userDOB: rawData[keyUserDOB].toString(),
        userPassword: rawData[keyUserPasswords].toString(),
      );
}

const String keyUserName = 'user_name';
const String keyUserEmail = 'user_email';
const String keyUserDOB = 'user_dob';
const String keyUserPasswords = 'user_password';
const String keyUserPhoto = 'user_photo';
