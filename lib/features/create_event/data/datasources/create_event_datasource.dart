import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
    final rawData = createEventEntity.toJson();
    final String photoURL = createEventEntity.eventImage;
    try {
      // If image is null then we will upload the placeholder as shown
      String newPath = defaultImage;
      // else if it is not null then we will upload the given picture to storage and get the download url and store that in the firestore.
      if (photoURL != null && photoURL.isNotEmpty) {
        final _image = File(photoURL);
        final StorageReference storageReference =
            FirebaseStorage().ref().child('profile_pictures/${_image.name}}');
        final StorageUploadTask uploadTask = storageReference.putFile(_image);
        await uploadTask.onComplete;
        newPath = (await storageReference.getDownloadURL()).toString();
      }
      rawData.update(keyEventImage, (value) => newPath);
      await Firestore.instance
          .collection(eventCollectionName)
          .document()
          .setData(rawData)
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
const String keyEventImage = 'event_image';
const String defaultImage =
    "https://images.unsplash.com/photo-1501281668745-f7f57925c3b4?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1350&q=80";

extension FileExtention on FileSystemEntity {
  String get name {
    return path?.split("/")?.last;
  }
}
