import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:frontend/components/showMessage.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/locator.dart';
import 'package:frontend/screens/home.dart';
import 'package:frontend/screens/ticktacktoe.dart';
import 'package:frontend/screens/waiting_room.dart';
import 'package:frontend/services/navigation_service.dart';


class SocketProvider extends ChangeNotifier {
  Socket? socket;
  dynamic _serverResponse;
  bool socketConnected = false;
  int socketReconnectAttempts = 0;

  BuildContext? _context;

  dynamic get serverResponse => _serverResponse;

  List<String> board = ["", "", "", "", "", "", "", "", ""];

  String? myToken = "T";
  String? boardToken = "T";
  bool? imTapped = false;

  void move(int index, bool imTapped) {
    board[index] = boardToken!;
    this.imTapped = imTapped;
    
    print(board);
    notifyListeners();
  }

  SocketProvider() {
    connect();
  }

  setContext(BuildContext context) {
    _context = context;
    notifyListeners();
  }

  Future<void> onDone() async {
    var delay = 1 + 1 * socketReconnectAttempts;
    if (delay > 10) {
      delay = 10;
    }
    print(
        "Done, reconnecting in $delay seconds, attempt $socketReconnectAttempts ");
    socketConnected = false;
    socket = null;
    await Future.delayed(Duration(seconds: delay));
    connect();
  }

  Future<void> onError(error) async {
    print(error);
    await Future.delayed(const Duration(seconds: 5));
    connect();
  }

  Future<void> connect() async {
    try {
      socket = await Socket.connect(HOST, PORT);
      socket!.listen((Uint8List data) {
        socketConnected = true;
        socketReconnectAttempts = 0;
        _serverResponse = jsonDecode(String.fromCharCodes(data));

        print(_serverResponse);

        final NavigationService navigationService =
            locator<NavigationService>();

        if (_serverResponse["task"] == "load") {
          if (_serverResponse["response"]["code"] == 200) {
            navigationService.navigateToAndRemove(HomeScreen.routeName);
          } else {
            showErrorMessage(_context!, _serverResponse["response"]["body"]);
          }
        } else if (_serverResponse["task"] == "new") {
          if (_serverResponse["response"]["code"] == 200) {
            navigationService.navigateToAndRemove(HomeScreen.routeName);
          } else {
            showErrorMessage(_context!, _serverResponse["response"]["body"]);
          }
        } else if (_serverResponse["task"] == "wait") {
          if (_serverResponse["response"]["code"] == 200) {
            navigationService.navigateToAndRemove(WaitingRoomScreen.routeName);
          } else {
            showErrorMessage(_context!, _serverResponse["response"]["body"]);
          }
        } else if (_serverResponse["task"] == "start") {
          if (_serverResponse["response"]["code"] == 200) {
            myToken = _serverResponse["response"]["body"]["player_token"];
            imTapped = _serverResponse["response"]["body"]["im_tapped"];
            notifyListeners();
            navigationService.navigateToAndRemove(TickTackToeScreen.routeName);
          } else {
            showErrorMessage(_context!, _serverResponse["response"]["body"]);
          }
        } else if (_serverResponse["task"] == "game") {
          if (_serverResponse["response"]["code"] == 200) {
            var body = _serverResponse["response"]["body"];
            boardToken = body["board_token"];
            notifyListeners();
            move(body["position"], body["im_tapped"]);
          } else {
            showErrorMessage(_context!, _serverResponse["response"]["body"]);
          }
        } else if (_serverResponse["task"] == "end") {
          //if (_serverResponse["response"]["code"] == 200) {



          navigationService.navigateToAndRemove(HomeScreen.routeName);
          //} else {
          //  showErrorMessage(_context!, _serverResponse["response"]["body"]);
          //}
        }
      }, onError: onError, onDone: onDone);
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }

  Future<void> write(String request) async {
    socket?.write(request);
  }
}
