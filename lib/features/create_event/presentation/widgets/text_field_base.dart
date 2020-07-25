import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meet/application.dart';

Widget getTextField(String label,
        {bool isPasswordShown = false,
        Function suffixCallback,
        TextEditingController textEditingController,
        FocusNode nextFocusNode,
        FocusNode focusNode,
        Function onTap,
        Function onSubmit}) =>
    TextFormField(
        onTap: () => onTap != null ? onTap() : () {},
        controller: textEditingController,
        focusNode: focusNode,
        textInputAction: label == dateConst ? TextInputAction.done : TextInputAction.next,
        onFieldSubmitted: (value) => fieldSubmitted(focusNode, nextFocusNode, onSubmit),
        // Validate based on the label
        validator: (value) => label == dateConst
            ? validateDate(value)
            : label == descriptionConst
                ? validateDescrption(value)
                : validateUserName(value),
        obscureText: isPasswordShown,
        // * Styling
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(left: 20),
          border: const OutlineInputBorder(),
          hintText: label,
          hintStyle: GoogleFonts.poppins(fontSize: 14),
        ));

void fieldSubmitted(FocusNode focusNode, FocusNode nextFocusNode, Function onSubmit) {
  focusNode.unfocus();
  if (nextFocusNode != null) {
    FocusScope.of(navigatorKey.currentState.overlay.context).requestFocus(nextFocusNode);
  }
  if (onSubmit != null) {
    onSubmit.call();
  }
}

String validateUserName(String value) {
  return value != null && value.isNotEmpty ? null : nameError;
}

String validateDescrption(String value) {
  return value != null && value.isNotEmpty ? null : descriptionError;
}

String validateDate(String value) {
  return value != null && value.isNotEmpty ? null : dateError;
}

const nameConst = 'Enter Event Name';
const descriptionConst = 'Enter Event Description';
const dateConst = 'Enter Event Date';
const nameError = "Please enter the Event name";
const descriptionError = "Please enter the Event Description";
const dateError = "Please enter pick date";
