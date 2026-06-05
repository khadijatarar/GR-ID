import 'package:flutter/material.dart';
import 'screens/start_screen.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "GR-ID",
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Color(0xFF0F172A),
      ),
      home: StartScreen(),
    );
  }
}