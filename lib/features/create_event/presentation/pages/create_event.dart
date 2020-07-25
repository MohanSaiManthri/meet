import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meet/core/extensions/navigations.dart';
import 'package:meet/core/utils/constants.dart';
import 'package:meet/core/utils/general_dialog.dart';
import 'package:meet/dependecy_injection.dart';
import 'package:meet/features/create_event/domain/entities/create_event_entity.dart';
import 'package:meet/features/create_event/presentation/bloc/create_event_bloc.dart';
import 'package:meet/features/create_event/presentation/widgets/create_event.dart';
import 'package:meet/features/create_event/presentation/widgets/loader.dart';
import 'package:meet/features/create_event/presentation/widgets/text_fields.dart';
import 'package:meet/features/register/data/models/user_model.dart';
import 'package:random_string/random_string.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateEvent extends StatefulWidget {
  const CreateEvent({Key key}) : super(key: key);

  @override
  _CreateEventState createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  @override
  void initState() {
    super.initState();
    final String encodedData = _sharedPreferences.getString(keyUserInfo);
    final Map<String, dynamic> mappedData =
        json.decode(encodedData) as Map<String, dynamic>;
    userModel = UserModel.fromJson(mappedData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: BlocProvider(
        create: (context) => createEventBloc,
        child: BlocConsumer<CreateEventBloc, CreateEventState>(
          listener: (context, state) => buildHelper(context, state),
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                title: Text(
                  'Create Event',
                  style: Theme.of(context).textTheme.headline6.apply(color: Colors.white),
                ),
              ),
              body: buildForm(context),
            );
          },
        ),
      ),
    );
  }

  Form buildForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        children: <Widget>[
          buildSizedBox(),
          buildImagePlaceholder(context),
          GetFields(
            nameController: _nameController,
            dateController: _dateController,
            descriptionController: _descriptionController,
            submitCalled: _createEvent,
          ),
          buildButton(context, isEnabled: true, callback: _createEvent),
        ],
      ),
    );
  }

  void _createEvent() {
    if (_formKey.currentState.validate()) {
      createEventBloc.add(CreateEventAndStoreItToFirestore(
          createEventEntity: CreateEventEntity(
        eventID: randomAlphaNumeric(10),
        eventName: _nameController.text.trim(),
        eventDescription: _descriptionController.text.trim(),
        eventDateTime: _dateController.text.trim(),
        eventOrganizerDetails: userModel.toJson(),
        eventCreatedAt: DateTime.now().toIso8601String(),
        eventImage: path,
        eventParticipants: const [<String, dynamic>{}],
      )));
    }
  }

  Widget buildImagePlaceholder(BuildContext context) {
    return Center(
      child: Container(
        height: deviceHeight * 0.3,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: path == null ? Colors.grey[200] : null),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () => buildShowCupertinoModalPopup(context),
            child: Container(
              width: deviceWidth * 0.9,
              height: deviceHeight * 0.3,
              child: path == null
                  ? Icon(
                      Icons.add_photo_alternate,
                      size: 36,
                      color: Colors.grey,
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        File(path),
                        fit: BoxFit.cover,
                      )),
            ),
          ),
        ),
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

  void buildHelper(BuildContext context, CreateEventState state) {
    if (state is CreatingEvent) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
        if (!Loader.isShowing()) {
          Loader.show();
        }
      });
    } else if (state is EventCreated) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
        if (Loader.isShowing()) {
          Loader.dismiss();
        }
        mShowGeneralDialog(context,
            content: "Event Created Successfully", callback: () => pop());
      });
    } else if (state is FailedToCreateEvent) {
      Future.delayed(const Duration(seconds: 1), () {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
          if (Loader.isShowing()) {
            Loader.dismiss();
          }
          showErrorSnack(
            context,
            message: state.errorMsg,
          );
        });
      });
    }
  }

  SizedBox buildSizedBox() {
    return const SizedBox(
      height: 20,
    );
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  final ImagePicker imagePicker = ImagePicker();

  String path;
  final CreateEventBloc createEventBloc = sl<CreateEventBloc>();

  final SharedPreferences _sharedPreferences = sl<SharedPreferences>();

  UserModel userModel;
}