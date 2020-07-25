import 'package:flutter/material.dart';
import 'package:meet/core/extensions/navigations.dart';

void mShowGeneralDialog(BuildContext context,
    {Function callback,
    String title = 'Success',
    String content = 'Account registered succesfully'}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      title: Text(title, style: Theme.of(context).textTheme.headline6),
      content: Text(content, style: Theme.of(context).textTheme.bodyText1),
      actions: <Widget>[
        FlatButton(
            onPressed: () {
              pop();
              if (callback != null) {
                callback.call();
              }
            },
            child: const Text('Okay'))
      ],
    ),
  );
}
