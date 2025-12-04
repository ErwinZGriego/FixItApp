import 'package:flutter/material.dart';
import '../../core/di/service_locator.dart';
import '../../domain/enums/incident_status.dart';
import '../../domain/models/incident.dart';
import '../../domain/repositories/i_incident_repository.dart';

class DashboardViewModel extends ChangeNotifier {
  // Inyectamos el repositorio
  final IIncidentRepository _repo = getIt<IIncidentRepository>();

  List<Incident> items = [];
  bool isLoading = false;

  // Para mostrar feedback (Snackbars) en la UI
  String? message;

  // Cargar TODOS los incidentes (Admin Mode)
  Future<void> loadAll() async {
    isLoading = true;
    notifyListeners();
    try {
      // Al no pasar userId, el repositorio trae todo (gracias a tu lógica del Paso 3)
      items = await _repo.getIncidents(userId: null);
    } catch (e) {
      debugPrint('Error cargando dashboard: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Actualizar el estado de un reporte
  Future<void> updateStatus(Incident incident, IncidentStatus newStatus) async {
    // Optimistic Update: Actualizamos la UI localmente primero para que se sienta rápido
    final index = items.indexWhere((i) => i.id == incident.id);
    if (index == -1) return;

    final oldStatus = incident.status;
    final updatedIncident = incident.copyWith(status: newStatus);

    // 1. Actualizamos lista local
    items[index] = updatedIncident;
    notifyListeners();

    try {
      // 2. Enviamos a Firebase
      await _repo.updateIncident(updatedIncident);
      message = 'Estado actualizado a ${newStatus.name}';
    } catch (e) {
      // Si falla, revertimos el cambio (Rollback)
      items[index] = incident.copyWith(status: oldStatus);
      message = 'Error actualizando estado';
      notifyListeners();
    }
  }
}
