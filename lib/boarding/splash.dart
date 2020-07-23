import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meet/core/extensions/navigations.dart';
import 'package:meet/core/utils/constants.dart';
import 'package:meet/features/login/presentation/pages/login.dart';

class Splash extends StatelessWidget {
  const Splash({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    prepareForLaunch();
    return AnnotatedRegion(
      // This changes the status bar to light icon as our background is dark.
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: Container(color: primaryColor, child: centeredChild(context)),
      ),
    );
  }
}

Widget centeredChild(BuildContext context) {
  return Center(
    child: Text('meet*',
        style: GoogleFonts.poppins(
            color: Colors.white, fontSize: 48, fontWeight: FontWeight.w500)),
  );
}

void prepareForLaunch() {
  Future.delayed(const Duration(seconds: 2), () {
    pushReplacement(Login());
  });
}
