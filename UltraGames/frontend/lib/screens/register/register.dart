import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/providers/registerProvider.dart';
import 'package:frontend/providers/socketProvider.dart';
import 'package:frontend/screens/sign_in/sign_in.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  static String routeName = "/register";

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    final socketRead = context.read<SocketProvider>();
    final socketWatch = context.watch<SocketProvider>();
    final registerWatch = context.watch<RegisterProvider>();
    final registerRead = context.read<RegisterProvider>();
    final nicknameTextEditingController =
        TextEditingController(text: registerWatch.nickname);
    final loginTextEditingController =
        TextEditingController(text: registerWatch.login);
    final passwordTextEditingController =
        TextEditingController(text: registerWatch.password);

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
                  Selector<RegisterProvider, String>(
                      selector: (_, nicknameWatch) => nicknameWatch.errorNickname,
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
                  Selector<RegisterProvider, String>(
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
                  Selector<RegisterProvider, String>(
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
                        registerRead
                            .setNickname(nicknameTextEditingController.text);
                        registerRead.setLogin(loginTextEditingController.text);
                        registerRead
                            .setPassword(passwordTextEditingController.text);
                        socketRead.setContext(context);

                        bool nicknameEmpty = true;
                        bool loginEmpty = true;
                        bool passwordEmpty = true;

                        if (nicknameTextEditingController.text
                            .trim()
                            .isNotEmpty) {
                          registerRead.setNicknameError("");
                          nicknameEmpty = false;
                        } else {
                          registerRead.setNicknameError("Введите никнейм");
                        }

                        if (loginTextEditingController.text.trim().isNotEmpty) {
                          registerRead.setLoginError("");
                          loginEmpty = false;
                        } else {
                          registerRead.setLoginError("Введите логин");
                        }

                        if (passwordTextEditingController.text
                            .trim()
                            .isNotEmpty) {
                          registerRead.setPasswordError("");
                          passwordEmpty = false;
                        } else {
                          registerRead.setPasswordError("Введите пароль");
                        }

                        if (!loginEmpty && !passwordEmpty && !nicknameEmpty) {
                          dynamic request = {
                            "task": "new",
                            "request": {
                              "nickname" : nicknameTextEditingController.text,
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
                  const SizedBox(height: 30),
                  GestureDetector(
                    onTap: () {
                      registerRead.setNickname(nicknameTextEditingController.text);
                      registerRead.setLogin(loginTextEditingController.text);
                      registerRead
                          .setPassword(passwordTextEditingController.text);
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
