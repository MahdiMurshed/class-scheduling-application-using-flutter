//settings page
//user logout
//user delete
//unimplemented feature:push notification

part of event_calendar;

class ProfileSettings extends StatefulWidget {
  @override
  _ProfileSettingsState createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettings> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  bool sendNot = false;

  @override
  void initState() {
    print("init state event calendar");

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

  // Future<void> _show() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   final TimeOfDay? result =
  //       await showTimePicker(context: context, initialTime: TimeOfDay.now());
  //   if (result != null) {
  //     setState(() {
  //       _selectedTime = result.format(context);
  //       prefs.setString('_selectedTime', _selectedTime);
  //     });
  //   }
  //   print(DateFormat('hh:mm').parse(_selectedTime));
  //   print(_selectedTime);
  //   print(_selectedTime as DateTime);
  //   // NotificationApi.showNotification(
  //   //     title: "Hello", body: "Hello World", payload: 'sarah.abs');
  //   // NotificationApi.showScheduledNotification(
  //   //     scheduledDate: _selectedTime as DateTime,
  //   //     title: "Scheduled notification",
  //   //     body: "Hello World",
  //   //     payload: 'sarah.abs');
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   title: Text(
        //     'Profile Settings',
        //     style: TextStyle(color: Colors.white),
        //   ),
        //   backgroundColor: Colors.black,
        // ),
        body: SettingsList(
      sections: [
        SettingsSection(
          title: 'Profile',
          tiles: [
            SettingsTile(
              title: '${loggedInUser.firstName}',
              titleTextStyle: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
              subtitle: loggedInUser.reg_no,
              leading: Icon(Icons.person),
              onPressed: (BuildContext context) {},
            ),
            SettingsTile(
              title: 'type : ${loggedInUser.studentType}',
              leading: Icon(Icons.note_outlined),
              onPressed: (BuildContext context) {},
            ),
          ],
        ),
        SettingsSection(
          title: 'Common',
          tiles: [
            SettingsTile.switchTile(
                title: 'Notify me',
                onToggle: (val) {
                  setState(() {
                    sendNot = val;
                  });
                  // if (sendNot) {
                  //   NotificationApi.showNotification(
                  //       title: "Hello",
                  //       body: "Hello World",
                  //       payload: 'sarah.abs');
                  //   NotificationApi.showScheduledNotification(
                  //       scheduledDate: DateTime.now().add(Duration(seconds: 9)),
                  //       title: "Scheduled notification",
                  //       body: "Hello World",
                  //       payload: 'sarah.abs');
                  // }
                },
                switchValue: sendNot),
            SettingsTile(
              title: 'Notify me',
              subtitle: 'at 9 PM everyday(sat to wed)',
              leading: Icon(Icons.alarm),
              onPressed: (BuildContext context) {
                // NotificationApi.showNotification(
                //     title: "Hello", body: "Hello World", payload: 'sarah.abs');
                // NotificationApi.showScheduledNotification(
                //     scheduledDate: DateTime.now().add(Duration(seconds: 12)),
                //     title: "Scheduled notification",
                //     body: "Hello World",
                //     payload: 'sarah.abs');
              },
            ),

            // SettingsTile.switchTile(
            //   title: 'Use fingerprint',
            //   leading: Icon(Icons.fingerprint),
            //   switchValue: value,
            //   onToggle: (bool value) {},// ),
          ],
        ),
        SettingsSection(
          title: 'Account',
          tiles: [
            SettingsTile(
              title: 'Log Out',
              subtitle: '${user!.email}',
              leading: Icon(Icons.logout),
              onPressed: (BuildContext context) async {
                FirebaseAuth.instance.signOut();

                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              },
            ),
            SettingsTile(
              title: 'Delete User',
              titleTextStyle: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red),
              subtitle: '${user!.email}',
              leading: Icon(Icons.delete),
              onPressed: (BuildContext context) async {
                user!.delete();
                FirebaseFirestore.instance
                    .collection(usersCollectionName)
                    .doc(user!.uid)
                    .delete()
                    .then((value) => print('User deleted'));
                FirebaseAuth.instance.signOut();

                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              },
            ),
          ],
        ),
      ],
    ));
  }
}
