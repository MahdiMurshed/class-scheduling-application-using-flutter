//showing upcoming tts and assignments

part of event_calendar;

class ScheduleView extends StatefulWidget {
  ScheduleView();

  @override
  _ScheduleViewState createState() => _ScheduleViewState();
}

class _ScheduleViewState extends State<ScheduleView> {
  final Stream<QuerySnapshot> studentsStream =
      FirebaseFirestore.instance.collection(classesCollectionName).snapshots();
  List<Classes> specialEvents = [];
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
          try {
            final List<Classes> storedocs = [];
            List<Classes> _specialEvents = [];
            snapshot.data!.docs.map((DocumentSnapshot document) {
              Map a = document.data() as Map<String, dynamic>;
              var rand = new Random();
              _selectedColorIndex = rand.nextInt(9);

              storedocs.add(Classes(
                  background: _colorCollection[_selectedColorIndex],
                  id: document.id,
                  from: (a['Start'] as Timestamp).toDate(),
                  to: (a['End'] as Timestamp).toDate(),
                  eventName: a['eventName'] + ' ${a['type']}',
                  type: a['type'],
                  isAllDay: a['isAllDay']));
            }).toList();
            print('Store docs ${storedocs.length}');

            _events = MeetingDataSource(storedocs);

            storedocs.forEach((element) {
              if (element.type == "TT" || element.type == "Assignment") {
                _specialEvents.add(element);
              }
            });
            print('Event screen ${_specialEvents.length}');

            specialEvents = _specialEvents;
          } catch (e) {
            print(e.toString());
          }
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              title: const Text(
                "Upcoming TTs and Assignments",
                style: TextStyle(color: Colors.black),
              ),
              centerTitle: true,
              elevation: 0,
            ),
            body: SfCalendar(
              allowedViews: [],
              scheduleViewSettings: ScheduleViewSettings(
                  hideEmptyScheduleWeek: true,
                  monthHeaderSettings: MonthHeaderSettings(
                      monthFormat: 'MMMM',
                      height: 100,
                      textAlign: TextAlign.center,
                      backgroundColor: LightColors.kLightYellow,
                      monthTextStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 25,
                          fontWeight: FontWeight.w400)),
                  appointmentTextStyle: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.white)),
              view: CalendarView.schedule,
              dataSource: MeetingDataSource(specialEvents),
            ),
          );
        });
  }
}
