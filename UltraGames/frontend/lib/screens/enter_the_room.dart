import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/locator.dart';
import 'package:frontend/providers/key_provider.dart';
import 'package:frontend/providers/socket_provider.dart';
import 'package:frontend/services/navigation_service.dart';
import 'package:provider/provider.dart';

class EnterTheRoomScreen extends StatefulWidget {
  EnterTheRoomScreen({super.key});

  static String routeName = "/enter_the_room";

  @override
  _EnterTheRoomScreenState createState() => _EnterTheRoomScreenState();
}

class _EnterTheRoomScreenState extends State<EnterTheRoomScreen> {
  final NavigationService navigationService = locator<NavigationService>();

  List<CreateRoom> rooms = [
    CreateRoom(task: "ticroom", label: "Крестики нолики"),
    CreateRoom(task: "rpcroom", label: "Камень ножницы бумага")
  ];
  late CreateRoom selectedItem = rooms[0];

  @override
  Widget build(BuildContext context) {
    final socketRead = context.read<SocketProvider>();
    final keyRead = context.read<KeyProvider>();
    final keyWatch = context.watch<KeyProvider>();
    final keyTextEditingController =
        TextEditingController(text: keyWatch.key);
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(title: Text("Войти в комнату")),
        body: SafeArea(
          child: SizedBox(
            width: double.infinity,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    /*
                  const Text(
                    "Создание комнаты",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  */
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: DropdownButtonFormField<CreateRoom>(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        value: selectedItem,
                        items: rooms
                            .map((item) => DropdownMenuItem<CreateRoom>(
                                value: item, child: Text(item.label)))
                            .toList(),
                        onChanged: (item) =>
                            setState(() => selectedItem = item!),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: keyTextEditingController,
                      decoration: const InputDecoration(
                        labelText: "Ключ",
                        border: OutlineInputBorder(),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                    Selector<KeyProvider, String>(
                        selector: (_, keyWatch) => keyWatch.errorKey,
                        builder: (_, errorKey, __) => errorKey != ""
                            ? Padding(
                                padding: const EdgeInsets.all(4),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const SizedBox(width: 20),
                                    Text(
                                      errorKey,
                                      style: const TextStyle(color: Colors.red),
                                    ),
                                  ],
                                ),
                              )
                            : Container()),
                    const SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: () {
                        if (keyTextEditingController.text.trim().isNotEmpty) {
                          keyRead.setKeyError("");

                          dynamic request = {
                            "task": selectedItem.task,
                            "request": {
                              "key": keyTextEditingController.text,
                            }
                          };

                          socketRead.write(jsonEncode(request));

                        } else {
                          keyRead.setKeyError("Введите ключ");
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          minimumSize: const Size(double.infinity, 56),
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50)))),
                      child: const Text(
                        "Присоедениться",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CreateRoom {
  String task;
  String label;

  CreateRoom({
    required this.task,
    required this.label,
  });
}
