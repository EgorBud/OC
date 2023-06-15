import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/providers/login_and_register_provider.dart';
import 'package:frontend/providers/socket_provider.dart';
import 'package:frontend/screens/sign_in.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  static String routeName = "/register";

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterScreen> {
  late TextEditingController nicknameTextEditingController;
  late TextEditingController loginTextEditingController;
  late TextEditingController passwordTextEditingController;

  @override
  void initState() {
    super.initState();
    final logAndRegRead = context.read<LoginAndRegisterProvider>();
    nicknameTextEditingController = TextEditingController(text: logAndRegRead.nickname);
    loginTextEditingController = TextEditingController(text: logAndRegRead.login);
    passwordTextEditingController = TextEditingController();
  }

  @override
  void dispose() {
    nicknameTextEditingController.dispose();
    loginTextEditingController.dispose();
    passwordTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final socketRead = context.read<SocketProvider>();
    final logAndRegRead = context.read<LoginAndRegisterProvider>();

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
                    "Регистрация",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30),
                  TextField(
                    controller: nicknameTextEditingController,
                    decoration: const InputDecoration(
                      labelText: "Никнейм",
                      border: OutlineInputBorder(),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                  Selector<LoginAndRegisterProvider, String>(
                      selector: (_, nickname) => nickname.errorNickname,
                      builder: (_, errorNickname, __) => errorNickname != ""
                          ? Padding(
                              padding: const EdgeInsets.all(4),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const SizedBox(width: 20),
                                  Text(
                                    errorNickname,
                                    style: const TextStyle(color: Colors.red),
                                  ),
                                ],
                              ),
                            )
                          : Container()),
                  const SizedBox(height: 30),
                  TextField(
                    controller: loginTextEditingController,
                    decoration: const InputDecoration(
                      labelText: "Логин",
                      border: OutlineInputBorder(),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                  Selector<LoginAndRegisterProvider, String>(
                      selector: (_, login) => login.errorLogin,
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
                  Selector<LoginAndRegisterProvider, String>(
                      selector: (_, password) => password.errorPassword,
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
                        logAndRegRead
                            .setNickname(nicknameTextEditingController.text);
                        logAndRegRead.setLogin(loginTextEditingController.text);

                        bool nicknameEmpty = true;
                        bool loginEmpty = true;
                        bool passwordEmpty = true;

                        if (nicknameTextEditingController.text
                            .trim()
                            .isNotEmpty) {
                          logAndRegRead.setNicknameError("");
                          nicknameEmpty = false;
                        } else {
                          logAndRegRead.setNicknameError("Введите никнейм");
                        }

                        if (loginTextEditingController.text.trim().isNotEmpty) {
                          logAndRegRead.setLoginError("");
                          loginEmpty = false;
                        } else {
                          logAndRegRead.setLoginError("Введите логин");
                        }

                        if (passwordTextEditingController.text
                            .trim()
                            .isNotEmpty) {
                          logAndRegRead.setPasswordError("");
                          passwordEmpty = false;
                        } else {
                          logAndRegRead.setPasswordError("Введите пароль");
                        }

                        if (!loginEmpty && !passwordEmpty && !nicknameEmpty) {
                          dynamic request = {
                            "task": "new",
                            "request": {
                              "nickname": nicknameTextEditingController.text,
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
                      logAndRegRead
                          .setNickname(nicknameTextEditingController.text);
                      logAndRegRead.setLogin(loginTextEditingController.text);
                      Navigator.pushNamedAndRemoveUntil(
                          context, SignInScreen.routeName, (route) => false);
                    },
                    child: const Text(
                      "Нажмите для входа",
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
