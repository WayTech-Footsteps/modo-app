import 'package:flutter/material.dart';

class TimelineStep {
  final String hour;
  final String message;
  final Duration breakTimeDuration;
  final IconData iconData;

  TimelineStep({
    this.hour,
    this.message,
    this.breakTimeDuration,
    this.iconData
  });


  bool get hasHour => hour != null && hour.isNotEmpty;
}