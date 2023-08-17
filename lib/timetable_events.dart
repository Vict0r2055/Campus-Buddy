// import 'package:flutter/material.dart';
// import 'dart:typed_data';
// import 'dart:convert';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:xml/xml.dart';
// import 'package:hive/hive.dart';

// class EventPage extends StatefulWidget {
//   @override
//   _EventPageState createState() => _EventPageState();
// }

// class _EventPageState extends State<EventPage> {
//   List<Event> events = [];

//   @override
//   void initState() {
//     super.initState();
//     // Initialize Firebase if you haven't already done so.
//     final fileNames = ["m7322.xml"];
//     // downloadEventsFromStorage(fileNames); // Call the downloadEvents function when the page loads.
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Sample Page'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               'Welcome to the Sample Page!',
//               style: TextStyle(fontSize: 24),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 getEventsFromHive();

//                 // TODO: Add button functionality here
//                 // This function will be called when the button is pressed.
//               },
//               child: Text('Click Me!'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// @HiveType(typeId: 0) // Add this annotation and specify a unique typeId.
// class Event {
//   @HiveField(0)
//   final String title;

//   @HiveField(1)
//   final String startTime;

//   @HiveField(2)
//   final String day;

//   @HiveField(3)
//   final String room;

//   // @HiveField(4)
//   // final String? color;

//   Event({
//     required this.title,
//     required this.startTime,
//     required this.day,
//     required this.room,
//     // required this.color,
//   });
// }

// class EventAdapter extends TypeAdapter<Event> {
//   @override
//   final int typeId = 0; // Assign a unique typeId for the Event class.

//   @override
//   Event read(BinaryReader reader) {
//     return Event(
//       title: reader.readString(),
//       startTime: reader.readString(),
//       day: reader.readString(),
//       room: reader.readString(),
//       // color: reader.readString(),
//     );
//   }

//   @override
//   void write(BinaryWriter writer, Event obj) {
//     writer.writeString(obj.title);
//     writer.writeString(obj.startTime);
//     writer.writeString(obj.day);
//     writer.writeString(obj.room);
//     // writer.writeString(obj.color);
//   }
// }

// Future<void> saveEventsToHive(List<Event> events) async {
//   final eventsBox = await Hive.openBox('events');
//   eventsBox.clear(); // Clear the box to avoid duplicates.
//   eventsBox.addAll(events);
// }

// Future<List<Event>> getEventsFromHive() async {
//   final eventsBox = await Hive.openBox('events');
//   List<Event> events = eventsBox.values.toList().cast<Event>();
//   // printing(events);
//   return events;
// }

// void printing(events) {
//   events.forEach((event) {
//     print(event.title);
//     print(event.startTime);
//     print(event.day);
//     print(event.room);
//   });
// }

// Future<List<Event>> downloadEventsFromStorage(List<String> fileNames) async {
//   final storage = FirebaseStorage.instance;
//   List<Event> events = [];

//   for (String fileName in fileNames) {
//     final file = storage.ref().child('/timetableData/$fileName');
//     final Uint8List? document = await file.getData();
//     final xmlData = utf8.decode(document!);
//     XmlDocument xmlDoc = XmlDocument.parse(xmlData);
//     List<XmlElement> eventElements = xmlDoc.findAllElements('event').toList();
//     for (var eventElement in eventElements) {
//       // String? colorValue = eventElement.getAttribute('colour');
//       String day = eventElement.findElements('day').single.innerText;
//       String time =
//           eventElement.findElements('prettytimes').single.innerText.trim();
//       String module = eventElement.findAllElements('item').first.innerText;

//       String room = eventElement.findAllElements('item').last.innerText;

//       events.add(Event(
//         title: module,
//         startTime: time,
//         day: day,
//         room: room,
//         // color: colorValue,
//       ));
//     }
//   }
//   saveEventsToHive(events);
//   return events;
// }
