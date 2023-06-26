import 'package:flutter/material.dart';
import 'package:safe_neighborhood/main.dart';

class DrawerTile extends StatelessWidget {
  final IconData icon;
  final String text;
  final PageController pageController;
  final int page;

  const DrawerTile({Key? key, required this.icon, required this.text, required this.pageController, required this.page}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        child: Container(
          height: 60.0,
          child: Row(
            children: [
              Icon(
                icon,
                size: 32.0,
                color: pageController.page?.round() == page ? Theme.of(context).primaryColor : Colors.grey[700],
              ),
              const SizedBox(width: 32.0,),
              Text(text,
                style: TextStyle(
                  fontSize: 16.0,
                  color: pageController.page?.round() == page ? Theme.of(context).primaryColor : Colors.grey[700],
                ),
              )
            ],
          ),
        ),
        onTap: () {
          navigatorKey?.currentState?.pop();
          pageController.jumpToPage(page);
        },
      ),
    );
  }
}
