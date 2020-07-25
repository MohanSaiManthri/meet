import 'package:flutter/material.dart';
import 'package:meet/features/events/domain/usecases/get_events_usecase.dart';
import 'package:meet/features/events/presentation/bloc/events_bloc.dart';
import 'package:meet/features/events/presentation/widgets/skeleton.dart';
import 'package:meet/features/register/data/models/user_model.dart';

class PageViewWidget extends StatefulWidget {
  const PageViewWidget(
      {Key key,
      @required PageController controller,
      @required this.listOfEvents,
      @required ScrollController hideButtonController,
      @required this.eventsBloc,
      @required this.mUserModel,
      @required this.currentIndex,
      @required this.scaffoldState})
      : _controller = controller,
        _hideButtonController = hideButtonController,
        super(key: key);

  final PageController _controller;
  final OrganizedEventModel listOfEvents;
  final ScrollController _hideButtonController;
  final EventsBloc eventsBloc;
  final UserModel mUserModel;
  final ScaffoldState scaffoldState;
  final double currentIndex;

  @override
  _PageViewWidgetState createState() => _PageViewWidgetState();
}

class _PageViewWidgetState extends State<PageViewWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (widget._controller.hasClients) {
        if (widget.currentIndex == 1) {
          widget._controller.animateToPage(1,
              duration: const Duration(milliseconds: 500), curve: Curves.fastOutSlowIn);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: widget._controller,
      children: [
        if (widget.listOfEvents.otherEvents.isEmpty)
          Center(
            child: Image.asset('assets/empty.jpg'),
          )
        else
          ListView.separated(
              controller: widget._hideButtonController,
              itemBuilder: (context, index) => Skeleton(
                  model: widget.listOfEvents.otherEvents,
                  index: index,
                  isMyEvents: false,
                  attendEventCallback: (eventId) {
                    attendEvent(
                      eventId,
                    );
                  },
                  reloadRequired: () =>
                      widget.eventsBloc.add(FetchAllEventsOrganizedOnFirestore()),
                  showMsg: (msg) {
                    showErrorSnack(context, message: msg);
                  },
                  myUID: widget.mUserModel.userUID),
              separatorBuilder: (context, index) => const Divider(),
              itemCount: widget.listOfEvents.otherEvents.length),
        if (widget.listOfEvents.myEvents.isEmpty)
          Center(
            child: Image.asset('assets/empty.jpg'),
          )
        else
          ListView.separated(
              controller: widget._hideButtonController,
              itemBuilder: (context, index) => Skeleton(
                    model: widget.listOfEvents.myEvents,
                    index: index,
                    reloadRequired: () =>
                        widget.eventsBloc.add(FetchAllEventsOrganizedOnFirestore()),
                    isMyEvents: true,
                    attendEventCallback: (e) {},
                    showMsg: (msg) {
                      showErrorSnack(context, message: msg);
                    },
                    myUID: widget.mUserModel.userUID,
                  ),
              separatorBuilder: (context, index) => const Divider(),
              itemCount: widget.listOfEvents.myEvents.length),
      ],
    );
  }

  void showErrorSnack(BuildContext context, {String message}) {
    final snackbar = SnackBar(
        content: Text(
      message,
      style: Theme.of(context).textTheme.bodyText2.apply(color: Colors.white),
    ));
    widget.scaffoldState.showSnackBar(snackbar);
  }

  void attendEvent(String eventId) => widget.eventsBloc.add(
      LetTheUserAttendEventAsRequested(eventID: eventId, userModel: widget.mUserModel));
}
