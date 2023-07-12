import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class Item {
  final String name;
  final String description;
  bool selected;

  Item({required this.name, required this.description, this.selected = false});
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
      } else {
        selectedItems.remove(item);
        fileNames.remove(item.description);
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
          print(fileNames);
          // Do something with selected items
          // for (var item in selectedItems) {
          //   // print(selectedItems);
          //   // print('Selected Item: ${item.name}');

          // }
        },
        child: const Icon(Icons.done),
      ),
    );
  }
}
