import 'package:flutter/material.dart';
import 'package:meet/application.dart';
import 'package:meet/core/utils/constants.dart';

class Loader {
  Loader._();

  static Widget _alertDialog;
  static bool _isShowing = false;

  /// Returns the Alert Dialog Instance
  /// If Instance is already created then it will return previous instance instead of creating new
  ///
  static Widget _getInstance() {
    // Returns the Alert Dialog.
    return _alertDialog ??= WillPopScope(
      onWillPop: () async => false,
      child: AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        content: Container(
          height: 50,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(
                width: 20,
              ),
              const Center(
                  widthFactor: 0.2,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(primaryColor),
                  )),
              const SizedBox(
                width: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Please wait...',
                  style: Theme.of(navigatorKey.currentState.overlay.context)
                      .textTheme
                      .headline6,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  /// Shows the loader which can't be dismissed [BarrierDismissable] is set to false
  ///
  /// Use [dismiss()] to dismiss the Dialog
  ///
  /// You can also use the [isShowing] parameter to check the whether dialog is showing or dismissed.
  ///
  /// Returns the Alert Dialog Instance
  /// If Instance is already created then it will return previous instance instead of creating new
  ///
  static void show() {
    // Dismiss if any previous dialog if it is showing before showing the new one.
    if (_isShowing) {
      dismiss();
    }
    _isShowing = true;
    showGeneralDialog(
        context: navigatorKey.currentState.overlay.context,
        useRootNavigator: true,
        barrierColor: Colors.black45,
        transitionBuilder: (context, anim1, anim2, _) {
          return Transform.scale(
              scale: anim1.value,
              child: Opacity(opacity: anim1.value, child: _getInstance()));
        },
        barrierDismissible: false,
        transitionDuration: const Duration(milliseconds: 250),
        pageBuilder: (context, animation1, animation2) {
          return null;
        }).then((value) => _isShowing = false);
  }

  static bool isShowing() {
    return _isShowing;
  }

  static void dismiss() {
    if (_isShowing) {
      Navigator.of(navigatorKey.currentState.overlay.context, rootNavigator: true).pop();
      _isShowing = false;
    }
  }
}
