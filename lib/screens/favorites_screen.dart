import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:waytech/providers/StationProvider.dart';
import 'file:///D:/Mobile%20App/waytech-app/lib/widgets/near_station_tile.dart';

class FavoritesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final stationProvider = Provider.of<StationProvider>(context);
    return FutureBuilder(
      future: stationProvider.getFavorites(),
      builder: (context, snapshot) =>
          snapshot.connectionState == ConnectionState.waiting
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.builder(
                  itemBuilder: (context, index) => NearStationTile(
                        station: snapshot.data[index],
                      ),
                  itemCount: snapshot.data.length),
    );
  }
}
