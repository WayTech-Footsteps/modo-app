import 'package:waytech/models/Place.dart';

class POI extends Place {

  POI({id, title, longitude, latitude})
      : super(id: id, title: title, longitude: longitude, latitude: latitude);

  factory POI.fromJson(Map<String, dynamic> parsedJson) {
    return POI(
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
    };
  }
}