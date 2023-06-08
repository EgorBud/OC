import 'package:frontend/locator.dart';
import 'package:frontend/models/message.dart';
import 'package:frontend/screens/home.dart';
import 'package:frontend/screens/ticktacktoe.dart';
import 'package:frontend/services/navigation_service.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import 'package:frontend/routes.dart';
import 'package:frontend/screens/sign_in.dart';

import 'providers/key_provider.dart';
import 'providers/login_provider.dart';
import 'providers/register_provider.dart';
import 'providers/socket_provider.dart';

void main() {
  setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => LoginProvider()),
        ChangeNotifierProvider(create: (context) => RegisterProvider()),
        ChangeNotifierProvider(create: (context) => KeyProvider()),
        ChangeNotifierProvider(create: (context) => SocketProvider()),
        ChangeNotifierProvider(create: (context) => ChatProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Flutter Demo",
        initialRoute: TickTackToeScreen.routeName,
        routes: routes,
        navigatorKey: locator<NavigationService>().navigatorKey,
      ),
    );
  }
}

class ChatProvider extends ChangeNotifier {
  final List<Message> _messages = [];

  List<Message> get messages => _messages;

  void addMessage(Message message) {
    _messages.add(message);
    notifyListeners();
  }
}