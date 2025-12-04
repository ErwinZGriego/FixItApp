import 'package:flutter/material.dart';

import '../../core/di/service_locator.dart';
import '../../domain/models/incident.dart';
import '../../domain/repositories/i_auth_repository.dart'; // <--- 1. Importar Auth
import '../../domain/repositories/i_incident_repository.dart';

class IncidentListViewModel extends ChangeNotifier {
  // 2. Inyectamos tanto el Repo de Incidentes como el de Auth
  IncidentListViewModel({IIncidentRepository? repo, IAuthRepository? authRepo})
    : _repo = repo ?? getIt<IIncidentRepository>(),
      _authRepo = authRepo ?? getIt<IAuthRepository>();

  final IIncidentRepository _repo;
  final IAuthRepository _authRepo;

  List<Incident> items = [];
  bool isLoading = false;

  Future<void> load() async {
    isLoading = true;
    notifyListeners();
    try {
      // 3. Obtenemos el ID del usuario actual
      final myId = _authRepo.currentUserId;

      // 4. Pedimos SOLO los incidentes que coincidan con ese ID
      // (Si myId es null, el repo devolverá todos o lista vacía según tu implementación,
      // pero aquí asumimos que siempre hay usuario logueado en esta pantalla).
      items = await _repo.getIncidents(userId: myId);
    } catch (e) {
      // Es buena práctica manejar errores, aunque sea con un print por ahora
      debugPrint('Error cargando incidentes: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refresh() => load();
}
