import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet/core/extensions/navigations.dart';
import 'package:meet/core/utils/constants.dart';
import 'package:meet/dependecy_injection.dart';
import 'package:meet/features/create_event/domain/entities/create_event_entity.dart';
import 'package:meet/features/create_event/presentation/bloc/create_event_bloc.dart';
import 'package:meet/features/create_event/presentation/widgets/loader.dart';
import 'package:meet/features/events/presentation/pages/events_list.dart';
import 'package:meet/features/register/data/models/user_model.dart';
import 'package:random_string/random_string.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateEvent extends StatefulWidget {
  const CreateEvent({Key key}) : super(key: key);

  @override
  _CreateEventState createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  final CreateEventBloc createEventBloc = sl<CreateEventBloc>();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final SharedPreferences _sharedPreferences = sl<SharedPreferences>();

  UserModel userModel;

  @override
  void initState() {
    super.initState();
    final String encodedData = _sharedPreferences.getString(keyUserInfo);
    final Map<String, dynamic> mappedData =
        json.decode(encodedData) as Map<String, dynamic>;
    userModel = UserModel.fromJson(mappedData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: BlocProvider(
        create: (context) => createEventBloc,
        child: BlocConsumer<CreateEventBloc, CreateEventState>(
          listener: (context, state) => buildHelper(context, state),
          builder: (context, state) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  RaisedButton(
                    // TODO: Start from here
                    // First generate randomID as an eventID
                    // Make the fields dynamic
                    // Thats it in create event
                    // Then after go to event list and do further steps.
                    onPressed: () => createEventBloc.add(CreateEventAndStoreItToFirestore(
                        createEventEntity: CreateEventEntity(
                      eventID: randomAlphaNumeric(10),
                      eventName: 'First Event',
                      eventDescription:
                          'During a flex layout, available space along the main axis is allocated to children. After allocating space, there might be some remaining free space. This value controls whether to maximize or minimize the amount of free space, subject to the incoming layout constraints.',
                      eventDateTime: '31/07/2020',
                      eventOrganizerDetails: userModel.toJson(),
                      eventImage:
                          'https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=634&q=80',
                      eventParticipants: const [<String, dynamic>{}],
                    ))),
                    child: Text(
                      'Create Event'.toUpperCase(),
                      style: Theme.of(context).textTheme.button,
                    ),
                  ),
                  RaisedButton(
                    onPressed: () => push(const EventsList()),
                    child: Text(
                      'List Events'.toUpperCase(),
                      style: Theme.of(context).textTheme.button,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void buildHelper(BuildContext context, CreateEventState state) {
    if (state is CreatingEvent) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
        if (!Loader.isShowing()) {
          Loader.show();
        }
      });
    } else if (state is EventCreated) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
        if (Loader.isShowing()) {
          Loader.dismiss();
        }
        showErrorSnack(
          context,
          message: "Success",
        );
      });
    } else if (state is FailedToCreateEvent) {
      Future.delayed(const Duration(seconds: 1), () {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
          if (Loader.isShowing()) {
            Loader.dismiss();
          }
          showErrorSnack(
            context,
            message: state.errorMsg,
          );
        });
      });
    }
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
