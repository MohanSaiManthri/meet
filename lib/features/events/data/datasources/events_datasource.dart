import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meet/core/error/exceptions.dart';
import 'package:meet/features/events/data/models/event_model.dart';

abstract class EventsDataSource {
  /// Returns all the organized events in firestore
  ///
  /// Under collection `Events`
  Future<List<EventModel>> getAllOrganizedEvents();
}

class EventDatasourceImpl extends EventsDataSource {
  @override
  Future<List<EventModel>> getAllOrganizedEvents() => _getAllEventsFromFirestore();

  Future<List<EventModel>> _getAllEventsFromFirestore() async {
    final List<EventModel> listOfEvents = [];
    final QuerySnapshot querySnapshot =
        await Firestore.instance.collection(eventCollectionName).getDocuments();
    for (final DocumentSnapshot document in querySnapshot.documents) {
      try {
        final event = EventModel.fromJson(HashMap.from(document.data));
        listOfEvents.add(event);
      } catch (e) {
        throw EventFetchException(e.toString());
      }
    }
    return listOfEvents;
  }
}

const String eventCollectionName = "Events";
