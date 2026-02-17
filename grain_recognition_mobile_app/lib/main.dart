import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Grain Recognition App',
      theme: ThemeData(
        primarySwatch: Colors.green,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        scaffoldBackgroundColor: Colors.green[900], // dark green background
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF004d00), // darker green
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF00b300),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
