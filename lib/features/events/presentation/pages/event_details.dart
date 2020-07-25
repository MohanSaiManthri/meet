import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_stack/image_stack.dart';
import 'package:intl/intl.dart';
import 'package:meet/core/extensions/navigations.dart';
import 'package:meet/core/utils/constants.dart';
import 'package:meet/dependecy_injection.dart';
import 'package:meet/features/events/data/models/event_model.dart';
import 'package:meet/features/events/presentation/bloc/events_bloc.dart';
import 'package:meet/features/events/presentation/pages/events_list.dart';
import 'package:meet/features/events/presentation/widgets/loader.dart';
import 'package:meet/features/register/data/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EventDetails extends StatefulWidget {
  final EventModel model;
  final bool isHeAttendingEvent;
  const EventDetails({Key key, @required this.model, @required this.isHeAttendingEvent})
      : super(key: key);

  @override
  _EventDetailsState createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {
  final EventsBloc eventsBloc = sl<EventsBloc>();
  final SharedPreferences sharedPreferences = sl<SharedPreferences>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  UserModel userModel;
  bool isHeAttends = true;
  @override
  void initState() {
    super.initState();
    userModel = UserModel.fromJson(
        json.decode(sharedPreferences.getString(keyUserInfo)) as Map<String, dynamic>);
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        key: _scaffoldKey,
        floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: widget.isHeAttendingEvent && isHeAttends
            ? FloatingActionButton.extended(
                onPressed: attendEvent, label: const Text('Attend this Event'))
            : null,
        appBar: AppBar(
          title: Text(
            'Event Details',
            style: Theme.of(context)
                .textTheme
                .headline6
                .apply(color: Colors.black, fontSizeDelta: -3),
          ),
          backgroundColor: Colors.white,
          brightness: Brightness.light,
          leading: IconButton(
              icon: Icon(
                Icons.keyboard_backspace,
                color: Colors.black,
              ),
              onPressed: () => pop()),
        ),
        body: BlocProvider(
          create: (context) => eventsBloc,
          child: BlocConsumer<EventsBloc, EventsState>(
            listener: buildHelper,
            builder: (context, state) => SafeArea(
              minimum: const EdgeInsets.all(10),
              child: ListView(
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Hero(
                        transitionOnUserGestures: true,
                        tag: widget.model.eventID,
                        child: Image.network(
                          widget.model.eventImage,
                          height: deviceHeight * 0.3,
                          width: deviceWidth,
                          fit: BoxFit.cover,
                        )),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(5, 10, 10, 0),
                            child: Text(widget.model.eventName,
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle2
                                    .apply(fontSizeDelta: 3)),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(5, 3, 10, 10),
                            child: Text(
                                'on ${DateFormat.yMMMEd().format(DateTime.parse(widget.model.eventDateTime))}',
                                style: Theme.of(context).textTheme.caption),
                          )
                        ],
                      ),
                      buildImageStack(context)
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Text(widget.model.eventDescription),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Tooltip buildImageStack(BuildContext context) {
    final List<String> imageList = [];
    for (final participant in widget.model.eventParticipants) {
      imageList.add(participant.userPhotoURL);
    }
    return Tooltip(
      message: 'People Attending',
      child: ImageStack(
        imageList: imageList,
        totalCount: imageList.length,
        imageBorderColor: Colors.grey[300],
        backgroundColor: Colors.grey[300],
        extraCountTextStyle: Theme.of(context).textTheme.bodyText2,
        imageRadius: 28, // Radius of each images
        imageCount: 3, // Maximum number of images to be shown
        imageBorderWidth: 3, // Border width around the images
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
          message: successMsgForRegisteringEvent,
        );
        setState(() {
          isHeAttends = false;
        });
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

  void showErrorSnack(BuildContext context, {String message}) {
    final snackbar = SnackBar(
        content: Text(
      message,
      style: Theme.of(context).textTheme.bodyText2.apply(color: Colors.white),
    ));
    _scaffoldKey.currentState.showSnackBar(snackbar);
  }

  void attendEvent() {
    eventsBloc.add(LetTheUserAttendEventAsRequested(
        eventID: widget.model.eventID, userModel: userModel));
  }
}
