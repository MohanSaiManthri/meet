import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meet/core/error/failures.dart';
import 'package:meet/core/utils/constants.dart';
import 'package:meet/dependecy_injection.dart';
import 'package:meet/features/register/data/models/user_model.dart';
import 'package:meta/meta.dart';

import 'package:meet/core/usecases/usecases.dart';
import 'package:meet/features/events/data/models/event_model.dart';
import 'package:meet/features/events/domain/repositories/events_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetEventsUsecase extends UseCase<OrganizedEventModel, EventsParams> {
  final EventRepository eventRepository;

  GetEventsUsecase({@required this.eventRepository});

  @override
  Future<Either<Failure, OrganizedEventModel>> call(EventsParams params) async {
    final Either<Failure, List<EventModel>> model =
        await eventRepository.fetchAllOrganizedEventsFromFirestore();
    // Used to get the user details
    final SharedPreferences _sharedPreferences = sl<SharedPreferences>();
    // Convert string to UserModel
    final mUserModel = UserModel.fromJson(
        json.decode(_sharedPreferences.getString(keyUserInfo)) as Map<String, dynamic>);

    //Extract the data
    Failure error;
    List<EventModel> listOfModel;
    model.fold((l) => error = l, (r) => listOfModel = r);
    // ! If it is error, Just return
    if (model.isLeft()) {
      return left(error);
    }
    // * Extract the data and divide the myEvents and otherEvents
    final List<EventModel> listOfOtherEvents = getOtherEvents(listOfModel, mUserModel);
    final List<EventModel> listOfMyEvents = getMyEvents(listOfModel, mUserModel);
    // * And Send it back by wrapping in new Model class.
    return right(OrganizedEventModel(listOfMyEvents, listOfOtherEvents));
  }

  List<EventModel> getOtherEvents(List<EventModel> listOfModel, UserModel mUserModel) {
    return listOfModel
      .where((element) =>
          UserModel.fromJson(element.eventOrganizerDetails as Map<String, dynamic>)
              .userUID !=
          mUserModel.userUID)
      .toList();
  }

  List<EventModel> getMyEvents(List<EventModel> listOfModel, UserModel mUserModel) {
    return listOfModel
        .where((element) =>
            UserModel.fromJson(element.eventOrganizerDetails as Map<String, dynamic>)
                .userUID ==
            mUserModel.userUID)
        .toList();
  }
}

class EventsParams extends Equatable {
  @override
  List<Object> get props => [];
}

class OrganizedEventModel extends Equatable {
  final List<EventModel> myEvents;
  final List<EventModel> otherEvents;

  const OrganizedEventModel(this.myEvents, this.otherEvents);

  @override
  List<Object> get props => [myEvents, otherEvents];
}
