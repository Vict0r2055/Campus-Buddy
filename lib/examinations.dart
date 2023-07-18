import 'package:campus_buddy/home_page.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class ExaminationsPage extends StatelessWidget {
  const ExaminationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
        return false; // Prevents the app from exiting
      },
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                );
              },
            ),
            title: const Text('Calendar & Exams'),
            bottom: const TabBar(
              tabs: [
                Tab(text: 'Calendar'),
                Tab(text: 'Exams'),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              TableCalendar(
                calendarFormat: CalendarFormat.month,
                firstDay: DateTime.utc(2022, 11, 9),
                focusedDay: DateTime.now(),
                lastDay: DateTime.utc(2030, 12, 9),
                startingDayOfWeek: StartingDayOfWeek.monday,
                shouldFillViewport: true,

                // Add more properties and customization as needed
              ),
              const Center(
                child: Text('Exams'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
