import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/main.dart';
import 'package:frontend/screens/home/home.dart';
import 'package:frontend/screens/register/register.dart';
import 'package:provider/provider.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  static String routeName = "/sign_in";

  @override
  _SignFormState createState() => _SignFormState();
}

class _SignFormState extends State<SignInScreen> {
  late String serverResponse;
  late Socket socket;

  _setConnectionAndListen() async {
    socket = await Socket.connect(HOST, PORT);
    socket.listen(
      (Uint8List data) {
        serverResponse = String.fromCharCodes(data);
        if (jsonDecode(serverResponse)["code"] == 200) {
          Navigator.pushNamed(context, HomeScreen.routeName);
        } else {
          print(jsonDecode(serverResponse)["body"]);
        }
      },
      onError: (error) {
        socket.destroy();
      },
      onDone: () {
        print("Left");
        socket.destroy();
      },
    );
  }

  @override
  void initState() {
    _setConnectionAndListen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userRead = context.read<User>();
    final user = context.watch<User>();
    final loginTextEditingController = TextEditingController(text: user.login);
    final passwordTextEditingController =
        TextEditingController(text: user.password);

    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        body: SafeArea(
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
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: loginTextEditingController,
                    decoration: const InputDecoration(
                      labelText: "Логин",
                      border: OutlineInputBorder(),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                  Selector<User, String>(
                      selector: (_, user) => user.errorLogin,
                      builder: (_, errorLogin, __) => errorLogin != ""
                          ? Padding(
                              padding: const EdgeInsets.all(4),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const SizedBox(width: 20),
                                  Text(
                                    errorLogin,
                                    style: const TextStyle(color: Colors.red),
                                  ),
                                ],
                              ),
                            )
                          : Container()),
                  const SizedBox(height: 30),
                  TextField(
                    obscureText: true,
                    controller: passwordTextEditingController,
                    decoration: const InputDecoration(
                      labelText: "Пароль",
                      border: OutlineInputBorder(),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                  Selector<User, String>(
                      selector: (_, user) => user.errorPassword,
                      builder: (_, errorPassword, __) => errorPassword != ""
                          ? Padding(
                        padding: const EdgeInsets.all(4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(width: 20),
                            Text(
                              errorPassword,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                      )
                          : Container()),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 24),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        userRead.setLogin(loginTextEditingController.text);
                        userRead
                            .setPassword(passwordTextEditingController.text);

                        bool loginEmpty = true;
                        bool passwordEmpty = true;
                        if (loginTextEditingController.text.trim().isNotEmpty) {
                          user.setLoginError("");
                          loginEmpty = false;
                        } else {
                          user.setLoginError("Введите логин");
                        }

                        if (passwordTextEditingController.text
                            .trim()
                            .isNotEmpty) {
                          user.setPasswordError("");
                          passwordEmpty = false;
                        } else {
                          user.setPasswordError("Введите пароль");
                        }

                        if (!loginEmpty && !passwordEmpty) {
                          dynamic request = {
                            "task": "load",
                            "request": {
                              "login": loginTextEditingController.text,
                              "password": passwordTextEditingController.text
                            }
                          };
                          try {
                            socket.write(jsonEncode(request));
                          } catch (exception) {
                            print(exception);
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          minimumSize: const Size(double.infinity, 56),
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50)))),
                      icon: const Icon(CupertinoIcons.arrow_right),
                      label: const Text("Продолжить"),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      userRead.setLogin(loginTextEditingController.text);
                      userRead.setPassword(passwordTextEditingController.text);
                      Navigator.pushNamedAndRemoveUntil(
                          context, RegisterScreen.routeName, (route) => false);
                    },
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
        ),
      ),
    );
  }
}
