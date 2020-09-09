import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waytech/enums/place_type.dart';
import 'package:http/http.dart' as http;
import 'package:waytech/models/Place.dart';
import 'package:waytech/models/Station.dart';
import 'package:waytech/server_config/server_config.dart';

class StationProvider with ChangeNotifier {
  List<Station> stations = [
    Station(
      id: 3,
      title: "Lab",
      latitude: 12.953400,
      longitude: 12.546000,
    ),

    Station(
        id: 1,
        title: "Entrance",
        latitude: 12.953400,
        longitude: 12.546000,
    ),

    Station(
        id: 2,
        title: "Pool",
        latitude: 12.953400,
        longitude: 12.546000,
    )
  ];

  List<Station> favStations = [];

//  Future<List<Place>> getStations() async {
//
//    final response = await http.get(
//      ServerConfig.GetStations
//
//    );
//
//
//    List<Place> finalPlaces = [];
//
//    List<Map<String, dynamic>> places = json.decode(response.body);
//    print(places);
//    places.forEach((place) {
//      finalPlaces.add(Place(
//        id: place['id'],
//        title: place['title'],
//        latitude: place['latitude'],
//        longitude: place['longitude'],
//        placeType: place['place_type'] == "STI" ? PlaceType.STI : PlaceType.POI,
//      ));
//    });
//
//    notifyListeners();
//    return finalPlaces;
//  }

  void toggleFavorite(int stationId) async {
    int index = stations.indexWhere((element) => element.id == stationId);

    if (index != -1) {
      List<Station> newStations = [...stations];
      newStations[index].starred = !newStations[index].starred;
      if (newStations[index].starred) {
        favStations.add(newStations[index]);
      } else {
        favStations.removeWhere((element) => element.id == stationId);
      }

      await saveFavorites();
      notifyListeners();
    }

  }

  Future<List<Place>> getFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> encodedFavPlaces = prefs.getStringList("favStations");
    List<Station> decodedFavStations = [];

    encodedFavPlaces.forEach((encodedFavPlace) {
      Map<String, dynamic> favStation = json.decode(encodedFavPlace);
      decodedFavStations.add(Station.fromJson(favStation));
    });

    favStations = decodedFavStations;
    return decodedFavStations;
  }

  Future<void> saveFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> encodedStations = [];
    favStations.forEach((station) {
      String encodedStation = json.encode(station.toJson());
      encodedStations.add(encodedStation);
    });

    await prefs.setStringList('favStations', encodedStations);
  }
}
