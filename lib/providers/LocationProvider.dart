import 'package:flutter/foundation.dart';
import 'package:latlong/latlong.dart';
import 'package:location/location.dart';

class LocationProvider with ChangeNotifier {
  var location = new Location();
  LatLng currentMapLocation;

  Future getLocation() async {
    location.onLocationChanged.listen((LocationData currentLocation) {
      print('Latitude:${currentLocation.latitude}');
      print('Longitude:${currentLocation.longitude}');
      currentMapLocation =
          LatLng(currentLocation.longitude, currentLocation.latitude);
      notifyListeners();
    });
  }
}
