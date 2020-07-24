import 'package:dartz/dartz.dart';
import 'package:meet/core/error/failures.dart';
import 'package:meet/features/events/data/models/event_model.dart';

abstract class EventRepository {
  Future<Either<Failure, List<EventModel>>> fetchAllOrganizedEventsFromFirestore();
}
