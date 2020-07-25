import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meet/core/error/failures.dart';
import 'package:meet/features/create_event/domain/entities/create_event_entity.dart';
import 'package:meet/features/create_event/domain/usecases/create_event_usecase.dart';
part 'create_event_event.dart';
part 'create_event_state.dart';

class CreateEventBloc extends Bloc<CreateEventEvent, CreateEventState> {
  final CreateEventUsecase createEventUsecase;
  CreateEventBloc({@required this.createEventUsecase}) : super(CreateEventInitial());
  @override
  Stream<CreateEventState> mapEventToState(
    CreateEventEvent event,
  ) async* {
    if (event is CreateEventAndStoreItToFirestore) {
      yield CreatingEvent();
      final _failedOrCreated = await createEventUsecase.call(CreateEventParams(
        eventId: event.createEventEntity.eventID,
        eventName: event.createEventEntity.eventName,
        eventDescription: event.createEventEntity.eventDescription,
        eventDateTime: event.createEventEntity.eventDateTime,
        eventParticipants: event.createEventEntity.eventParticipants,
        eventOrganizerDetails: event.createEventEntity.eventOrganizerDetails,
        eventCreatedAt: event.createEventEntity.eventCreatedAt,
        eventImage: event.createEventEntity.eventImage,
      ));
      yield* _eitherLoadedOrErrorState(_failedOrCreated);
    }
  }

  Stream<CreateEventState> _eitherLoadedOrErrorState(
    Either<Failure, bool> failureOrTrivia,
  ) async* {
    yield failureOrTrivia.fold(
      (failure) => FailedToCreateEvent(errorMsg: _mapFailureToMessage(failure)),
      (bool trivia) => EventCreated(),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return failure.errorMessage;
      case AuthenticationFailure:
        return failure.errorMessage;
      case SocketFailure:
        return SOCKET_FAILURE_MESSAGE;
      case EventCreationFailure:
        return failure.errorMessage;
      default:
        return 'Unexpected error';
    }
  }
}

// ignore: constant_identifier_names
const SERVER_FAILURE_MESSAGE = 'Server Failure';
// ignore: constant_identifier_names
const SERVER_FAILURE_INVALID_CREDENTIALS_MESSAGE = 'Invalid Credentials';
// ignore: constant_identifier_names
const SOCKET_FAILURE_MESSAGE = 'Please check your internet connection or try again later';
