import 'package:dartz/dartz.dart';
import 'package:meet/core/error/failures.dart';

abstract class LoginRepository {
  /// Uses Firebase `Email_Password` Sign for authentication
  ///
  /// if authentication succeds return bool of true
  ///
  /// else throws an `AuthenticationException` with error message.
  Future<Either<Failure, bool>> requestFirebaseToHandleEmailSignIn(
      String email, String password);
}
