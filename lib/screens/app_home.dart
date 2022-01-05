//first scren of the app with bottom navigation bar.

part of event_calendar;

class AppHome extends StatefulWidget {
  const AppHome({Key? key}) : super(key: key);

  @override
  AppHomeState createState() => AppHomeState();
}

class AppHomeState extends State<AppHome> {
  int currentIndex = 0;
  final screens = [EventCalendar(), ScheduleView(), ProfileSettings()];
  AppHomeState();

  // List<Meeting> specialEvents = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        unselectedItemColor: Colors.grey[800],
        selectedItemColor: Colors.white,
        showUnselectedLabels: false,
        currentIndex: currentIndex,
        elevation: 15,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
              backgroundColor: LightColors.kLightGreen),
          BottomNavigationBarItem(
              icon: Icon(Icons.schedule),
              label: 'T&A',
              backgroundColor: LightColors.kPalePink),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Profile',
              backgroundColor: LightColors.kBlue),
        ],
      ),
    );
  }
}
