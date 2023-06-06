import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import 'package:frontend/routes.dart';
import 'package:frontend/screens/sign_in/sign_in.dart';

import 'providers/loginProvider.dart';
import 'providers/registerProvider.dart';
import 'providers/socketProvider.dart';

void main() {
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
        ChangeNotifierProvider(create: (context) => SocketProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Flutter Demo",
        initialRoute: SignInScreen.routeName,
        routes: routes,
      ),
    );
  }
}