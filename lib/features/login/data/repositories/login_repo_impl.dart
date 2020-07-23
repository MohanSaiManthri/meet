import 'package:meet/core/error/exceptions.dart';
import 'package:meet/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import 'package:meet/features/login/data/datasources/login_datasource.dart';
import 'package:meet/features/login/domain/repositories/login_repository.dart';
import 'package:meet/network/netwrok_info.dart';

typedef LoginUser = Future<bool> Function();

class LoginRepositoryImpl extends LoginRepository {
  final LoginRemoteDataSource loginRemoteDataSource;
  final NetworkInfo networkInfo;

  LoginRepositoryImpl({@required this.loginRemoteDataSource, @required this.networkInfo});

  @override
  Future<Either<Failure, bool>> requestFirebaseToHandleEmailSignIn(
          String email, String password) =>
      _letFirebaseHandleTheEmailSignIn(
          () => loginRemoteDataSource.letFirebaseHandleTheEmailSignIn(email, password));

  // * Remove common handlers in future if want to use any Provider specific code or something like that.
  Future<Either<Failure, bool>> _letFirebaseHandleTheEmailSignIn(LoginUser p) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteLogin = await p();
        return Right(remoteLogin);
      } on ServerException catch (e) {
        return Left(ServerFailure(error: e.error));
      } on AuthenticationException catch (e) {
        return Left(AuthenticationFailure(error: e.error));
      }
    } else {
      return Left(SocketFailure());
    }
  }
}
