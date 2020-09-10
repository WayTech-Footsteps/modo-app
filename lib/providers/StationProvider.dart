import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waytech/enums/place_type.dart';
import 'package:http/http.dart' as http;
import 'package:waytech/models/Place.dart';
import 'package:waytech/models/Station.dart';
import 'package:waytech/server_config/server_config.dart';

class StationProvider with ChangeNotifier {
  List<Station> stations = [];

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

  Future<List<Station>> getStations() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (stations.isEmpty || stations == null) {
      print("here");
      print(ServerConfig.GetStations);
      final response = await http.get(
        ServerConfig.GetStations,
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
        },
      );

      List<Map<String, dynamic>> allStations =
          List<Map<String, dynamic>>.from(json.decode(response.body));
      allStations.forEach((currStation) {
        Station station = Station.fromJson(currStation);
        stations.add(station);
      });
    }

    List<String> encodedFavStations = prefs.getStringList("favStations");

    if (favStations == null) {
      favStations = [];
    }

    if (encodedFavStations != null) {
      stations.forEach((station) {
        if (encodedFavStations.contains(station.id.toString())) {
          station.starred = true;
          favStations.add(station);
        }
      });
    }

    notifyListeners();

    print(stations);

    return stations;

//    favStations = decodedFavStations;
//    return decodedFavStations;
  }

  Future<List<Station>> getFavorites() async {
    return favStations;
  }

  Future<void> saveFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> encodedStations = [];
    favStations.forEach((station) {
//      String encodedStation = json.encode(station.toJson());
//      encodedStations.add(encodedStation);
      String encodedStationId = station.id.toString();
      encodedStations.add(encodedStationId);
    });

    await prefs.setStringList('favStations', encodedStations);
  }
}
