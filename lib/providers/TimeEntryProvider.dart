import 'dart:convert';

import 'package:flutter/material.dart';
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

    print(response.body);

    List<Map<String, dynamic>> timeEntries = List<Map<String, dynamic>>.from(json.decode(response.body));

    List<TimeEntry> convertedTimeEntries = [];

    timeEntries.forEach((timeEntry) {
      convertedTimeEntries.add(TimeEntry.fromJson(timeEntry));
    });

    print("converted");
    print(convertedTimeEntries);

    return convertedTimeEntries;



  }
}
