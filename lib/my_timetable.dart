import 'package:flutter/material.dart';
import 'app_bar.dart';
import 'bottom_nav.dart';

class MyTimetable extends StatelessWidget {
  const MyTimetable({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: MyAppBar(),
      drawer: NavBar(),
      bottomNavigationBar: BottomNavigation(),
      body: Text('my timetable'),
    );
  }
}
