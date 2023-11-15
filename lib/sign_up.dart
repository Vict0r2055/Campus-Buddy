// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
// import 'package:campus_buddy/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:multiselect_formfield/multiselect_formfield.dart';

import 'app_bar.dart';
import 'reusable_widgets.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:campus_buddy/chatbot.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _userNameTextController = TextEditingController();
  // List<String> _selectedFaculties = []; // Store the selected faculties
  String? _dropdownValue; // Store the selected value
  String? _dropdownValue2;
  String? _dropdownValue3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const MyAppBar(),
      drawer: const NavBar(),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/logo.jpeg'),
            opacity: 0.1,
            fit: BoxFit.contain,
            alignment: Alignment.center,
          ),
        ),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 120, 20, 0),
            child: Column(
              children: <Widget>[
                const SizedBox(height: 20),
                reusableDropdownButton(
                  "Select Faculty",
                  _dropdownValue,
                  Icons.school_outlined,
                  [
                    const DropdownMenuItem(
                      value: "Faculty of Science & Agriculture",
                      child: Text('Faculty of Science & Agriculture'),
                    ),
                    const DropdownMenuItem(
                      value: "Faculty of Education",
                      child: Text('Faculty of Education'),
                    ),
                    const DropdownMenuItem(
                      value: "Faculty of Arts",
                      child: Text('Faculty of Arts'),
                    ),
                    const DropdownMenuItem(
                      value: "Faculty of Commerce, Administration & Law",
                      child: Text('Faculty of Commerce, Administration & Law'),
                    ),
                  ],
                  dropdownCallback,
                ),
                const SizedBox(height: 20),
                reusableDropdownButton(
                  "Select Department",
                  _dropdownValue2,
                  Icons.add_business_outlined,
                  [
                    const DropdownMenuItem(
                      value: "ACCOUNTING AND AUDITING",
                      child: Text('ACCOUNTING AND AUDITING'),
                    ),
                    const DropdownMenuItem(
                      value: "AFRICAN LANGUAGES & CULTURE",
                      child: Text('AFRICAN LANGUAGES & CULTURE'),
                    ),
                    const DropdownMenuItem(
                      value: "AGRICULTURE",
                      child: Text('AGRICULTURE'),
                    ),
                    const DropdownMenuItem(
                      value: "ANTHROPOLOGY",
                      child: Text('ANTHROPOLOGY'),
                    ),
                    const DropdownMenuItem(
                      value: "ANTHROPOLOGY&DEVELOPMENT ST",
                      child: Text('ANTHROPOLOGY & DEVELOPMENT ST'),
                    ),
                    const DropdownMenuItem(
                      value: "ARTS & LANGUAGES EDUCATION",
                      child: Text('ARTS & LANGUAGES EDUCATION'),
                    ),
                    const DropdownMenuItem(
                      value: "BIOCHEMISTRY AND MICROBIOLOGY",
                      child: Text('BIOCHEMISTRY AND MICROBIOLOGY'),
                    ),
                  ],
                  dropdownCallback2,
                ),
                const SizedBox(height: 20),
                reusableDropdownButton(
                  "Select Department",
                  _dropdownValue3,
                  Icons.add_business_outlined,
                  [
                    const DropdownMenuItem(
                      value: "none",
                      child: Text('none'),
                    ),
                    const DropdownMenuItem(
                      value: "ACCOUNTING AND AUDITING",
                      child: Text('ACCOUNTING AND AUDITING'),
                    ),
                    const DropdownMenuItem(
                      value: "AFRICAN LANGUAGES & CULTURE",
                      child: Text('AFRICAN LANGUAGES & CULTURE'),
                    ),
                    const DropdownMenuItem(
                      value: "AGRICULTURE",
                      child: Text('AGRICULTURE'),
                    ),
                    const DropdownMenuItem(
                      value: "ANTHROPOLOGY",
                      child: Text('ANTHROPOLOGY'),
                    ),
                    const DropdownMenuItem(
                      value: "ANTHROPOLOGY&DEVELOPMENT ST",
                      child: Text('ANTHROPOLOGY & DEVELOPMENT ST'),
                    ),
                    const DropdownMenuItem(
                      value: "ARTS & LANGUAGES EDUCATION",
                      child: Text('ARTS & LANGUAGES EDUCATION'),
                    ),
                    const DropdownMenuItem(
                      value: "BIOCHEMISTRY AND MICROBIOLOGY",
                      child: Text('BIOCHEMISTRY AND MICROBIOLOGY'),
                    ),
                  ],
                  dropdownCallback3,
                ),
                const SizedBox(height: 20),
                reusableTextField(
                  "Enter Student/Staff NO",
                  Icons.person_outline,
                  false,
                  _userNameTextController,
                ),
                const SizedBox(height: 20),
                reusableTextField(
                  "Enter Email Id",
                  Icons.person_outline,
                  false,
                  _emailTextController,
                ),
                const SizedBox(height: 20),
                reusableTextField(
                  "Enter Password",
                  Icons.lock_outlined,
                  true,
                  _passwordTextController,
                ),
                const SizedBox(height: 20),
                firebaseUIButton(context, "Sign Up", () {
                  FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                    email: _emailTextController.text,
                    password: _passwordTextController.text,
                  )
                      .then((userCredential) {
                    // User registration was successful
                    // Now write user data to the database
                    writeUserDataToDatabase(
                      userId: userCredential.user!.uid, // Unique user ID
                      faculty: _dropdownValue,
                      department1: _dropdownValue2,
                      department2: _dropdownValue3,
                      studentStaffNumber: _userNameTextController.text,
                      email: _emailTextController.text,
                      // password: _passwordTextController.text,
                    );

                    showCustomSnackbar(context, "Created New Account");
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ChatScreen(),
                      ),
                    );
                  }).catchError((error) {
                    showCustomSnackbar(context, "Error ${error.toString()}");
                  });
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void dropdownCallback(String? selectedValue) {
    if (selectedValue is String) {
      setState(() {
        _dropdownValue = selectedValue;
        // print(_dropdownValue);
      });
    }
  }

  void dropdownCallback2(String? selectedValue2) {
    if (selectedValue2 is String) {
      setState(() {
        _dropdownValue2 = selectedValue2;
        // print(_dropdownValue2);
      });
    }
  }

  void dropdownCallback3(String? selectedValue3) {
    if (selectedValue3 is String) {
      setState(() {
        _dropdownValue3 = selectedValue3;
        // print(_dropdownValue3);
      });
    }
  }
}

Future<void> writeUserDataToDatabase({
  String? userId, // The unique user ID
  String? faculty,
  String? department1,
  String? department2,
  String? studentStaffNumber,
  String? email,
  // String? password,
}) async {
  final reference = FirebaseDatabase.instance.ref().child('users');

  try {
    await reference.child(userId!).set({
      'faculty': faculty,
      'department1': department1,
      'department2': department2,
      'studentStaffNumber': studentStaffNumber,
      'email': email,
      // 'password': password,
    });

    // Data has been successfully written to the database
    print('User data has been written to the database');
  } catch (error) {
    // Handle any errors that occur during the database write operation
    print('Error writing user data to the database: $error');
  }
}
