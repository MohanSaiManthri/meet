import 'package:flutter/material.dart';
import 'package:meet/core/extensions/navigations.dart';
import 'package:meet/core/utils/constants.dart';
import 'package:meet/features/register/presentation/pages/register.dart';

Widget footer(BuildContext context) {
  return InkWell(
    onTap: () => pop(),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Center(
        child: RichText(
            text: TextSpan(
                style: Theme.of(context)
                    .textTheme
                    .bodyText2
                    .apply(color: const Color(0xff8B959A)),
                children: [
              const TextSpan(text: alreadyHaveAccount),
              TextSpan(
                  text: loginHere,
                  style:
                      Theme.of(context).textTheme.bodyText2.apply(color: primaryColor)),
            ])),
      ),
    ),
  );
}
