import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet/dependecy_injection.dart';
import 'package:meet/features/register/presentation/bloc/register_bloc.dart';
import 'package:meet/features/register/presentation/widgets/loader.dart';
import 'package:meet/features/register/presentation/widgets/local_instance_for_register_bloc.dart';

class RegisterUser extends StatefulWidget {
  @override
  _RegisterUserState createState() => _RegisterUserState();
}

class _RegisterUserState extends State<RegisterUser> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void dispose() {
    GetLocalInstanceOfRegisterBloc.registerBloc = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        body: BlocProvider(
          create: (context) =>
              GetLocalInstanceOfRegisterBloc.registerBloc ??= sl<RegisterBloc>(),
          child: BlocBuilder<RegisterBloc, RegisterState>(
            builder: (context, state) {
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
                  //TODO: Fix this
                  // pushAndRemoveUntil(const ConnectWithFriends());
                  showErrorSnack(
                    context,
                    message: "Success",
                  );
                });
              } else if (state is RegistrationFailed) {
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
        ));
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
      child: RaisedButton(
        onPressed: () => GetLocalInstanceOfRegisterBloc.registerBloc.add(
            const RequestFirebaseToHandleRegistration(
                email: 'mohansaimanthri03@gmail.com',
                password: 'Test@123',
                dob: '09/07/97',
                name: 'Mohan Sai Manthri',
                photoUrl:
                    'https://pbs.twimg.com/profile_images/1051433515127070720/5OrVggZg.jpg')),
        child: Text(
          'Register'.toUpperCase(),
          style: Theme.of(context).textTheme.button,
        ),
      ),
    );
  }
}
