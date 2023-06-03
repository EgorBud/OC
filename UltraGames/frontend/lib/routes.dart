import 'package:flutter/material.dart';
import 'package:frontend/screens/home/home.dart';
import 'package:frontend/screens/register/register.dart';
import 'package:frontend/screens/sign_in/sign_in.dart';
import 'package:frontend/screens/ticktacktoe/ticktacktoe.dart';

final Map<String, WidgetBuilder> routes = {
  SignInScreen.routeName: (context) => SignInScreen(),
  RegisterScreen.routeName: (context) => RegisterScreen(),
  HomeScreen.routeName: (context) => HomeScreen(),
  TickTackToeScreen.routeName: (context) => TickTackToeScreen(),
};