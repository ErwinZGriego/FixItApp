// lib/presentation/app/fixit_app.dart
import 'package:fix_it_app/presentation/screens/incident_detail_screen.dart';
import 'package:fix_it_app/presentation/screens/incident_history_screen.dart';
import 'package:fix_it_app/presentation/viewmodels/create_report_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_theme.dart';
import '../screens/create_report_screen.dart';
import '../screens/dashboard_screen.dart';
import '../screens/home_screen.dart';
import '../screens/login_screen.dart';
import '../screens/register_screen.dart';
import '../viewmodels/login_view_model.dart';

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
          RegisterScreen.routeName: (_) => const RegisterScreen(),
          DashboardScreen.routeName: (_) => const DashboardScreen(),
          HomeScreen.routeName: (_) => const HomeScreen(),

          CreateReportScreen.routeName: (_) => ChangeNotifierProvider(
            create: (_) => CreateReportViewModel(),
            child: const CreateReportScreen(),
          ),
          IncidentHistoryScreen.routeName: (_) => const IncidentHistoryScreen(),
          IncidentDetailScreen.routeName: (_) => const IncidentDetailScreen(),
        },
      ),
    );
  }
}
