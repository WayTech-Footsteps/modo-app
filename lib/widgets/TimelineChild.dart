import 'package:flutter/material.dart';
import 'package:waytech/models/TimelineStep.dart';

class TimelineChild extends StatelessWidget {
  const TimelineChild({Key key, this.step}) : super(key: key);

  final TimelineStep step;

  @override
  Widget build(BuildContext context) {
    final double minHeight = 100;

    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: minHeight),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
              padding: EdgeInsets.only(left: 20, top: 8, bottom: 8, right: 8),
              child: Row(children: [
                Icon(step.iconData),
                SizedBox(
                  width: 3,
                ),
                RichText(
                  text: TextSpan(children: <TextSpan>[
                    TextSpan(
                      text: step.breakTimeDuration.inMinutes >= 0
                          ? "${step.breakTimeDuration.inMinutes} min"
                          : "",
                    ),
                    TextSpan(
                      text: '  ${step.breakTimeDuration.inSeconds} sec',
                    )
                  ]),
                )
              ]))
        ],
      ),
    );
  }
}
