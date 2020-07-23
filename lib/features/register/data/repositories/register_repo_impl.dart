import 'package:dartz/dartz.dart';
import 'package:meet/core/error/exceptions.dart';
import 'package:meet/core/error/failures.dart';
import 'package:meet/features/register/domain/entities/register_entity.dart';
import 'package:meta/meta.dart';

import 'package:meet/features/register/data/datasources/register_datasource.dart';
import 'package:meet/features/register/domain/repositories/register_repo.dart';
import 'package:meet/network/netwrok_info.dart';

typedef RegisterUser = Future<bool> Function();

class RegisterRepositoryImpl extends RegisterRepository {
  final RegisterRemoteDataSource registerRemoteDataSource;
  final NetworkInfo networkInfo;

  RegisterRepositoryImpl(
      {@required this.registerRemoteDataSource, @required this.networkInfo});

  @override
  Future<Either<Failure, bool>> requestFirebaseToHandleRegistration(
          RegisterEntity registerEntity) =>
      _letFirebaseHandleTheRegistration(() =>
          registerRemoteDataSource.letFirebaseHandleTheRegistration(registerEntity));

  // * Remove common handlers in future if want to use any Provider specific code or something like that.
  Future<Either<Failure, bool>> _letFirebaseHandleTheRegistration(RegisterUser p) async {
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
