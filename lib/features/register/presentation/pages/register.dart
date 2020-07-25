import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meet/core/extensions/navigations.dart';
import 'package:meet/core/utils/constants.dart';
import 'package:meet/dependecy_injection.dart';
import 'package:meet/features/register/presentation/bloc/register_bloc.dart';
import 'package:meet/features/register/presentation/widgets/check_box.dart';
import 'package:meet/features/register/presentation/widgets/footer.dart';
import 'package:meet/features/register/presentation/widgets/signup_button.dart';
import 'package:meet/features/register/presentation/widgets/state_helper.dart';
import 'package:meet/features/register/presentation/widgets/text_decoration.dart';
import 'package:meet/features/register/presentation/widgets/text_fields.dart';

class RegisterUser extends StatefulWidget {
  @override
  _RegisterUserState createState() => _RegisterUserState();
}

class _RegisterUserState extends State<RegisterUser> {
  @override
  void initState() {
    super.initState();
    registerBloc = sl<RegisterBloc>();
  }

  @override
  void dispose() {
    registerBloc = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
          key: _scaffoldKey,
          body: BlocProvider(
            create: (context) => registerBloc ??= sl<RegisterBloc>(),
            child: BlocConsumer<RegisterBloc, RegisterState>(
              listener: (context, state) =>
                  stateHelper(state, context, _scaffoldKey.currentState),
              builder: (context, state) => buildForm(context),
            ),
          )),
    );
  }

  Form buildForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        children: <Widget>[
          meet(),
          getStarted(context),
          signupInfo(context),
          buildSizedBox(),
          buildImagePlaceholder(context),
          GetFields(
            nameController: _nameController,
            emailController: _emailController,
            passwordController: _passwordController,
            dobController: _dobController,
            submitCalled: () {
              if (isCheckboxChecked) {
                registerUser();
              } else {
                showErrorSnack(context, message: "Please accept terms & conditions!");
              }
            },
          ),
          getCheckBox(context, toggleCheckbox, (bool v) => onChange(value: v),
              checkboxCheck: isCheckboxChecked),
          buildButton(context, isEnabled: isCheckboxChecked, callback: registerUser),
          footer(context)
        ],
      ),
    );
  }

  Widget buildImagePlaceholder(BuildContext context) {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                width: 120,
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: primaryColor,
                  child: CircleAvatar(
                      radius: 48,
                      backgroundColor: Colors.white,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Padding(
                          padding: EdgeInsets.only(top: path == null ? 12.0 : 0),
                          child: path == null
                              ? Image.asset('assets/profile_placeholder.png')
                              : Image.file(
                                  File(path),
                                  fit: BoxFit.cover,
                                  width: 100,
                                  height: 100,
                                ),
                        ),
                      )),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: IconButton(
                    icon: CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.grey[200],
                      child: const Icon(Icons.add, color: primaryColor),
                    ),
                    onPressed: () {
                      buildShowCupertinoModalPopup(context);
                    }),
              )
            ],
          ),
        ],
      ),
    );
  }

  Future<void> buildShowCupertinoModalPopup(BuildContext context) async {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        actions: <Widget>[
          CupertinoActionSheetAction(
              onPressed: () async {
                pop();
                try {
                  path = (await imagePicker.getImage(source: ImageSource.camera)).path;
                  if (mounted) {
                    setState(() {});
                  }
                } catch (_) {}
              },
              child: const Text("Open Camera")),
          CupertinoActionSheetAction(
              onPressed: () async {
                pop();
                try {
                  path = (await imagePicker.getImage(source: ImageSource.gallery)).path;
                  if (mounted) {
                    setState(() {});
                  }
                } catch (_) {}
              },
              child: const Text("Open Gallery")),
        ],
        cancelButton: CupertinoActionSheetAction(
            isDefaultAction: true, onPressed: () => pop(), child: const Text('Cancel')),
      ),
    );
  }

  void showErrorSnack(BuildContext context, {String message}) {
    try {
      final snackbar = SnackBar(
          content: Text(
        message,
        style: Theme.of(context).textTheme.bodyText2.apply(color: Colors.white),
      ));
      _scaffoldKey.currentState.showSnackBar(snackbar);
    } catch (_) {}
  }

  void registerUser() {
    if (_formKey.currentState.validate()) {
      FocusScope.of(context).requestFocus(FocusNode());
      registerBloc.add(RequestFirebaseToHandleRegistration(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
          dob: _dobController.text.trim(),
          name: _nameController.text.trim(),
          photoUrl: path));
    }
  }

  void onChange({bool value}) {
    isCheckboxChecked = value;
    setState(() {});
  }

  void toggleCheckbox() {
    setState(() {
      isCheckboxChecked = !isCheckboxChecked;
    });
  }

  SizedBox buildSizedBox() {
    return const SizedBox(
      height: 40,
    );
  }

  bool isCheckboxChecked = false;
  RegisterBloc registerBloc;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final ImagePicker imagePicker = ImagePicker();

  String path;
}

const String signupUsing = 'Sign up using email and password';
const String alreadyHaveAccount = "Already have an account? ";
const String loginHere = "Login Here";
