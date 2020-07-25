import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet/core/extensions/navigations.dart';
import 'package:meet/core/utils/constants.dart';
import 'package:meet/dependecy_injection.dart';
import 'package:meet/features/events/presentation/pages/child_network_wrapper.dart';
import 'package:meet/features/events/presentation/pages/events_list.dart';
import 'package:meet/features/login/presentation/bloc/login_bloc.dart';
import 'package:meet/features/login/presentation/widgets/loader.dart';
import 'package:meet/features/login/presentation/widgets/login_email_btn.dart';
import 'package:meet/features/login/presentation/widgets/text_decorations.dart';
import 'package:meet/features/login/presentation/widgets/text_fields.dart';
import 'package:meet/features/login/presentation/widgets/footer_email.dart';
import 'package:meet/features/register/presentation/pages/register.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final GlobalKey<FormState> _formKey = GlobalKey();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  LoginBloc loginBloc;

  @override
  void initState() {
    super.initState();
    loginBloc ??= sl<LoginBloc>();
  }

  @override
  void dispose() {
    loginBloc = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: BlocProvider(
        create: (context) => loginBloc,
        child: BlocConsumer<LoginBloc, LoginState>(
            listener: (context, state) {
              stateHelper(state, context);
            },
            builder: (context, state) => buildListView(context)),
      ),
    );
  }

  void stateHelper(LoginState state, BuildContext context) {
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
        final SharedPreferences _sharedPrefs = sl<SharedPreferences>();
        _sharedPrefs.setBool(keyDoesUserLoggedIn, true);
        pushAndRemoveUntil(const ChildNetworkWrapper(child: EventsList()));
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
  }

  void showErrorSnack(BuildContext context, {String message}) {
    final snackbar = SnackBar(
        content: Text(
      message,
      style: Theme.of(context).textTheme.bodyText2.apply(color: Colors.white),
    ));
    _scaffoldKey.currentState.showSnackBar(snackbar);
  }

  Widget buildListView(BuildContext context) {
    return ListView(
      children: <Widget>[
        meet(),
        getLoginStarted(context),
        loginInfoForEmail(context),
        buildSizedBox(),
        //loginInstantly(context),
        Form(
            key: _formKey,
            child: GetFields(
              emailController: _emailController,
              passwordController: _passwordController,
              submitCalled: () => letTheUserLogin(context),
            )),

        buildButton(context, isEnabled: true, callback: () => letTheUserLogin(context)),
        footer(context)
      ],
    );
  }

  void letTheUserLogin(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
    if (_formKey.currentState.validate()) {
      loginBloc.add(RequestFirebaseToHandleEmailSignIn(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim()));
    }
  }

  Center buildCenter(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          RaisedButton(
            onPressed: () => loginBloc.add(const RequestFirebaseToHandleEmailSignIn(
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

  SizedBox buildSizedBox() {
    return const SizedBox(
      height: 40,
    );
  }
}
