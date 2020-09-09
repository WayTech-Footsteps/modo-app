import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

//import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:provider/provider.dart';
import 'package:waytech/models/Path.dart';
import 'package:waytech/providers/PathProvider.dart';
import 'package:waytech/providers/StationProvider.dart';
import 'package:waytech/widgets/input_field.dart';
import 'package:waytech/widgets/near_station_tile.dart';

class JourneyScreen extends StatefulWidget {
  @override
  _JourneyScreenState createState() => _JourneyScreenState();
}

class _JourneyScreenState extends State<JourneyScreen> {
  final Map<String, dynamic> info = {};
  TextEditingController fromController = TextEditingController();
  TextEditingController toController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> inputTiles = [
      InputField(
        onSaved: (v) {
          info["from"] = v;
        },
        validator: null,
        suffixIcon: Icon(Icons.map),
        isDone: true,
        label: "From",
        controller: fromController,
        actionFunction: () async {
          LocationResult result = await showLocationPicker(
            context,
            "AIzaSyDvBDqtpGE5l6IZdm52YIFAf0CSMfr6G6g",
            myLocationButtonEnabled: true,
            layersButtonEnabled: true,
            countries: ['IR'],

          );

          fromController.text = result.address;

          info["from"] = result.address;

        },
      ),
      InputField(
          onSaved: (v) {
            info["to"] = v;
          },
          controller: toController,
          validator: null,
          suffixIcon: Icon(Icons.map),
          actionFunction: () async {
            LocationResult result = await showLocationPicker(
              context,
              "AIzaSyDvBDqtpGE5l6IZdm52YIFAf0CSMfr6G6g",
              myLocationButtonEnabled: true,
              layersButtonEnabled: true,
              countries: ['IR'],
            );

            toController.text = result.address;

            info["to"] = result.address;

//            Navigator.push(
//              context,
//              MaterialPageRoute(
//                builder: (context) => PlacePicker(
//                  apiKey: "AIzaSyDvBDqtpGE5l6IZdm52YIFAf0CSMfr6G6g",   // Put YOUR OWN KEY here.
//                  desiredLocationAccuracy: LocationAccuracy.high,
//
//                  onPlacePicked: (result) {
//                    Navigator.of(context).pop();
//                  },
//                  initialPosition: LatLng(29.642269, 52.517159),
//                  useCurrentLocation: true,
//
//                ),
//              )
//            );
          },
          label: "To"),
    ];

    final mediaSize = MediaQuery.of(context).size;
    PathProvider pathProvider =
        Provider.of<PathProvider>(context, listen: false);

    final stationProvider = Provider.of<StationProvider>(context);

    List<Path> paths = [];

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
                width: mediaSize.width * 0.9,
                child: ListView.builder(
                  physics: PageScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) => Container(
                    color: Colors.blue.withOpacity(0.4),
                    child: ListTile(
                      leading: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.subdirectory_arrow_left),
                          SizedBox(
                            width: 2.0,
                          ),
                          Text(paths[index].start.title),
                        ],
                      ),
                      title: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.subdirectory_arrow_right),
                          SizedBox(
                            width: 2.0,
                          ),
                          Text(paths[index].end.title),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.access_time),
                          SizedBox(
                            width: 2.0,
                          ),
                          Text("${paths[index].weight} min"),
                        ],
                      ),
                    ),
                  ),
                  itemCount: paths.length,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
