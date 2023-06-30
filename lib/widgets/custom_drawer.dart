import 'package:flutter/material.dart';
import 'package:safe_neighborhood/login_screen.dart';
import 'package:safe_neighborhood/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';
import '../main.dart';
import 'drawer_tile.dart';

class CustomDrawer extends StatelessWidget {
  final PageController pageController;

  const CustomDrawer({Key? key, required this.pageController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget _buildDrawerBack() => Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 174, 214, 241),
                Colors.white
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter
          )
      ),
    );

    return Drawer(
      child: Stack(
        children: [
          _buildDrawerBack(),
          ListView(
            padding: const EdgeInsets.only(left: 32.0, top: 16.0),
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 8.0),
                padding: const EdgeInsets.fromLTRB(0, 16.0, 16.0, 8.0),
                height: 170.0,
                child: Stack(
                  children: [
                    const Positioned(
                      top: 8.0,
                      left: 0,
                      child: Text("Safe\nNeighborhood",
                        style: TextStyle(
                            fontSize: 34.0, fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      bottom: 0,
                      child: ScopedModelDescendant<UserModel> (
                        builder: (context, child, model) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Olá, ${!model.isLoggedIn() ? "" : model.userData["name"]}",
                                style: const TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                              GestureDetector(
                                child: Text(!model.isLoggedIn() ? "Entre ou cadastre-se >" : "Sair",
                                  style: TextStyle(
                                      color: Colors.blue[600],
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                                onTap: () {
                                  if (!model.isLoggedIn()) {
                                    navigatorKey.currentState?.pop();
                                    navigatorKey.currentState?.push(
                                        MaterialPageRoute(builder: (
                                            _) => const LoginScreen()));
                                  }
                                  else {
                                    model.signOut();
                                  }
                                },
                              )
                            ],
                          );
                        },
                      )
                    ),
                  ],
                ),
              ),
              const Divider(
                color: Colors.grey,
                thickness: 0.5,
                indent: 20.0,
              ),
              DrawerTile(icon: Icons.map, text: "Mapa", pageController: pageController, page: 0,),
              DrawerTile(icon: Icons.add, text: "Cadastrar Ocorrência", pageController: pageController, page: 1,),
              DrawerTile(icon: Icons.list, text: "Feed", pageController: pageController, page: 2,)
              ],
          ),
        ],
      ),
    );
  }
}
