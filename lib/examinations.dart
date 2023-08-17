import 'package:campus_buddy/home_page.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:campus_buddy/bottom_nav.dart';

class ExaminationsPage extends StatelessWidget {
  const ExaminationsPage({Key? key}) : super(key: key);

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
            backgroundColor: const Color(0xFF157D9E),
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
            bottom: const TabBar(
              labelColor:
                  Colors.white, // Change the color of the selected tab text
              unselectedLabelColor:
                  Colors.grey, // Change the color of the unselected tab text
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
                firstDay: DateTime.utc(2022, 10, 13),
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
          bottomNavigationBar: const BottomNavigation(),
        ),
      ),
    );
  }
}
