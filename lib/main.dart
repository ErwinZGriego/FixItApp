import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart'; // Este archivo lo generó el comando anterior

void main() async {
  // 1. Asegura que los bindings de Flutter estén listos antes de usar código nativo
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Inicializa Firebase usando las opciones generadas para tu plataforma
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FixIt App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Scaffold(body: Center(child: Text('Firebase Inicializado'))),
    );
  }
}
