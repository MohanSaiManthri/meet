import 'package:dartz/dartz.dart';
import 'package:meet/core/error/failures.dart';
import 'package:meet/features/create_event/domain/entities/create_event_entity.dart';

abstract class CreateEventRepository {
  Future<Either<Failure, bool>> letsCreateEventOnFirestore(
      CreateEventEntity createEventEntity);
}
