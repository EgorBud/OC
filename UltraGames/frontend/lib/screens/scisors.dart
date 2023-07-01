import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/components/showMessage.dart';
import 'package:frontend/locator.dart';
import 'package:frontend/providers/socket_provider.dart';
import 'package:frontend/screens/chat.dart';
import 'package:frontend/services/navigation_service.dart';
import 'package:provider/provider.dart';

class ScisorsScreen extends StatefulWidget {
   ScisorsScreen({super.key});

  static String routeName = "/scisors";

  @override
  _ScisorsScreenState createState() => _ScisorsScreenState();
}

class _ScisorsScreenState extends State<ScisorsScreen> {
  final NavigationService navigationService = locator<NavigationService>();

  @override
  Widget build(BuildContext context) {
    final socketRead = context.read<SocketProvider>();
    final socketWatch = context.watch<SocketProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Камень ножницы бумага"),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [

              SizedBox(height: 80),
              Row(children: [
                SizedBox(width: 20),
                InkWell(
                  onTap: () {
                    socketRead.setContext(context);

                    dynamic message = {
                      "choise" : "1",
                    };
                    socketRead.write(jsonEncode(message));
                  }, // Handle your callback.
                  child: Ink(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('images/rock.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 20),
                InkWell(
                  onTap: () {
                    socketRead.setContext(context);

                    dynamic message = {
                      "choise" : "2",
                    };
                    socketRead.write(jsonEncode(message));
                  }, // Handle your callback.
                  child: Ink(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('images/paper.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 20),
                InkWell(
                  onTap: () {
                    socketRead.setContext(context);

                    dynamic message = {
                      "choise" : "3",
                    };
                    socketRead.write(jsonEncode(message));
                  }, // Handle your callback.
                  child: Ink(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('images/scissors.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                )
              ],),
              SizedBox(height: 100),
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
