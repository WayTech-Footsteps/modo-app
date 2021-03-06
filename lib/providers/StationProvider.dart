import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:latlong/latlong.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waytech/enums/place_type.dart';
import 'package:http/http.dart' as http;
import 'package:waytech/models/Place.dart';
import 'package:waytech/models/Station.dart';
import 'package:waytech/models/TimeEntry.dart';
import 'package:waytech/providers/LocationProvider.dart';
import 'package:waytech/providers/TimeEntryProvider.dart';
import 'package:waytech/server_config/server_config.dart';

class StationProvider with ChangeNotifier {
  List<Station> stations = [];
  bool dataFetched = false;

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

  Future<List<Station>> getStations(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Station> res_stations = [];
    favStations = [];
    final response = await http.get(
      ServerConfig.GetStations,
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      },
    );
    final Distance distance = new Distance();

    List<Map<String, dynamic>> allStations =
    List<Map<String, dynamic>>.from(json.decode(response.body));
    final locationProvider =
    Provider.of<LocationProvider>(context, listen: false);
    final timeEntryProvider =
    Provider.of<TimeEntryProvider>(context, listen: false);
    await locationProvider.getCurrentLocation();

    allStations.forEach((currStation) {
      Station station = Station.fromJson(currStation);
      // print(locationProvider.currentMapLocation);
//        station.distance = distance.as(LengthUnit.Meter,
//            new LatLng(station.latitude, station.longitude),
//            locationProvider.currentMapLocation);
      // print(station);
      // print(new LatLng(station.longitude, station.latitude));
      num dist = distance.as(
          LengthUnit.Meter,
          new LatLng(station.latitude, station.longitude),
          locationProvider.currentMapLocation);
      station.distance = dist.toDouble().roundToDouble();

      var dist_to_double = double.parse(station.distance.toString());
      station.distance = dist_to_double / 1000;

//        station.distance = distance.as(LengthUnit.Meter,
//            new LatLng(station.latitude, station.longitude), locationProvider.currentMapLocation);
      res_stations.add(station);
    });
    String currentTime = DateFormat('HH:mm:ss').format(DateTime.now());
    for (Station station in res_stations) {
      List<TimeEntry> stationIncomingLines =
      await timeEntryProvider.getIncomingLines(station.id, currentTime);

      station.incomingLines = stationIncomingLines;
    }



    res_stations.sort((a, b) => a.distance.compareTo(b.distance));

    List<String> encodedFavStations = prefs.getStringList("favStations");

    if (favStations == null) {
      favStations = [];
    }

    if (encodedFavStations != null) {
      res_stations.forEach((station) {
        if (encodedFavStations.contains(station.id.toString())) {
          station.starred = true;
          favStations.add(station);
        }
      });
    }
    stations = res_stations;
    dataFetched = true;
    notifyListeners();

    return res_stations;
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
