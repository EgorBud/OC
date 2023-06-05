import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/components/form_error.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/screens/home/home.dart';

import 'package:frontend/globals.dart' as globals;
import 'package:http/http.dart' as http;

class SignForm extends StatefulWidget {
  const SignForm({super.key});

  @override
  _SignFormState createState() => _SignFormState();
}

class _SignFormState extends State<SignForm> {
  final _formKey = GlobalKey<FormState>();
  late String login;
  late String password;
  final List<String> errors = [];

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildLoginFormField(),
          const SizedBox(height: 20),
          buildPasswordFormField(),
          const SizedBox(height: 30),
          FormError(errors: errors),
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 24),
            child: ElevatedButton.icon(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();

                  print(login);
                  print(password);
                  var data = jsonEncode({
                    "login": login,
                    "password": password,
                  });
                  final response = await http.post(
                      Uri.parse('http://$hostAndPort/login'),
                      headers: <String, String>{
                        'Content-Type': 'text/plain',
                      },
                      body: data
                  );
                  int status = response.statusCode;
                  dynamic responseBody = jsonDecode(response.body);
                  print(response.statusCode);
                  print(jsonDecode(response.body));
                  if (status == 200) {
                    Navigator.pushNamed(context, HomeScreen.routeName);
                  } else if (status == 403) {

                  }

                  //Navigator.pushNamed(context, HomeScreen.routeName);
                }
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
        ]
      ),
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
      decoration: const InputDecoration(
        labelText: "Логин",
        hintText: "Введите логин",
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
      decoration: const InputDecoration(
        labelText: "Логин",
        hintText: "Введите логин",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }
}
