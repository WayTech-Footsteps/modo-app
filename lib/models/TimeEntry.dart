class TimeEntry {
  final int id;
  final String startLoc;
  final String endLoc;
  final String arrivalTime;
  final String departureTime;
  final int lineNumber;

  TimeEntry(
      {this.id,
      this.startLoc,
      this.endLoc,
      this.arrivalTime,
      this.departureTime,
      this.lineNumber});

  factory TimeEntry.fromJson(Map<String, dynamic> parsedJson) {
    return TimeEntry(
        id: parsedJson['id'] as int,
        startLoc: parsedJson['from_station'] as String,
        endLoc: parsedJson['to_station'] as String,
        arrivalTime: parsedJson['arr_time'] as String,
        departureTime: parsedJson['dep_time'] as String,
        lineNumber: parsedJson['line'] as int
    );
  }

//  Map<String, dynamic> toJson() {
//    return {
//      "id": this.id,
//      "title": this.title,
//      "longitude": this.longitude,
//      "latitude": this.latitude,
//      "starred": this.starred
//    };
//  }
}