// lib/main.dart
import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const BancaSeguraApp());
}

class BancaSeguraApp extends StatelessWidget {
  const BancaSeguraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Banca Segura',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}