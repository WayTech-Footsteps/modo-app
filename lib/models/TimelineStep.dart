class TimelineStep {
  final String hour;
  final String message;
  final int duration;

  TimelineStep({
    this.hour,
    this.message,
    this.duration,
  });


  bool get hasHour => hour != null && hour.isNotEmpty;
}