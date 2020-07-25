import 'package:flutter/material.dart';
import 'package:meet/features/create_event/presentation/widgets/date_picker.dart';
import 'package:meet/features/create_event/presentation/widgets/text_field.dart';

class GetFields extends StatefulWidget {
  const GetFields(
      {Key key,
      @required this.nameController,
      @required this.descriptionController,
      @required this.dateController,
      this.submitCalled})
      : super(key: key);

  final TextEditingController descriptionController;
  final TextEditingController nameController;
  final TextEditingController dateController;
  final Function submitCalled;

  @override
  _GetFieldsState createState() => _GetFieldsState();
}

class _GetFieldsState extends State<GetFields> {
  bool isPasswordShown = true;

  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _descriptionFocusNode = FocusNode();
  final FocusNode _dateFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        buildField(context, eventNameHint, eventNameLabel,
            textEditingController: widget.nameController,
            focusNode: _nameFocusNode,
            nextFocusNode: _descriptionFocusNode,
            onSubmit: () {}),
        buildField(context, eventDescriptionHint, eventDescriptionLabel,
            textEditingController: widget.descriptionController,
            focusNode: _descriptionFocusNode,
            nextFocusNode: FocusNode(),
            onSubmit: _openDatePicker),
        buildField(
          context,
          eventDateHint,
          eventDateLabel,
          textEditingController: widget.dateController,
          focusNode: _dateFocusNode,
          onSubmit: () {},
          onTap: _openDatePicker,
        ),
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
    _dateFocusNode.unfocus();
    FocusScope.of(context).requestFocus(FocusNode());
    return openDatePicker(context, (String val) {
      setState(() {
        widget.dateController.text = val;
      });
    });
  }
}

const String eventNameHint = "Enter Event Name";
const String eventNameLabel = "Event Name";
const String eventDescriptionHint = "Enter Event Description";
const String eventDescriptionLabel = "Event Description";
const String eventDateHint = "Enter Event Date";
const String eventDateLabel = "Pick Date";
