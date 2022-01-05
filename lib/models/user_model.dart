//user model for registered user

class UserModel {
  String? uid;
  String? email;
  String? firstName;
  // ignore: non_constant_identifier_names
  String? reg_no;
  String? dept;
  String? classCollection;
  String? studentType;
  String? teacherName;
  String? teacherDept;
  String? teacherEmail;

  UserModel(
      {this.uid,
      this.email,
      this.firstName,
      // ignore: non_constant_identifier_names
      this.reg_no,
      this.studentType,
      this.dept,
      this.classCollection,
      this.teacherName,
      this.teacherDept,
      this.teacherEmail});

  // receiving data from server
  factory UserModel.fromMap(map) {
    UserModel usM = UserModel(
        uid: map['uid'],
        email: map['email'],
        firstName: map['firstName'],
        reg_no: map['Reg'],
        dept: map['dept'],
        studentType: map['studentType'],
        teacherName: map['teacherName'],
        teacherDept: map['teacherDept'],
        teacherEmail: map['teacherEmail'],
        classCollection: map['userCollection']);

    return usM;
  }

  // sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'firstName': firstName,
      'Reg': reg_no,
      'dept': dept,
      'userCollection': classCollection,
      'studentType': studentType,
      'teacherName': teacherName,
      'teacherDept': teacherDept,
      'teacherEmail': teacherEmail
    };
  }
}
