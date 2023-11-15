// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'app_bar.dart';
import 'bottom_nav.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:xml/xml.dart';

Future<List<String>> fetchModules() async {
  User? user = FirebaseAuth.instance.currentUser;
  final ref = FirebaseDatabase.instance.ref();
  final snapshot = await ref.child('users/${user!.uid}/modules').once();

  DatabaseEvent data = snapshot;

  if (data != null) {
    DatabaseEvent modulesData = data;
    List<String> modulesList = [];

    // modulesData.forEach((key, value) {
    //   // Here, 'key' is the node key, and 'value' is the data under the node.
    //   modulesList.add(value.toString());
    // });
    print(modulesList);
    return modulesList;
  } else {
    return [];
  }
}

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs, including the "Seating Plan" tab.
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 0, 97, 175),
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Padding(
            padding: EdgeInsets.all(4),
            child: Text(
              'CAMPUS BUDDY',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          // bottom: const TabBar(
          //   labelColor:
          //       Colors.white, // Change the color of the selected tab text
          //   unselectedLabelColor: Colors.grey,
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(text: 'Exam List'), // Your existing tab.
              Tab(text: 'Seating Plan'), // New "Seating Plan" tab.
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // fetchModules();
          },
          child: const Icon(Icons.done),
        ),
        drawer: const NavBar(),
        bottomNavigationBar: const BottomNavigation(),
        body: const TabBarView(
          children: [
            ExamListView(),
            SeatingPlanView(), // Add your SeatingPlanView here.
          ],
        ),
      ),
    );
  }
}

class ExamListView extends StatefulWidget {
  const ExamListView({super.key});

  @override
  _ExamListViewState createState() => _ExamListViewState();
}

class _ExamListViewState extends State<ExamListView> {
  Future<List<dynamic>>? examDataFuture;
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    examDataFuture = fetchExamData();
  }

  Future<List<dynamic>> fetchExamData() async {
    final ref = FirebaseStorage.instance.ref().child('output.json');
    final url = await ref.getDownloadURL();
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load exam data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value.toLowerCase();
                });
              },
              decoration:
                  const InputDecoration(labelText: 'Search by Module Code'),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: examDataFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text('No exam data available.'),
                  );
                } else {
                  List<dynamic> examData = snapshot.data!
                      .where((exam) => exam['Exam unique name']
                          .toString()
                          .toLowerCase()
                          .contains(searchQuery))
                      .toList();

                  return ListView.builder(
                    itemCount: examData.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ExamCard(exam: examData[index]);
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ExamCard extends StatelessWidget {
  final Map<String, dynamic> exam;

  const ExamCard({super.key, required this.exam});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Add your onTap functionality here
      },
      child: Card(
        color: const Color.fromARGB(150, 147, 149, 152),
        margin: const EdgeInsets.all(8.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Module: ${exam['Exam name']}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('Module code: ${exam['Exam unique name']}'),
              Text('Exam Site: ${exam['Exam site']}'),
              Text('Exam Date: ${exam['Exam date']}'),
              Text('Exam Start Time: ${exam['Exam start']}'),
              Text('Duration: ${exam['Duration']} minutes'),
              Text('Room ID: ${exam['Room unique']}'),
              Text('Room Name: ${exam['Room name']}'),
            ],
          ),
        ),
      ),
    );
  }
}

class SeatingPlanView extends StatelessWidget {
  const SeatingPlanView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              DataTextBox('202036737', 'Nmajola', 'Chapel', 'R1', '4cps312',
                  '14:00 to 17:30'),
              DataTextBox('201946285', 'Xmazibuko', 'Chapel', 'R2', '4cps312',
                  '14:00 to 17:30'),
              DataTextBox('202176700', 'Q Shezi', 'Chapel', 'R3', '4cps312',
                  '14:00 to 17:30'),
              DataTextBox('201846787', 'T Mdluli', 'Chapel', 'R4', '4cps312',
                  '14:00 to 17:30'),
              DataTextBox('202148537', 'F Brian', 'Chapel', 'R5', '4cps312',
                  '14:00 to 17:30'),
              DataTextBox('202195646', 'P Mzolo', 'Chapel', 'R6', '4cps312',
                  '14:00 to 17:30'),
              DataTextBox('202045645', 'J Ntuli', 'Chapel', 'R7', '4cps312',
                  '14:00 to 17:30'),
              DataTextBox('201456546', 'S Qwabe', 'Chapel', 'R8', '4cps312',
                  '14:00 to 17:30'),
              DataTextBox('202196564', 'L Zulu', 'Chapel', 'R9', '4cps312',
                  '14:00 to 17:30'),
              DataTextBox('202046756', 'G Shozi', 'Chapel', 'R10', '4cps312',
                  '14:00 to 17:30'),
              DataTextBox('202059656', 'B Cele', 'Chapel', 'R11', '4cps312',
                  '14:00 to 17:30'),
              DataTextBox('202156775', 'Z Mzobe', 'Chapel', 'R12', '4cps312',
                  '14:00 to 17:30'),
              DataTextBox('202044550', 'K Khumalo', 'Chapel', 'R13', '4cps312',
                  '14:00 to 17:30'),
              DataTextBox('201924556', 'BJili', 'Chapel', 'R14', '4cps312',
                  '14:00 to 17:30'),
              DataTextBox('201845676', 'P Mgenge', 'Chapel', 'R15', '4cps312',
                  '14:00 to 17:30'),
            ],
          ),
        ));
  } // Implement the Seating Plan view here.
}

class DataTextBox extends StatelessWidget {
  final String id;
  final String name;
  final String location;
  final String room;
  final String code;
  final String time;

  const DataTextBox(
      this.id, this.name, this.location, this.room, this.code, this.time,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('ID: $id'),
        TextField(
          decoration: const InputDecoration(labelText: 'Name'),
          controller: TextEditingController(text: name),
        ),
        TextField(
          decoration: const InputDecoration(labelText: 'Location'),
          controller: TextEditingController(text: location),
        ),
        TextField(
          decoration: const InputDecoration(labelText: 'Room'),
          controller: TextEditingController(text: room),
        ),
        TextField(
          decoration: const InputDecoration(labelText: 'Code'),
          controller: TextEditingController(text: code),
        ),
        TextField(
          decoration: const InputDecoration(labelText: 'Time'),
          controller: TextEditingController(text: time),
        ),
        const SizedBox(height: 16.0),
      ],
    );
  }
}
