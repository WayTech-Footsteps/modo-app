import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:waytech/models/Station.dart';
import 'package:waytech/providers/LocationProvider.dart';
import 'package:waytech/providers/StationProvider.dart';
import 'file:///D:/Mobile%20App/waytech-app/lib/widgets/near_station_tile.dart';

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
    print(locationProvider.currentMapLocation.latitude);
    print(locationProvider.currentMapLocation.longitude);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final locationProvider =
        Provider.of<LocationProvider>(context, listen: false);
    final stationProvider =
        Provider.of<StationProvider>(context, listen: false);
    return FutureBuilder(
      future: stationProvider.getStations(context),
      builder: (context, snapshot) =>
          snapshot.connectionState == ConnectionState.waiting ||
                  locationProvider.currentMapLocation == null
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.builder(
                  itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: NearStationTile(
                        station: snapshot.data[index],
                      )),
                  itemCount: snapshot.data.length,
                ),
    );
  }
}
