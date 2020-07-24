import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meet/core/error/failures.dart';
import 'package:meet/features/events/data/models/event_model.dart';
import 'package:meet/features/events/domain/usecases/get_events_usecase.dart';
part 'events_event.dart';
part 'events_state.dart';

class EventsBloc extends Bloc<EventsEvent, EventsState> {
  final GetEventsUsecase getEventsUsecase;
  EventsBloc({@required this.getEventsUsecase}) : super(EventsInitial());
  @override
  Stream<EventsState> mapEventToState(
    EventsEvent event,
  ) async* {
    if (event is FetchAllEventsOrganizedOnFirestore) {
      yield FetchingEvents();
      final _failedOrFetched = await getEventsUsecase.call(EventsParams());
      yield* _eitherLoadedOrErrorState(_failedOrFetched);
    }
  }

  Stream<EventsState> _eitherLoadedOrErrorState(
    Either<Failure, List<EventModel>> failureOrTrivia,
  ) async* {
    yield failureOrTrivia.fold(
      (failure) => FailedToFetchEvents(errorMsg: _mapFailureToMessage(failure)),
      (List<EventModel> trivia) => EventsFetchedSuccessfully(listOfEvents: trivia),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return failure.errorMessage;
      case AuthenticationFailure:
        return failure.errorMessage;
      case EventFetchFailure:
        return failure.errorMessage;
      case SocketFailure:
        return SOCKET_FAILURE_MESSAGE;
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
