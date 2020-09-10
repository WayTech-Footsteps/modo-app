import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:waytech/providers/StationProvider.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = {};

  CameraPosition initialPosition;
  var location = new Location();

  Future _getLocation() async {
    try {
      location.onLocationChanged.listen((LocationData currentLocation) {
        print('Latitude:${currentLocation.latitude}');
        print('Longitude:${currentLocation.longitude}');
        setState(() {
          initialPosition = CameraPosition(
              target: LatLng(currentLocation.latitude, currentLocation.longitude),
              zoom: 14.567);
        });

        return LatLng(currentLocation.latitude, currentLocation.longitude);
      });
    } catch (e) {
      print('ERROR:$e');
      initialPosition = null;
    }
  }

  void setMapPins(StationProvider stationProvider) {
    setState(() {
      stationProvider.stations.forEach((station) {
        _markers.add(Marker(
            markerId: MarkerId(station.id.toString()),
            position: LatLng(station.longitude, station.latitude),
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueGreen)));
      });

      // destination pin
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getLocation();
  }

  @override
  Widget build(BuildContext context) {
    final StationProvider stationProvider = Provider.of(context);
    return initialPosition == null || stationProvider.dataFetched == false
        ? Center(
            child: CircularProgressIndicator(),
          )
        : GoogleMap(
            mapType: MapType.hybrid,
            initialCameraPosition: initialPosition,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            mapToolbarEnabled: true,
            onMapCreated: (GoogleMapController controller) {
              print("object");
              setMapPins(stationProvider);
              _controller.complete(controller);
            },
            markers: _markers,
          );
  }
}
