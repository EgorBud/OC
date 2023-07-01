import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/components/showMessage.dart';
import 'package:frontend/locator.dart';
import 'package:frontend/providers/socket_provider.dart';
import 'package:frontend/screens/chat.dart';
import 'package:frontend/services/navigation_service.dart';
import 'package:provider/provider.dart';

class TickTackToeScreen extends StatefulWidget {
  TickTackToeScreen({super.key});

  static String routeName = "/ticktacktoe";

  @override
  _TickTackToeScreenState createState() => _TickTackToeScreenState();
}

class _TickTackToeScreenState extends State<TickTackToeScreen> {
  final NavigationService navigationService = locator<NavigationService>();

  @override
  Widget build(BuildContext context) {
    final socketRead = context.read<SocketProvider>();
    final socketWatch = context.watch<SocketProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Крестики нолики"),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
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
                        socketRead.setContext(context);

                        if (socketWatch.gameStart == false) {
                          showWarningMessage(context, "Игра закончилась");
                          return;
                        }

                        if (socketWatch.board[index].isNotEmpty) {
                          showWarningMessage(context, "Клетка не пуста");
                          return;
                        }

                        if (socketWatch.imTapped == false) {
                          showWarningMessage(context, "Не ваш ход");
                          return;
                        }

                        dynamic message = {
                          "task": "game",
                          "request": {
                            "move": index,
                            "login" : socketWatch.login,
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
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 40.0, right: 40),
                child: ElevatedButton(
                  onPressed: () {
                    dynamic request = {
                      "task": "leave"
                    };

                    socketRead.write(jsonEncode(request));
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      minimumSize: const Size(double.infinity, 56),
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(50)))),
                  child: const Text("Покинуть комнату"),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            socketRead.notifyCheck();
            navigationService.navigateTo(ChatScreen.routeName);
          },
          backgroundColor: Colors.blueAccent,
          child: socketWatch.notify
              ? Badge(
                  label: Text("${socketWatch.countMessage}"),
                  child: const Icon(Icons.message_outlined))
              : const Icon(Icons.message_outlined)),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
