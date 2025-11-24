import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'core/di/service_locator.dart';
import 'core/theme/app_theme.dart';
import 'firebase_options.dart';
import 'presentation/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await setupServiceLocator();

  runApp(const FixItApp());
}

class FixItApp extends StatelessWidget {
  const FixItApp({super.key});

  @override
  Widget build(BuildContext context) {
    // NOTA: MultiProvider requiere al menos un provider para funcionar.
    // Lo dejamos comentado hasta tener el primer ViewModel (ej. LoginViewModel).

    /* return MultiProvider(
      providers: [
        // ChangeNotifierProvider(create: (_) => getIt<LoginViewModel>()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'FixIt App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
          useMaterial3: true,
        ),
        home: const HomeScreen(),
      ),
    );
    */

    // Mientras tanto, retornamos la app directa para que no falle
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FixIt App',
      theme: AppTheme.lightTheme,
      home: const HomeScreen(),
    );
  }
}
