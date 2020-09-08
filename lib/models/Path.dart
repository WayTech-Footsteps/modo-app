import 'package:flutter/material.dart';
import 'package:waytech/models/Place.dart';

class Path with ChangeNotifier {
  final Place start;
  final Place end;
  final double weight;

  Path({this.start, this.end, this.weight});

}