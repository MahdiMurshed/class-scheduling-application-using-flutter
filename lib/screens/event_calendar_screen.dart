part of event_calendar;

class EventCalendar extends StatefulWidget {
  const EventCalendar({Key? key}) : super(key: key);

  @override
  EventCalendarState createState() => EventCalendarState();
}

class EventCalendarState extends State<EventCalendar> {
  EventCalendarState();
  final Stream<QuerySnapshot> studentsStream =
      FirebaseFirestore.instance.collection(classesCollectionName).snapshots();
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  CalendarView _calendarView = CalendarView.workWeek;

//creating user model for logged in user at the start of this page
  @override
  void initState() {
    print("init state event calendar");
    print(_calendarView);

    _events = MeetingDataSource([]);
    _selectedAppointment = null;
    _selectedColorIndex = 0;
    _subject = '';
    _notes = '';
    FirebaseFirestore.instance
        .collection(usersCollectionName)
        .doc(user!.uid)
        .get()
        .then((value) {
      this.loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
    });
    print('looged in $loggedInUser.uid');

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: studentsStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print('Something went Wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          //fetching all the classes from firebase to the list
          try {
            final List<Classes> storedocs = [];
            // List<Meeting> _specialEvents = [];
            snapshot.data!.docs.map((DocumentSnapshot document) {
              Map a = document.data() as Map<String, dynamic>;
              var rand = new Random();
              _selectedColorIndex = rand.nextInt(9);

              storedocs.add(Classes(
                  background: _colorCollection[_selectedColorIndex],
                  id: document.id,
                  from: (a['Start'] as Timestamp).toDate(),
                  to: (a['End'] as Timestamp).toDate(),
                  eventName: a['eventName'],
                  type: a['type'],
                  isAllDay: a['isAllDay']));
            }).toList();
            print('Store docs ${storedocs.length}');

            _events = MeetingDataSource(storedocs);
          } catch (e) {
            print(e.toString());
          }

          return Scaffold(
            body: SafeArea(
              child: Padding(
                  padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
                  //actual calendar
                  child: CalendarWidget(
                      calendarView: _calendarView,
                      calendarDataSource: _events,
                      calendarTapCallback: loggedInUser.studentType == "cr"
                          ? onCalendarTapped
                          : onCalendarTapped2)),
            ),
          );
        });
  }

//if CR taps on the calendar(edititing the calendar)
  void onCalendarTapped(CalendarTapDetails calendarTapDetails) {
    if (calendarTapDetails.targetElement != CalendarElement.calendarCell &&
        calendarTapDetails.targetElement != CalendarElement.appointment) {
      return;
    }

    setState(() {
      _selectedAppointment = null;
      _isAllDay = false;
      _selectedColorIndex = 0;
      //_selectedTimeZoneIndex = 0;
      _subject = '';
      _notes = '';
      if (_calendarView == CalendarView.month) {
        _calendarView = CalendarView.day;
      } else {
        if (calendarTapDetails.appointments != null &&
            calendarTapDetails.appointments!.length == 1) {
          final Classes meetingDetails = calendarTapDetails.appointments![0];

          _startDate = meetingDetails.from;
          _endDate = meetingDetails.to;
          _isAllDay = meetingDetails.isAllDay;

          _subject = meetingDetails.eventName == '(No title)'
              ? ''
              : meetingDetails.eventName;
          _notes = meetingDetails.description;
          _selectedAppointment = meetingDetails;
          type = _selectedAppointment!.type;
          _isTT = type == 'TT';
          _isAssignment = type == 'Assignment';
          _isRecurred = _selectedAppointment!.isReccured;
        } else {
          final DateTime date = calendarTapDetails.date!;
          _startDate = date;
          _endDate = date.add(const Duration(hours: 1));
          _isTT = false;
          _isAssignment = false;
          _isRecurred = false;
          _is2h = false;
        }
        _startTime =
            TimeOfDay(hour: _startDate.hour, minute: _startDate.minute);
        _endTime = TimeOfDay(hour: _endDate.hour, minute: _endDate.minute);
        Navigator.push<Widget>(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => AppointmentEditor()),
        );
      }
    });
  }

//If other users taps on the calendar(viewing the calendar)
  void onCalendarTapped2(CalendarTapDetails details) {
    String _dateText;
    String _startTimeText;
    String _endTimeText;
    String _timeDetails;

    if (details.targetElement == CalendarElement.appointment ||
        details.targetElement == CalendarElement.agenda) {
      final Classes appointmentDetails = details.appointments![0];
      _subject = appointmentDetails.eventName;
      _dateText = DateFormat('MMMM dd, yyyy')
          .format(appointmentDetails.from)
          .toString();
      _startTimeText =
          DateFormat('hh:mm a').format(appointmentDetails.from).toString();
      _endTimeText =
          DateFormat('hh:mm a').format(appointmentDetails.to).toString();
      if (appointmentDetails.isAllDay) {
        _timeDetails = 'All day';
      } else {
        _timeDetails = '$_startTimeText - $_endTimeText';
      }
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Container(child: new Text('$_subject')),
              content: Container(
                height: 80,
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          '$_dateText',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text(''),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text(_timeDetails,
                            style: TextStyle(
                                fontWeight: FontWeight.w400, fontSize: 15)),
                      ],
                    )
                  ],
                ),
              ),
              actions: <Widget>[
                new TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: new Text('close'))
              ],
            );
          });
    }
  }
}
