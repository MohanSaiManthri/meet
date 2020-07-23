import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meet/application.dart';

void push(Widget route) => Navigator.push(navigatorKey.currentState.overlay.context,
        MaterialPageRoute(builder: (context) {
      return route;
    }));

void pop() => Navigator.pop(navigatorKey.currentState.overlay.context);

void pushReplacement(Widget route) =>
    Navigator.pushReplacement(navigatorKey.currentState.overlay.context,
        MaterialPageRoute(builder: (context) {
      return route;
    }));

void pushAndRemoveUntil(Widget route, {bool condition = false}) =>
    Navigator.pushAndRemoveUntil(navigatorKey.currentState.overlay.context,
        MaterialPageRoute(builder: (context) {
      return route;
    }), (route) => condition);

void pushIOS(Widget route) => Navigator.push(navigatorKey.currentState.overlay.context,
        CupertinoPageRoute(builder: (context) {
      return route;
    }));

void pushIOSReplacement(Widget route) =>
    Navigator.pushReplacement(navigatorKey.currentState.overlay.context,
        CupertinoPageRoute(builder: (context) {
      return route;
    }));
