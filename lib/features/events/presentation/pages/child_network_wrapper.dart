import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:meet/core/extensions/navigations.dart';
import 'package:meet/core/utils/global_network.dart';
import 'package:meet/no_internet.dart';

class ChildNetworkWrapper extends StatelessWidget {
  final Widget child;

  const ChildNetworkWrapper({Key key, @required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OfflineBuilder(
      builder: (context) => child,
      connectivityBuilder: (
        BuildContext context,
        ConnectivityResult connectivity,
        Widget child,
      ) {
        final bool connected = connectivity != ConnectivityResult.none;
        GLobalNetowrk.isShown ??= false;
        if (connected) {
          if (GLobalNetowrk.isShown) {
            GLobalNetowrk.isShown = false;
            pop();
          }
        } else {
          if (!GLobalNetowrk.isShown) {
            GLobalNetowrk.isShown = true;
            push(NoInternet());
          }
        }
        return child;
      },
    );
  }
}
