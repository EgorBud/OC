import 'package:flutter/material.dart';

class LoginAndRegisterProvider extends ChangeNotifier {
  String? nickname;
  String? login;
  String? password;

  String _errorNickname = "";
  String _errorLogin = "";
  String _errorPassword = "";

  String get errorNickname => _errorNickname;
  String get errorLogin => _errorLogin;
  String get errorPassword => _errorPassword;

  void setNickname(String nickname) {
    this.nickname = nickname;
    notifyListeners();
  }

  void setNicknameError(String nickname) {
    _errorNickname = nickname;
    notifyListeners();
  }

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