import 'package:get_it/get_it.dart';

// Instancia global de GetIt (el Service Locator)
final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  // Aquí registraremos nuestras dependencias más adelante.
  // El orden importa:
  // 1. External (Firebase, SharedPreferences, Dio)
  // 2. Data (Repositorios y Data Sources)
  // 3. Domain (Use Cases - opcional)
  // 4. Presentation (ViewModels/Blocs)

  // Ejemplo futuro:
  // getIt.registerLazySingleton<IAuthRepository>(() => AuthRepositoryImpl());

  // Por ahora, solo imprimimos para confirmar que se ejecutó.
  /*print(
    '✅ Service Locator (Inyección de Dependencias) inicializado correctamente.',
  );*/
}
