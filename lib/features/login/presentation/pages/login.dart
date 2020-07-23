import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet/core/extensions/navigations.dart';
import 'package:meet/dependecy_injection.dart';
import 'package:meet/features/login/presentation/bloc/login_bloc.dart';
import 'package:meet/features/login/presentation/widgets/loader.dart';
import 'package:meet/features/login/presentation/widgets/local_instance_for_login_bloc.dart';
import 'package:meet/features/register/presentation/pages/register.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    GetLocalInstanceOfLoginBloc.loginBloc = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: BlocProvider(
        create: (context) => GetLocalInstanceOfLoginBloc.loginBloc ??= sl<LoginBloc>(),
        child: BlocBuilder<LoginBloc, LoginState>(
          builder: (context, state) {
            if (state is Authenticating) {
              WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
                if (!Loader.isShowing()) {
                  Loader.show();
                }
              });
            } else if (state is AuthenticatedSuccessfully) {
              WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
                if (Loader.isShowing()) {
                  Loader.dismiss();
                }
                //TODO: Fix this
                // pushAndRemoveUntil(const ConnectWithFriends());
                showErrorSnack(
                  context,
                  message: "Success",
                );
              });
            } else if (state is AuthenticationFailed) {
              Future.delayed(const Duration(seconds: 1), () {
                WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
                  if (Loader.isShowing()) {
                    Loader.dismiss();
                  }
                  showErrorSnack(
                    context,
                    message: state.message,
                  );
                });
              });
            }
            return buildCenter(context);
          },
        ),
      ),
    );
  }

  void showErrorSnack(BuildContext context, {String message}) {
    final snackbar = SnackBar(
        content: Text(
      message,
      style: Theme.of(context).textTheme.bodyText2.apply(color: Colors.white),
    ));
    _scaffoldKey.currentState.showSnackBar(snackbar);
  }

  Center buildCenter(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          RaisedButton(
            onPressed: () => GetLocalInstanceOfLoginBloc.loginBloc.add(
                const RequestFirebaseToHandleEmailSignIn(
                    email: 'mohansaimanthri03@gmail.com', password: 'Test@123')),
            child: Text(
              'Login'.toUpperCase(),
              style: Theme.of(context).textTheme.button,
            ),
          ),
          RaisedButton(
            onPressed: () => push(RegisterUser()),
            child: Text(
              'Go to Register'.toUpperCase(),
              style: Theme.of(context).textTheme.button,
            ),
          ),
        ],
      ),
    );
  }
}
