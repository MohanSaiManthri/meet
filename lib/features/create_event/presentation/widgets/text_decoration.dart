import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meet/core/utils/constants.dart';
import 'package:meet/features/register/presentation/pages/register.dart';

Widget signupInfo(BuildContext context) {
  return Center(
    child: Text(
      signupUsing,
      style: Theme.of(context).textTheme.bodyText2.apply(color: const Color(0xff8B959A)),
    ),
  );
}

Widget getStarted(BuildContext context) {
  return Container(
    padding: const EdgeInsets.only(top: 10),
    child: Center(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(30, 0, 30, 10),
        child: Text(
          'Create an account',
          style: Theme.of(context).textTheme.headline6.apply(color: Colors.grey),
        ),
      ),
    ),
  );
}

Widget meet() {
  return Padding(
    padding: const EdgeInsets.only(top: 10),
    child: ConstrainedBox(
      constraints:
          BoxConstraints(maxHeight: deviceHeight * 0.10, minHeight: deviceHeight * 0.05),
      child: Center(
        child: Text(
          'meet*',
          style: GoogleFonts.poppins(
              color: primaryColor, fontSize: 28, fontWeight: FontWeight.w500),
        ),
      ),
    ),
  );
}
