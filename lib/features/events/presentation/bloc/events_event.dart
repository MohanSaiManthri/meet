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
