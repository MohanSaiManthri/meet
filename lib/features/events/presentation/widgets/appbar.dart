import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meet/boarding/splash.dart';
import 'package:meet/core/extensions/navigations.dart';
import 'package:meet/core/utils/constants.dart';
import 'package:meet/core/utils/global_firebase_auth_instance.dart';
import 'package:meet/dependecy_injection.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Appbar extends StatefulWidget {
  final Function() refreshCallback;
  const Appbar({Key key, @required this.refreshCallback}) : super(key: key);

  @override
  _AppbarState createState() => _AppbarState();
}

class _AppbarState extends State<Appbar> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        brightness: Brightness.light,
        titleSpacing: 0,
        title: Text(
          'Events',
          style: Theme.of(context).textTheme.headline6.apply(color: primaryColor),
        ),
        leading: IconButton(
            icon: Image.asset(
              'assets/freezer.png',
              scale: 2,
              width: 24,
              height: 24,
              color: primaryColor,
            ),
            onPressed: () {}),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.refresh,
                color: const Color(0xff20242C).withOpacity(0.7),
              ),
              onPressed: widget.refreshCallback),
          IconButton(
              icon: Icon(
                Icons.power_settings_new,
                color: const Color(0xff20242C).withOpacity(0.7),
              ),
              onPressed: () {
                final SharedPreferences _sharedPrefs = sl<SharedPreferences>();
                _sharedPrefs.remove(keyDoesUserLoggedIn);
                _sharedPrefs.remove(keyUserInfo);
                (GlobalFirebaseAuthInstnace.firebaseAuth ??= FirebaseAuth.instance)
                    .signOut();
                pushAndRemoveUntil(const Splash());
              })
        ],
      ),
    );
  }
}
