import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:waytech/models/Station.dart';
import 'package:waytech/providers/StationProvider.dart';

class NearStationTile extends StatefulWidget {
  final Station station;

  NearStationTile({this.station});

  @override
  _NearStationTileState createState() => _NearStationTileState();
}

class _NearStationTileState extends State<NearStationTile> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).copyWith(dividerColor: Colors.transparent);

    return Theme(
      data: theme,
      child: ExpansionTile(
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.directions_bus,
                color: Theme.of(context).primaryColor,
              ),
              SizedBox(
                width: 20.0,
              ),
              FittedBox(
                  fit: BoxFit.contain,
                  child: Container(
                    child: Text(
                      widget.station.title,
                      textAlign: TextAlign.center,
                    ),
                    width: 140.0,
                  )),
            ],
          ),
          trailing: Container(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.near_me, color: Theme.of(context).primaryColor),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      widget.station.distance >= 1.0
                          ? "${widget.station.distance.toString()} km"
                          : "${(widget.station.distance * 1000).toString()} m",
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    )
                  ],
                ),
                Consumer<StationProvider>(
                  builder: (context, station, child) => IconButton(
                    icon: Icon(
                      widget.station.starred
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: Theme.of(context).primaryColor,
                    ),
                    onPressed: () async {
                      station.toggleFavorite(widget.station.id);
                    },
                  ),
                )
              ],
            ),
          ),
          children: widget.station.incomingLines
              .map((e) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Container(
                    color: Colors.white10,
                    child: ListTile(
                      leading: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).primaryColor,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            e.lineNumber.toString(),
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                      title: Text(e.startLoc),
                      trailing: Text(e.arrivalTime),
                    ),
                  )))
              .toList()),
    );
  }
}
