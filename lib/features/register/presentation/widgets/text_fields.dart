import 'package:flutter/material.dart';
import 'package:meet/features/register/presentation/widgets/date_picker.dart';
import 'package:meet/features/register/presentation/widgets/text_field.dart';

class GetFields extends StatefulWidget {
  const GetFields(
      {Key key,
      @required this.nameController,
      @required this.dobController,
      @required this.emailController,
      @required this.passwordController,
      this.submitCalled})
      : super(key: key);

  final TextEditingController emailController;
  final TextEditingController nameController;
  final TextEditingController dobController;
  final TextEditingController passwordController;
  final Function submitCalled;

  @override
  _GetFieldsState createState() => _GetFieldsState();
}

class _GetFieldsState extends State<GetFields> {
  bool isPasswordShown = true;

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _dabFocusNode = FocusNode();
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        buildField(context, fullNameHint, fullNameLabel,
            textEditingController: widget.nameController,
            focusNode: _nameFocusNode,
            nextFocusNode: _emailFocusNode,
            onSubmit: _openDatePicker),
        buildField(context, dobHint, dobLabel,
            textEditingController: widget.dobController,
            focusNode: _dabFocusNode,
            nextFocusNode: _emailFocusNode,
            onTap: _openDatePicker,
            onSubmit: () {}),
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

  /// * Removes the focus of Date field
  ///
  /// * Requests the focus for location field
  ///
  /// * Shows Cupertino Date picker to user and returns the Date in String
  ///
  /// * Date format would be [yyyy-MM-dd]
  ///
  void _openDatePicker() {
    _dabFocusNode.unfocus();
    FocusScope.of(context).requestFocus(_emailFocusNode);
    return openDatePicker(context, (String val) {
      setState(() {
        widget.dobController.text = val;
      });
    });
  }
}

const String fullNameHint = "Enter Full Name";
const String fullNameLabel = "Full Name";
const String emailHint = "Enter your email";
const String emailLabel = "E-mail ID";
const String dobHint = "Enter your DOB";
const String dobLabel = "Date of Birth";
const String passwordHint = "Enter your password";
const String passwordLabel = "Password";
