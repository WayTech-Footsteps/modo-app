import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:waytech/models/POI.dart';
import 'package:waytech/server_config/server_config.dart';

class POIProvider with ChangeNotifier {


  Future<List<POI>> getPOIs() async {
    final response = await http.get(
      ServerConfig.GetPOIs,
      headers: {
        'Content-type': 'application/json',
      },
    );


    List<Map<String, dynamic>> placesOfInterest = List<Map<String, dynamic>>.from(json.decode(response.body));

    List<POI> convertedPOIs = [];

    placesOfInterest.forEach((poi) {
      convertedPOIs.add(POI.fromJson(poi));
    });




    return convertedPOIs;
  }
}