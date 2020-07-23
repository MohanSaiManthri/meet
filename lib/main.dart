import 'package:flutter/material.dart';
import 'package:meet/application.dart';
import 'package:meet/boarding/splash.dart';
import 'package:meet/core/utils/constants.dart';
import 'package:meet/core/utils/styles.dart';
import 'package:meet/dependecy_injection.dart' as di;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColor: primaryColor,
          // TODO: Change this
          accentColor: primaryColor,
          textTheme: materialDesignTypeScale,
          cursorColor: primaryColor),
      navigatorKey: navigatorKey,
      home: const Material(
        child: Splash(),
      ),
    );
  }
}
