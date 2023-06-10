import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/locator.dart';
import 'package:frontend/providers/socket_provider.dart';
import 'package:frontend/services/navigation_service.dart';
import 'package:provider/provider.dart';

class RandomGameScreen extends StatefulWidget {
  RandomGameScreen({super.key});

  static String routeName = "/random_game";

  @override
  _RandomGameScreenState createState() => _RandomGameScreenState();
}

class _RandomGameScreenState extends State<RandomGameScreen> {
  final NavigationService navigationService = locator<NavigationService>();

  List<CreateRoom> rooms = [
    CreateRoom(task: "ticroom", label: "Крестики нолики"),
    CreateRoom(task: "rpcroom", label: "Камень ножницы бумага")
  ];
  late CreateRoom selectedItem = rooms[0];

  @override
  Widget build(BuildContext context) {
    final socketRead = context.read<SocketProvider>();
    return Scaffold(
      appBar: AppBar(title: Text("Рандомная игра")),
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
                      onChanged: (item) => setState(() => selectedItem = item!),
                    ),
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () {
                      dynamic request = {
                        "task" : selectedItem.task,
                        "request" : {
                          "key" : "public_key"
                        }
                      };

                      print(selectedItem.task);
                      socketRead.write(jsonEncode(request));
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        minimumSize: const Size(double.infinity, 56),
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(50)))),
                    child: const Text(
                      "Играть",
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
