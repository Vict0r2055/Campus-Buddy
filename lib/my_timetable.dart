// ignore_for_file: library_private_types_in_public_api

import 'package:campus_buddy/home_page.dart';
import 'package:flutter/material.dart';
import 'package:campus_buddy/my_modules.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:campus_buddy/bottom_nav.dart';
import 'app_bar.dart';

class MyTimetable extends StatefulWidget {
  const MyTimetable({Key? key}) : super(key: key);
  // final Function(List<Event>) rebuildCallback;

  // const MyTimetable({Key? key, required this.rebuildCallback}) : super(key: key);

  @override
  _MyTimetableState createState() => _MyTimetableState();
}

class _MyTimetableState extends State<MyTimetable> {
  late int _currentDayIndex;
  List<Event> events = [];

  @override
  void initState() {
    super.initState();
    _currentDayIndex = DateTime.now().weekday - 1;
    fetchEvents(); // Call the function to fetch events
  }

  Future<List<Event>> getEventsFromHive() async {
    final eventsBox = await Hive.openBox('events');
    List<Event> events = eventsBox.values.toList().cast<Event>();
    // printing(events);
    // print("i got thembags");
    return events;
  }

  void fetchEvents() async {
    // Call the method to fetch events from Hive
    List<Event> fetchedEvents = await getEventsFromHive();

    // Update the events list with the fetched events
    setState(() {
      events = fetchedEvents;
    });
  }

  Widget _buildTabContent(List<Event> events, String day) {
    final filteredEvents = events.where((event) => event.day == day).toList();
    if (filteredEvents.isEmpty) {
      return Center(child: Text('No events for today'));
    }
    filteredEvents.sort((a, b) => a.startTime.compareTo(b.startTime));
    return Column(
      children: filteredEvents.map((event) {
        return Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(16),
          ),
          child: ListTile(
            title: Text(event.title),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Text('Time: ${event.startTime}'),
                const SizedBox(height: 4),
                Text('Room: ${event.room}'),
                const SizedBox(height: 4),
              ],
            ),
          ),
        );
      }).toList(),
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
        initialIndex: _currentDayIndex <= 4 ? _currentDayIndex : 4,
        length: 5,
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
            bottom: const TabBar(
              labelColor:
                  Colors.white, // Change the color of the selected tab text
              unselectedLabelColor: Colors.grey,
              tabs: [
                Tab(text: 'Mon'),
                Tab(text: 'Tue'),
                Tab(text: 'Wed'),
                Tab(text: 'Thu'),
                Tab(text: 'Fri'),
              ],
            ),
          ),
          drawer: const NavBar(),
          body: events.isNotEmpty
              ? TabBarView(
                  children: [
                    _buildTabContent(events, '0'),
                    _buildTabContent(events, '1'),
                    _buildTabContent(events, '2'),
                    _buildTabContent(events, '3'),
                    _buildTabContent(events, '4'),
                  ],
                )
              : const Center(child: CircularProgressIndicator()),
          bottomNavigationBar: const BottomNavigation(),
        ),
      ),
    );
  }
}
