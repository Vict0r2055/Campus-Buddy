import 'package:campus_buddy/examinations.dart';
import 'package:campus_buddy/admin_panel.dart';
import 'package:campus_buddy/my_modules.dart';
import 'package:campus_buddy/sign_in.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:campus_buddy/bottom_nav.dart';
import 'chatbot.dart';
import 'home_page.dart';
import 'my_timetable.dart';
import 'calendar.dart';
import 'app_bar.dart';
import 'firebase_options.dart';
// import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'qr_scanner.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(EventAdapter());
  // Hive.registerAdapter(EventAdapter());
  // await Hive.openBox<Event>('events');
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
      // home: const MyHomePage(),
      home: const SignInScreen(),
      routes: {
        '/my_modules': (context) => const MyModules(),
        '/home_page': (context) => const HomePage(),
        '/my_timetable': (context) => const MyTimetable(),
        '/examinations': (context) => const CalendarScreen(),
        '/qr_scanner': (context) => const QRCodeScannerPage(),
        '/chatbot': (context) => const ChatScreen(),
        '/about_page': (context) => const AboutPage(),
        '/admin_panel': (context) => const AdminPage(),
        // '/qr_scanner': (context) => const QRCodeScannerPage(),
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
    return Scaffold(
        appBar: const MyAppBar(),
        drawer: const NavBar(),
        bottomNavigationBar: const BottomNavigation(),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/logo.jpeg'),
              fit: BoxFit.contain,
              alignment: Alignment.center,
            ),
          ),
        ));
  }
}
