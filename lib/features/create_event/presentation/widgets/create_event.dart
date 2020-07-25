import 'package:flutter/material.dart';
import 'package:meet/core/utils/constants.dart';

Widget buildButton(BuildContext context, {bool isEnabled = false, Function callback}) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(26, 16, 26, 26),
    child: Container(
      width: double.maxFinite,
      height: 50,
      child: RaisedButton(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        color: primaryColor,
        onPressed: isEnabled ? () => callback.call() : null,
        child: Text(
          createEvent.toUpperCase(),
          style: Theme.of(context).textTheme.button.apply(color: Colors.white),
        ),
      ),
    ),
  );
}

const createEvent = "Create Event";
