import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/components/showMessage.dart';
import 'package:frontend/providers/socket_provider.dart';
import 'package:provider/provider.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  static const String playerX = "X";
  static const String playerO = "O";

  String currentPlayer = playerX;
  List<String> occupied = ["", "", "", "", "", "", "", "", "",];

  @override
  Widget build(BuildContext context) {
      return SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _headerText(),
                _gameContainer(),
                //_restartButton(),
              ],
            ),
          )
      );
  }

  Widget _headerText() {
    return Text(
      "Ходит $currentPlayer",
      style: const TextStyle(
        color: Colors.black87,
        fontSize: 32,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _gameContainer() {
    return Container(
      height: MediaQuery.of(context).size.height / 2,
      width: MediaQuery.of(context).size.height / 2,
      margin: const EdgeInsets.all(8),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        itemCount: 9,
        itemBuilder: (context, int index) {
          return _box(index);
        }
      ),
    );
  }

  Widget _box(int index) {
    final socketRead = context.read<SocketProvider>();

    return InkWell(
      onTap: () {
        if (occupied[index].isNotEmpty) {
          showWarningMessage(context, "Клетка не пуста");
          return;
        }

        dynamic message = {
          "task" : "",
          "request": {
            "move" : index,
          }
        };

        socketRead.write(jsonEncode(message));
      },
      child: Container(
        color: occupied[index].isEmpty
          ? Colors.black26
          : occupied[index] == playerX
            ? Colors.blue
            : Colors.orange,
        margin: const EdgeInsets.all(8),
        child: Center(
          child: Text(
            occupied[index],
            style: const TextStyle(fontSize: 50),
          ),
        ),
      ),
    );
  }
}