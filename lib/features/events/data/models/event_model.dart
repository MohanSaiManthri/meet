import 'dart:collection';
import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meet/features/register/data/models/user_model.dart';

class EventModel extends Equatable {
  final String eventID;
  final String eventName;
  final String eventDescription;
  final String eventDateTime;
  final String eventImage;
  final UserModel eventOrganizerDetails;
  final List<UserModel> eventParticipants;
  final String eventCreatedAt;

  const EventModel(
      {@required this.eventCreatedAt,
      @required this.eventID,
      @required this.eventName,
      @required this.eventDescription,
      @required this.eventDateTime,
      @required this.eventParticipants,
      @required this.eventOrganizerDetails,
      @required this.eventImage});

  @override
  List<Object> get props => [
        eventID,
        eventName,
        eventDescription,
        eventDateTime,
        eventParticipants,
        eventImage,
        eventCreatedAt
      ];

  HashMap<String, dynamic> toJson() => HashMap.of({
        keyEventID: eventID,
        keyEventName: eventName,
        keyEventDescription: eventDescription,
        keyEventDateTime: eventDateTime,
        keyEventParticipants: eventParticipants,
        keyEventOrganizerDetails: eventOrganizerDetails,
        keyEventCreatedAt: eventCreatedAt,
        keyEventImage: eventImage
      });

  factory EventModel.fromJson(Map<String, dynamic> rawData) => EventModel(
      eventID: rawData[keyEventID].toString(),
      eventName: rawData[keyEventName].toString(),
      eventDescription: rawData[keyEventDescription].toString(),
      eventDateTime: rawData[keyEventDateTime].toString(),
      eventParticipants: formatParticipants(rawData),
      eventOrganizerDetails:
          UserModel.fromJson(rawData[keyEventOrganizerDetails] as Map<String, dynamic>),
      eventImage: rawData[keyEventImage].toString(),
      eventCreatedAt: rawData[keyEventCreatedAt].toString());

  static List<UserModel> formatParticipants(Map<String, dynamic> data) {
    final List<UserModel> listOfParticipants = [];
    final decodedData = json.decode(json.encode(data[keyEventParticipants]));
    (decodedData as List<dynamic>)
        .removeWhere((element) => (element as Map<String, dynamic>).isEmpty);
    if ((decodedData.runtimeType.toString() == 'List<dynamic>') &&
        (decodedData as List<dynamic>).isEmpty) {
      return listOfParticipants;
    }
    final rawData = decodedData as List<dynamic>;
    for (final participant in rawData) {
      listOfParticipants.add(UserModel.fromJson(participant as Map<String, dynamic>));
    }
    return listOfParticipants;
  }
}

const String keyEventID = 'event_id';
const String keyEventName = 'event_name';
const String keyEventDescription = 'event_description';
const String keyEventDateTime = 'event_date_time';
const String keyEventParticipants = 'event_participants';
const String keyEventOrganizerDetails = 'evnt_organizer_details';
const String keyEventCreatedAt = 'event_created_at';
const String keyEventImage = 'event_image';
