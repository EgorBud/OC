import 'package:flutter/material.dart';
import 'package:frontend/screens/chat.dart';
import 'package:frontend/screens/create_room.dart';
import 'package:frontend/screens/enter_the_room.dart';
import 'package:frontend/screens/home.dart';
import 'package:frontend/screens/random_game.dart';
import 'package:frontend/screens/register.dart';
import 'package:frontend/screens/sign_in.dart';
import 'package:frontend/screens/ticktacktoe.dart';
import 'package:frontend/screens/waiting_room.dart';

final Map<String, WidgetBuilder> routes = {
  SignInScreen.routeName: (context) => const SignInScreen(),
  RegisterScreen.routeName: (context) => const RegisterScreen(),
  HomeScreen.routeName: (context) => HomeScreen(),
  WaitingRoomScreen.routeName: (context) => const WaitingRoomScreen(),
  CreateRoomScreen.routeName: (context) => CreateRoomScreen(),
  EnterTheRoomScreen.routeName: (context) => EnterTheRoomScreen(),
  RandomGameScreen.routeName: (context) => RandomGameScreen(),
  TickTackToeScreen.routeName: (context) => TickTackToeScreen(),
  ChatScreen.routeName: (context) => const ChatScreen(),
};