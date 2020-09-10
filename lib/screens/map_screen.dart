import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:waytech/providers/StationProvider.dart';
import 'package:waytech/widgets/MapIndicator.dart';

class MapScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MapIndicator(
      selectionEnabled: false,
      onMarkerTapped: () => {},
    );
  }
}
