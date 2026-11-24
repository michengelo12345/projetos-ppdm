import 'package:flutter/material.dart';

import 'screens/home_screen.dart';

void main() {
  runApp(const PpdmExercisesApp());
}

class PpdmExercisesApp extends StatelessWidget {
  const PpdmExercisesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PPDM - Exercícios',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF176B5B),
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF5F7F6),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF176B5B),
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
