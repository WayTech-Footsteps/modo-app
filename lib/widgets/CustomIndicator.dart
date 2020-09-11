import 'package:flutter/material.dart';
import 'package:waytech/enums/TimeEntryType.dart';

class CustomIndicator extends StatelessWidget {
  final TimeEntryType timeEntryType;
  final String number;
  final bool busLineChange;

  const CustomIndicator({Key key, this.number, this.timeEntryType, this.busLineChange : false}) : super(key: key);



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
//              blurRadius: 5,
//              spreadRadius: 2,
            ),
          ],
          shape: BoxShape.circle,
          color: Colors.red,
        ),
      );
    } else if (timeEntryType == TimeEntryType.Middle) {
      indicator = Container(
        decoration: BoxDecoration(
          shape: busLineChange ?  BoxShape.rectangle : BoxShape.circle,
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
//              blurRadius: 5,
//              spreadRadius: 2,
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