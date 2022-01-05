library event_calendar;

import 'dart:math';
import 'package:aassss/models/user_model.dart';
import 'const/deptList.dart';
import 'package:aassss/screens/forget_pass.dart';
import 'package:aassss/screens/waitingPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:page_transition/page_transition.dart';
import 'theme/colors/light_colors.dart';
import 'package:aassss/theme/colors/light_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'widgets/calendar_widget.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'models/event.dart';
import 'models/event_data_source.dart';
import 'const/colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'models/user_model.dart';
import 'dart:async';
import 'package:settings_ui/settings_ui.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';

//part of event_calendar;

part 'screens/event_calendar_screen.dart';
part 'color-picker.dart';
part 'screens/appointment-editor.dart';
part 'screens/registration_screen.dart';
part 'screens/login_screen.dart';
part 'screens/cr_reg_screen.dart';
part 'screens/verify.dart';
part 'screens/app_home.dart';
part 'screens/schedule_view_screen.dart';
part 'screens/profiile_settings.dart';
part 'notifications/notification_api.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  usersCollectionName = (prefs.getString('usersCollectionName') ?? 'users');
  classesCollectionName =
      (prefs.getString('classesCollectionName') ?? 'classes');

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  final String title = 'Calender';
  //for the unimplemented notification feature
  @override
  void initState() {
    NotificationApi.init(initScheduled: true);
    listenNotification();

    super.initState();
  }

//for the unimplemented notification feature
  void listenNotification() =>
      NotificationApi.onNotifications.stream.listen(onClickedNotification);
  void onClickedNotification(String? payload) {
    print("onClickedNotification: $payload");
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print("Something went Wrong");
          }
          // once Completed, show your application
          if (snapshot.connectionState == ConnectionState.done) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: title,
              home: user == null ? LoginScreen() : AppHome(),
            );
          }
          return CircularProgressIndicator();
        });
  }
}
//global variables

List<Color> _colorCollection = colorCollection;
List<String> _colorNames = colorNames;
int _selectedColorIndex = 0;
late MeetingDataSource _events;
Classes? _selectedAppointment;
late DateTime _startDate;
late TimeOfDay _startTime;
late DateTime _endDate;
late TimeOfDay _endTime;
bool _isAllDay = false;
bool _isRecurred = false;
String _subject = '';
String _notes = '';
String usersCollectionName = 'users';
String classesCollectionName = 'classes';
bool _is2h = false;
bool _isTT = false;
bool _isAssignment = false;
String type = 'Class';
Classes? currentMeeting;
