import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/providers/login_provider.dart';
import 'package:frontend/providers/socket_provider.dart';
import 'package:frontend/screens/register.dart';
import 'package:provider/provider.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  static String routeName = "/sign_in";

  @override
  _SignFormState createState() => _SignFormState();
}

class _SignFormState extends State<SignInScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final socketRead = context.read<SocketProvider>();
    final loginRead = context.read<LoginProvider>();
    final loginWatch = context.watch<LoginProvider>();
    final loginTextEditingController =
        TextEditingController(text: loginWatch.login);
    final passwordTextEditingController =
        TextEditingController(text: loginWatch.password);

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
                  Selector<LoginProvider, String>(
                      selector: (_, loginWatch) => loginWatch.errorLogin,
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
                  Selector<LoginProvider, String>(
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
                    padding: const EdgeInsets.only(top: 8, bottom: 30),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        loginRead.setLogin(loginTextEditingController.text);
                        loginRead
                            .setPassword(passwordTextEditingController.text);
                        socketRead.setContext(context);

                        bool loginEmpty = true;
                        bool passwordEmpty = true;
                        if (loginTextEditingController.text.trim().isNotEmpty) {
                          loginRead.setLoginError("");
                          loginEmpty = false;
                        } else {
                          loginRead.setLoginError("Введите логин");
                        }

                        if (passwordTextEditingController.text
                            .trim()
                            .isNotEmpty) {
                          loginRead.setPasswordError("");
                          passwordEmpty = false;
                        } else {
                          loginRead.setPasswordError("Введите пароль");
                        }

                        if (!loginEmpty && !passwordEmpty) {
                          dynamic request = {
                            "task": "load",
                            "request": {
                              "login": loginTextEditingController.text,
                              "password": passwordTextEditingController.text
                            }
                          };
                          socketRead.write(jsonEncode(request));
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
                      loginRead.setLogin(loginTextEditingController.text);
                      loginRead.setPassword(passwordTextEditingController.text);
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
