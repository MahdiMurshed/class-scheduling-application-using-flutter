part of event_calendar;

class CrRegistration extends StatefulWidget {
  const CrRegistration({Key? key}) : super(key: key);

  @override
  _CrRegistrationState createState() => _CrRegistrationState();
}

class _CrRegistrationState extends State<CrRegistration> {
  final _auth = FirebaseAuth.instance;
  bool sendVerificationEmail = false;

  // string for displaying the error Message
  String? errorMessage;

  // our form key
  final _formKey = GlobalKey<FormState>();
  // editing Controller
  final firstNameEditingController = new TextEditingController();
  final regEditingController = new TextEditingController();
  final emailEditingController = new TextEditingController();
  String dept = 'Department';
  String studentType = '';
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final teacherName = TextFormField(
        autofocus: false,
        controller: firstNameEditingController,
        keyboardType: TextInputType.name,
        validator: (value) {
          RegExp regex = new RegExp(r'^.{3,}$');
          if (value!.isEmpty) {
            return ("First Name cannot be Empty");
          }
          if (!regex.hasMatch(value)) {
            return ("Enter Valid name(Min. 3 Character)");
          }
          return null;
        },
        onSaved: (value) {
          firstNameEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.account_circle),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Teacher Name",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    final phoneNumber = TextFormField(
        autofocus: false,
        controller: regEditingController,
        keyboardType: TextInputType.name,
        validator: (value) {
          if (value!.startsWith('01') && value.length == 11) {
            return null;
          }

          return ("Please Enter a valid phone");
        },
        onSaved: (value) {
          regEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.phone),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "phone",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));
    // final selectDept = Text('Select Department',
    //     style: TextStyle(
    //         fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold));

    final dropDownButton = DropdownButtonFormField(
      validator: (value) =>
          value == 'Department' ? 'Please Select Department' : null,
      value: dept,
      onChanged: (value) {
        setState(() {
          dept = value.toString();
        });
      },
      decoration: const InputDecoration(
          // icon: Icon(Icons.home),
          prefixIcon: Icon(Icons.home),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          )),
      hint: const Text('Department'),
      items: deptList.map((String value) {
        return new DropdownMenuItem<String>(
          value: value,
          child: new Text(value),
        );
      }).toList(),
      isExpanded: true,
    );

    //email field
    final emailField = TextFormField(
        autofocus: false,
        controller: emailEditingController,
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (value!.isEmpty) {
            return ("Please Enter Your Email");
          }
          //TODO :checking if the email has sust.edu domain

          // if (regEditingController.text != null) {
          //   //taking last two digit of registration number(XX) as mail ends with XX@student.sust.edu
          //   // var str = regEditingController.text.substring(8, 10);
          //   // print(str);
          //   if (!value.endsWith('@student.sust.edu')) {
          //     return ("Please Enter a valid SUST email");
          //   }
          // }

          return null;
        },
        onSaved: (value) {
          firstNameEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.mail),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Email",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    final proceed = Material(
      elevation: 15,
      // borderRadius: BorderRadius.circular(30),
      color: Colors.black,
      child: MaterialButton(
          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () {
            signUp(emailEditingController.text);
          },
          child: Text(
            "Send Verification Email",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          )),
    );
    final goToReg = Material(
      elevation: 15,
      // borderRadius: BorderRadius.circular(30),
      color: _auth.currentUser != null ? Colors.black : Colors.grey,
      child: MaterialButton(
          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () {
            if (studentType == 'cr') {
              Navigator.pushReplacement(
                  context,
                  PageTransition(
                      child: RegistrationScreen(
                        studentType: 'cr',
                        teacherName: firstNameEditingController.text,
                        teacherDept: dept,
                        teacherEmail: emailEditingController.text,
                      ),
                      type: PageTransitionType.rightToLeftWithFade));
              // Navigator.of(context).push(MaterialPageRoute(
              //     builder: (context) => RegistrationScreen(
              //           studentType: 'cr',
              //           teacherName: firstNameEditingController.text,
              //           teacherDept: dept,
              //           teacherEmail: emailEditingController.text,
              //         )));
            } else {
              _auth.signOut();
              _auth.currentUser!.delete();

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.orangeAccent,
                  content: Text(
                    'Verification Failed',
                    style: TextStyle(fontSize: 18.0, color: Colors.black),
                  ),
                ),
              );
            }
          },
          child: Text(
            "Go to Registration",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          )),
    );
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Center(
            child: SingleChildScrollView(
                child: Container(
                    color: Colors.white,
                    child: Padding(
                        padding: const EdgeInsets.all(36.0),
                        child: Form(
                            key: _formKey,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  SizedBox(
                                      height: 180,
                                      child: Image.asset(
                                        "assets/images/logo.png",
                                        fit: BoxFit.contain,
                                      )),
                                  teacherName,
                                  SizedBox(height: 20),
                                  phoneNumber,
                                  SizedBox(height: 20),
                                  dropDownButton,
                                  SizedBox(height: 20),
                                  emailField,
                                  SizedBox(height: 20),
                                  proceed,
                                  SizedBox(height: 20),
                                  goToReg,
                                ])))))));
  }

//sends email to the teacher and checks if the teacher verified the email or not.If the teacher verified the email then user will be eligible to register as CR
  void signUp(String email) async {
    String password = email.toString();

    if (_formKey.currentState!.validate()) {
      print('Validation');
      try {
        await _auth
            .createUserWithEmailAndPassword(email: email, password: password)
            .then((value) async {
          studentType = await Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => VerifyScreen()));
        }).catchError((e) {
          Fluttertoast.showToast(msg: e!.message);
        });
      } on FirebaseAuthException catch (error) {
        switch (error.code) {
          case "invalid-email":
            errorMessage = "Your email address appears to be malformed.";
            break;
          case "wrong-password":
            errorMessage = "Your password is wrong.";
            break;
          case "user-not-found":
            errorMessage = "User with this email doesn't exist.";
            break;
          case "user-disabled":
            errorMessage = "User with this email has been disabled.";
            break;
          case "too-many-requests":
            errorMessage = "Too many requests";
            break;
          case "operation-not-allowed":
            errorMessage = "Signing in with Email and Password is not enabled.";
            break;
          default:
            errorMessage = "An undefined Error happened.";
        }
        Fluttertoast.showToast(msg: errorMessage!);
        print(error.code);
      }
    }

    print('teacher signup complted');
  }
}
