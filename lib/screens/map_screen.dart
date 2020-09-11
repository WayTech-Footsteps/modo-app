import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:waytech/enums/MapMethod.dart';
import 'package:waytech/providers/StationProvider.dart';
import 'package:waytech/screens/JourneyScreen.dart';
import 'package:waytech/widgets/MapIndicator.dart';

class MapScreen extends StatelessWidget {
  final Function changeTab;
  final Function changeJourneyInfo;
  final JourneyScreen journeyScreen;


  MapScreen({this.changeTab, this.changeJourneyInfo, this.journeyScreen});

  @override
  Widget build(BuildContext context) {
    return MapIndicator(
      selectionEnabled: false,
      onMarkerTapped: () => {},
      showPOIs: true,
      showInfoWindow: true,
      mapMethod: MapMethod.OnMap,
      changeTab: changeTab,
      changeJourneyInfo: changeJourneyInfo,
      journeyScreen: journeyScreen,
    );
  }
}
