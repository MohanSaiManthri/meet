import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meet/core/utils/constants.dart';
import 'package:meet/features/events/data/models/event_model.dart';
import 'package:meet/features/events/presentation/pages/event_details.dart';
import 'package:time_formatter/time_formatter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class Skeleton extends StatelessWidget {
  final List<EventModel> model;
  final int index;
  final bool isMyEvents;
  final String myUID;
  final Function(String) attendEventCallback;
  final Function(String) showMsg;
  final Function() reloadRequired;
  const Skeleton(
      {Key key,
      this.model,
      this.index,
      @required this.isMyEvents,
      @required this.myUID,
      @required this.showMsg,
      @required this.reloadRequired,
      @required this.attendEventCallback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    model.sort((a, b) => b.eventCreatedAt.compareTo(a.eventCreatedAt));
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // Info Container
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              // * Profile picture
              CircleAvatar(
                backgroundColor: Colors.white,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(48),
                    child: Image.network(
                      model[index].eventOrganizerDetails.userPhotoURL,
                      fit: BoxFit.cover,
                      width: 80,
                      height: 80,
                    )),
              ),
              const SizedBox(
                width: 10,
              ),
              // * Name, time and category
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    model[index].eventOrganizerDetails.userDisplayName,
                    style:
                        Theme.of(context).textTheme.bodyText1.apply(fontWeightDelta: 3),
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  RichText(
                      text: TextSpan(
                          style:
                              Theme.of(context).textTheme.caption.apply(fontSizeDelta: 2),
                          children: [
                        TextSpan(
                            text: formatTime(DateTime.parse(model[index].eventCreatedAt)
                                .millisecondsSinceEpoch)),
                      ])),
                ],
              )),
              const SizedBox(
                width: 10,
              ),
              IconButton(
                  icon: Icon(
                    isMyEvents ||
                            model[index]
                                .eventParticipants
                                .where((element) => element.userUID == myUID)
                                .toList()
                                .isNotEmpty
                        ? MdiIcons.calendarCheck
                        : MdiIcons.calendarPlus,
                    color: primaryColor,
                  ),
                  onPressed: callbackToAttendEvent),
              const SizedBox(
                width: 5,
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Flexible(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
            child: Wrap(
              alignment: WrapAlignment.start,
              children: <Widget>[
                Text(
                  model[index].eventDescription,
                  style:
                      Theme.of(context).textTheme.bodyText2.apply(fontSizeDelta: 2).apply(
                            color: Colors.black54,
                            fontSizeDelta: -2,
                          ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
                InkWell(
                  onTap: () async {
                    await Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => EventDetails(
                              model: model[index],
                              isHeAttendingEvent: !(isMyEvents ||
                                  model[index]
                                      .eventParticipants
                                      .where((element) => element.userUID == myUID)
                                      .toList()
                                      .isNotEmpty),
                            )));
                    reloadRequired();
                  },
                  child: Padding(
                    padding: model[index].eventDescription.length < 40
                        ? const EdgeInsets.symmetric(vertical: 2, horizontal: 3)
                        : EdgeInsets.zero,
                    child: Text('Read more',
                        style: Theme.of(context).textTheme.caption.apply(
                              color: primaryColor,
                              fontWeightDelta: 2,
                            )),
                  ),
                )
              ],
            ),
          ),
        ),
        Hero(
          transitionOnUserGestures: true,
          tag: model[index].eventID,
          child: Image.network(
            model[index].eventImage,
            height: 250,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
          child: Container(
            height: 50,
            child: Row(
              children: getStackImageWidget(context),
            ),
          ),
        )
      ],
    );
  }

  void callbackToAttendEvent() {
    if (isMyEvents || model[index].eventOrganizerDetails.userUID == myUID) {
      showMsg(isMyEvents ? warningMsgOrganizer : warningMsgAlreadyReg);
    } else if (model[index]
        .eventParticipants
        .where((element) => element.userUID == myUID)
        .toList()
        .isNotEmpty) {
      showMsg(isMyEvents ? warningMsgOrganizer : warningMsgAlreadyReg);
    } else {
      attendEventCallback.call(model[index].eventID);
    }
  }

  List<Widget> getStackImageWidget(BuildContext context) {
    return <Widget>[
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(model[index].eventName, style: Theme.of(context).textTheme.subtitle2),
          Text(
              'on ${DateFormat.yMMMEd().format(DateTime.parse(model[index].eventDateTime))}',
              style: Theme.of(context).textTheme.caption)
        ],
      ),
      const Spacer(
        flex: 4,
      ),
      FlatButton(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        color: primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        onPressed: () async {
          await Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => EventDetails(
                    model: model[index],
                    isHeAttendingEvent: !(isMyEvents ||
                        model[index]
                            .eventParticipants
                            .where((element) => element.userUID == myUID)
                            .toList()
                            .isNotEmpty),
                  )));
          reloadRequired();
        },
        child: Row(
          children: <Widget>[
            Text(
              'View Event',
              style: Theme.of(context)
                  .textTheme
                  .button
                  .apply(color: Colors.white, fontSizeDelta: -2),
            ),
            const SizedBox(
              width: 5,
            ),
            Icon(
              Icons.keyboard_tab,
              color: Colors.white,
              size: 14,
            )
          ],
        ),
      )
    ];
  }
}

const warningMsgAlreadyReg = "You have already registered to this event!";
const warningMsgOrganizer = "You are the organizer for this event";

