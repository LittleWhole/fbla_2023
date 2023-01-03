import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: const Center(
          child: SpinKitFadingCircle(
            color: const Color(0xFF2B4A9D),
            size: 50.0,
          ),
        ));
  }
}
