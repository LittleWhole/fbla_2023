import 'package:Alatus/screens/home/calendar.dart';
import 'package:Alatus/screens/home/feed.dart';
import 'package:Alatus/screens/home/profile.dart';
import 'package:Alatus/services/auth.dart';
import 'package:flutter/material.dart';

import '../../data/globals.dart' as globals;
import '../../services/database.dart';
import 'announcements.dart';
import 'changepassword.dart';
import 'editprofile.dart';
import 'mystudents.dart';
import 'posts/post.dart';

class Home extends StatefulWidget {
  Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Alatus'),
        backgroundColor: const Color(0xFF2B4A9D),
        elevation: 0.0,
      ),
      body: getWidget(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.feed),
            label: 'Feed',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.announcement),
            label: 'Announcements',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF2B4A9D),
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        onTap: (index) async {
          globals.name =
              await DatabaseService(uid: _auth.currentUser().uid).name;
          setState(() => _selectedIndex = index);
        },
      ),
      floatingActionButton: FutureBuilder<Widget?>(
        future: getFab(_selectedIndex),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return snapshot.data!;
          } else {
            return Container();
          }
        },
      ),
    );
  }

  Widget getWidget(int index) {
    switch (index) {
      case 0:
        return const Feed();
      case 1:
        return const Calendar();
      case 2:
        return const Announcements();
      case 3:
        return const Profile();
      default:
        return const Feed();
    }
  }

  Future<Widget?> getFab(int index) async {
    DatabaseService _db = DatabaseService(uid: _auth.currentUser().uid);
    switch (index) {
      case 0:
        return FloatingActionButton.extended(
          icon: Icon(Icons.add),
          backgroundColor: const Color(0xFF2B4A9D),
          elevation: 4.0,
          label: const Text('Post'),
          onPressed: () async {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => const Post()));
          },
        );
      case 1:
        if (await _db.accountType != 'Parent') {
          return FloatingActionButton.extended(
            icon: Icon(Icons.add),
            backgroundColor: const Color(0xFF2B4A9D),
            elevation: 4.0,
            label: const Text('Event'),
            onPressed: () async {},
          );
        } else
          return null;
      case 2:
        if (await _db.accountType != 'Parent') {
          return FloatingActionButton.extended(
            icon: Icon(Icons.add),
            backgroundColor: const Color(0xFF2B4A9D),
            elevation: 4.0,
            label: const Text('Announcement'),
            onPressed: () {},
          );
        } else
          return null;
      case 3:
        return null;
      default:
        return FloatingActionButton.extended(
          icon: Icon(Icons.add),
          backgroundColor: const Color(0xFF2B4A9D),
          elevation: 4.0,
          label: const Text('Post'),
          onPressed: () {},
        );
    }
  }
}
