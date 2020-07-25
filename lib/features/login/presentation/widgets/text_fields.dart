import 'package:flutter/material.dart';
import 'package:meet/features/login/presentation/widgets/text_field.dart';

class GetFields extends StatefulWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final Function submitCalled;
  const GetFields(
      {Key key,
      @required this.emailController,
      @required this.passwordController,
      @required this.submitCalled})
      : super(key: key);
  Map<String, String> get getEmailAndPassword => {};
  @override
  _GetFieldsState createState() => _GetFieldsState();
}

class _GetFieldsState extends State<GetFields> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        buildField(context, emailHint, emailLabel,
            textEditingController: widget.emailController,
            focusNode: _emailFocusNode,
            nextFocusNode: _passwordFocusNode,
            onSubmit: () {}),
        buildField(context, passwordHint, passwordLabel,
            textEditingController: widget.passwordController,
            focusNode: _passwordFocusNode,
            isPasswordShown: isPasswordShown,
            suffixCallback: () {
              setState(() {
                isPasswordShown = !isPasswordShown;
              });
            },
            onSubmit: () => widget.submitCalled()),
      ],
    );
  }

  final FocusNode _emailFocusNode = FocusNode();

  final FocusNode _passwordFocusNode = FocusNode();

  bool isPasswordShown = true;
}

const String emailHint = "Enter your email ";
const String emailLabel = "E-mail ID";
const String passwordHint = "Enter your password";
const String passwordLabel = "Password";
