import 'dart:typed_data';

import 'package:campus_buddy/reusable_widgets.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'app_bar.dart';
import 'dart:convert';
import 'bottom_nav.dart';

void downloadfile() async {
  final storageRef = FirebaseStorage.instance.ref();
  final fileRef = storageRef.child('timetableData/m1152.xml');
  try {
    const oneMegabyte = 1024 * 1024;
    final Uint8List? data = await fileRef.getData(oneMegabyte);
    if (data != null) {
      final xmlString = utf8.decode(data);
      print(xmlString);
      // Use the xmlString as needed
    }
    print(data);
  } catch (e) {}
}

class NavigationPage extends StatelessWidget {
  const NavigationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const MyAppBar(),
        drawer: const NavBar(),
        bottomNavigationBar: const BottomNavigation(),
        body: firebaseUIButton(context, 'read file', () => downloadfile()));
  }
}
