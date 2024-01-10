import 'package:flutter/material.dart';
import 'package:kanbaniser/app/views/home_view.dart';
import 'package:kanbaniser/core/themes/light_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kanbaniser',
      theme: LightTheme().theme,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          appBar: AppBar(
            title: const Text(
              'Kanbaniser',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
                color: Colors.white
              ),
            ),
            backgroundColor: const Color(0xFF645757),
          ),
          body: const HomeView()),
    );
  }
}
