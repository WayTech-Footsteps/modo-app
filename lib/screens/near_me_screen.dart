import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:waytech/providers/StationProvider.dart';
import 'file:///D:/Mobile%20App/waytech-app/lib/widgets/near_station_tile.dart';

class NearMeScreen extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    final stationProvider = Provider.of<StationProvider>(context, listen: false);
    return FutureBuilder(
        future: stationProvider.getStations(),
        builder: (context, snapshot) => snapshot.connectionState == ConnectionState.waiting ? Center(
          child: CircularProgressIndicator(),) : ListView.builder(
          itemBuilder: (context, index) =>
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: NearStationTile(
                    station: snapshot.data[index],)
              ),
          itemCount: snapshot.data.length,
        ),
    );
  }
}
