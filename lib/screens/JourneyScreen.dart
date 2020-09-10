import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:intl/intl.dart';

//import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:provider/provider.dart';
import 'package:waytech/models/Path.dart';
import 'package:waytech/models/TimeEntry.dart';
import 'package:waytech/providers/TimeEntryProvider.dart';
import 'package:waytech/providers/StationProvider.dart';
import 'package:waytech/widgets/MapIndicator.dart';
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
  List<TimeEntry> timeEntries = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<void> getTimeEntry(TimeEntryProvider timeEntryProvider) async {
    List<TimeEntry> fetchedTimeEntries = await timeEntryProvider.getTimeEntries(
        info["start"], info["end"], "11:35:00");

    print("FETCHED");
    print(fetchedTimeEntries);

    setState(() {
      timeEntries = fetchedTimeEntries;
    });
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
          Navigator.push(
              context,
              MaterialPageRoute(
                maintainState: true,
                builder: (context) => MapIndicator(
                  selectionEnabled: true,
                  onMarkerTapped: (result) {
                    fromController.text = result.title;
                    info["from"] = result.title;
                    info["start"] = result.id;
                  },
                ),
              ));

//          LocationResult result = await showLocationPicker(
//            context,
//            "AIzaSyDvBDqtpGE5l6IZdm52YIFAf0CSMfr6G6g",
//
//            myLocationButtonEnabled: true,
//            layersButtonEnabled: true,
//            countries: ['IR'],
//
//          );
//
//          fromController.text = result.address;
//
//          info["from"] = result.address;
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
            Navigator.push(
                context,
                MaterialPageRoute(
                  maintainState: true,
                  builder: (context) => MapIndicator(
                    selectionEnabled: true,
                    onMarkerTapped: (result) {
                      toController.text = result.title;
                      info["to"] = result.title;
                      info["end"] = result.id;
                    },
                  ),
                ));

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
    TimeEntryProvider timeEntryProvider =
        Provider.of<TimeEntryProvider>(context, listen: false);

    final stationProvider = Provider.of<StationProvider>(context);

    return SingleChildScrollView(
      child: Column(
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

                RaisedButton(
                  onPressed: () {
                    getTimeEntry(timeEntryProvider);
                    print(DateFormat('HH:mm:ss').format(DateTime.now()));
                  },
                  child: Text("find the Path"),
                ),

                // Timeline(
                //     children: timeLineModels, position: TimelinePosition.Center)

              Container(
                width: mediaSize.width * 0.9,
                child: ListView.builder(
                  physics: PageScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return index % 2 == 0
                        ? Wrap(
                      children: [
                        TimelineTile(
                          alignment: TimelineAlign.center,
                          hasIndicator: true,
                          lineX: 0.1,
                          isFirst: index == 0,
                          isLast: index == timeEntries.length - 1,
                          indicatorStyle: IndicatorStyle(
                            width: 40,
                            height: 40,
                            indicator:
                            index == 0 ? _Sun(type: Type.Start, number: '${timeEntries[index].lineNumber.toString()}',) : index == timeEntries.length - 1 ? _Sun(type: Type.End, number: '${timeEntries[index].lineNumber.toString()}',) : _IndicatorExample(number: '${timeEntries[index].lineNumber.toString()}'),
                            drawGap: true,
                          ),
                          topLineStyle: LineStyle(
                            color: Colors.blue.withOpacity(0.7),
                          ),
                          leftChild: Text(timeEntries[index].startLoc),
                        )
                      ],
                    )
                        : Wrap(
                      children: [
                      TimelineTile(
                      alignment: TimelineAlign.center,
                      hasIndicator: true,
                      lineX: 0.1,
                      isFirst: index == 0,
                      isLast: index == timeEntries.length - 1,
                      indicatorStyle: IndicatorStyle(
                        width: 40,
                        height: 40,
                        indicator: _IndicatorExample(number: '${timeEntries[index].lineNumber.toString()}'),
                        drawGap: true,
                      ),
                      topLineStyle: LineStyle(
                        color: Colors.blue.withOpacity(0.7)
                      ),
                      rightChild: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(timeEntries[index].startLoc),
                      ),
                    )
                      ],
                    );
                  },
                  itemCount: timeEntries.length,
                ),
              ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}



class _Sun extends StatelessWidget {
  final Type type;
  final String number;


  _Sun({this.type, this.number});

  @override
  Widget build(BuildContext context) {
    return type == Type.End ? Container(
      child: Center(
        child: Text(
          number,
          style: const TextStyle(fontSize: 20),
        ),
      ),
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.red,
            blurRadius: 15,
            spreadRadius: 10,
          ),
        ],
        shape: BoxShape.circle,
        color: Colors.red,
      ),
    ) : Container(
      child: Center(
        child: Text(
          number,
          style: const TextStyle(fontSize: 18),
        ),
      ),
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.green,
            blurRadius: 15,
            spreadRadius: 10,
          ),
        ],
        shape: BoxShape.circle,
        color: Colors.green,
      ),
    );
  }
}


