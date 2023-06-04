import 'package:flutter/material.dart';

import 'package:frontend/screens/home/home.dart';
import 'package:frontend/screens/register/register.dart';
import 'package:frontend/screens/sign_in/sign_in.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
                      hintText: "Введите логин",
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
    );
  }
}