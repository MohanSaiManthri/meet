import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meet/core/error/exceptions.dart';
import 'package:meet/features/create_event/domain/entities/create_event_entity.dart';

abstract class CreateEventDataSource {
  Future<bool> createEventOnDemand(CreateEventEntity createEventEntity);
}

class CreateEventDataSourceImpl extends CreateEventDataSource {
  @override
  Future<bool> createEventOnDemand(CreateEventEntity createEventEntity) =>
      _letTheUserCreateEvent(createEventEntity);

  Future<bool> _letTheUserCreateEvent(CreateEventEntity createEventEntity) async {
    try {
      await Firestore.instance
          .collection(eventCollectionName)
          .document()
          .setData(createEventEntity.toJson())
          .catchError((_) {
        throw EventCreationException(errorWhileCreatingEvent);
      });
      return true;
    } catch (_) {
      throw EventCreationException(errorWhileCreatingEvent);
    }
  }
}

const String eventCollectionName = "Events";
const String errorWhileCreatingEvent =
    "Something went wrong while creating an event, Please try again!";
