import 'package:flutter/material.dart';

abstract class Consts {
  static final buttonStyle = ButtonStyle(
      backgroundColor: MaterialStateProperty.all(Colors.blueAccent));

  static final boxStyle = BoxDecoration(
      border: Border.all(color: Colors.teal, width: 2.0),
      borderRadius: BorderRadius.circular(10));

  static const textStyle = TextStyle(fontSize: 20, fontWeight: FontWeight.w500);
}
