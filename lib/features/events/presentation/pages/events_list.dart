import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet/core/utils/constants.dart';
import 'package:meet/dependecy_injection.dart';
import 'package:meet/features/create_event/presentation/pages/create_event.dart';
import 'package:meet/features/events/data/models/event_model.dart';
import 'package:meet/features/events/domain/usecases/get_events_usecase.dart';
import 'package:meet/features/events/presentation/bloc/events_bloc.dart';
import 'package:meet/features/events/presentation/widgets/appbar.dart';
import 'package:meet/features/events/presentation/widgets/error_widget.dart';
import 'package:meet/features/events/presentation/widgets/loader.dart';
import 'package:meet/features/events/presentation/widgets/page_view_widget.dart';
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
  double currentIndex = 0;
  bool _isVisible = true;
  final PageController _controller = PageController(
    initialPage: 0,
  );
  ScrollController _hideButtonController;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        currentIndex = _controller.page;
      });
    });
    _hideButtonController = ScrollController();
    _hideButtonController.addListener(() {
      if (_hideButtonController.position.userScrollDirection == ScrollDirection.reverse) {
        setState(() {
          _isVisible = false;
        });
      }
      if (_hideButtonController.position.userScrollDirection == ScrollDirection.forward) {
        setState(() {
          _isVisible = true;
        });
      }
    });
    eventsBloc.add(FetchAllEventsOrganizedOnFirestore());
    mUserModel = UserModel.fromJson(
        json.decode(_sharedPreferences.getString(keyUserInfo)) as Map<String, dynamic>);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Appbar(
            refreshCallback: () {
              eventsBloc.add(FetchAllEventsOrganizedOnFirestore());
            },
          )),
      floatingActionButton: Padding(
        padding: EdgeInsets.all(_isVisible ? 0.0 : 8.0),
        child: FloatingActionButton(
          onPressed: () async {
            await Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const CreateEvent(),
            ));
            eventsBloc.add(FetchAllEventsOrganizedOnFirestore());
          },
          child: const Icon(
            Icons.add,
            size: 28,
          ),
        ),
      ),
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBarCustom(
          isVisible: _isVisible,
          callback: (isLeft) {
            setState(() {
              currentIndex = isLeft ? 0 : 1;
              _controller.animateToPage(isLeft ? 0 : 1,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.fastOutSlowIn);
            });
          },
          currentIndex: currentIndex),
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
              return PageViewWidget(
                  controller: _controller,
                  listOfEvents: listOfEvents,
                  hideButtonController: _hideButtonController,
                  scaffoldState: _scaffoldKey.currentState,
                  currentIndex: currentIndex,
                  eventsBloc: eventsBloc,
                  mUserModel: mUserModel);
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
          message: successMsgForRegisteringEvent,
        );
        Future.delayed(const Duration(milliseconds: 500), () {
          eventsBloc.add(FetchAllEventsOrganizedOnFirestore());
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

  void attendEvent(String eventId) => eventsBloc
      .add(LetTheUserAttendEventAsRequested(eventID: eventId, userModel: mUserModel));

  bool doesUserAlreadyBookedForEvent(EventModel model) {
    return (model.eventParticipants)
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

class BottomAppBarCustom extends StatelessWidget {
  const BottomAppBarCustom(
      {Key key,
      @required bool isVisible,
      @required this.currentIndex,
      @required this.callback})
      : _isVisible = isVisible,
        super(key: key);

  final bool _isVisible;
  final double currentIndex;
  final Function(bool) callback;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      curve: Curves.fastLinearToSlowEaseIn,
      height: _isVisible ? 60 : 0.0,
      child: BottomAppBar(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: const CircularNotchedRectangle(),
        notchMargin: 6.0,
        child: Container(
          height: 60,
          child: Material(
            child: InkWell(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  FlatButton(
                      onPressed: () {
                        callback.call(true);
                      },
                      child: Text(
                        'Events',
                        style: Theme.of(context).textTheme.subtitle2.apply(
                            color: currentIndex == 0.0 ? primaryColor : Colors.black45),
                      )),
                  FlatButton(
                      onPressed: () {
                        callback.call(false);
                      },
                      child: Text(
                        'My Events',
                        style: Theme.of(context).textTheme.subtitle2.apply(
                            color: currentIndex == 1.0 ? primaryColor : Colors.black45),
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

const String somethingWentWrong = "Something went wrong!";
const String successMsgForRegisteringEvent = "Successfully registered to the event";
