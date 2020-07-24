import 'dart:collection';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class EventModel extends Equatable {
  final String eventName;
  final String eventDescription;
  final String eventDateTime;
  final String eventImage;
  final String eventOrganizer;
  final String eventOrganizerUID;
  final dynamic eventParticipants;

  const EventModel(
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

  HashMap<String, dynamic> toJson() => HashMap.of({
        keyEventName: eventName,
        keyEventDescription: eventDescription,
        keyEventDateTime: eventDateTime,
        keyEventParticipants: eventParticipants,
        keyEventOrganizer: eventOrganizer,
        keyEventOrganizerUID: eventOrganizerUID,
        keyEventImage: eventImage
      });

  factory EventModel.fromJson(Map<String, dynamic> rawData) => EventModel(
      eventName: rawData[keyEventName].toString(),
      eventDescription: rawData[keyEventDescription].toString(),
      eventDateTime: rawData[keyEventDateTime].toString(),
      eventParticipants: rawData[keyEventParticipants],
      eventOrganizer: rawData[keyEventOrganizer].toString(),
      eventOrganizerUID: rawData[keyEventOrganizerUID].toString(),
      eventImage: rawData[keyEventImage].toString());
}

const String keyEventName = 'event_name';
const String keyEventDescription = 'event_description';
const String keyEventDateTime = 'event_date_time';
const String keyEventParticipants = 'event_participants';
const String keyEventOrganizer = 'evnt_organizer';
const String keyEventOrganizerUID = 'event_organzier_uid';
const String keyEventImage = 'event_image';
