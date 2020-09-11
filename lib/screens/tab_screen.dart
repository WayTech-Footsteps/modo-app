import 'package:flutter/material.dart';
import 'package:waytech/models/destination.dart';
import 'package:waytech/screens/JourneyScreen.dart';
import 'package:waytech/screens/favorites_screen.dart';
import 'package:waytech/screens/map_screen.dart';
import 'package:waytech/screens/near_me_screen.dart';

class TabScreen extends StatefulWidget {
  @override
  _TabScreenState createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  int _currentIndex = 0;
  List<Destination> allDestinations = <Destination>[
    Destination('Near Me', Icons.near_me, NearMeScreen()),
    Destination('Map', Icons.map, MapScreen()),
    Destination('Journey', Icons.search, JourneyScreen()),
    Destination('Favorites', Icons.favorite_border, FavoritesScreen()),
  ];

  BottomNavigationBarItem _bottomNavItemMaker(String title, IconData iconData) {
    return BottomNavigationBarItem(
        icon: Icon(iconData),
        title: Text(title),
        backgroundColor: Theme.of(context).primaryColor);
  }

  String _getTitle() {
    switch (_currentIndex) {
      case 0:
        return "Near Me";
      case 1:
        return "Map";
      case 2:
        return "Journey";
      case 3:
        return "Favorites";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getTitle()),
      ),
      body: SafeArea(
        top: false,
        child: IndexedStack(
          index: _currentIndex,
          children: allDestinations.map<Widget>((Destination destination) {
            return destination.screen;
          }).toList(),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        currentIndex: _currentIndex,
        items: allDestinations.map((Destination destination) {
          return BottomNavigationBarItem(
              icon: Icon(destination.icon),
              title: Text(destination.title),
              backgroundColor: Theme.of(context).primaryColor);
        }).toList(),
      ),
    );
  }
}
