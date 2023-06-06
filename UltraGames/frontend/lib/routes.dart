import 'package:flutter/material.dart';
import 'package:frontend/screens/home/home.dart';
import 'package:frontend/screens/register/register.dart';
import 'package:frontend/screens/sign_in/sign_in.dart';
import 'package:frontend/screens/ticktacktoe/ticktacktoe.dart';

final Map<String, WidgetBuilder> routes = {
  SignInScreen.routeName: (context) => const SignInScreen(),
  RegisterScreen.routeName: (context) => const RegisterScreen(),
  HomeScreen.routeName: (context) => const HomeScreen(),
  TickTackToeScreen.routeName: (context) => const TickTackToeScreen(),
};