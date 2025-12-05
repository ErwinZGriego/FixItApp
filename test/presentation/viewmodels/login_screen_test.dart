import 'package:fix_it_app/core/di/service_locator.dart';
import 'package:fix_it_app/domain/repositories/i_auth_repository.dart';
import 'package:fix_it_app/presentation/screens/login_screen.dart';
import 'package:fix_it_app/presentation/viewmodels/login_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import '../../mocks.dart';

void main() {
  late MockAuthRepository mockAuthRepo;

  setUp(() async {
    // <--- async importante
    await getIt.reset(); // <--- await importante
    mockAuthRepo = MockAuthRepository();
    getIt.registerLazySingleton<IAuthRepository>(() => mockAuthRepo);
  });

  Widget createLoginScreen() {
    return ChangeNotifierProvider(
      create: (_) => LoginViewModel(),
      child: const MaterialApp(home: LoginScreen()),
    );
  }

  testWidgets('LoginScreen debe mostrar campos de Email, Password y Botón', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(createLoginScreen());

    expect(find.text('Inicia sesión'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Entrar'), findsOneWidget);
    expect(find.byType(TextField), findsNWidgets(2));
  });
}
