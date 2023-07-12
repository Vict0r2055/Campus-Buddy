import 'dart:typed_data';
import 'dart:convert';
import 'package:campus_buddy/home_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:xml/xml.dart';

class Event {
  final String title;
  final String startTime;
  final String day;
  final String room;
  final String? color;

  Event({
    required this.title,
    required this.startTime,
    required this.day,
    required this.room,
    required this.color,
  });
}

class MyTimetable extends StatefulWidget {
  const MyTimetable({Key? key}) : super(key: key);

  @override
  _MyTimetableState createState() => _MyTimetableState();
}

class _MyTimetableState extends State<MyTimetable> {
  late Future<List<Event>> _eventsFuture;
  late int _currentDayIndex;

  Map<String, Widget> tabContentMap = {};

  @override
  void initState() {
    super.initState();
    _currentDayIndex = DateTime.now().weekday - 1;
    _eventsFuture = _loadEventsFromStorage();
  }

  Future<List<Event>> _loadEventsFromStorage() async {
    if (tabContentMap.isNotEmpty) {
      return _filterEventsByDay(
          tabContentMap['$_currentDayIndex']! as List<Event>,
          '$_currentDayIndex');
    }

    final fileNames = ['m7754.xml', 'm7755.xml', 'm7704.xml', 'm7703.xml'];
    final events = await downloadEventsFromStorage(fileNames);

    final currentDayEvents = _filterEventsByDay(events, '$_currentDayIndex');
    tabContentMap['$_currentDayIndex'] =
        _buildTabContent(currentDayEvents, '$_currentDayIndex');

    return events;
  }

  Future<List<Event>> downloadEventsFromStorage(List<String> fileNames) async {
    final storage = FirebaseStorage.instance;
    List<Event> events = [];

    for (String fileName in fileNames) {
      final file = storage.ref().child('/timetableData/$fileName');
      final Uint8List? document = await file.getData();
      final xmlData = utf8.decode(document!);
      XmlDocument xmlDoc = XmlDocument.parse(xmlData);
      List<XmlElement> eventElements = xmlDoc.findAllElements('event').toList();
      for (var eventElement in eventElements) {
        String? colorValue = eventElement.getAttribute('colour');
        String day = eventElement.findElements('day').single.innerText;
        String time =
            eventElement.findElements('prettytimes').single.innerText.trim();
        String module = eventElement.findAllElements('item').first.innerText;

        String room = eventElement.findAllElements('item').last.innerText;

        events.add(Event(
          title: module,
          startTime: time,
          day: day,
          room: room,
          color: colorValue,
        ));
      }
    }

    return events;
  }

  List<Event> _filterEventsByDay(List<Event> events, String day) {
    return events.where((event) => event.day == day).toList();
  }

  Widget _buildTabContent(List<Event> events, String day) {
    final filteredEvents = events.where((event) => event.day == day).toList();

    if (filteredEvents.isEmpty) {
      return Center(child: Text('No events for $day'));
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
    return DefaultTabController(
      initialIndex: _currentDayIndex,
      length: 5,
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
          title: const Text('Daily Planner'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Mon'),
              Tab(text: 'Tue'),
              Tab(text: 'Wed'),
              Tab(text: 'Thu'),
              Tab(text: 'Fri'),
            ],
          ),
        ),
        body: FutureBuilder<List<Event>>(
          future: _eventsFuture,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final events = snapshot.data!;
              return TabBarView(
                children: [
                  _buildTabContent(events, '0'),
                  _buildTabContent(events, '1'),
                  _buildTabContent(events, '2'),
                  _buildTabContent(events, '3'),
                  _buildTabContent(events, '4'),
                ],
              );
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
