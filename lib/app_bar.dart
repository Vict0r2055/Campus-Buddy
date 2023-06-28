import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: const Text(
        'CAMPUS BUDDY',
        style: TextStyle(
          color: Color(0xFF157D9E),
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
    );
  }
}

class MyAppBarWithDrawer extends StatelessWidget
    implements PreferredSizeWidget {
  const MyAppBarWithDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: const Text(
        'CAMPUS BUDDY',
        style: TextStyle(
          color: Color(0xFF157D9E),
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
      ],
    );
  }
}

class NavBar extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
  const NavBar({Key? key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color.fromARGB(141, 131, 134, 135),
      child: ListView(
        children: [
          const UserAccountsDrawerHeader(
            accountName: Text('oihehdeded'),
            accountEmail: Text('eedqwiuhww@gmail.com'),
          ),
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text('Home'),
            onTap: () {
              // Navigate to the Home page
              Navigator.pushNamed(context, '/home_page');
            },
          ),
          ListTile(
            leading: const Icon(Icons.calendar_month_outlined),
            title: const Text('My Timetable'),
            onTap: () {
              // Navigate to the My Timetable page
              Navigator.pushNamed(context, '/my_timetable');
            },
          ),
          ListTile(
            leading: const Icon(Icons.assessment_outlined),
            title: const Text('Examinations'),
            onTap: () {
              // Navigate to the Examinations page
              Navigator.pushNamed(context, '/examinations');
            },
          ),
          ListTile(
            leading: const Icon(Icons.navigation_outlined),
            title: const Text('Navigation'),
            onTap: () {
              // Navigate to the Navigation page
              Navigator.pushNamed(context, '/navigation_page');
            },
          ),
          ListTile(
            leading: const Icon(Icons.chat_outlined),
            title: const Text('Chatbot'),
            onTap: () {
              // Navigate to the Chatbot page
              Navigator.pushNamed(context, '/chatbot');
            },
          ),
          ListTile(
            leading: const Icon(Icons.admin_panel_settings_outlined),
            title: const Text('Admin Panel'),
            onTap: () {
              // Navigate to the Admin Panel page
              Navigator.pushNamed(context, '/admin_panel');
            },
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About'),
            onTap: () {
              // Navigate to the About page
              Navigator.pushNamed(context, '/about_page');
            },
          ),
        ],
      ),
    );
  }
}
