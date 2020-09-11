import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:waytech/models/POI.dart';
import 'package:waytech/models/Station.dart';
import 'package:waytech/providers/JourneyInfoProvider.dart';
import 'package:waytech/providers/POIProvider.dart';
import 'package:waytech/providers/StationProvider.dart';

class MapIndicator extends StatefulWidget {
  final bool selectionEnabled;
  final Function onMarkerTapped;
  final bool showPOIs;
  final bool showInfoWindow;
  final bool onMap;
  final Function changeTab;

  MapIndicator(
      {this.selectionEnabled, this.onMarkerTapped, this.showPOIs: false, this.showInfoWindow: false, this.onMap: false, this.changeTab});

  @override
  _MapIndicatorState createState() => _MapIndicatorState();
}

class _MapIndicatorState extends State<MapIndicator> {
  GoogleMapController _controller;
  Set<Marker> _markers = {};
  BitmapDescriptor pinLocationIcon;
  List<POI> placesOfInterest = [];
  Map<String, Station> journeyInfo = {};
  CameraPosition initialPosition;
  var location = new Location();
  LocationData currentMapLocation;
  String _mapStyle;

  Future _getLocation() async {
    try {
      location.onLocationChanged.listen((LocationData currentLocation) {
        currentMapLocation = currentLocation;
        if (this.mounted) {
          setState(() {
            initialPosition = CameraPosition(
                target:
                    LatLng(currentLocation.latitude, currentLocation.longitude),
                zoom: 14.567);
          });
        }

        return LatLng(currentLocation.latitude, currentLocation.longitude);
      });
    } catch (e) {
      initialPosition = null;
    }
  }

  Future getPOIs() async {
    final poiProvider = Provider.of<POIProvider>(context, listen: false);
    placesOfInterest = await poiProvider.getPOIs();
  }

  void setMapPins(StationProvider stationProvider, JourneyInfoProvider journeyProvider) {
    setState(() {
      stationProvider.stations.forEach((station) {
        _markers.add(Marker(
          onTap: () {
            if (widget.selectionEnabled) {
              widget.onMarkerTapped(station);
              Navigator.of(context).pop();
            } else if (widget.onMap) {
              showModalBottomSheet(
                  context: context,
                  builder: (ctx) => Container(
                    height: 200,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RaisedButton(
                          color: Theme.of(context).primaryColor,
                          onPressed: () {
                            journeyInfo["start"] = station;
                            journeyProvider.addJourneyInfo(journeyInfo);
                            Navigator.of(context).pop();
                            widget.changeTab(2);
                          },
                          child: Text(
                              "Choose as Origin",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),

                        RaisedButton(
                          color: Theme.of(context).primaryColor,
                          onPressed: () {
                            journeyInfo["end"] = station;
                            journeyProvider.addJourneyInfo(journeyInfo);
                            Navigator.of(context).pop();
                            widget.changeTab(2);
                          },
                          child: Text(
                              "Choose as Destination",
                            style: TextStyle(color: Colors.black),
                          ),
                        )
                      ],
                    ),

                  )
              );
            }
          },
          infoWindow: widget.showInfoWindow ? InfoWindow(
            title: station.title
          ) : InfoWindow(),
          markerId: MarkerId("station" + station.id.toString()),
          position: LatLng(station.longitude, station.latitude),
          icon: pinLocationIcon,
        ));
      });

      if (widget.showPOIs) {
        placesOfInterest.forEach((poi) {
          _markers.add(Marker(
              markerId: MarkerId("poi" + poi.id.toString()),
              position: LatLng(poi.longitude, poi.latitude),
              infoWindow: widget.showInfoWindow ? InfoWindow(
                  title: poi.title
              ) : InfoWindow(),
              icon: BitmapDescriptor.defaultMarkerWithHue(42)));
        });
      }

      // destination pin
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getLocation();
    getPOIs();
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(devicePixelRatio: 16 / 9, size: Size(50, 50)),
            'lib/assets/bus_stop_yellow.png')
        .then((onValue) {
      pinLocationIcon = onValue;
    });
    rootBundle.loadString('lib/assets/map_style.txt').then((string) {
      _mapStyle = string;
    });
  }

  @override
  Widget build(BuildContext context) {
    final StationProvider stationProvider = Provider.of(context);
    final journeyProvider = Provider.of<JourneyInfoProvider>(context);
    return initialPosition == null || stationProvider.dataFetched == false
        ? Center(
            child: CircularProgressIndicator(),
          )
        : GoogleMap(
            initialCameraPosition: initialPosition,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            mapToolbarEnabled: true,
            onMapCreated: (GoogleMapController controller) {
              setMapPins(stationProvider, journeyProvider);
              _controller = controller;
              setState(() {
                _controller.setMapStyle(_mapStyle);
              });
            },
            markers: _markers,
          );
  }
}
