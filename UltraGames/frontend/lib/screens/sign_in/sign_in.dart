import 'package:flutter/material.dart';

import 'components/body.dart';

import 'package:frontend/globals.dart' as globals;

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  static String routeName = "/sign_in";

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: const Scaffold(body: Body()),
    );
  }
}
