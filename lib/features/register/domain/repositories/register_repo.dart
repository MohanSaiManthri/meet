import 'package:dartz/dartz.dart';
import 'package:meet/core/error/failures.dart';
import 'package:meet/features/register/domain/entities/register_entity.dart';

abstract class RegisterRepository {
  Future<Either<Failure, bool>> requestFirebaseToHandleRegistration(
      RegisterEntity registerEntity);
}
