import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet/dependecy_injection.dart';
import 'package:meet/features/events/presentation/bloc/events_bloc.dart';
import 'package:meet/features/events/presentation/widgets/error_widget.dart';

class EventsList extends StatefulWidget {
  const EventsList({Key key}) : super(key: key);

  @override
  _EventsListState createState() => _EventsListState();
}

class _EventsListState extends State<EventsList> {
  final EventsBloc eventsBloc = sl<EventsBloc>();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    eventsBloc.add(FetchAllEventsOrganizedOnFirestore());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: BlocProvider(
        create: (context) => eventsBloc,
        child: BlocBuilder<EventsBloc, EventsState>(
          builder: (context, state) {
            if (state is FetchingEvents) {
              return loadingWidget();
            } else if (state is EventsFetchedSuccessfully) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(10, 50, 10, 0),
                child: ListView.builder(
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(state.listOfEvents[index].eventOrganizerUID),
                  ),
                  itemCount: state.listOfEvents.length,
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
