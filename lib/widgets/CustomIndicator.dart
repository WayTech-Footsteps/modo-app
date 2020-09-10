import 'package:flutter/material.dart';
import 'package:waytech/enums/TimeEntryType.dart';

class CustomIndicator extends StatelessWidget {
  final TimeEntryType timeEntryType;
  final String number;

  const CustomIndicator({Key key, this.number, this.timeEntryType}) : super(key: key);



  Widget _buildIndicator(BuildContext context) {
    Widget indicator;
    if (timeEntryType == TimeEntryType.Start) {
      indicator = Container(
        child: Center(
          child: Text(
            number,
            style: const TextStyle(fontSize: 20),
          ),
        ),
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.red,
              blurRadius: 15,
              spreadRadius: 10,
            ),
          ],
          shape: BoxShape.circle,
          color: Colors.red,
        ),
      );
    } else if (timeEntryType == TimeEntryType.Middle) {
      indicator = Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).primaryColor,
        ),
        child: Center(
          child: Text(
            number,
            style: const TextStyle(fontSize: 20),
          ),
        ),
      );
    } else if (timeEntryType == TimeEntryType.End) {
      indicator = Container(
        child: Center(
          child: Text(
            number,
            style: const TextStyle(fontSize: 18),
          ),
        ),
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.green,
              blurRadius: 15,
              spreadRadius: 10,
            ),
          ],
          shape: BoxShape.circle,
          color: Colors.green,
        ),
      );
    }

    return indicator;
  }

  @override
  Widget build(BuildContext context) {
    return _buildIndicator(context);
  }
}