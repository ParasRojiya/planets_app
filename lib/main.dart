import 'package:flutter/material.dart';
import 'package:planets_app/screens/detail_page.dart';
import 'package:planets_app/screens/homepage.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => const HomePage(),
        'detail_page': (context) => const DetailPage(),
      },
    ),
  );
}
