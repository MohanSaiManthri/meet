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
        textInputAction:
            label == passwordConst ? TextInputAction.done : TextInputAction.next,
        onFieldSubmitted: (value) => fieldSubmitted(focusNode, nextFocusNode, onSubmit),
        // Validate based on the label
        validator: (value) => label == dobConst
            ? validateDob(value)
            : label == passwordConst
                ? validatePassword(value)
                : label == emailConst ? validateEmail(value) : validateUserName(value),
        obscureText: isPasswordShown,
        // * Styling
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.only(left: 20),
            border: const OutlineInputBorder(),
            hintText: label,
            hintStyle: GoogleFonts.poppins(fontSize: 14),
            suffixIcon: label == passwordConst
                ? IconButton(
                    icon: Icon(
                      isPasswordShown ? Icons.visibility : Icons.visibility_off,
                      color: Colors.grey,
                    ),
                    onPressed: () => suffixCallback.call())
                : null));

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
  return value != null && value.isNotEmpty ? null : usernameErrorMsg;
}

String validateEmail(String value) {
  return isEmailCompliant(value) ? null : emailErrorMsg;
}

String validatePassword(String value) {
  return isPasswordCompliant(value) ? null : passwordErrorMsg;
}


String validateDob(String value) {
  return value != null  && value.isNotEmpty ? null : dobErrorMsg;
}

bool isEmailCompliant(String email) {
  const String pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  final RegExp regex = RegExp(pattern);
  return regex.hasMatch(email);
}

bool isPasswordCompliant(String password, [int minLength = 6]) {
  if (password == null || password.isEmpty) {
    return false;
  }

  // ignore: unnecessary_raw_strings
  final bool hasUppercase = password.contains(RegExp(r'[A-Z]'));
  // ignore: unnecessary_raw_strings
  //final bool hasDigits = password.contains(RegExp(r'[0-9]'));
  // ignore: unnecessary_raw_strings
  //final bool hasLowercase = password.contains(RegExp(r'[a-z]'));
  final bool hasSpecialCharacters = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
  final bool hasMinLength = password.length > minLength;

  //return hasDigits & hasUppercase & hasLowercase & hasSpecialCharacters & hasMinLength;
  return hasUppercase & hasSpecialCharacters & hasMinLength;
}

const passwordConst = 'Enter your password';
const emailConst = 'Enter your email';
const dobConst = 'Enter your DOB';
const usernameErrorMsg = "Please enter your Username";
const emailErrorMsg = "Please enter valid Email address";
const dobErrorMsg = "Please enter valid Date of Birth";
const passwordErrorMsg = "Required atleast 8 chars, 1 uppercase & 1 special char";
