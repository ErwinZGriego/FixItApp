import 'package:fix_it_app/core/di/service_locator.dart';
import 'package:fix_it_app/domain/enums/user_role.dart';
import 'package:fix_it_app/domain/repositories/i_auth_repository.dart';
import 'package:fix_it_app/presentation/viewmodels/login_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks.dart';

void main() {
  late MockAuthRepository mockAuthRepo;
  late LoginViewModel viewModel;

  setUp(() async {
    // <--- async
    await getIt.reset(); // <--- await
    mockAuthRepo = MockAuthRepository();
    getIt.registerLazySingleton<IAuthRepository>(() => mockAuthRepo);
    viewModel = LoginViewModel();
  });

  group('LoginViewModel Tests', () {
    test('submit() debe retornar TRUE si el login es exitoso', () async {
      viewModel.emailController.text = 'test@uth.mx';
      viewModel.passwordController.text = '123456';

      when(() => mockAuthRepo.signIn(any(), any())).thenAnswer((_) async {});
      when(
        () => mockAuthRepo.getUserRole(),
      ).thenAnswer((_) async => UserRole.student);

      final resultado = await viewModel.submit();

      expect(resultado, true);
      verify(() => mockAuthRepo.signIn('test@uth.mx', '123456')).called(1);
    });
  });
}
