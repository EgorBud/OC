import 'package:flutter/material.dart';
import 'package:frontend/routes.dart';
import 'package:frontend/screens/sign_in/sign_in.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Flutter Demo",
      initialRoute: SignInScreen.routeName,
      routes: routes,
    );
  }
}
