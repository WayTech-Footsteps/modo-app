import 'package:flutter/material.dart';
import 'package:waytech/models/Station.dart';
import 'package:waytech/models/destination.dart';
import 'package:waytech/models/globalJourneyInfo.dart';
import 'package:waytech/screens/JourneyScreen.dart';
import 'package:waytech/screens/favorites_screen.dart';
import 'package:waytech/screens/map_screen.dart';
import 'package:waytech/screens/near_me_screen.dart';

class TabScreen extends StatefulWidget {
  Map<String, Station> journeyInfo;
  int index;


  TabScreen({this.journeyInfo, this.index});

  @override
  _TabScreenState createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  int _currentIndex = 0;
  Map<String, Station> _journeyInfoo;
  List<Destination> allDestinations;

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

  void changeTab(int tabIndex) {
    setState(() {
      _currentIndex = tabIndex;
    });
  }

  void changeJourneyInfo(Map<String, Station> info) {
    setState(() {
      GlobalJourneyInfo.jInfo = info;
    });
  }

  @override
  void initState() {
    JourneyScreen js = JourneyScreen();
    // TODO: implement initState
    super.initState();
//    _journeyInfoo = widget.journeyInfo;
    allDestinations = <Destination>[
      Destination('Near Me', Icons.near_me, NearMeScreen()),
      Destination('Map', Icons.map, MapScreen(changeTab: (i) => changeTab(i), changeJourneyInfo: (info) => changeJourneyInfo(info), journeyScreen: js,)),
      Destination('Journey', Icons.search, js),
      Destination('Favorites', Icons.favorite_border, FavoritesScreen())];
//    ];
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
          widget.index = null;
          setState(() {
            _currentIndex = index;
          });
        },
        currentIndex: widget.index == null ? _currentIndex : 2,
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
