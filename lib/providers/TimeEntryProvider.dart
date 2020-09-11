import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:waytech/models/Path.dart';
import 'package:http/http.dart' as http;
import 'package:waytech/models/TimeEntry.dart';
import 'package:waytech/server_config/server_config.dart';

class TimeEntryProvider with ChangeNotifier {
  Future<List<TimeEntry>> getTimeEntries(int startId, endId, String time) async {
    final response = await http.post(
      ServerConfig.PathFinder,
      body: json.encode({
        "start": startId,
        "end": endId,
        "time": time,
      }),
      headers: {
        'Content-type': 'application/json',
      },
    );


    List<Map<String, dynamic>> timeEntries = List<Map<String, dynamic>>.from(json.decode(response.body));

    List<TimeEntry> convertedTimeEntries = [];

    timeEntries.forEach((timeEntry) {
      convertedTimeEntries.add(TimeEntry.fromJson(timeEntry));
    });

    TimeEntry finalTimeEntry;
    if (convertedTimeEntries.isNotEmpty) {
      TimeEntry lastEntry = convertedTimeEntries[convertedTimeEntries.length - 1];
      finalTimeEntry = TimeEntry(
        startLoc: lastEntry.endLoc,
        lineNumber: lastEntry.lineNumber,
        arrivalTime: lastEntry.arrivalTime
      );

      convertedTimeEntries.add(finalTimeEntry);

    }



    return convertedTimeEntries;
  }

  Future<List<TimeEntry>> getIncomingLines(int stationId, String time) async {
    final response = await http.post(
      ServerConfig.IncomingLines,
      body: json.encode({
        "station": stationId,
        "time": time,
      }),
      headers: {
        'Content-type': 'application/json',
      },
    );


    List<Map<String, dynamic>> incomingLinesEntries = List<Map<String, dynamic>>.from(json.decode(response.body));

    List<TimeEntry> convertedLineEntries = [];

    incomingLinesEntries.forEach((timeEntry) {
      convertedLineEntries.add(TimeEntry.fromJson(timeEntry));
    });




    return convertedLineEntries;
  }




}
