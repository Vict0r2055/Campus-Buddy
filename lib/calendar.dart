import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:campus_buddy/bottom_nav.dart';
import 'app_bar.dart';

class Event {
  final String title;
  final String time;
  final String location;

  Event(this.title, this.time, this.location);
}

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  // CalendarFormat _calendarFormat = CalendarFormat.month;
  // DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  final Map<DateTime, List<Event>> _events = {};
  DateTime _selectedDate = DateTime.now();
  final TextEditingController _eventTitleController = TextEditingController();
  final TextEditingController _eventTimeController = TextEditingController();
  final TextEditingController _eventLocationController =
      TextEditingController();
  // final Map<DateTime, List<Event>> _events = {};
  List<Event> _selectedEvents =
      []; // List to store events for the selected date

  // List<Event> _selectedEvents = [];

  @override
  void initState() {
    super.initState();
    _selectedEvents = _events[_selectedDay] ?? [];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      // _focusedDay = focusedDay;
      _selectedEvents = _events[selectedDay] ?? [];
    });
  }

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
      _fetchEventsForDate(_selectedDay);

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
                _fetchEventsForDate(_selectedDay);
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
      body: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Column(
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
                const SizedBox(height: 20),
              ],
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                if (index == 0) {
                  return Container(
                    color: const Color.fromARGB(255, 132, 67, 73),
                    margin: const EdgeInsets.symmetric(vertical: 10.0),
                    padding: const EdgeInsets.all(16.0),
                    child: const Text(
                      'Events for the day',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                  );
                }
                final event = _selectedEvents[index - 1];
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
                      _deleteEvent(event);
                    },
                  ),
                );
              },
              childCount: _selectedEvents.length + 1,
            ),
          ),
          // const SliverToBoxAdapter(
          //   child: Column(
          //     children: [
          //       // Rest of your content
          //     ],
          //   ),
          // ),
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
