import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/components/form_error.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/screens/home/home.dart';
import 'package:frontend/screens/register/register.dart';

import 'package:frontend/globals.dart' as globals;

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  static String routeName = "/sign_in";

  @override
  _SignFormState createState() => _SignFormState();
}

class _SignFormState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _loginTextEditingController =
      TextEditingController();
  final TextEditingController _passwordTextEditingController =
      TextEditingController();

  String login = "";
  String password = "";
  final List<String> errors = [];

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
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
          body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(32),
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
                const SizedBox(height: 20),
                Form(
                  key: _formKey,
                  child: Column(children: [
                    buildLoginFormField(),
                    const SizedBox(height: 20),
                    buildPasswordFormField(),
                    const SizedBox(height: 30),
                    FormError(errors: errors),
                    const SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 24),
                      child: ElevatedButton.icon(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();

                            dynamic request = {
                              "task" : "load",
                              "request": {
                                "login" : _loginTextEditingController.text,
                                "password" : _passwordTextEditingController.text
                              }
                            };

                            try {
                              socket.write(jsonEncode(request));
                            } catch (exception ) {
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
                  ]),
                ),
                GestureDetector(
                  onTap: () {
                    globals.login = _loginTextEditingController.text;
                    globals.password = _passwordTextEditingController.text;
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
      )),
    );
  }

  TextFormField buildLoginFormField() {
    return TextFormField(
      onSaved: (newValue) => login = newValue!,
      onChanged: (value) {
        if (value.isNotEmpty && errors.contains(kLoginNullError)) {
          setState(() {
            errors.remove(kLoginNullError);
          });
        }
        return null;
      },
      validator: (value) {
        if (value == "" && !errors.contains(kLoginNullError)) {
          setState(() {
            errors.add(kLoginNullError);
          });
          return "";
        }
        return null;
      },
      controller: _loginTextEditingController,
      decoration: const InputDecoration(
        labelText: "Логин",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField buildPasswordFormField() {
    return TextFormField(
      obscureText: true,
      onSaved: (newValue) => password = newValue!,
      onChanged: (value) {
        if (value.isNotEmpty && errors.contains(kPasswordNullError)) {
          setState(() {
            errors.remove(kPasswordNullError);
          });
        }
        return null;
      },
      validator: (value) {
        if (value == "" && !errors.contains(kPasswordNullError)) {
          setState(() {
            errors.add(kPasswordNullError);
          });
          return "";
        }
        return null;
      },
      controller: _passwordTextEditingController,
      decoration: const InputDecoration(
        labelText: "Пароль",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }
}
