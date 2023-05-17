import 'package:flutter/material.dart';

abstract class Consts {
  static final buttonStyle = ButtonStyle(
      backgroundColor: MaterialStateProperty.all(Colors.orangeAccent));

  static final tfStyle = InputDecoration(
    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
    focusedBorder: OutlineInputBorder(
      gapPadding: 4.0,
      borderSide: const BorderSide(color: Colors.orange),
      borderRadius: BorderRadius.circular(14),
    ),
    border: OutlineInputBorder(
      gapPadding: 0.0,
      borderSide: BorderSide(color: Colors.black12.withOpacity(0.3), width: 1),
      borderRadius: BorderRadius.circular(6),
    ),
  );

  static final boxStyle = BoxDecoration(
      color: Colors.white,
      border: Border.all(color: Colors.white, width: 2.0),
      borderRadius: BorderRadius.circular(10),
      boxShadow: <BoxShadow>[
        BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 2,
            spreadRadius: 4,
            offset: const Offset(0, 2))
      ]);

  static const bigTextStyle =
      TextStyle(fontSize: 18, fontWeight: FontWeight.w600);
  static const textStyle = TextStyle(fontSize: 16, fontWeight: FontWeight.w400);
}
