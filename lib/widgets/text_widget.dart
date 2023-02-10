import 'package:flutter/material.dart';

Widget textWidget1(String text) {
  return Text(
    text,
    style: const TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    ),
  );
}

Widget textWidget2(String text) {
  return Text(
    text,
    style: const TextStyle(
      color: Colors.black45,
    ),
  );
}
