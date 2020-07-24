part of 'create_event_bloc.dart';

abstract class CreateEventState extends Equatable {
  @override
  List<Object> get props => [];
}

class CreateEventInitial extends CreateEventState {
  @override
  List<Object> get props => [];
}

class CreatingEvent extends CreateEventState {}

class EventCreated extends CreateEventState {
  EventCreated();
  @override
  List<Object> get props => [];
}

class FailedToCreateEvent extends CreateEventState {
  final String errorMsg;

  FailedToCreateEvent({@required this.errorMsg});

  @override
  List<Object> get props => [errorMsg];
}
