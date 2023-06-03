import 'package:flutter/material.dart';

import 'components/body.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  static String routeName = "/register";

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
