import 'dart:async';

import 'package:fbla_2023/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

import '../../services/auth.dart';
import '../../services/database.dart';
import 'profile.dart';
import '../../data/globals.dart' as globals;

class MyStudents extends StatefulWidget {
  const MyStudents({super.key});

  @override
  State<MyStudents> createState() => _MyStudentsState();
}

class _MyStudentsState extends State<MyStudents> {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(padding: EdgeInsetsDirectional.only(top: 40)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: [
                    IconButton(
                        icon: const Icon(Icons.arrow_back_ios),
                        onPressed: () {
                          Navigator.pop(context);
                        }),
                    const Text('My Students', style: titleStyle),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {},
                ),
              ],
            ),
            //const SizedBox(height: 16),
            Expanded(
              child: SizedBox(child: _studentsListView()),
            )
          ],
        ),
      ),
    );
  }

  Widget _studentsListView() {
    return FutureBuilder(
      future: DatabaseService(uid: _auth.currentUser().uid).usersStudents,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  title: FutureBuilder(
                    future: DatabaseService(uid: _auth.currentUser().uid)
                        .fetchStudentName(snapshot.data![index]),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Text(snapshot.data.toString());
                      } else {
                        return const Text("Loading...");
                      }
                    },
                  ),
                  //title: Text(DatabaseService(uid: _auth.currentUser().uid).fetchStudentName(snapshot.data![index])),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () async {
                    setState(() {});
                  },
                ),
              );
            },
          );
        } else {
          return const Text("No students");
        }
      },
    );

    /*return ListView.builder(
      itemCount: await DatabaseService(uid: _auth.currentUser().uid).usersStudents.length,
      itemBuilder: (context, index) {
        return Text("hello");
      },
    );*/
  }
}
