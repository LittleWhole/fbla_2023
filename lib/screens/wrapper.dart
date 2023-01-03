import 'package:Alatus/screens/authenticate/authenticate.dart';
import 'package:Alatus/screens/home/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';

import 'package:Alatus/data/globals.dart' as globals;

import 'home/changepassword.dart';
import 'home/editprofile.dart';
import 'home/mystudents.dart';
import 'home/profile.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    print(user);

    // return either Home or Authenticate widghet
    return user == null ? const Authenticate() : Home();
  }
}
