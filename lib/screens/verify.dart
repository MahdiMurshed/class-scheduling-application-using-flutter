part of event_calendar;

class Verify extends StatefulWidget {
  final String? name;
  final String? reg;
  final String? dept;
  final String? studentType;
  final String teacherName;
  final String teacherEmail;
  final String teacherDept;

  const Verify(
      {Key? key,
      this.name,
      this.reg,
      this.dept,
      this.studentType,
      this.teacherName = '',
      this.teacherEmail = '',
      this.teacherDept = ''})
      : super(key: key);

  @override
  _VerifyState createState() => _VerifyState();
}

class _VerifyState extends State<Verify> {
  final auth = FirebaseAuth.instance;
  User? user;
  Timer? timer;

  @override
  void initState() {
    user = auth.currentUser;
    user!.sendEmailVerification();

    //email verification function will check whether the user is verified or not after 5 seconds
    timer = Timer.periodic(Duration(seconds: 5), (timer) {
      checkEmailVerified();
    });
    super.initState();
  }

  @override
  void dispose() {
    timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('An email has been sent to ${user!.email} please verify'),
      ),
    );
  }

//check whether the user is verified or not
  Future<void> checkEmailVerified() async {
    user = auth.currentUser;
    await user!.reload();
    if (user!.emailVerified) {
      timer!.cancel();
      postDetailsToFirestore();
    }
  }

//creating user document in firestore
  postDetailsToFirestore() async {
    // calling our firestore
    // calling our user model
    // sedning these values

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = auth.currentUser;

    UserModel userModel = UserModel();

    // writing all the values
    userModel.email = user!.email;
    userModel.uid = user.uid;
    userModel.firstName = widget.name;
    userModel.reg_no = widget.reg;
    userModel.dept = widget.dept;
    userModel.studentType = widget.studentType;
    userModel.teacherName = widget.teacherName;
    userModel.teacherEmail = widget.teacherEmail;
    userModel.teacherDept = widget.teacherDept;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    usersCollectionName =
        "usersOf${userModel.dept!.substring(0, 3)}${userModel.reg_no!.substring(2, 4)}batch";
    prefs.setString('usersCollectionName', usersCollectionName);
    classesCollectionName =
        "classesOf${userModel.dept!.substring(0, 3)}${userModel.reg_no!.substring(2, 4)}batch";
    prefs.setString('classesCollectionName', classesCollectionName);
    print(usersCollectionName);
    print(classesCollectionName);
    userModel.classCollection = classesCollectionName;

    await firebaseFirestore
        .collection(usersCollectionName)
        .doc(user.uid)
        .set(userModel.toMap());

    Fluttertoast.showToast(msg: "Account created successfully :) ");

    Navigator.pushAndRemoveUntil(
        (context),
        MaterialPageRoute(builder: (context) => LoginScreen()),
        (route) => false);
  }
}
