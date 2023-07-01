import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/models/message.dart';
import 'package:frontend/providers/socket_provider.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  static String routeName = "/chat";

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageInputController = TextEditingController();

  @override
  void dispose() {
    _messageInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final socketRead = context.read<SocketProvider>();
    final socketWatch = context.watch<SocketProvider>();

    return WillPopScope(
      onWillPop: () async {
        print("back");
        socketRead.notifyCheck();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Чат"),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemBuilder: (context, index) {
                  final message = socketWatch.messages[index];
                  return Wrap(
                    alignment: message.senderUsername == socketWatch.myToken
                        ? WrapAlignment.end
                        : WrapAlignment.start,
                    children: [
                      Card(
                        color: message.senderUsername == socketWatch.myToken
                            ? Theme.of(context).primaryColorLight
                            : Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment:
                                message.senderUsername == socketWatch.myToken
                                    ? CrossAxisAlignment.end
                                    : CrossAxisAlignment.start,
                            children: [
                              Text(message.message),
                            ],
                          ),
                        ),
                      )
                    ],
                  );
                },
                separatorBuilder: (_, index) => const SizedBox(
                  height: 5,
                ),
                itemCount: socketWatch.messages.length,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: SafeArea(
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _messageInputController,
                        decoration: const InputDecoration(
                          hintText: "",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        if (_messageInputController.text.trim().isNotEmpty) {
                          socketRead.addMessageLocally(
                            Message(
                              message: _messageInputController.text,
                              senderUsername: socketWatch.myToken,
                            ),
                          );

                          dynamic request = {
                            "task": "chat",
                            "request": {
                              "message": _messageInputController.text,
                              "sender": socketWatch.myToken,
                            }
                          };

                          socketRead.write(jsonEncode(request));
                          _messageInputController.clear();
                        }
                      },
                      icon: const Icon(Icons.send),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
