import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class DateTimePicker extends StatefulWidget {
  final String label;
  final Function onChanged;

  DateTimePicker(
      {@required this.label, this.onChanged});

  @override
  _DateTimePickerState createState() => _DateTimePickerState();
}

class _DateTimePickerState extends State<DateTimePicker> {
  DateTime dateTime;
  DateTime _pickedDate;

  TextEditingController textEditingController = TextEditingController();

  String formatTime(TimeOfDay timeOfDay) {
    return timeOfDay.hour.toString().padLeft(2, "0") + ":" + timeOfDay.minute.toString().padLeft(2, "0") + ":00";
  }



  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        decoration: InputDecoration(
          labelText: widget.label,
          suffixIcon: IconButton(
            icon: Icon(Icons.access_time),
            onPressed: () {
              TimeOfDay now = TimeOfDay.now();
              textEditingController.text = now.format(context);
              widget.onChanged(formatTime(now));
            },
          )
        ),
        readOnly: true,
        controller: textEditingController,
        onChanged: widget.onChanged,
        onTap: () async {
          TimeOfDay picked = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.now(),
            builder: (BuildContext context, Widget child) {
              return MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(alwaysUse24HourFormat: true),
                child: child,
              );
            },
          );

          textEditingController.text = picked.format(context);
          widget.onChanged(formatTime(picked));
        });
  }
}
