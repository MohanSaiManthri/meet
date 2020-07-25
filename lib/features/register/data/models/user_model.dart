import 'dart:collection';

import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String userDisplayName;
  final String userEmail;
  final String userPhotoURL;
  final String userDob;
  final String userUID;
  final String userProviderID;
  final bool isEmailVerified;

  const UserModel(
      {this.userDisplayName,
      this.userEmail,
      this.userPhotoURL,
      this.userDob,
      this.userUID,
      this.userProviderID,
      this.isEmailVerified});

  @override
  List<Object> get props => [
        userDisplayName,
        userEmail,
        userPhotoURL,
        userDob,
        userUID,
        userProviderID,
        isEmailVerified
      ];

  HashMap<String, dynamic> toJson() => HashMap.of({
        keyUserEmail: userEmail,
        keyUserName: userDisplayName,
        keyUserPhoto: userPhotoURL,
        keyUserDOB: userDob,
        keyUserEmailVerified: isEmailVerified,
        keyUserUid: userUID,
        keyUserProviderId: userProviderID
      });

  factory UserModel.fromJson(Map<String, dynamic> rawData) => UserModel(
        isEmailVerified: rawData[keyUserEmailVerified] as bool,
        userDisplayName: rawData[keyUserName].toString(),
        userDob: rawData[keyUserDOB].toString(),
        userEmail: rawData[keyUserEmail].toString(),
        userPhotoURL: rawData[keyUserPhoto].toString(),
        userProviderID: rawData[keyUserProviderId].toString(),
        userUID: rawData[keyUserUid].toString(),
      );
}

const String keyUserName = 'display_name';
const String keyUserEmail = 'email';
const String keyUserDOB = 'dob';
const String keyUserEmailVerified = 'is_email_verified';
const String keyUserPhoto = 'photo_url';
const String keyUserUid = 'user_uid';
const String keyUserProviderId = 'provider_id';
