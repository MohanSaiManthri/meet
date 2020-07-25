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
  final OrganizedEventModel listOfEvents;

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

class UpdatingUserEventstatus extends EventsState {}

class UserNowAttendingEvent extends EventsState {
  final bool unnecessaryBool;

  UserNowAttendingEvent({this.unnecessaryBool});
  @override
  List<Object> get props => [unnecessaryBool];
}

class FailedToUpdateUserEventstatus extends EventsState {
  final String error;

  FailedToUpdateUserEventstatus({@required this.error});
  @override
  List<Object> get props => [error];
}
