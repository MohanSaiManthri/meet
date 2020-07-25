import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meet/features/register/data/models/user_model.dart';
import 'package:meta/meta.dart';

import 'package:meet/core/error/failures.dart';
import 'package:meet/core/usecases/usecases.dart';
import 'package:meet/features/events/domain/repositories/events_repository.dart';

class MarkEventUseCase extends UseCase<bool, MarkEventParams> {
  final EventRepository eventRepository;

  MarkEventUseCase({@required this.eventRepository});
  @override
  Future<Either<Failure, bool>> call(MarkEventParams params) =>
      eventRepository.userRequestedToAttendAnEvent(params.userModel, params.eventID);
}

class MarkEventParams extends Equatable {
  final UserModel userModel;
  final String eventID;

  const MarkEventParams({this.userModel, this.eventID});
  @override
  List<Object> get props => [userModel, eventID];
}
