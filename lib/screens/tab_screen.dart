import 'package:flutter/material.dart';

class TabScreen extends StatefulWidget {
  @override
  _TabScreenState createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  BottomNavigationBarItem _bottomNavItemMaker(String title, IconData iconData) {
    return BottomNavigationBarItem(
        icon: Icon(iconData),
        title: Text(title),
        backgroundColor: Theme.of(context).primaryColor);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: [
          _bottomNavItemMaker("Near Me", Icons.near_me),
          _bottomNavItemMaker("Map", Icons.map),
          _bottomNavItemMaker("Journey", Icons.search),
          _bottomNavItemMaker("Favs", Icons.favorite_border),
        ],
      ),
    );
  }
}
