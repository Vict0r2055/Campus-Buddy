import 'package:flutter/material.dart';
import 'app_bar.dart';
import 'bottom_nav.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(),
      drawer: const NavBar(),
      bottomNavigationBar: const BottomNavigation(),
      body: ModuleFilterApp(),
    );
  }
}

class ModuleFilterApp extends StatefulWidget {
  @override
  _ModuleFilterAppState createState() => _ModuleFilterAppState();
}

class _ModuleFilterAppState extends State<ModuleFilterApp> {
  List<Map<String, dynamic>> examData = [];

  @override
  void initState() {
    super.initState();
    // Load your Excel data here
    // You can use the excel package to read data from the Excel file
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: const MyAppBar(),
        body: Column(
          children: [
            // Add filter options here (e.g., DropdownButton, TextField)
            // Implement filtering logic based on user input

            // Display filtered modules
            Expanded(
              child: ListView.builder(
                itemCount: examData.length,
                itemBuilder: (context, index) {
                  final module = examData[index];
                  return ListTile(
                    title: Text(module['Exam name']),
                    subtitle: Text(module['Exam unique name']),
                    // Display other module details here
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
