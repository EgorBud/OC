import 'dart:async';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart';

import 'package:flutter/material.dart';
import 'package:frontend/routes.dart';
import 'package:frontend/screens/sign_in/sign_in.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => User()),
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

class User extends ChangeNotifier {
  String? login;
  String? password;
  String? retryPassword;
  String? nickname;

  String _errorLogin = "";
  String _errorPassword = "";
  String _errorRetryPassword = "";
  String _errorNickname = "";

  String get errorLogin => _errorLogin;
  String get errorPassword => _errorPassword;

  void setLogin(String login) {
    this.login = login;
    notifyListeners();
  }

  void setLoginError(String login) {
    _errorLogin = login;
    notifyListeners();
  }

  void setPassword(String password) {
    this.password = password;
    notifyListeners();
  }

  void setPasswordError(String password) {
    _errorPassword = password;
    notifyListeners();
  }

  void setRetryPassword(String retryPassword) {
    this.retryPassword = retryPassword;
    notifyListeners();
  }

  void setNickname(String nickname) {
    this.nickname = nickname;
    notifyListeners();
  }
}
