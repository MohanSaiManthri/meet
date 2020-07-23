import 'package:flutter/material.dart';
import 'package:meet/application.dart';

//colors
const Color primaryColor = Color(0xff2B44FF);
const Color greyColor = Color(0xff3E4A59);

// Device height & width
double deviceWidth = MediaQuery.of(navigatorKey.currentState.overlay.context).size.width;
double deviceHeight =
    MediaQuery.of(navigatorKey.currentState.overlay.context).size.height;

// Constant Strings
const String keyLoggedInUser = "KEY_LOGGED_IN_USER";
const String keyUserInfo = "KEY_USER_INFO";
