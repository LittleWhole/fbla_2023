import 'dart:async';

import 'package:fbla_2023/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
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
                    showDialog(
                        context: context,
                        builder: ((context) =>
                            confirmAbsenceDialog("this student")));
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

  Widget confirmAbsenceDialog(String name) {
    return AlertDialog(
      title: const Text('Declare an Absence'),
      content: Text('Would you like to declare an absence for $name?'),
      actions: [
        TextButton(
          child: const Text('Yes'),
          onPressed: () async {
            /*await DatabaseService(uid: _auth.currentUser().uid)
                .declareAbsence(globals.currentStudent);
            Navigator.pop(context);*/
            Navigator.pop(context);
            showDateRangePicker(
                    context: context,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.fromMillisecondsSinceEpoch(
                        DateTime.now().millisecondsSinceEpoch + 31556926000))
                .then((value) async {
              if (value == null) {
                return;
              } else {
                /*await DatabaseService(uid: _auth.currentUser().uid)
                    .declareAbsence(
                        globals.currentStudent, value.start, value.end);*/
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                      title: const Text("Absence Declared"),
                      content: Text(
                          "You successfully declared absence for this student for the dates ${DateFormat.yMd().format(value.start)} to ${DateFormat.yMd().format(value.end)}."),
                      actions: [
                        TextButton(
                            child: const Text('Ok'),
                            onPressed: () async {
                              /*await DatabaseService(uid: _auth.currentUser().uid)
                .declareAbsence(globals.currentStudent);
            Navigator.pop(context);*/
                              Navigator.pop(context);
                            })
                      ]),
                );
              }
            });
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
