import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:waytech/providers/StationProvider.dart';
import '../widgets/near_station_tile.dart';

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
              : snapshot.data.isEmpty ? Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border, size: 70.0),
                  SizedBox(height: 20,),
                  Text("No Favorites Added", style: TextStyle(fontSize: 25.0),),
                ],
              )) : ListView.builder(
                  itemBuilder: (context, index) => NearStationTile(
                        station: snapshot.data[index],
                      ),
                  itemCount: snapshot.data.length),
    );
  }
}
