import 'dart:collection';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class EventModel extends Equatable {
  final String eventID;
  final String eventName;
  final String eventDescription;
  final String eventDateTime;
  final String eventImage;
  final dynamic eventOrganizerDetails;
  final dynamic eventParticipants;

  const EventModel(
      {@required this.eventID,
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
        eventImage
      ];

  HashMap<String, dynamic> toJson() => HashMap.of({
        keyEventID: eventID,
        keyEventName: eventName,
        keyEventDescription: eventDescription,
        keyEventDateTime: eventDateTime,
        keyEventParticipants: eventParticipants,
        keyEventOrganizerDetails: eventOrganizerDetails,
        keyEventImage: eventImage
      });

  factory EventModel.fromJson(Map<String, dynamic> rawData) => EventModel(
      eventID: rawData[keyEventID].toString(),
      eventName: rawData[keyEventName].toString(),
      eventDescription: rawData[keyEventDescription].toString(),
      eventDateTime: rawData[keyEventDateTime].toString(),
      eventParticipants: rawData[keyEventParticipants],
      eventOrganizerDetails: rawData[keyEventOrganizerDetails],
      eventImage: rawData[keyEventImage].toString());
}

const String keyEventID = 'event_id';
const String keyEventName = 'event_name';
const String keyEventDescription = 'event_description';
const String keyEventDateTime = 'event_date_time';
const String keyEventParticipants = 'event_participants';
const String keyEventOrganizerDetails = 'evnt_organizer_details';
const String keyEventImage = 'event_image';
