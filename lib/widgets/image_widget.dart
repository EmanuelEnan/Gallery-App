import 'package:flutter/material.dart';

Widget imageWidget1() {
  return const Image(
    image: AssetImage(
      'assets/01.jpg',
    ),
    fit: BoxFit.cover,
  );
}
