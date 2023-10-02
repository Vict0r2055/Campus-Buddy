// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'app_bar.dart';
import 'bottom_nav.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_storage/firebase_storage.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    return Scaffold(
      appBar: const MyAppBar(),
      drawer: const NavBar(),
      bottomNavigationBar: const BottomNavigation(),
      body: const ExamListView(),
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

  @override
  void initState() {
    super.initState();
    // Initialize the future to fetch exam data
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
      body: FutureBuilder<List<dynamic>>(
        future: examDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Display a loading indicator while fetching data
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            // Handle any errors that occurred during data fetching
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // Handle the case where no data is available
            return const Center(
              child: Text('No exam data available.'),
            );
          } else {
            // Display the list of exams once data is available
            List<dynamic> examData = snapshot.data!;
            return ListView.builder(
              itemCount: examData.length,
              itemBuilder: (BuildContext context, int index) {
                final exam = examData[index];
                return ExamCard(exam: exam);
              },
            );
          }
        },
      ),
    );
  }
}

class ExamCard extends StatelessWidget {
  final Map<String, dynamic> exam;

  const ExamCard({super.key, required this.exam});

  @override
  Widget build(BuildContext context) {
    return Card(
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
            Text('Exam Site: ${exam['Exam site']}'),
            Text('Exam Date: ${exam['Exam date']}'),
            Text('Exam Start Time: ${exam['Exam start']}'),
            Text('Duration: ${exam['Duration']} minutes'),
            Text('Room ID: ${exam['Room unique']}'),
            Text('Room Name: ${exam['Room name']}'),
          ],
        ),
      ),
    );
  }
}
