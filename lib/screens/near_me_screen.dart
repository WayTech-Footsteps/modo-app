import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:waytech/providers/PlaceProvider.dart';
import 'file:///D:/Mobile%20App/waytech-app/lib/widgets/near_station_tile.dart';

class NearMeScreen extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    final placeProvider = Provider.of<PlaceProvider>(context);
    return ListView.builder(
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: NearStationTile(place: placeProvider.places[index],)
      ),
      itemCount: placeProvider.places.length,
    );
  }
}
