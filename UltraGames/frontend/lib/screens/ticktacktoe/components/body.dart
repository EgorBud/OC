import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/components/showMessage.dart';
import 'package:frontend/main.dart';
import 'package:frontend/providers/socket_provider.dart';
import 'package:provider/provider.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    final socketRead = context.read<SocketProvider>();
    final socketWatch = context.watch<SocketProvider>();
    return SafeArea(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              socketWatch.imTapped == true ? "Ходите" : "Ходит соперник",
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),

            Container(
              height: MediaQuery.of(context).size.height / 2,
              width: MediaQuery.of(context).size.height / 2,
              margin: const EdgeInsets.all(8),
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3),
                itemCount: 9,
                itemBuilder: (context, int index) {
                  return InkWell(
                    onTap: () {
                      if (socketWatch.board[index].isNotEmpty) {
                        showWarningMessage(context, "Клетка не пуста");
                        return;
                      }

                      if (socketWatch.imTapped == false) {
                        showWarningMessage(context, "Не ваш ход");
                        return;
                      }

                      dynamic message = {
                        "task": "",
                        "request": {
                          "move": index,
                        }
                      };

                      socketRead.write(jsonEncode(message));
                    },
                    child: Container(
                      color: socketWatch.board[index].isEmpty
                          ? Colors.black26
                          : socketWatch.board[index] == "O"
                              ? Colors.blue
                              : Colors.orange,
                      margin: const EdgeInsets.all(8),
                      child: Center(
                        child: Text(
                          socketWatch.board[index],
                          style: const TextStyle(fontSize: 50),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            //_restartButton(),
          ],
        ),
      ),
    );
  }
}
