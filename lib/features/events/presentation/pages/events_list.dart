import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet/core/utils/constants.dart';
import 'package:meet/dependecy_injection.dart';
import 'package:meet/features/events/data/models/event_model.dart';
import 'package:meet/features/events/domain/usecases/get_events_usecase.dart';
import 'package:meet/features/events/presentation/bloc/events_bloc.dart';
import 'package:meet/features/events/presentation/widgets/error_widget.dart';
import 'package:meet/features/events/presentation/widgets/loader.dart';
import 'package:meet/features/register/data/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EventsList extends StatefulWidget {
  const EventsList({Key key}) : super(key: key);

  @override
  _EventsListState createState() => _EventsListState();
}

class _EventsListState extends State<EventsList> {
  final EventsBloc eventsBloc = sl<EventsBloc>();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final SharedPreferences _sharedPreferences = sl<SharedPreferences>();

  OrganizedEventModel listOfEvents;
  UserModel mUserModel;

  @override
  void initState() {
    super.initState();
    eventsBloc.add(FetchAllEventsOrganizedOnFirestore());
    mUserModel = UserModel.fromJson(
        json.decode(_sharedPreferences.getString(keyUserInfo)) as Map<String, dynamic>);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: BlocProvider(
        create: (context) => eventsBloc,
        child: BlocConsumer<EventsBloc, EventsState>(
          listener: (context, state) => buildHelper(context, state),
          builder: (context, state) {
            if (state is FetchingEvents) {
              return loadingWidget();
            } else if (state is EventsFetchedSuccessfully ||
                state is UserNowAttendingEvent ||
                state is UpdatingUserEventstatus) {
              if (state is EventsFetchedSuccessfully) {
                listOfEvents = state.listOfEvents;
              }
              return Padding(
                padding: const EdgeInsets.fromLTRB(10, 50, 10, 0),
                child: ListView.builder(
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(UserModel.fromJson(listOfEvents.myEvents[index]
                                .eventOrganizerDetails as Map<String, dynamic>)
                            .userDisplayName),
                        Visibility(
                          visible:
                              doesUserAlreadyBookedForEvent(listOfEvents.myEvents[index]),
                          child: RaisedButton(
                            onPressed: () =>
                                attendEvent(listOfEvents.myEvents[index].eventID),
                            child: Text('Attend Event'.toUpperCase()),
                          ),
                        )
                      ],
                    ),
                  ),
                  itemCount: listOfEvents.myEvents.length,
                ),
              );
            } else if (state is FailedToFetchEvents) {
              return buildErrorWidget(context, eventsBloc, error: state.errorMsg);
            } else {
              return buildErrorWidget(context, eventsBloc);
            }
          },
        ),
      ),
    );
  }

  void buildHelper(BuildContext context, EventsState state) {
    if (state is UpdatingUserEventstatus) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
        if (!Loader.isShowing()) {
          Loader.show();
        }
      });
    } else if (state is UserNowAttendingEvent) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
        if (Loader.isShowing()) {
          Loader.dismiss();
        }
        showErrorSnack(
          context,
          message: "Success",
        );
      });
    } else if (state is FailedToUpdateUserEventstatus) {
      Future.delayed(const Duration(seconds: 1), () {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
          if (Loader.isShowing()) {
            Loader.dismiss();
          }
          showErrorSnack(
            context,
            message: state.error,
          );
        });
      });
    }
  }

  void attendEvent(String eventId) => eventsBloc
      .add(LetTheUserAttendEventAsRequested(eventID: eventId, userModel: mUserModel));

  bool doesUserAlreadyBookedForEvent(EventModel model) {
    return (model.eventParticipants as List<dynamic>)
        .where((element) =>
            UserModel.fromJson(element as Map<String, dynamic>).userUID !=
            mUserModel.userUID)
        .toList()
        .isNotEmpty;
  }

  Center loadingWidget() {
    return Center(
      child: Platform.isIOS
          ? const CupertinoActivityIndicator(
              radius: 20,
            )
          : const CircularProgressIndicator(),
    );
  }

  void showErrorSnack(BuildContext context, {String message}) {
    final snackbar = SnackBar(
        content: Text(
      message,
      style: Theme.of(context).textTheme.bodyText2.apply(color: Colors.white),
    ));
    _scaffoldKey.currentState.showSnackBar(snackbar);
  }
}

const String somethingWentWrong = "Something went wrong!";
