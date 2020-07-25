import 'package:dartz/dartz.dart';
import 'package:meet/core/error/failures.dart';
import 'package:meet/features/events/data/models/event_model.dart';
import 'package:meet/features/register/data/models/user_model.dart';

abstract class EventRepository {
  Future<Either<Failure, List<EventModel>>> fetchAllOrganizedEventsFromFirestore();
  Future<Either<Failure, bool>> userRequestedToAttendAnEvent(
      UserModel userModel, String eventID);
}
