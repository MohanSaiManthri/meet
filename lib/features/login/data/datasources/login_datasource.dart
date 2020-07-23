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
      throw AuthenticationException(e.toString().contains('ERROR_USER_NOT_FOUND')
          ? accountDoesNotExists(email)
          : e.toString());
    } catch (e) {
      throw AuthenticationException(e.toString());
    }
  }

  void cacheDataForLaterUse(String encodedData) {
    final SharedPreferences sharedPreferences = sl<SharedPreferences>();
    sharedPreferences.setString(keyLoggedInUser, encodedData);
  }

  Future<void> fetchTheUserDetailsFromTheServer(String uid) async {
    try {
      final DocumentSnapshot documentSnapshot =
          await Firestore.instance.collection('users').document(uid).get();
      final String encodedData = json.encode(documentSnapshot.data);
      cacheDataForLaterUse(encodedData);
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
