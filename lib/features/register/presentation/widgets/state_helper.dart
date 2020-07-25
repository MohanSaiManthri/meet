import 'package:flutter/material.dart';
import 'package:meet/core/extensions/navigations.dart';
import 'package:meet/features/events/presentation/pages/events_list.dart';
import 'package:meet/features/register/presentation/bloc/register_bloc.dart';
import 'package:meet/features/register/presentation/widgets/loader.dart';

void stateHelper(RegisterState state, BuildContext context, ScaffoldState _scaffoldKey) {
  if (state is Registering) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (!Loader.isShowing()) {
        Loader.show();
      }
    });
  } else if (state is RegistrationSuccessful) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (Loader.isShowing()) {
        Loader.dismiss();
      }
      pushAndRemoveUntil(const EventsList());
    });
  } else if (state is RegistrationFailed) {
    Future.delayed(const Duration(seconds: 1), () {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
        if (Loader.isShowing()) {
          Loader.dismiss();
        }
        showErrorSnack(
          context,
          _scaffoldKey,
          message: state.message,
        );
      });
    });
  }
}

void showErrorSnack(BuildContext context, ScaffoldState _scaffoldKey, {String message}) {
  try {
    final snackbar = SnackBar(
        content: Text(
      message,
      style: Theme.of(context).textTheme.bodyText2.apply(color: Colors.white),
    ));
    _scaffoldKey.showSnackBar(snackbar);
  } catch (_) {}
}
