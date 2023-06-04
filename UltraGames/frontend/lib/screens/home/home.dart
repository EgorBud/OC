import 'package:flutter/material.dart';
import 'package:frontend/screens/ticktacktoe/ticktacktoe.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  static String routeName = "/home";

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text("Дом"),
      ),
      body: SafeArea(
        child: SizedBox(
            width: double.infinity,
            child: SingleChildScrollView(
                child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        TextButton(
                          style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            backgroundColor: Colors.blueAccent,
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, TickTackToeScreen.routeName);
                          },
                          child: const Text(
                            "Крестики нолики",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextButton(
                          style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            backgroundColor: Colors.blueAccent,
                          ),
                          onPressed: () {
                            //Navigator.pushNamed(context, TickTackToeScreen.routeName);
                          },
                          child: const Text(
                            "Камень ножницы бумага",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    )
                )
            )
        ),
      ),
    );
  }
}