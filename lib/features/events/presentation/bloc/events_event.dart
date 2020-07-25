part of 'events_bloc.dart';

abstract class EventsEvent extends Equatable {
  const EventsEvent();
}

class FetchAllEventsOrganizedOnFirestore extends EventsEvent {
  @override
  String toString() => "Fetching Events from Firestore";

  @override
  List<Object> get props => [];
}

class LetTheUserAttendEventAsRequested extends EventsEvent {
  final String eventID;
  final UserModel userModel;

  const LetTheUserAttendEventAsRequested({this.eventID, this.userModel});

  @override
  List<Object> get props => [eventID, userModel];
}
