import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meet/core/extensions/navigations.dart';
import 'package:meet/core/utils/constants.dart';

DateTime _dateTime;

/// Shows Cupertino Date picker to user and returns the Date in String
///
/// Date format would be [yyyy-MM-dd]
///
///
void openDatePicker(BuildContext context, Function(String) _date) {
  // This makes sure to clear the date time every time it opens
  // Because if user presses _dateTime without selecting anything which means he is pointing towards the current date.
  _dateTime = null;
  showCupertinoModalPopup(
    context: context,
    builder: (context) => Container(
      height: 300,
      padding: const EdgeInsets.only(bottom: 10),
      decoration: boxDecoration(),
      child: Column(
        children: <Widget>[
          bannerDetial(),
          Align(
            alignment: Alignment.centerRight,
            child: FlatButton(
                onPressed: () {
                  pop();
                  _date
                      .call(DateFormat('yyyy-MM-dd').format(_dateTime ?? DateTime.now()));
                },
                child: Text(
                  'Done',
                  style: Theme.of(context).textTheme.bodyText2.apply(color: primaryColor),
                )),
          ),
          Expanded(
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              initialDateTime: DateTime.now().subtract(const Duration(days: 365 * 18)),
              maximumDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
              onDateTimeChanged: (value) {
                _date(DateFormat('yyyy-MM-dd').format(value));
                _dateTime = value;
              },
            ),
          ),
        ],
      ),
    ),
  );
}

Container bannerDetial() {
  return Container(
    height: 10,
    color: primaryColor,
  );
}

BoxDecoration boxDecoration() {
  return BoxDecoration(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(16),
        topRight: Radius.circular(16),
        bottomLeft: Radius.circular(32),
        bottomRight: Radius.circular(32),
      ),
      color: Colors.white);
}
