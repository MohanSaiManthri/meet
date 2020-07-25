import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:meet/application.dart';
import 'package:meet/boarding/splash.dart';
import 'package:meet/core/extensions/navigations.dart';
import 'package:meet/core/utils/constants.dart';
import 'package:meet/core/utils/global_network.dart';
import 'package:meet/core/utils/styles.dart';
import 'package:meet/dependecy_injection.dart' as di;
import 'package:meet/no_internet.dart';

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
      home: Material(
        child: Scaffold(
            body: OfflineBuilder(
                connectivityBuilder: (
                  BuildContext context,
                  ConnectivityResult connectivity,
                  Widget child,
                ) {
                  final bool connected = connectivity != ConnectivityResult.none;
                  GLobalNetowrk.isShown ??= false;
                  if (connected ?? false) {
                    if (GLobalNetowrk.isShown) {
                      pop();
                    }
                  } else {
                    if (!connected) {
                      if (!GLobalNetowrk.isShown) {
                        push(NoInternet());
                      }
                    }
                  }
                  return const Splash();
                },
                child: const Splash())),
      ),
    );
  }
}

class TestGrid extends StatefulWidget {
  const TestGrid({Key key}) : super(key: key);

  @override
  _TestGridState createState() => _TestGridState();
}

class _TestGridState extends State<TestGrid> {
  final List<Widget> listOfWidgets = [];
  /*24 is for notification bar on Android*/
  final double itemHeight = (deviceHeight - kToolbarHeight - 24) / 2;
  final double itemWidth = deviceWidth / 2;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      listOfWidgets.addAll(List.generate(10, (index) => skeleton()));
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.white,
      ),
      body: listOfWidgets == null || listOfWidgets.isEmpty
          ? const CircularProgressIndicator()
          : GridView.count(
              crossAxisCount: 2,
              childAspectRatio: itemWidth / itemHeight,
              children: listOfWidgets,
            ),
    );
  }

  Widget skeleton() {
    return Container(
      margin: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                profileImage,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text(
              title,
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text(
              price,
              style: Theme.of(context).textTheme.subtitle2,
            ),
          ),
        ],
      ),
    );
  }
}

const String profileImage =
    "https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=634&q=80";
const String title = 'Printed floral Jacket';
const String price = '\$16.99';
