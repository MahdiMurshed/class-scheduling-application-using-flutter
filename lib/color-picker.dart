part of event_calendar;
// import 'package:flutter/material.dart';
// import 'package:scheduling_events/models/event.dart';
// import 'package:scheduling_events/models/event_data_source.dart';

class ColorPicker extends StatefulWidget {
  ColorPicker();
  @override
  State<StatefulWidget> createState() {
    return _ColorPickerState();
  }
}

class _ColorPickerState extends State<ColorPicker> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
          width: double.maxFinite,
          child: ListView.builder(
            padding: const EdgeInsets.all(0),
            itemCount: _colorCollection.length - 1,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                contentPadding: const EdgeInsets.all(0),
                leading: Icon(
                    index == _selectedColorIndex
                        ? Icons.lens
                        : Icons.trip_origin,
                    color: _colorCollection[index]),
                title: Text(_colorNames[index]),
                onTap: () {
                  setState(() {
                    _selectedColorIndex = index;
                  });

                  // ignore: always_specify_types
                  Future.delayed(const Duration(milliseconds: 200), () {
                    // When task is over, close the dialog
                    Navigator.pop(context);
                  });
                },
              );
            },
          )),
    );
  }
}
