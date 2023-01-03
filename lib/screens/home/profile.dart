library profile;

import 'dart:async';

import 'package:Alatus/services/auth.dart';
import 'package:Alatus/services/database.dart';
import 'package:Alatus/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../../data/globals.dart' as globals;
import 'changepassword.dart';
import 'editprofile.dart';
import 'mystudents.dart';

int profilePage = 0;

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            //width: double.infinity,
            //padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: InkWell(
              child: Row(children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: const BoxDecoration(
                    color: const Color(0xFF2B4A9D),
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                          'https://www.w3schools.com/howto/img_avatar.png'),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100 / 2),
                    child: Image.network(
                      'https://www.w3schools.com/howto/img_avatar.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(globals.name, style: titleStyle)),
                      const SizedBox(height: 5),
                      Text(_auth.email),
                      const SizedBox(height: 5),
                      FutureBuilder(
                        future: DatabaseService(uid: _auth.currentUser().uid)
                            .accountType,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Text(snapshot.data!);
                          } else {
                            return const Text('Loading...');
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ]),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  ListView(
                    shrinkWrap: true,
                    children: [
                      Card(
                        color: const Color(0xFF2B4A9D),
                        child: ListTile(
                          textColor: Colors.white,
                          title: const Text('Manage My Students'),
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: () async {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const MyStudents()));
                          },
                        ),
                      ),
                      FutureBuilder(
                          future: DatabaseService(uid: _auth.currentUser().uid)
                              .accountType,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              if (snapshot.data == 'Principal') {
                                return Card(
                                  child: ListTile(
                                    title: const Text('Edit User Permissions'),
                                    trailing:
                                        const Icon(Icons.arrow_forward_ios),
                                    onTap: () async {
                                      setState(() {
                                        profilePage = 2;
                                      });
                                    },
                                  ),
                                );
                              } else {
                                return Container();
                              }
                            } else {
                              return Container();
                            }
                          }),
                      Card(
                        child: ListTile(
                          title: const Text('Edit Profile'),
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: () async {
                            setState(() {
                              profilePage = 3;
                            });
                          },
                        ),
                      ),
                      Card(
                        child: ListTile(
                          title: const Text('Change Password'),
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: () async {
                            setState(() {
                              profilePage = 4;
                            });
                          },
                        ),
                      ),
                      Card(
                        child: ListTile(
                          title: const Text('Sign Out'),
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: () async {
                            showDialog(
                                context: context,
                                builder: (_) => signOutDialog());
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget signOutDialog() {
    return AlertDialog(
      title: const Text('Sign Out'),
      content: const Text('Are you sure you want to sign out?'),
      actions: [
        TextButton(
          child: const Text('Yes'),
          onPressed: () async {
            await _auth.signOut().then((value) => Navigator.pop(context));
          },
        ),
        TextButton(
          child: const Text('No'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
