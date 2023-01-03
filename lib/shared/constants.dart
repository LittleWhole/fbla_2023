import 'package:flutter/material.dart';

const textInputDecoration = InputDecoration(
  fillColor: Colors.white,
  filled: true,
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.grey, width: 2.0),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: const Color(0xFF2B4A9D), width: 2.0),
  ),
);

const TextStyle titleStyle =
    TextStyle(fontSize: 29, fontWeight: FontWeight.bold);

const TextStyle subtitleStyle =
    TextStyle(fontSize: 20, fontWeight: FontWeight.normal);
