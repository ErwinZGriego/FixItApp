import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_theme.dart';
import '../login/login_screen.dart';
import '../login/login_view_model.dart';

class FixItApp extends StatelessWidget {
  const FixItApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        // Aquí irán más ViewModels (home, reportes, etc.) según las HU
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'FixIt',
        theme: AppTheme.lightTheme,
        home: const LoginScreen(),
      ),
    );
  }
}
