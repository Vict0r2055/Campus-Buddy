import 'package:flutter/material.dart';
import 'app_bar.dart';
import 'package:campus_buddy/bottom_nav.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(),
      drawer: const NavBar(),
      bottomNavigationBar: const BottomNavigation(),
      body: Container(
        // Wrap the body in a Container to set the background color
        color: Colors.black26, // Set your desired background color here
        child: const Center(
          child: Text('Home'),
        ),
      ),
    );
  }
}
