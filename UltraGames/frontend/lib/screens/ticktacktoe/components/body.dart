import 'package:flutter/material.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  static const String playerX = "X";
  static const String playerO = "O";

  String currentPlayer = playerX;
  bool gameEnd = false;
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
                _restartButton(),
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
    return InkWell(
      onTap: () {
        if (gameEnd || occupied[index].isNotEmpty) {
          return;
        }
        setState(() {
          occupied[index] = currentPlayer;
          changeTurn();
          checkForWinner();
          checkForDraw();
        });
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

  Widget _restartButton() {
    return TextButton(
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.blueAccent,
      ),
      onPressed: () {
        setState(() {
          gameEnd = false;
          occupied = ["", "", "", "", "", "", "", "", "",];
        });
      },
      child: const Text(
        "Начать заново",
        style: TextStyle(
          fontSize: 20,
          color: Colors.white
        ),
      )
    );
  }

  void changeTurn() {
    if (currentPlayer == playerX) {
      currentPlayer = playerO;
    } else {
      currentPlayer = playerX;
    }
  }

  void checkForWinner() {
    List<List<int>> winningList = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];

    for (var winningPos in winningList) {
      if (occupied[winningPos[0]].isNotEmpty) {
        if (occupied[winningPos[0]] == occupied[winningPos[1]] &&
            occupied[winningPos[0]] == occupied[winningPos[2]]) {
          showGameOverMessage("Игрок ${occupied[winningPos[0]]} победил");
          gameEnd = true;
          return;
        }
      }
    }
  }

  void checkForDraw() {
    if (gameEnd) {
      return;
    }

    bool draw = true;
    for (var occupiedPlayer in occupied) {
      if (occupiedPlayer.isEmpty) {
        draw = false;
      }
    }

    if (draw) {
      showGameOverMessage("Ничья");
      gameEnd = true;
    }
  }

  void showGameOverMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        content: Text(
          "Игра окончена \n $message",
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}