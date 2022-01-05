//class object
import 'package:flutter/material.dart';

class Classes {
  Classes(
      {required this.from,
      required this.to,
      required this.id,
      this.isReccured = false,
      this.background = Colors.green,
      this.isAllDay = false,
      this.eventName = '',
      this.startTimeZone = '',
      //this.recurrenceRule,
      this.endTimeZone = '',
      this.description = '',
      this.type = 'Class'});

  final String eventName;
  final DateTime from;
  final DateTime to;
  final Color background;
  final bool isAllDay;
  final String type;
  final bool isReccured;
  final String startTimeZone;
  final String endTimeZone;
  final String description;
  final String id;
  //String? recurrenceRule;
}
