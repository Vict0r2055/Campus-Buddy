// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'app_bar.dart';
import 'bottom_nav.dart';

class Event {
  final String title;
  final String time;
  final String location;

  Event(this.title, this.time, this.location);
}

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _selectedDate = DateTime.now();
  final TextEditingController _eventTitleController = TextEditingController();
  final TextEditingController _eventTimeController = TextEditingController();
  final TextEditingController _eventLocationController =
      TextEditingController();
  final Map<DateTime, List<Event>> _events = {};
  List<Event> _selectedEvents =
      []; // List to store events for the selected date

  void _addEvent() {
    setState(() {
      final dateKey = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
      );

      final event = Event(
        _eventTitleController.text,
        _eventTimeController.text,
        _eventLocationController.text,
      );

      if (_events.containsKey(dateKey)) {
        _events[dateKey]!.add(event);
      } else {
        _events[dateKey] = [event];
      }

      _eventTitleController.clear();
      _eventTimeController.clear();
      _eventLocationController.clear();

      // print('Events for $_selectedDate: ${_events[dateKey]}');
    });
  }

  void _deleteEvent(Event event) {
    final dateKey = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
    );

    setState(() {
      // Remove the event from the selected events list
      _selectedEvents.remove(event);

      // Remove the event from the events map for the selected date
      if (_events.containsKey(dateKey)) {
        _events[dateKey]!.remove(event);
        // If there are no events left for the date, remove the date from the map
        if (_events[dateKey]!.isEmpty) {
          _events.remove(dateKey);
        }
      }
    });
  }

  void _fetchEventsForDate(DateTime date) {
    final dateKey = DateTime(date.year, date.month, date.day);
    if (_events.containsKey(dateKey)) {
      setState(() {
        _selectedDate = date; // Set the selected date
        _selectedEvents =
            _events[dateKey]!; // Store events for the selected date
      });
    } else {
      setState(() {
        _selectedDate = date; // Set the selected date
        _selectedEvents = []; // No events for the selected date
      });
    }
  }

  Future<void> _showAddEventDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Event'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextField(
                  controller: _eventTitleController,
                  decoration: const InputDecoration(
                    hintText: 'Event Title',
                  ),
                ),
                TextField(
                  controller: _eventTimeController,
                  decoration: const InputDecoration(
                    hintText: 'Event Time',
                  ),
                ),
                TextField(
                  controller: _eventLocationController,
                  decoration: const InputDecoration(
                    hintText: 'Event Location',
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                _addEvent();
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Add'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(),
      body: Column(
        children: [
          TableCalendar(
            focusedDay: _selectedDate,
            firstDay: DateTime(2000),
            lastDay: DateTime(2101),
            selectedDayPredicate: (day) => isSameDay(_selectedDate, day),
            startingDayOfWeek: StartingDayOfWeek.monday,
            shouldFillViewport: false,
            onDaySelected: (selectedDay, focusedDay) {
              _fetchEventsForDate(
                  selectedDay); // Fetch events for the selected date
            },
            headerStyle: const HeaderStyle(
              titleCentered: true,
              formatButtonVisible: false,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            padding: const EdgeInsets.only(left: 30),
            width: MediaQuery.of(context).size.width,
            // height: MediaQuery.of(context).size.height * 0.55,
            decoration: const BoxDecoration(
                color: Color.fromARGB(255, 132, 67, 73),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50))),
            child: Stack(
              children: <Widget>[
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Padding(
                        padding: EdgeInsets.only(top: 50),
                        child: Text(
                          "Events for today",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SingleChildScrollView(
                        child: ListView.builder(
                          itemCount: _selectedEvents.length,
                          itemBuilder: (context, index) {
                            final event = _selectedEvents[index];
                            return ListTile(
                              title: Text(event.title),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Time: ${event.time}'),
                                  Text('Location: ${event.location}'),
                                ],
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  // Call the delete function when the delete button is pressed
                                  _deleteEvent(event);
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ])
              ],
            ),
          ),
          Container(
            color: const Color.fromARGB(255, 132, 67, 73),
            margin: const EdgeInsets.symmetric(vertical: 10.0),
            padding: const EdgeInsets.all(10.0),
            child: const Text(
              'Events for the day',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddEventDialog,
        tooltip: 'Adding events to calendar',
        backgroundColor: const Color.fromARGB(255, 0, 97, 175),
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: const BottomNavigation(),
    );
  }
}

class BottomNavigationT extends StatelessWidget {
  const BottomNavigationT({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String getCurrentRoute() {
      final currentRoute = ModalRoute.of(context)?.settings.name;
      return currentRoute ?? '';
    }

    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8), // Add bottom padding here
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                    bottom: 8.0), // Add bottom padding here
                child: BottomNavigationItem(
                  context: context,
                  icon: Icon(
                    Icons.home_outlined,
                    size: 35,
                    color: getCurrentRoute() == '/home_page'
                        ? const Color(0xFF157D9E)
                        : Colors.grey,
                  ),
                  label: 'exam timetable',
                  routeName: '/about_page',
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    bottom: 8.0), // Add bottom padding here
                child: BottomNavigationItem(
                  context: context,
                  icon: Icon(
                    Icons.assignment_outlined,
                    size: 35,
                    color: getCurrentRoute() == '/my_timetable'
                        ? const Color(0xFF157D9E)
                        : Colors.grey,
                  ),
                  label: 'My Timetable',
                  routeName: '/my_timetable',
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    bottom: 8.0), // Add bottom padding here
                child: BottomNavigationItem(
                  context: context,
                  icon: Icon(
                    Icons.calendar_month_outlined,
                    size: 35,
                    color: getCurrentRoute() == '/examinations'
                        ? const Color(0xFF157D9E)
                        : Colors.grey,
                  ),
                  label: 'Calendar',
                  routeName: '/examinations',
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    bottom: 8.0), // Add bottom padding here
                child: BottomNavigationItem(
                  context: context,
                  icon: Icon(
                    Icons.chat_outlined,
                    size: 35,
                    color: getCurrentRoute() == '/chatbot'
                        ? const Color(0xFF157D9E)
                        : Colors.grey,
                  ),
                  label: 'Chatbot',
                  routeName: '/chatbot',
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    bottom: 8.0), // Add bottom padding here
                child: BottomNavigationItem(
                  context: context,
                  icon: Icon(
                    Icons.settings_outlined,
                    size: 35,
                    color: getCurrentRoute() == '/navigation_page'
                        ? const Color(0xFF157D9E)
                        : Colors.grey,
                  ),
                  label: 'Settings',
                  routeName: 'navigation_page',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BottomNavigationItem extends StatelessWidget {
  final BuildContext context;
  final Icon icon;
  final String label;
  final String routeName;

  const BottomNavigationItem({
    Key? key, // Add the Key parameter
    required this.context,
    required this.icon,
    required this.label,
    required this.routeName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacementNamed(context, routeName);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          Text(
            label,
            style: TextStyle(
              color: getCurrentRoute() == routeName
                  ? const Color(0xFF157D9E)
                  : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  String getCurrentRoute() {
    final currentRoute = ModalRoute.of(context)?.settings.name;
    return currentRoute ?? '';
  }
}
