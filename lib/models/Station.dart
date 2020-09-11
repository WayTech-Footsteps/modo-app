import 'package:waytech/models/Place.dart';
import 'package:waytech/models/TimeEntry.dart';

class Station extends Place {
  bool starred;
  double distance;
  List<TimeEntry> incomingLines = [];

  Station(
      {id, title, longitude, latitude, this.starred: false, this.incomingLines})
      : super(id: id, title: title, longitude: longitude, latitude: latitude);

  factory Station.fromJson(Map<String, dynamic> parsedJson) {
    return Station(
        id: parsedJson['id'] as int,
        title: parsedJson['title'] as String,
        latitude: double.parse(parsedJson['latitude']),
        longitude: double.parse(parsedJson['longitude']));
  }

  Map<String, dynamic> toJson() {
    return {
      "id": this.id,
      "title": this.title,
      "longitude": this.longitude,
      "latitude": this.latitude,
      "starred": this.starred
    };
  }
}
