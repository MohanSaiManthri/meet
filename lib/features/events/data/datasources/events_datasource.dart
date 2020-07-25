import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meet/core/error/exceptions.dart';
import 'package:meet/features/events/data/models/event_model.dart';
import 'package:meet/features/register/data/models/user_model.dart';

abstract class EventsDataSource {
  /// Returns all the organized events in firestore
  ///
  /// Under collection `Events`
  Future<List<EventModel>> getAllOrganizedEvents();

  Future<bool> markUserAttendingEvent(UserModel userModel, String eventID);
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
        final event = EventModel.fromJson(document.data);
        listOfEvents.add(event);
      } catch (e) {
        throw EventFetchException(e.toString());
      }
    }
    return listOfEvents;
  }

  @override
  Future<bool> markUserAttendingEvent(UserModel userModel, String eventID) =>
      _allowUserToAttendEvent(userModel, eventID);

  Future<bool> _allowUserToAttendEvent(UserModel userModel, String mEventID) async {
    try {
      // Fetch All Documents
      final QuerySnapshot querySnapshot =
          await Firestore.instance.collection(eventCollectionName).getDocuments();
      // Filter document we need based on eventID & get the first element
      final DocumentSnapshot document = querySnapshot.documents
          .where((element) => EventModel.fromJson(element.data).eventID == mEventID)
          .first;

      Firestore.instance.runTransaction((transaction) async {
        final DocumentSnapshot postSnapshot = await transaction.get(document.reference);
        // Fetch the already attending participants
        final List<dynamic> listOfParticipants =
            postSnapshot.data[eventParticipantsKey] as List<dynamic>;
        // Add new participant to the list
        // First we will check whether user already exists or not
        bool participantExists = false;
        for (final participant in listOfParticipants) {
          final UserModel formattedParticipant =
              UserModel.fromJson(participant as Map<String, dynamic>);
          if (formattedParticipant.userUID == userModel.userUID) {
            participantExists = true;
          }
        }
        // If not then we will add
        if (!participantExists) {
          listOfParticipants.add(userModel.toJson());
        }
        listOfParticipants
            .removeWhere((element) => (element as Map<String, dynamic>).isEmpty);
        // Update the data now
        if (postSnapshot.exists) {
          await transaction.update(document.reference,
              <String, dynamic>{eventParticipantsKey: listOfParticipants});
        }
      });
      return true;
    } catch (e) {
      throw MarkingUserToAttentEventException(e.toString());
    }
  }
}

const String eventCollectionName = "Events";
const String eventParticipantsKey = "event_participants";
