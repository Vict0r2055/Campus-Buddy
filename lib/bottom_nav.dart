import 'package:flutter/material.dart';

class BottomNavigation extends StatelessWidget {
  const BottomNavigation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String getCurrentRoute() {
      final currentRoute = ModalRoute.of(context)?.settings.name;
      return currentRoute ?? '';
    }

    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            BottomNavigationItem(
              context: context,
              icon: Icon(
                Icons.home_outlined,
                size: 40,
                color: getCurrentRoute() == '/home_page'
                    ? Colors.blue
                    : Colors.grey,
              ),
              label: 'Home',
              routeName: '/home_page',
            ),
            BottomNavigationItem(
              context: context,
              icon: Icon(
                Icons.calendar_month_outlined,
                size: 40,
                color: getCurrentRoute() == '/my_timetable'
                    ? Colors.blue
                    : Colors.grey,
              ),
              label: 'My Timetable',
              routeName: '/my_timetable',
            ),
            BottomNavigationItem(
              context: context,
              icon: Icon(
                Icons.assignment_outlined,
                size: 40,
                color: getCurrentRoute() == '/examinations'
                    ? Colors.blue
                    : Colors.grey,
              ),
              label: 'Examinations',
              routeName: '/examinations',
            ),
            BottomNavigationItem(
              context: context,
              icon: Icon(
                Icons.navigation_outlined,
                size: 40,
                color: getCurrentRoute() == '/navigation_page'
                    ? Colors.blue
                    : Colors.grey,
              ),
              label: 'Navigation',
              routeName: '/navigation_page',
            ),
            BottomNavigationItem(
              context: context,
              icon: Icon(
                Icons.chat_outlined,
                size: 40,
                color:
                    getCurrentRoute() == '/chatbot' ? Colors.blue : Colors.grey,
              ),
              label: 'Chatbot',
              routeName: '/chatbot',
            ),
          ],
        ),
      ),
    );
  }
}

class BottomNavigationItem extends StatelessWidget {
  final BuildContext context;
  final Icon icon;
  final String label;
  final String routeName;

  const BottomNavigationItem({
    super.key,
    required this.context,
    required this.icon,
    required this.label,
    required this.routeName,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacementNamed(context, routeName);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          Text(
            label,
            style: TextStyle(
              color: getCurrentRoute() == routeName ? Colors.blue : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  String getCurrentRoute() {
    final currentRoute = ModalRoute.of(context)?.settings.name;
    return currentRoute ?? '';
  }
}
