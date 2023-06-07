import 'package:flutter/material.dart';

class LoginProvider extends ChangeNotifier {
  String? login;
  String? password;

  String _errorLogin = "";
  String _errorPassword = "";

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
}