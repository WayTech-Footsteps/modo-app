import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:waytech/enums/MapMethod.dart';
import 'package:waytech/models/POI.dart';
import 'package:waytech/models/Station.dart';
import 'package:waytech/providers/POIProvider.dart';
import 'package:waytech/providers/StationProvider.dart';
import 'package:waytech/screens/JourneyScreen.dart';
import 'package:waytech/screens/tab_screen.dart';


class MapIndicator extends StatefulWidget {
  final bool selectionEnabled;
  final Function onMarkerTapped;
  final bool showPOIs;
  final bool showInfoWindow;
  final MapMethod mapMethod;
  final Function changeTab;
  final JourneyScreen journeyScreen;
  final Function changeJourneyInfo;
  MapIndicator({this.selectionEnabled, this.onMarkerTapped, this.showPOIs: false, this.showInfoWindow: false, this.mapMethod, this.changeTab, this.changeJourneyInfo, this.journeyScreen});

  @override
  _MapIndicatorState createState() => _MapIndicatorState();
}

class _MapIndicatorState extends State<MapIndicator> {
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = {};
  BitmapDescriptor pinLocationIcon;
  List<POI> placesOfInterest = [];
  final Map<String, Station> journeyInfo = {};

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

  Future getPOIs() async {
    final poiProvider = Provider.of<POIProvider>(context, listen: false);
    placesOfInterest = await poiProvider.getPOIs();
  }



  void setMapPins(StationProvider stationProvider) {
    setState(() {
      stationProvider.stations.forEach((station) {
        _markers.add(Marker(
          onTap: () {
            if (widget.mapMethod == MapMethod.OnJourney) {
              widget.onMarkerTapped(station);
              Navigator.of(context).pop();
            } else if (widget.mapMethod == MapMethod.OnMap) {
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
                            print("erfan is love");
                            print(journeyInfo);
                            widget.changeJourneyInfo(journeyInfo);
//                            widget.journeyScreen.();
                            widget.changeTab(2);
                          },
                          child: Text(
                              "Choose as Origin"
                          ),
                        ),

                        RaisedButton(
                          color: Theme.of(context).primaryColor,
                          onPressed: () {
                            journeyInfo["end"] = station;
                            widget.changeJourneyInfo(journeyInfo);
                            widget.changeTab(2);
                          },
                          child: Text(
                            "Choose as Destination"
                          ),
                        )
                      ],
                    ),

                  )
              );
            }
            print("stat info");
            print(station.longitude);
            print(station.latitude);
          },
          markerId: MarkerId("station" + station.id.toString()),
          position: LatLng(station.longitude, station.latitude),
          infoWindow: widget.mapMethod == MapMethod.OnMap ? InfoWindow(
            title: station.title
          ) : InfoWindow(),
          icon: pinLocationIcon,));
      });

      if (widget.mapMethod == MapMethod.OnMap) {
        placesOfInterest.forEach((poi) {
          _markers.add(Marker(
              markerId: MarkerId("poi" + poi.id.toString()),
              position: LatLng(poi.longitude, poi.latitude),
              infoWindow: widget.mapMethod == MapMethod.OnMap ? InfoWindow(
                  title: poi.title
              ) : InfoWindow(),
              icon: BitmapDescriptor.defaultMarker));
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
        ImageConfiguration(devicePixelRatio: 16/9, size: Size(50, 50)),
        'lib/assets/bus-stop.png').then((onValue) {
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
