import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meet/core/error/failures.dart';
import 'package:meta/meta.dart';

import 'package:meet/core/usecases/usecases.dart';
import 'package:meet/features/events/data/models/event_model.dart';
import 'package:meet/features/events/domain/repositories/events_repository.dart';

class GetEventsUsecase extends UseCase<List<EventModel>, EventsParams> {
  final EventRepository eventRepository;

  GetEventsUsecase({@required this.eventRepository});

  @override
  Future<Either<Failure, List<EventModel>>> call(EventsParams params) =>
      eventRepository.fetchAllOrganizedEventsFromFirestore();
}

class EventsParams extends Equatable {
  @override
  List<Object> get props => [];
}
