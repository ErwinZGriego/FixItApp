import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'presentation/home_screen.dart'; // Importamos la pantalla de la capa de presentación

void main() async {
  // 1. Inicialización de Bindings y Firebase
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Aquí inicializaremos la Inyección de Dependencias (DI) más adelante.
  // setupServiceLocator();

  runApp(const FixItApp());
}

class FixItApp extends StatelessWidget {
  const FixItApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Quitamos la etiqueta de debug
      title: 'FixIt App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      // La home apunta a nuestra capa de presentación
      home: const HomeScreen(),
    );
  }
}
