import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meet/core/utils/constants.dart';

Widget meet() {
  return ConstrainedBox(
    constraints:
        BoxConstraints(maxHeight: deviceHeight * 0.25, minHeight: deviceHeight * 0.05),
    child: Center(
      child: Text(
        'meet*',
        style: GoogleFonts.poppins(
            color: primaryColor, fontSize: 28, fontWeight: FontWeight.w500),
      ),
    ),
  );
}

Widget getLoginStarted(BuildContext context) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.fromLTRB(30, 0, 30, 10),
      child: Text(
        'Login in to your account',
        style: Theme.of(context).textTheme.headline6.apply(color: greyColor),
      ),
    ),
  );
}

Widget loginInfoForEmail(BuildContext context) {
  return Center(
    child: Text(
      loginUsingEmail,
      style: Theme.of(context).textTheme.bodyText2.apply(color: const Color(0xff8B959A)),
    ),
  );
}

const String loginUsingEmail = 'using Email and Password';
