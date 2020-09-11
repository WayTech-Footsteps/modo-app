import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:intl/intl.dart';

//import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:provider/provider.dart';
import 'package:waytech/enums/TimeEntryType.dart';
import 'package:waytech/models/Path.dart';
import 'package:waytech/models/TimeEntry.dart';
import 'package:waytech/models/TimelineStep.dart';
import 'package:waytech/providers/TimeEntryProvider.dart';
import 'package:waytech/providers/StationProvider.dart';
import 'package:waytech/widgets/CustomIndicator.dart';
import 'package:waytech/widgets/MapIndicator.dart';
import 'package:waytech/widgets/TimelineChild.dart';
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

  final RoundedLoadingButtonController _btnController =
      new RoundedLoadingButtonController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<void> getTimeEntry(TimeEntryProvider timeEntryProvider) async {
    List<TimeEntry> fetchedTimeEntries = await timeEntryProvider.getTimeEntries(
        info["start"], info["end"], "11:35:00");

    _btnController.reset();

    print("FETCHED");
    print(fetchedTimeEntries);

    setState(() {
      timeEntries = fetchedTimeEntries;
    });
  }

  Duration calculateBreakTime(
      String previousArrivalTime, String currentDepartureTime) {
    DateTime prevArrTime = DateFormat('HH:mm:ss').parse(previousArrivalTime);
    DateTime currDepTime = DateFormat('HH:mm:ss').parse(currentDepartureTime);

    print(previousArrivalTime + currentDepartureTime);

    Duration breakTimeDuration = currDepTime.difference(prevArrTime);

    print("diff: " +
        breakTimeDuration.inMinutes.toString() +
        " " +
        breakTimeDuration.inSeconds.toString());
    return breakTimeDuration;
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> inputTiles = [
      InputField(
        onSaved: (v) {
          info["from"] = v;
        },
        readOnly: true,
        validator: null,
        suffixIcon: Icon(Icons.map),
        isDone: true,
        label: "From",
        controller: fromController,
        actionFunction: () async {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Scaffold(
                        appBar: AppBar(
                          title: Text("Choose Origin..."),
                        ),
                        body: MapIndicator(
                          selectionEnabled: true,
                          onMarkerTapped: (result) {
                            fromController.text = result.title;
                            info["from"] = result.title;
                            info["start"] = result.id;
                          },
                          showPOIs: false,
                        ),
                      )));

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
          readOnly: true,
          controller: toController,
          validator: null,
          suffixIcon: Icon(Icons.map),
          actionFunction: () async {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Scaffold(
                          appBar: AppBar(
                            title: Text("Choose Destination..."),
                          ),
                          body: MapIndicator(
                            selectionEnabled: true,
                            onMarkerTapped: (result) {
                              toController.text = result.title;
                              info["to"] = result.title;
                              info["end"] = result.id;
                            },
                            showPOIs: false,
                          ),
                        )));

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

                RoundedLoadingButton(
                  borderRadius: 5,
                  controller: _btnController,
                  onPressed: () => getTimeEntry(timeEntryProvider),
                  elevation: 5,
                  child: Text(
                    "Find the Journey",
                    style: Theme.of(context).textTheme.button,
                  ),
                ),

//                RaisedButton(
//                  onPressed: () {
//                    getTimeEntry(timeEntryProvider);
//                    print(DateFormat('HH:mm:ss').format(DateTime.now()));
//                  },
//                  child: Text("find the Path"),
//                ),

                // Timeline(
                //     children: timeLineModels, position: TimelinePosition.Center)

                Container(
                  width: mediaSize.width * 0.9,
                  child: ListView.builder(
                    physics: PageScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return TimelineTile(
                          alignment: TimelineAlign.center,
                          hasIndicator: true,
                          lineX: 0.1,
                          isFirst: index == 0,
                          isLast: index == timeEntries.length - 1,
                          indicatorStyle: IndicatorStyle(
                            width: 40,
                            height: 40,
                            indicator: CustomIndicator(
                              timeEntryType: TimeEntryType.Start,
                              number:
                                  '${timeEntries[index].lineNumber.toString()}',
                            ),
                            drawGap: true,
                          ),
                          topLineStyle: LineStyle(
                            color: Colors.blue.withOpacity(0.7),
                          ),
                          leftChild: Text(
                            timeEntries[index].startLoc,
                            style: TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          rightChild: TimelineChild(
                            type: TimeEntryType.Start,
                            step: TimelineStep(
                              departureIcon: Icons.departure_board,
                              departureTime: timeEntries[index].departureTime,
                            ),
                          ),
                        );
                      } else if (index == timeEntries.length - 1) {
                        return TimelineTile(
                          alignment: TimelineAlign.center,
                          hasIndicator: true,
                          lineX: 0.1,
                          isFirst: index == 0,
                          isLast: index == timeEntries.length - 1,
                          indicatorStyle: IndicatorStyle(
                            width: 40,
                            height: 40,
                            indicator: CustomIndicator(
                              timeEntryType: TimeEntryType.End,
                              number:
                                  '${timeEntries[index].lineNumber.toString()}',
                            ),
                            drawGap: true,
                          ),
                          topLineStyle: LineStyle(
                            color: Colors.blue.withOpacity(0.7),
                          ),
                          leftChild: Text(
                            timeEntries[index].startLoc,
                            style: TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          rightChild: TimelineChild(
                            type: TimeEntryType.End,
                            step: TimelineStep(
                              arrivalIcon: Icons.access_time,
                              arrivalTime: timeEntries[index - 1].arrivalTime,
                            ),
                          ),
                        );
                      } else {
                        return TimelineTile(
                          alignment: TimelineAlign.center,
                          hasIndicator: true,
                          lineX: 0.1,
                          isFirst: index == 0,
                          isLast: index == timeEntries.length - 1,
                          indicatorStyle: IndicatorStyle(
                            width: 40,
                            height: 40,
                            indicator: CustomIndicator(
                              timeEntryType: TimeEntryType.Middle,
                              number:
                                  '${timeEntries[index].lineNumber.toString()}',
                            ),
                            drawGap: true,
                          ),
                          topLineStyle: LineStyle(
                            color: Colors.blue.withOpacity(0.7),
                          ),
                          leftChild: Text(
                            timeEntries[index].startLoc,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          rightChild: TimelineChild(
                            type: TimeEntryType.Middle,
                            step: TimelineStep(
                              breakTimeDuration: calculateBreakTime(
                                timeEntries[index - 1].arrivalTime,
                                timeEntries[index].departureTime,
                              ),
                              breakTimeIcon: Icons.local_cafe,
                              departureIcon: Icons.departure_board,
                              departureTime: timeEntries[index].departureTime,
                              arrivalIcon: Icons.access_time,
                              arrivalTime: timeEntries[index - 1].arrivalTime,
                            ),
                          ),
                        );
                      }
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
