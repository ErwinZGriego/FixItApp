import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/di/service_locator.dart';
import 'core/theme/app_theme.dart';
import 'firebase_options.dart';
import 'presentation/login/login_screen.dart';
import 'presentation/login/login_view_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await setupServiceLocator();

  runApp(const FixItApp());
}

class FixItApp extends StatelessWidget {
  const FixItApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => LoginViewModel())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'FixIt App',
        theme: AppTheme.lightTheme,
        home: const LoginScreen(),
      ),
    );
  }
}
