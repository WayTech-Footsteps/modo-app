import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:waytech/providers/PlaceProvider.dart';
import 'file:///D:/Mobile%20App/waytech-app/lib/widgets/near_station_tile.dart';

class FavoritesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final placeProvider = Provider.of<PlaceProvider>(context);
    return ListView.builder(
      itemBuilder: (context, index) => placeProvider.places[index].starred ? NearStationTile(
        place: placeProvider.places[index],
      ) : Container(),

      itemCount: placeProvider.places.where((element) => element.starred).toList().length,
    );
  }
}
