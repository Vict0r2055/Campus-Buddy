import 'package:campus_buddy/about_page.dart';
import 'package:campus_buddy/admin_panel.dart';
import 'package:flutter/material.dart';
import 'package:campus_buddy/bottom_nav.dart';
import 'navigation_Page.dart';
import 'home_page.dart';
import 'my_timetable.dart';
import 'examinations.dart';
import 'chatbot.dart';
import 'app_bar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Set this to false
      title: 'Campus Buddy',
      theme: ThemeData(
        primaryColor: Colors.white,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          color: Colors.white,
          centerTitle: true,
          iconTheme: IconThemeData(color: Color(0xFF157D9E)),
          toolbarHeight: 40,
        ),
      ),
      home: const MyHomePage(),
      routes: {
        '/home_page': (context) => const HomePage(),
        '/my_timetable': (context) => const MyTimetable(),
        '/examinations': (context) => const ExaminationsPage(),
        '/navigation_page': (context) => const NavigationPage(),
        '/chatbot': (context) => const Chatbot(),
        '/about_page': (context) => const AboutPage(),
        '/admin_panel': (context) => const AdminPage(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        appBar: MyAppBar(),
        drawer: NavBar(),
        bottomNavigationBar: BottomNavigation());
  }
}
