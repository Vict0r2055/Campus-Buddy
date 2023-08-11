import 'package:flutter/material.dart';
import 'app_bar.dart';
import 'bottom_nav.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      drawer: NavBar(),
      bottomNavigationBar: BottomNavigation(),
      body: Container(
        // Wrap the body in a Container to set the background color
        color: Colors.black26, // Set your desired background color here
        child: Center(
          child: Text('Home'),
        ),
      ),
    );
  }
}
