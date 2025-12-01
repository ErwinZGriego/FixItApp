// lib/presentation/app/fixit_app.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_theme.dart';
import '../home/home_screen.dart';
import '../login/login_screen.dart';
import '../login/login_view_model.dart';

class FixItApp extends StatelessWidget {
  const FixItApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        // Más ViewModels se agregan aquí conforme avancen las HU
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'FixIt',
        theme: AppTheme.lightTheme,
        initialRoute: LoginScreen.routeName,
        routes: {
          LoginScreen.routeName: (_) => const LoginScreen(),
          HomeScreen.routeName: (_) => const HomeScreen(),
        },
      ),
    );
  }
}
