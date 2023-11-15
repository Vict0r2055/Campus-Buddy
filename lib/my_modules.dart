// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'dart:convert';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:xml/xml.dart';
import 'package:hive/hive.dart';
import 'package:campus_buddy/reusable_widgets.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'my_timetable.dart';

class Item {
  final String code;
  final String name;
  final String description;
  bool selected;

  Item(
      {required this.code,
      required this.name,
      required this.description,
      this.selected = false});
}

class MyModules extends StatefulWidget {
  const MyModules({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyModulesState createState() => _MyModulesState();
}

class _MyModulesState extends State<MyModules> {
  late List<Item> itemList;
  late List<Item> filteredList;
  List<Item> selectedItems = [];
  List<String> fileNames = [];
  List<String> moduleCodes = [];

  final FirebaseDatabase database = FirebaseDatabase.instance;

  @override
  void initState() {
    super.initState();
    itemList = [];
    filteredList = [];
    fetchItemsFromFirebase();
  }

  void fetchItemsFromFirebase() {
    database.ref().child('Modules').onValue.listen((event) {
      Map<dynamic, dynamic>? items =
          event.snapshot.value as Map<dynamic, dynamic>?; // Type casting
      itemList.clear();
      items?.forEach((key, value) {
        itemList.add(Item(
          code: key,
          name: value['text'],
          description: value['value'],
        ));
      });
      setState(() {
        filteredList = List.from(itemList);
      });
    });
  }

  void filterItems(String query) {
    setState(() {
      filteredList = itemList
          .where(
              (item) => item.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void toggleItemSelection(Item item) {
    setState(() {
      item.selected = !item.selected;
      if (item.selected) {
        selectedItems.add(item);
        fileNames.add(item.description);
        moduleCodes.add(item.code);
        // print(fileNames);
      } else {
        selectedItems.remove(item);
        fileNames.remove(item.description);
        moduleCodes.remove(item.code);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          onChanged: (value) => filterItems(value),
          decoration: const InputDecoration(
            hintText: 'Search',
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: filteredList.length,
        itemBuilder: (context, index) {
          final item = filteredList[index];
          return ListTile(
            title: Text(item.name),
            subtitle: Text(item.description),
            leading: Checkbox(
              value: item.selected,
              onChanged: (_) => toggleItemSelection(item),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Call the downloadEventsFromStorage function
          // print(selectedItems);
          // print(moduleCodes);
          downloadEventsFromStorage(fileNames, context);
          showCustomSnackbar(context, "Done navigate to timetable page");

          saveListToFirebase(moduleCodes);
          saveModuleCodesToHive(moduleCodes);
          // Navigate to my_timetable.dart
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) =>
          //         const MyTimetable(), // Replace with your actual page/widget
          //   ),
          // );
        },
        child: const Icon(Icons.done),
      ),
    );
  }
}

@HiveType(typeId: 0) // Add this annotation and specify a unique typeId.
class Event {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final String startTime;

  @HiveField(2)
  final String day;

  @HiveField(3)
  final String room;

  // @HiveField(4)
  // final String? color;

  Event({
    required this.title,
    required this.startTime,
    required this.day,
    required this.room,
    // required this.color,
  });
}

class EventAdapter extends TypeAdapter<Event> {
  @override
  final int typeId = 0; // Assign a unique typeId for the Event class.

  @override
  Event read(BinaryReader reader) {
    return Event(
      title: reader.readString(),
      startTime: reader.readString(),
      day: reader.readString(),
      room: reader.readString(),
      // color: reader.readString(),
    );
  }

  @override
  void write(BinaryWriter writer, Event obj) {
    writer.writeString(obj.title);
    writer.writeString(obj.startTime);
    writer.writeString(obj.day);
    writer.writeString(obj.room);
    // writer.writeString(obj.color);
  }
}

Future<void> saveEventsToHive(List<Event> events) async {
  final eventsBox = await Hive.openBox('events');
  eventsBox.clear(); // Clear the box to avoid duplicates.
  eventsBox.addAll(events);
  // await getEventsFromHive();
}

Future<List<Event>> getEventsFromHive() async {
  final eventsBox = await Hive.openBox('events');
  List<Event> events = eventsBox.values.toList().cast<Event>();
  printing(events);
  // print("i got thembags");
  return events;
}

void printing(events) {
  events.forEach((event) {
    // print(event.title);
    // print(event.startTime);
    // print(event.day);
    // print(event.room);
  });
}

Future<void> saveModuleCodesToHive(List<String> moduleCodes) async {
  try {
    await Hive.initFlutter();

    // Open the Hive box for module codes
    final moduleCodesBox = await Hive.openBox<List<String>>('moduleCodes');

    // Simply put the data into the box
    moduleCodesBox.put('moduleCodes', moduleCodes);
    readAndPrintModuleCodesFromHive();
  } catch (error) {
    print("Error saving module codes to Hive: $error");
    // Handle the error as needed
  }
}

Future<List<Event>> downloadEventsFromStorage(
    List<String> fileNames, BuildContext context) async {
  final storage = FirebaseStorage.instance;
  List<Event> events = [];
  // print("boy doing things");
  for (String fileName in fileNames) {
    final file = storage.ref().child('/timetableData/$fileName');
    final Uint8List? document = await file.getData();
    final xmlData = utf8.decode(document!);
    XmlDocument xmlDoc = XmlDocument.parse(xmlData);
    List<XmlElement> eventElements = xmlDoc.findAllElements('event').toList();
    for (var eventElement in eventElements) {
      // String? colorValue = eventElement.getAttribute('colour');
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
        // color: colorValue,
      ));
    }
  }
  // print("never in doubt ");
  // showCustomSnackbar(context, "never in doubt ");
  saveEventsToHive(events);
  // showCustomSnackbar(context, "weeee ayii iqedile boi ayikasebenzi namanje");
  // print("weeee ayii iqedile boi ayikasebenzi namanje");
  return events;
}

Future<void> saveListToFirebase(List<String> data) async {
  final reference = FirebaseDatabase.instance.ref().child('users');

  User? user = FirebaseAuth.instance.currentUser;
  // print(user);
  // List<String>? codes;

  try {
    // Use the UID of the authenticated user to identify them
    await reference.child(user!.uid).update({
      'modules': data,
    });
  } catch (error) {
    // Handle any errors, such as network issues
    print("Error: $error");
  }
}

Future<void> readAndPrintModuleCodesFromHive() async {
  try {
    // Open the Hive box for module codes
    final moduleCodesBox = await Hive.openBox<List<String>>('moduleCodes');

    // Retrieve the list from the box
    final List<String>? moduleCodes = moduleCodesBox.get('moduleCodes');

    // Print each element in the list
    if (moduleCodes != null) {
      print(moduleCodes);
      for (String code in moduleCodes) {
        print(code);
      }
    } else {
      print("Module codes list is empty or not found in Hive box.");
    }
  } catch (error) {
    print("Error reading module codes from Hive: $error");
    // Handle the error as needed
  }
}
