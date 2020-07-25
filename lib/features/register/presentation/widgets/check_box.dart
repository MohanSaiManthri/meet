import 'package:flutter/material.dart';
import 'package:circular_check_box/circular_check_box.dart';

Widget getCheckBox(
  BuildContext context,
  Function onTap,
  Function(bool v) onChange, {
  bool checkboxCheck = false,
}) {
  return GestureDetector(
    onTap: () => onTap(),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 36),
      child: Row(
        children: <Widget>[
          Container(
            height: 20,
            width: 15,
            child: CircularCheckBox(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              value: checkboxCheck,
              onChanged: onChange,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Text(checkBox, style: Theme.of(context).textTheme.caption)
        ],
      ),
    ),
  );
}

const String checkBox = "I agree to the terms and conditions";
