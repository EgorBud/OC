import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/globals.dart' as globals;

import 'package:frontend/screens/home/home.dart';
import 'package:frontend/screens/register/register.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {

  Future<void> setConnection() async {
    globals.socket = await Socket.connect(HOST, PORT);

    globals.socket.listen((Uint8List data) {
      final serverResponse = jsonDecode(String.fromCharCodes(data));
      print(serverResponse["task"]);
    }, onError: (error) {
      print(error);
      globals.socket.destroy();
    }, onDone: () {
      print("Client: Server left");
    });
  }

  @override
  void initState() {
    setConnection();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text(
                "Вход",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 30),
                      child: Text(
                        "Логин",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 16),
                      child: TextFormField(
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(width: 2, color: Colors.black),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(width: 2, color: Colors.blue),
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 30, top: 8),
                      child: Text(
                        "Пароль",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 16),
                      child: TextFormField(
                        obscureText: true,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(width: 2, color: Colors.black),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(width: 2, color: Colors.blue),
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 24),
                child: ElevatedButton.icon(
                  onPressed: () async {
                    print("${globals.socket.remoteAddress}:${globals.socket.port}");

                    dynamic m = {
                      "task": "new",
                      "log": "man",
                      "pas": "123",
                      "key":'key'
                    };

                    globals.socket.write(jsonEncode(m));

                    //Navigator.pushNamed(context, HomeScreen.routeName);
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      minimumSize: const Size(double.infinity, 56),
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(50)))),
                  icon: const Icon(CupertinoIcons.arrow_right),
                  label: const Text("Продолжить"),
                ),
              ),
              const SizedBox(height: 30),
              GestureDetector(
                onTap: () => Navigator.pushNamedAndRemoveUntil(
                    context, RegisterScreen.routeName, (route) => false),
                child: const Text(
                  "Нажмите для регистрации",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.blueAccent,
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
