part of 'create_event_bloc.dart';

abstract class CreateEventEvent extends Equatable {
  const CreateEventEvent();
}

class CreateEventAndStoreItToFirestore extends CreateEventEvent {
  final CreateEventEntity createEventEntity;

  const CreateEventAndStoreItToFirestore({@required this.createEventEntity});

  @override
  String toString() => "Creating Event";

  @override
  List<Object> get props => [];
}
