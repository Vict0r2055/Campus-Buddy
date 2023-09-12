import 'package:campus_buddy/home_page.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:campus_buddy/bottom_nav.dart';

class Event {
  final String title;
  final DateTime date;

  Event(this.title, this.date);
}

List<Event> _getEventsForDay(DateTime day) {
  return events[day] ?? [];
}

// Example map of events (replace with your actual data)
Map<DateTime, List<Event>> events = {
  DateTime.utc(2023, 8, 17): [
    Event('Event 1', DateTime.utc(2023, 8, 17)),
    Event('Event 2', DateTime.utc(2023, 8, 17)),
  ],
  DateTime.utc(2023, 8, 18): [
    Event('Event 3', DateTime.utc(2023, 8, 18)),
  ],
  // ... more entries for other days
};

class ExaminationsPage extends StatefulWidget {
  @override
  _ExaminationsPageState createState() => _ExaminationsPageState();
}

class _ExaminationsPageState extends State<ExaminationsPage> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  List<Event> _selectedEvents = [];

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _focusedDay = focusedDay;
        _selectedDay = selectedDay;
        _selectedEvents = _getEventsForDay(selectedDay);
      });
    }
  }

  Widget _buildEventList(List<Event> events) {
    return ListView.builder(
      itemCount: events.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(events[index].title),
          subtitle: Text(events[index].date.toString()), // Customize as needed
        );
      },
    );
  }

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

                headerStyle: const HeaderStyle(
                  // Customize the header as needed
                  titleCentered: true,
                  titleTextStyle: TextStyle(fontSize: 18),
                  formatButtonVisible: false, // Hide the "2 weeks" button
                ),
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
                onPageChanged: (focusedDay) {
                  _focusedDay = _selectedDay;
                },
                eventLoader: (day) {
                  return _getEventsForDay(day);
                },

                // Add more properties and customization as needed
              ),
              Column(
                children: [
                  Expanded(
                    child: _buildEventList(_selectedEvents),
                  ),
                ],
              ),
              // const Center(
              //   child: Text('Exams'),
              // ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              // Add your desired action here
              print('Floating Action Button Pressed');
            },
            tooltip: 'Adding events to calendar',
            child: const Icon(Icons.add),
            backgroundColor: const Color(0xFF157D9E),
          ),
          bottomNavigationBar: const BottomNavigation(),
        ),
      ),
    );
  }
}
