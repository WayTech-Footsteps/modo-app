import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:waytech/providers/PlaceProvider.dart';
import 'package:waytech/widgets/input_field.dart';
import 'package:waytech/widgets/near_station_tile.dart';

class JourneyScreen extends StatelessWidget {
  final Map<String, dynamic> info = {};

  @override
  Widget build(BuildContext context) {
    final List<Widget> inputTiles = [
      InputField(
          onSaved: (v) {
            info["from"] = v;
          },
          validator: null,
          suffixIcon: Icon(Icons.map),
          label: "From"),
      InputField(
          onSaved: (v) {
            info["to"] = v;
          },
          validator: null,
          suffixIcon: Icon(Icons.map),
          label: "To"),
    ];

    final mediaSize = MediaQuery.of(context).size;
    final placeProvider = Provider.of<PlaceProvider>(context);

    return Column(
      children: [
        Center(
          // wrap this with single child scroll view
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                width: mediaSize.width * 0.9,
                child: ListView.builder(
                  physics: PageScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) => Container(
                      margin: EdgeInsets.symmetric(vertical: 5),
                      child: inputTiles[index]),
                  itemCount: inputTiles.length,
                ),
              ),

              Container(
                child: ListView.builder(
                  physics: PageScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) => NearStationTile(
                      place: placeProvider.places[index],),
                  itemCount: inputTiles.length,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
