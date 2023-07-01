import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/providers/key_provider.dart';
import 'package:frontend/providers/socket_provider.dart';
import 'package:provider/provider.dart';

class CreateRoomScreen extends StatefulWidget {
  const CreateRoomScreen({super.key});

  static String routeName = "/create_room";

  @override
  _CreateRoomScreenState createState() => _CreateRoomScreenState();
}

class _CreateRoomScreenState extends State<CreateRoomScreen> {

  List<CreateRoom> rooms = [
    CreateRoom(task: "ticroom", label: "Крестики нолики"),
    CreateRoom(task: "rpsroom", label: "Камень ножницы бумага")
  ];
  late CreateRoom selectedItem = rooms[0];

  late TextEditingController keyTextEditingController = TextEditingController();

  @override
  void initState() {
    keyTextEditingController;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    keyTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final socketRead = context.read<SocketProvider>();
    final keyRead = context.read<KeyProvider>();

    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(title: Text("Создание комнаты")),
        body: SafeArea(
          child: SizedBox(
            width: double.infinity,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  children: [
                    const SizedBox(height: 40),
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

                          print(selectedItem.task);
                          print(keyTextEditingController.text);
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
                        "Создать комнату",
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
