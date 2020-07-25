import 'package:flutter/material.dart';
import 'package:meet/features/events/presentation/bloc/events_bloc.dart';
import 'package:meet/features/events/presentation/pages/events_list.dart';

Center buildErrorWidget(BuildContext context, EventsBloc eventsBloc,
    {String error = somethingWentWrong}) {
  return Center(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            error,
            style: Theme.of(context).textTheme.bodyText2,
            textAlign: TextAlign.center,
          ),
        ),
        RaisedButton(
          onPressed: () => eventsBloc.add(FetchAllEventsOrganizedOnFirestore()),
          child: Text(
            'Retry'.toUpperCase(),
            style: Theme.of(context).textTheme.button,
          ),
        )
      ],
    ),
  );
}
