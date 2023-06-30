import 'package:flutter/material.dart';
import 'package:safe_neighborhood/map.dart';
import 'package:safe_neighborhood/register_event_screen.dart';
import 'package:safe_neighborhood/widgets/custom_drawer.dart';

import 'feed_history_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text('Mapa'),
          ),
          body: const SimpleMap(),
          drawer: CustomDrawer(pageController: _pageController),
        ),
        Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text('Cadastrar Ocorrência'),
          ),
          body: const RegisterEventScreen(),
          drawer: CustomDrawer(pageController: _pageController),
        ),
        Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text('Feed'),
          ),
          body: const FeedHistoryScreen(),
          drawer: CustomDrawer(pageController: _pageController),
        )
      ],
    );
  }
}
