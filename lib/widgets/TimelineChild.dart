import 'package:flutter/material.dart';
import 'package:waytech/enums/TimeEntryType.dart';
import 'package:waytech/models/TimelineStep.dart';

class TimelineChild extends StatelessWidget {
  const TimelineChild({Key key, this.step, this.type}) : super(key: key);

  final TimelineStep step;
  final TimeEntryType type;

  getTimelineWidgets() {

    List<Widget> widgets = [];

    if (type != TimeEntryType.Start) {
      widgets.add(Padding(
          padding: EdgeInsets.only(left: 20, top: 4, right: 8),
          child: Wrap(runAlignment: WrapAlignment.start, crossAxisAlignment: WrapCrossAlignment.center, direction: Axis.horizontal, children: [
            Icon(step.arrivalIcon),
            SizedBox(
              width: 3,
            ),
            Text("${step.arrivalTime}")
          ])));
    }

    // TODO: break time can be added, but is redundant as arrival and departure time is provided

//    if (type == TimeEntryType.Middle) {
//      widgets.add(Padding(
//          padding: EdgeInsets.only(left: 20, top: 4, right: 8),
//          child: Row(children: [
//            Icon(step.breakTimeIcon),
//            SizedBox(
//              width: 3,
//            ),
//            Text(step.breakTimeDuration.inMinutes <= 0 ? "${step.breakTimeDuration.inSeconds} sec" : "${step.breakTimeDuration.inMinutes} min")
//          ])));
//    }

    if (type != TimeEntryType.End) {
      widgets.add(Padding(
          padding: EdgeInsets.only(left: 20, top: 4, right: 8),
          child: Wrap(runAlignment: WrapAlignment.start, crossAxisAlignment: WrapCrossAlignment.center, direction: Axis.horizontal, children: [
            Icon(step.departureIcon),
            SizedBox(
              width: 3,
            ),
            Text("${step.departureTime}")
          ])),);
    }

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    final double minHeight = 100;

    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: minHeight),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: getTimelineWidgets()
      ),
    );
  }
}
