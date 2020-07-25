import 'package:flutter/material.dart';
import 'package:meet/core/extensions/navigations.dart';
import 'package:meet/core/utils/constants.dart';
import 'package:meet/features/register/presentation/pages/register.dart';

Widget footer(BuildContext context) {
  return InkWell(
    onTap: () => push(RegisterUser()),
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Center(
        child: RichText(
            text: TextSpan(
                style: Theme.of(context)
                    .textTheme
                    .bodyText2
                    .apply(color: const Color(0xff8B959A)),
                children: [
              const TextSpan(text: dontHaveAccount),
              TextSpan(
                  text: registerNow,
                  style:
                      Theme.of(context).textTheme.bodyText2.apply(color: primaryColor)),
            ])),
      ),
    ),
  );
}

const String dontHaveAccount = "Don't have an account? ";
const String registerNow = "Register Now";
