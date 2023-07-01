import 'package:flutter/material.dart';
import 'package:frontend/locator.dart';
import 'package:frontend/providers/socket_provider.dart';
import 'package:frontend/screens/create_room.dart';
import 'package:frontend/screens/enter_the_room.dart';
import 'package:frontend/screens/random_game.dart';
import 'package:frontend/services/navigation_service.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  static String routeName = "/home";
  final NavigationService navigationService = locator<NavigationService>();

  @override
  Widget build(BuildContext context) {
    final socketWatch = context.watch<SocketProvider>();

    return Scaffold(
      appBar: AppBar(title: Text("Главная страница")),
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  Text(
                    "Ник: ${socketWatch.nickname} \n"
                    "Очки в крестики нолики: ${socketWatch.ticScore}\n"
                    "Очки в камень ножницы бумага: ${socketWatch.rpsScore}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () {
                      navigationService.navigateTo(CreateRoomScreen.routeName);
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        minimumSize: const Size(double.infinity, 56),
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(50)))),
                    child: const Text(
                      "Создать комнату",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      navigationService
                          .navigateTo(EnterTheRoomScreen.routeName);
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        minimumSize: const Size(double.infinity, 56),
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(50)))),
                    child: const Text(
                      "Войти в комнату",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      navigationService.navigateTo(RandomGameScreen.routeName);
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        minimumSize: const Size(double.infinity, 56),
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(50)))),
                    child: const Text(
                      "Играть с рандомом",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
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
