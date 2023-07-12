// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:campus_buddy/app_bar.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:campus_buddy/reusable_widgets.dart';

void saveJsonFileToFirebase(BuildContext context) async {
  String jsonFileUrl = 'http://127.0.0.1:5000/download/timetable.json';

  var response = await http.get(Uri.parse(jsonFileUrl));
  if (response.statusCode == 200) {
    var jsonData = json.decode(response.body);

    final DatabaseReference databaseReference =
        FirebaseDatabase.instance.ref().child('Modules');
    await databaseReference.set(jsonData);
    retrieveAndPrintData(context);

    showCustomSnackbar(
        context, 'JSON file saved to Firebase Realtime Database successfully');
    showCustomSnackbar(context, 'done');
  } else {
    showCustomSnackbar(context,
        'Failed to fetch JSON file. Status code: ${response.statusCode}');
  }
}

List<String> valuesList = [];

void saveJsonFileToFirebase2(BuildContext context) async {
  String jsonFileUrl = 'http://127.0.0.1:5000/download/examinations.json';

  var response = await http.get(Uri.parse(jsonFileUrl));
  if (response.statusCode == 200) {
    var jsonData = json.decode(response.body);

    final DatabaseReference databaseReference =
        FirebaseDatabase.instance.ref().child('Examinations');
    await databaseReference.set(jsonData);

    showCustomSnackbar(
        context, 'JSON file saved to Firebase Realtime Database successfully');
    showCustomSnackbar(context, 'done');
  } else {
    showCustomSnackbar(context,
        'Failed to fetch JSON file. Status code: ${response.statusCode}');
  }
}

void retrieveAndPrintData(BuildContext context) {
  DatabaseReference databaseReference =
      FirebaseDatabase.instance.ref().child('Modules');

  databaseReference.once().then((event) {
    DataSnapshot dataSnapshot = event.snapshot;

    if (dataSnapshot.value != null) {
      Map<dynamic, dynamic> modules =
          dataSnapshot.value as Map<dynamic, dynamic>;

      modules.forEach((key, value) {
        String moduleValue = value['value'].toString();
        valuesList.add(moduleValue);
      });
    }
    uploadFilesToFirebase(context, valuesList);
  });
}

void uploadFilesToFirebase(BuildContext context, List<String> fileUrls) async {
  final FirebaseStorage storage = FirebaseStorage.instance;

  for (String fileUrl in fileUrls) {
    var response =
        await http.get(Uri.parse('http://127.0.0.1:5000/download/$fileUrl'));

    if (response.statusCode == 200) {
      String fileName = fileUrl.split('/').last;

      String fileContent = response.body;

      await storage.ref('timetableData/$fileName').putString(fileContent);

      showCustomSnackbar(
          context, 'File $fileName uploaded to Firebase Storage');
    } else {
      showCustomSnackbar(context, 'Failed to download file: $fileUrl');
    }
  }
}

class AdminPage extends StatelessWidget {
  const AdminPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          firebaseUIButton(
              context, 'Update Modules', () => saveJsonFileToFirebase(context)),
          const SizedBox(
            height: 20,
          ),
          firebaseUIButton(context, 'Update Exam Dates',
              () => saveJsonFileToFirebase2(context)),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
