import 'package:waytech/enums/place_type.dart';

class Place {
  final int id;
  final String title;
  final double longitude;
  final double latitude;
  final PlaceType placeType;
  bool starred;

  Place({this.id, this.title, this.longitude, this.latitude, this.placeType, this.starred = false});
}