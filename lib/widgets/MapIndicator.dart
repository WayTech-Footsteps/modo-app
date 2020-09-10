import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:waytech/providers/StationProvider.dart';

class MapIndicator extends StatefulWidget {
  final bool selectionEnabled;
  final Function onMarkerTapped;


  MapIndicator({this.selectionEnabled, this.onMarkerTapped});

  @override
  _MapIndicatorState createState() => _MapIndicatorState();
}

class _MapIndicatorState extends State<MapIndicator> {
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = {};
  BitmapDescriptor pinLocationIcon;

  CameraPosition initialPosition;
  var location = new Location();
  LocationData currentMapLocation;

  Future _getLocation() async {
    try {
      location.onLocationChanged.listen((LocationData currentLocation) {
        print('Latitude:${currentLocation.latitude}');
        print('Longitude:${currentLocation.longitude}');
        currentMapLocation = currentLocation;
        if (this.mounted) {
          setState(() {
            initialPosition = CameraPosition(
                target: LatLng(currentLocation.latitude, currentLocation.longitude),
                zoom: 14.567);
          });
        }


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
          onTap: () {
            if (widget.selectionEnabled) {
              widget.onMarkerTapped(station);
              Navigator.of(context).pop();
            }
            print("stat info");
            print(station.longitude);
            print(station.latitude);
          },
          markerId: MarkerId(station.id.toString()),
          position: LatLng(station.longitude, station.latitude),
          icon: pinLocationIcon,));
      });

      // destination pin
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getLocation();
    BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 16/9, size: Size(50, 50)),
        'lib/assets/splash_icon.png').then((onValue) {
      pinLocationIcon = onValue;
    });
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
