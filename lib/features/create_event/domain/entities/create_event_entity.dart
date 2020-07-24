import 'dart:collection';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class CreateEventEntity extends Equatable {
  final String eventName;
  final String eventDescription;
  final String eventDateTime;
  final String eventParticipants;
  final String eventImage;
  final String eventOrganizer;
  final String eventOrganizerUID;

  const CreateEventEntity(
      {@required this.eventName,
      @required this.eventDescription,
      @required this.eventDateTime,
      @required this.eventParticipants,
      @required this.eventOrganizer,
      @required this.eventOrganizerUID,
      @required this.eventImage});

  @override
  List<Object> get props =>
      [eventName, eventDescription, eventDateTime, eventParticipants, eventImage];

  HashMap<String, String> toJson() => HashMap.of({
        keyEventName: eventName,
        keyEventDescription: eventDescription,
        keyEventDateTime: eventDateTime,
        keyEventParticipants: eventParticipants,
        keyEventOrganizer: eventOrganizer,
        keyEventOrganizerUID: eventOrganizerUID,
        keyEventImage: eventImage
      });

  CreateEventEntity fromJson(HashMap<String, String> rawData) => CreateEventEntity(
      eventName: rawData[keyEventName],
      eventDescription: rawData[keyEventDescription],
      eventDateTime: rawData[keyEventDateTime],
      eventParticipants: rawData[keyEventParticipants],
      eventOrganizer: rawData[keyEventOrganizer],
      eventOrganizerUID: rawData[keyEventOrganizerUID],
      eventImage: rawData[keyEventImage]);
}

const String keyEventName = 'event_name';
const String keyEventDescription = 'event_description';
const String keyEventDateTime = 'event_date_time';
const String keyEventParticipants = 'event_participants';
const String keyEventOrganizer = 'evnt_organizer';
const String keyEventOrganizerUID = 'event_organzier_uid';
const String keyEventImage = 'event_image';
