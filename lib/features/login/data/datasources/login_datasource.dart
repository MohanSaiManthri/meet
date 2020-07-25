import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:meet/core/error/exceptions.dart';
import 'package:meet/core/utils/constants.dart';
import 'package:meet/core/utils/global_firebase_auth_instance.dart';
import 'package:meet/dependecy_injection.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class LoginRemoteDataSource {
  /// Uses Firebase `Email_Password` Sign for authentication
  ///
  /// if authentication succeds return bool of true
  ///
  /// else throws an exception
  Future<bool> letFirebaseHandleTheEmailSignIn(String email, String password);
}

class LoginRemoteDataSourceImpl extends LoginRemoteDataSource {
  @override
  Future<bool> letFirebaseHandleTheEmailSignIn(String email, String password) =>
      _handleEmailSignIn(email, password);

  Future<bool> _handleEmailSignIn(String email, String password) async {
    try {
      // Saving instance helps us to sign out user in future.
      final FirebaseAuth _firebaseAuth =
          GlobalFirebaseAuthInstnace.firebaseAuth ??= FirebaseAuth.instance;
      final FirebaseUser _firebaseUser = (await _firebaseAuth.signInWithEmailAndPassword(
              email: email, password: password))
          .user;
      fetchTheUserDetailsFromTheServer(_firebaseUser.uid);
      return true;
    } on PlatformException catch (e) {
      throw AuthenticationException(getError(e, email));
    } catch (e) {
      throw AuthenticationException(e.toString());
    }
  }

  String getError(PlatformException e, String email) {
    return e.toString().contains('ERROR_TOO_MANY_REQUESTS')
        ? tooManyRequests
        : e.toString().contains('ERROR_USER_NOT_FOUND')
            ? accountDoesNotExists(email)
            : e.toString().contains('ERROR_WRONG_PASSWORD') ||
                    e.toString().contains('ERROR_USER_NOT_FOUND')
                ? invalidCredentials
                : e.toString();
  }

  Future<void> cacheDataForLaterUse(String encodedData) async {
    final SharedPreferences sharedPreferences = sl<SharedPreferences>();
    await sharedPreferences.setString(keyUserInfo, encodedData);
  }

  Future<void> fetchTheUserDetailsFromTheServer(String uid) async {
    try {
      final DocumentSnapshot documentSnapshot =
          await Firestore.instance.collection('users').document(uid).get();
      final String encodedData = json.encode(documentSnapshot.data);
      await cacheDataForLaterUse(encodedData);
    } catch (e) {
      await signoutUser();
      throw AuthenticationException(errorWhileFetchingDataFromFirestore);
    }
  }

  Future<void> signoutUser() async {
    final FirebaseAuth _firebaseAuth =
        GlobalFirebaseAuthInstnace.firebaseAuth ??= FirebaseAuth.instance;
    await _firebaseAuth.signOut();
  }

  String accountDoesNotExists(String email) =>
      "Sorry, $email is not recognized as an active email address";
}

const String errorWhileFetchingDataFromFirestore =
    "We are facing difficulties contacting server, Please try again!";
const String accountDoesNotExists =
    "Sorry, *username* is not recognized as an active email address";

const String invalidCredentials = "Sorry, email/password entered is invalid!";
const String tooManyRequests =
    "Login unavailable because of too many Failed attempts, Try again in few hours ";
