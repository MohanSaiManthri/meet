import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meet/core/error/failures.dart';
import 'package:meet/core/usecases/usecases.dart';
import 'package:meet/features/create_event/domain/entities/create_event_entity.dart';
import 'package:meet/features/create_event/domain/repositories/create_event_repository.dart';

class CreateEventUsecase extends UseCase<bool, CreateEventParams> {
  final CreateEventRepository createEventRepository;

  CreateEventUsecase({@required this.createEventRepository});

  @override
  Future<Either<Failure, bool>> call(CreateEventParams params) =>
      createEventRepository.letsCreateEventOnFirestore(CreateEventEntity(
          eventID: params.eventId,
          eventName: params.eventName,
          eventDescription: params.eventDescription,
          eventDateTime: params.eventDateTime,
          eventParticipants: params.eventParticipants,
          eventOrganizerDetails: params.eventOrganizerDetails,
          eventImage: params.eventImage,
          eventCreatedAt: params.eventCreatedAt));
}

class CreateEventParams extends Equatable {
  final String eventId;
  final String eventName;
  final String eventDescription;
  final String eventDateTime;
  final dynamic eventParticipants;
  final String eventImage;
  final dynamic eventOrganizerDetails;
  final String eventCreatedAt;

  const CreateEventParams(
      {@required this.eventId,
      @required this.eventName,
      @required this.eventDescription,
      @required this.eventDateTime,
      @required this.eventParticipants,
      @required this.eventOrganizerDetails,
      @required this.eventCreatedAt,
      @required this.eventImage});

  @override
  List<Object> get props => [
        eventName,
        eventDescription,
        eventDateTime,
        eventParticipants,
        eventCreatedAt,
        eventImage,
        eventOrganizerDetails
      ];
}
