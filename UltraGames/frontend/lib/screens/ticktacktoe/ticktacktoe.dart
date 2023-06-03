import 'package:flutter/material.dart';

import 'components/body.dart';

class TickTackToeScreen extends StatelessWidget {
  const TickTackToeScreen({super.key});
  static String routeName = "/ticktacktoe";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Крестики нолики"),
      ),
      body: const Body(),
    );
  }
}