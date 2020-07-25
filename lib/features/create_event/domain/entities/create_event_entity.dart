import 'dart:collection';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class CreateEventEntity extends Equatable {
  final String eventID;
  final String eventName;
  final String eventDescription;
  final String eventDateTime;
  final dynamic eventParticipants;
  final String eventImage;
  final dynamic eventOrganizerDetails;

  const CreateEventEntity(
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
        keyEventOrganizerDetails: eventOrganizerDetails,
        keyEventImage: eventImage,
        keyEventParticipants: eventParticipants,
      });

  CreateEventEntity fromJson(HashMap<String, dynamic> rawData) => CreateEventEntity(
        eventID: rawData[keyEventID].toString(),
        eventName: rawData[keyEventName].toString(),
        eventDescription: rawData[keyEventDescription].toString(),
        eventDateTime: rawData[keyEventDateTime].toString(),
        eventOrganizerDetails: rawData[keyEventOrganizerDetails],
        eventImage: rawData[keyEventImage].toString(),
        eventParticipants: rawData[keyEventParticipants],
      );
}

const String keyEventID = 'event_id';
const String keyEventName = 'event_name';
const String keyEventDescription = 'event_description';
const String keyEventDateTime = 'event_date_time';
const String keyEventParticipants = 'event_participants';
const String keyEventOrganizerDetails = 'evnt_organizer_details';
const String keyEventOrganizerUID = 'event_organzier_uid';
const String keyEventImage = 'event_image';
