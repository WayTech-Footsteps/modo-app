import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:waytech/enums/place_type.dart';
import 'package:http/http.dart' as http;
import 'package:waytech/models/Place.dart';
import 'package:waytech/server_config/server_config.dart';

class PlaceProvider with ChangeNotifier {
  List<Place> places = [
    Place(
      id: 3,
      title: "Lab",
      latitude: 12.953400,
      longitude: 12.546000,
      placeType: PlaceType.STI,
    ),
    Place(
        id: 1,
        title: "Entrance",
        latitude: 12.953400,
        longitude: 12.546000,
        placeType: PlaceType.STI
    ),
    Place(
        id: 2,
        title: "Pool",
        latitude: 12.953400,
        longitude: 12.546000,
        placeType: PlaceType.STI
    ),



  ];


  Future<List<Place>> getPlaces() async {
    print("here");

    final response = await http.get(
      ServerConfig.GetPlaces
    );

    print("we are here");

    print(response.body);
    print("we are all here");


    List<Place> finalPlaces = [];

    List<Map<String, dynamic>> places = json.decode(response.body);
    print(places);
    places.forEach((place) {
      finalPlaces.add(
        Place(
          id: place['id'],
          title: place['title'],
          latitude: place['latitude'],
          longitude: place['longitude'],
          placeType: place['place_type'] == "STI" ? PlaceType.STI : PlaceType.POI,
        )
      );
    });

    notifyListeners();
    return finalPlaces;
  }

  void toggleFavorite(int placeId) {
    print(places[0].starred);
    print(places[1].starred);
    print(places[2].starred);
    int index = places.indexWhere((element) => element.id == placeId);
    print(index);
    if (index != -1) {
      List<Place> newPlaces = [...places];
      newPlaces[index].starred = !newPlaces[index].starred;
      places = newPlaces;
      notifyListeners();
    }

    print(places[0].starred);
    print(places[1].starred);
    print(places[2].starred);
  }
}