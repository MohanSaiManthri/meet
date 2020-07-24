import 'package:dartz/dartz.dart';
import 'package:meet/core/error/exceptions.dart';
import 'package:meta/meta.dart';

import 'package:meet/core/error/failures.dart';
import 'package:meet/features/create_event/data/datasources/create_event_datasource.dart';
import 'package:meet/features/create_event/domain/entities/create_event_entity.dart';
import 'package:meet/features/create_event/domain/repositories/create_event_repository.dart';
import 'package:meet/network/netwrok_info.dart';

typedef CreateEvent = Future<bool> Function();

class CreateEventRepoImpl extends CreateEventRepository {
  final CreateEventDataSource createEventDataSource;
  final NetworkInfo networkInfo;

  CreateEventRepoImpl({@required this.createEventDataSource, @required this.networkInfo});

  @override
  Future<Either<Failure, bool>> letsCreateEventOnFirestore(
          CreateEventEntity createEventEntity) =>
      _letFirebaseHandleTheEventCreation(
          () => createEventDataSource.createEventOnDemand(createEventEntity));

  Future<Either<Failure, bool>> _letFirebaseHandleTheEventCreation(CreateEvent p) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteLogin = await p();
        return Right(remoteLogin);
      } on ServerException catch (e) {
        return Left(ServerFailure(error: e.error));
      } on AuthenticationException catch (e) {
        return Left(AuthenticationFailure(error: e.error));
      } on EventCreationException catch (e) {
        return Left(EventCreationFailure(error: e.error));
      }
    } else {
      return Left(SocketFailure());
    }
  }
}
