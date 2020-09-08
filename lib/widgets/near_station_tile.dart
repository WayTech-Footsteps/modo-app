import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:timeline_list/timeline_model.dart';
import 'package:waytech/models/Place.dart';
import 'package:waytech/providers/PlaceProvider.dart';

class NearStationTile extends StatefulWidget {
  final Place place;


  NearStationTile({this.place});

  @override
  _NearStationTileState createState() => _NearStationTileState();
}

class _NearStationTileState extends State<NearStationTile> {
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Container(
        child: Row(
          children: [
            Icon(FontAwesomeIcons.bus),
            SizedBox(width: 20.0,),
            Text(widget.place.title),
          ],
        ),
      ),
      trailing: Container(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.near_me),
                SizedBox(height: 5.0,),
                Text("312 m")
              ],
            ),


            Consumer<PlaceProvider>(
              builder: (context, place, child) => IconButton(
                icon: Icon(widget.place.starred ? Icons.favorite : Icons.favorite_border, color: Colors.red,),
                onPressed: () {
                  place.toggleFavorite(widget.place.id);
                },
              ),
            )
          ],
        ),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            leading: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.red,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("21"),
              ),
            ),

            title: Text("Library"),
            trailing: Text(DateFormat('HH:mm').format(DateTime.now())),
          )
        )
      ],
    );
  }
}
