import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'core/di/service_locator.dart';
import 'firebase_options.dart';
import 'presentation/app/fixit_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await setupServiceLocator();

  runApp(const FixItApp());
}
