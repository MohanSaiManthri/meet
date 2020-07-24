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
          eventName: params.eventName,
          eventDescription: params.eventDescription,
          eventDateTime: params.eventDateTime,
          eventParticipants: params.eventParticipants,
          eventOrganizer: params.eventOrganizer,
          eventOrganizerUID: params.eventOrganizerUID,
          eventImage: params.eventImage));
}

class CreateEventParams extends Equatable {
  final String eventName;
  final String eventDescription;
  final String eventDateTime;
  final String eventParticipants;
  final String eventImage;
  final String eventOrganizer;
  final String eventOrganizerUID;

  const CreateEventParams(
      {@required this.eventName,
      @required this.eventDescription,
      @required this.eventDateTime,
      @required this.eventParticipants,
      @required this.eventOrganizer,
      @required this.eventOrganizerUID,
      @required this.eventImage});

  @override
  List<Object> get props =>
      [eventName, eventDescription, eventDateTime, eventParticipants, eventImage];
}
