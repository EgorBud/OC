import 'package:flutter/material.dart';

class KeyProvider extends ChangeNotifier {
  String? key;
  String _errorKey = "";

  String get errorKey => _errorKey;

  void setKey(String key) {
    this.key = key;
    notifyListeners();
  }

  void setKeyError(String key) {
    _errorKey = key;
    notifyListeners();
  }
}