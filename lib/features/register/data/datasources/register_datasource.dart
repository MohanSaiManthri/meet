import 'dart:collection';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meet/core/error/exceptions.dart';
import 'package:meet/core/utils/constants.dart';
import 'package:meet/core/utils/global_firebase_auth_instance.dart';
import 'package:meet/dependecy_injection.dart';
import 'package:meet/features/register/domain/entities/register_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class RegisterRemoteDataSource {
  /// Uses Firebase `Email_Password` Sign for authentication
  ///
  /// if authentication succeds, It will save user data to firestore
  ///
  /// else throws an exception
  Future<bool> letFirebaseHandleTheRegistration(RegisterEntity registerEntity);
}

class RegisterRemoteDataSourceImpl extends RegisterRemoteDataSource {
  @override
  Future<bool> letFirebaseHandleTheRegistration(RegisterEntity registerEntity) =>
      _handleRegistration(registerEntity);

  Future<bool> _handleRegistration(RegisterEntity registerEntity) async {
    try {
      // Saving instance helps us to sign out user in future.
      final FirebaseAuth _firebaseAuth =
          GlobalFirebaseAuthInstnace.firebaseAuth ??= FirebaseAuth.instance;
      // Before proceeding with Registration, we will check whether he is registered with us any way like Google, Facebook etc, As of now we only use, but in future this will be helpful.
      await checkUserExistence(_firebaseAuth, registerEntity);
      final FirebaseUser _firebaseUser =
          (await createUser(_firebaseAuth, registerEntity)).user;
      saveUserDetailsToFirestore(_firebaseUser, registerEntity);
      return true;
    } catch (e) {
      if (e.runtimeType == AuthenticationException) {
        throw AuthenticationException((e as AuthenticationException).error);
      } else {
        throw AuthenticationException(e.toString());
      }
    }
  }

  /// * Extract the required user details from `FirebaseUser` Object
  ///
  /// * Makes an Hashmap and encodes to string & Then save it into the SharedPreferences & Firestore.
  ///
  Future<void> saveUserDetailsToFirestore(
      FirebaseUser user, RegisterEntity registerEntity) async {
    final String displayName = registerEntity.userName;
    final String email = user.email;
    final String photoURL = registerEntity.userPhoto;
    final String dob = registerEntity.userDOB;
    final String userUID = user.uid;
    final String providerID = user.providerId;
    final bool isEmailVerified = user.isEmailVerified;

    final HashMap<String, dynamic> hashMap = HashMap.of({
      'display_name': displayName,
      'email': email,
      'dob': dob,
      'photo_url': photoURL,
      'user_uid': userUID,
      'provider_id': providerID,
      'is_email_verified': isEmailVerified
    });
    try {
      await Firestore.instance.collection('users').document(user.uid).setData(hashMap);
      final String encodedData = json.encode(hashMap);
      cacheDataForLaterUse(encodedData);
    } catch (e) {
      await signoutUser();
      throw AuthenticationException(errorWhileFetchingDataFromFirestore);
    }
  }

  void cacheDataForLaterUse(String encodedData) {
    final SharedPreferences sharedPreferences = sl<SharedPreferences>();
    sharedPreferences.setString(keyUserInfo, json.encode(encodedData));
  }

  /// Checks whether email is registered with us any way like `Google, Facebook` etc, As of now we only use `EMAIL`, but in future this will be more helpful.
  Future checkUserExistence(
      FirebaseAuth _firebaseAuth, RegisterEntity registerEntity) async {
    final List<String> _listOfScopes =
        await _firebaseAuth.fetchSignInMethodsForEmail(email: registerEntity.userEmail);
    if (_listOfScopes.isNotEmpty) {
      throw AuthenticationException(accountAlreadyExists(registerEntity.userEmail));
    }
  }

  Future<AuthResult> createUser(
      FirebaseAuth _firebaseAuth, RegisterEntity registerEntity) async {
    return _firebaseAuth.createUserWithEmailAndPassword(
        email: registerEntity.userEmail, password: registerEntity.userPassword);
  }

  Future<void> signoutUser() async {
    final FirebaseAuth _firebaseAuth =
        GlobalFirebaseAuthInstnace.firebaseAuth ??= FirebaseAuth.instance;
    await _firebaseAuth.signOut();
  }

  String accountAlreadyExists(String email) =>
      "Sorry, $email is already registered with us!";
}

const String errorWhileFetchingDataFromFirestore =
    "We are facing difficulties contacting server, Please try again!";
