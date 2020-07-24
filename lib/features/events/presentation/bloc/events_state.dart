part of 'events_bloc.dart';

abstract class EventsState extends Equatable {
  @override
  List<Object> get props => [];
}

class EventsInitial extends EventsState {
  @override
  List<Object> get props => [];
}

class FetchingEvents extends EventsState {}

class EventsFetchedSuccessfully extends EventsState {
  final List<EventModel> listOfEvents;

  EventsFetchedSuccessfully({this.listOfEvents});

  @override
  List<Object> get props => [listOfEvents];
}

class FailedToFetchEvents extends EventsState {
  final String errorMsg;

  FailedToFetchEvents({@required this.errorMsg});

  @override
  List<Object> get props => [errorMsg];
}
