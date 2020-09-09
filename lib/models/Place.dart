
import 'package:waytech/enums/place_type.dart';

abstract class Place {
  final int id;
  final String title;
  final double longitude;
  final double latitude;

  Place({this.id, this.title, this.longitude, this.latitude});

}