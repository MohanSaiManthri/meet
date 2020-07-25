import 'package:flutter/material.dart';
import 'package:meet/features/create_event/presentation/widgets/text_field_base.dart';

Padding buildField(BuildContext context, String hint, String label,
    {bool isPasswordShown = false,
    Function suffixCallback,
    TextEditingController textEditingController,
    FocusNode nextFocusNode,
    FocusNode focusNode,
    Function onTap,
    Function onSubmit}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            label,
            style: Theme.of(context).textTheme.caption,
          ),
        ),
        getTextField(hint,
            isPasswordShown: isPasswordShown,
            focusNode: focusNode,
            nextFocusNode: nextFocusNode,
            onSubmit: onSubmit,
            onTap: onTap,
            suffixCallback: suffixCallback,
            textEditingController: textEditingController)
      ],
    ),
  );
}
