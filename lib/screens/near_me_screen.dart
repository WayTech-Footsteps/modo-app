import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:waytech/models/Station.dart';
import 'package:waytech/providers/LocationProvider.dart';
import 'package:waytech/providers/StationProvider.dart';
import 'package:waytech/widgets/StationList.dart';
import '../widgets/near_station_tile.dart';

class NearMeScreen extends StatefulWidget {
  @override
  _NearMeScreenState createState() => _NearMeScreenState();
}

class _NearMeScreenState extends State<NearMeScreen> {
  @override
  void didChangeDependencies() async {
    final locationProvider =
        Provider.of<LocationProvider>(context, listen: false);
    await locationProvider.getLocation();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final locationProvider =
        Provider.of<LocationProvider>(context, listen: false);
    final stationProvider =
        Provider.of<StationProvider>(context, listen: false);
    return RefreshIndicator(
      child: FutureBuilder(
        future: stationProvider.getStations(context),
        builder: (context, snapshot) =>
        snapshot.connectionState == ConnectionState.waiting ||
            locationProvider.currentMapLocation == null
            ? Center(
          child: CircularProgressIndicator(),
        )
            : StationList(),
      ),
      onRefresh: () => stationProvider.getStations(context),
    );
  }
}
