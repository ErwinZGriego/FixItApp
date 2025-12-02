import 'package:flutter/material.dart';

import '../../core/di/service_locator.dart';
import '../../domain/models/incident.dart';
import '../../domain/repositories/i_incident_repository.dart';

/// VM simple para listar incidentes locales desde SQLite.
class IncidentListViewModel extends ChangeNotifier {
  IncidentListViewModel({IIncidentRepository? repo})
    : _repo = repo ?? getIt<IIncidentRepository>();

  final IIncidentRepository _repo;

  List<Incident> items = [];
  bool isLoading = false;

  Future<void> load() async {
    isLoading = true;
    notifyListeners();
    try {
      items = await _repo.getIncidents();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refresh() => load();
}
