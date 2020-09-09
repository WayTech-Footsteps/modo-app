import 'package:waytech/models/Place.dart';

class Station extends Place {
  bool starred;

  Station({id, title, longitude, latitude, this.starred: false})
      : super(id: id, title: title, longitude: longitude, latitude: latitude);

  factory Station.fromJson(Map<String, dynamic> parsedJson) {
    return new Station(
        id: parsedJson['id'] ?? "",
        title: parsedJson['title'] ?? "",
        longitude: parsedJson['longitude'] ?? "",
        latitude: parsedJson['latitude'] ?? "",
        starred: parsedJson['starred'] ?? "");
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
