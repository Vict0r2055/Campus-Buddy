import 'package:flutter/material.dart';
import 'app_bar.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: MyAppBar(),
      drawer: NavBar(),
      body: Center(
        child: Text('This is a Admin page!'),
      ),
    );
  }
}
