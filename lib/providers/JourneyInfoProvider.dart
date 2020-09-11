import 'package:flutter/foundation.dart';
import 'package:waytech/models/Station.dart';

class JourneyInfoProvider with ChangeNotifier {
  Map<String, Station> journeyInfo = {};

  void addJourneyInfo(Map<String, Station> info) {
    journeyInfo = info;
    notifyListeners();
  }
}