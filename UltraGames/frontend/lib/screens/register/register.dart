import 'package:flutter/material.dart';
import 'package:frontend/screens/home/home.dart';
import 'package:frontend/screens/sign_in/sign_in.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({Key? key}) : super(key: key);

  static String routeName = "/register";

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  String login = "";
  String password = "";
  final List<String> errors = [];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(body: SafeArea(
          child: SizedBox (
            width: double.infinity,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 60),
                    const Text(
                      "Регистрация",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 30,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    const SizedBox(height: 30),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: "Никнейм",
                        hintText: "Введите никнейм",
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                    const SizedBox(height: 30),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: "Логин",
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                    const SizedBox(height: 30),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: "Пароль",
                        hintText: "Введите пароль",
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                    const SizedBox(height: 30),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: "Пароль",
                        hintText: "Повторите пароль",
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                    const SizedBox(height: 30),
                    TextButton(
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        backgroundColor: Colors.blueAccent,
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, HomeScreen.routeName);
                      },
                      child: const Text(
                        "продолжить",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    GestureDetector(
                      onTap: () => Navigator.pushNamedAndRemoveUntil(context, SignInScreen.routeName, (route) => false),
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
          )
      )),
    );
  }
}
