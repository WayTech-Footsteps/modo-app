import 'package:flutter/material.dart';

class TimelineStep {
  final String departureTime;
  final String arrivalTime;
  final String message;
  final Duration breakTimeDuration;
  final IconData breakTimeIcon;
  final IconData departureIcon;
  final IconData arrivalIcon;


  TimelineStep(
      {this.departureTime, this.arrivalTime, this.message, this.breakTimeDuration, this.breakTimeIcon, this.departureIcon, this.arrivalIcon});

  bool get hasHour => departureTime != null && departureTime.isNotEmpty;
}
