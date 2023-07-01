import 'package:frontend/locator.dart';
import 'package:frontend/screens/scisors.dart';
import 'package:frontend/services/navigation_service.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import 'package:frontend/routes.dart';
import 'package:frontend/screens/sign_in.dart';

import 'providers/key_provider.dart';
import 'providers/login_and_register_provider.dart';
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
        ChangeNotifierProvider(create: (context) => LoginAndRegisterProvider()),
        ChangeNotifierProvider(create: (context) => KeyProvider()),
        ChangeNotifierProvider(create: (context) => SocketProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Ultra Games",
        initialRoute: SignInScreen.routeName,
        routes: routes,
        navigatorKey: locator<NavigationService>().navigatorKey,
      ),
    );
  }
}
