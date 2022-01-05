//part of event_calendar;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:scheduling_events/screens/event_calendar_screen.dart';

// import 'package:flutter/material.dart';
// import 'package:syncfusion_flutter_calendar/calendar.dart';
List<String> get colorNames {
  List<String> _c = [];
  _c.add('Green');
  _c.add('Purple');
  _c.add('Red');
  _c.add('Orange');
  _c.add('Caramel');
  _c.add('Magenta');
  _c.add('Blue');
  _c.add('Peach');
  _c.add('Gray');
  return _c;
}

List<Color> get colorCollection {
  List<Color> _colorCollection = <Color>[];
  _colorCollection.add(const Color(0xFF0F8644));
  _colorCollection.add(const Color(0xFFEC407A));
  // _colorCollection.add(const Color(0xFF4DB6AC));
  _colorCollection.add(const Color(0xFFF06292));
  // _colorCollection.add(const Color(0xFF80CBC4));
  _colorCollection.add(const Color(0xFF00695C));
  _colorCollection.add(const Color(0xFF1E88E5));
  // _colorCollection.add(const Color(0xFF4CAF50));
  // _colorCollection.add(const Color(0xFF009688));

  _colorCollection.add(Color(0xFFF9BE7C));

  _colorCollection.add(Color(0xFFE46472));
  _colorCollection.add(Color(0xFF6488E4));

  _colorCollection.add(Color(0xFF309397));
  _colorCollection.add(Color(0xFF0D253F));

  return _colorCollection;
}
