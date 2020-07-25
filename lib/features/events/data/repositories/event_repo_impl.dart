import 'package:dartz/dartz.dart';
import 'package:meet/core/error/exceptions.dart';
import 'package:meet/features/register/data/models/user_model.dart';
import 'package:meta/meta.dart';

import 'package:meet/core/error/failures.dart';
import 'package:meet/features/events/data/datasources/events_datasource.dart';
import 'package:meet/features/events/data/models/event_model.dart';
import 'package:meet/features/events/domain/repositories/events_repository.dart';
import 'package:meet/network/netwrok_info.dart';

typedef EventList = Future<List<EventModel>> Function();
typedef UserAttendingEvent = Future<bool> Function();

class EventRepositoryImpl extends EventRepository {
  final EventsDataSource eventsDataSource;
  final NetworkInfo networkInfo;

  EventRepositoryImpl({@required this.eventsDataSource, @required this.networkInfo});

  @override
  Future<Either<Failure, List<EventModel>>> fetchAllOrganizedEventsFromFirestore() =>
      _getAllOrganizedEvents(() => eventsDataSource.getAllOrganizedEvents());

  Future<Either<Failure, List<EventModel>>> _getAllOrganizedEvents(EventList p) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteLogin = await p();
        return Right(remoteLogin);
      } on ServerException catch (e) {
        return Left(ServerFailure(error: e.error));
      } on AuthenticationException catch (e) {
        return Left(AuthenticationFailure(error: e.error));
      } on EventFetchException catch (e) {
        return Left(EventFetchFailure(error: e.error));
      }
    } else {
      return Left(SocketFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> userRequestedToAttendAnEvent(
          UserModel userModel, String eventID) =>
      _markUserAsAttendingToGivenEvent(
          () => eventsDataSource.markUserAttendingEvent(userModel, eventID));

  Future<Either<Failure, bool>> _markUserAsAttendingToGivenEvent(
      UserAttendingEvent p) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteLogin = await p();
        return Right(remoteLogin);
      } on ServerException catch (e) {
        return Left(ServerFailure(error: e.error));
      } on AuthenticationException catch (e) {
        return Left(AuthenticationFailure(error: e.error));
      } on MarkingUserToAttentEventException catch (e) {
        return Left(EventFetchFailure(error: e.error));
      }
    } else {
      return Left(SocketFailure());
    }
  }
}
