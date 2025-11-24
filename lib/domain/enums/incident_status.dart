enum IncidentStatus {
  pendiente,
  enProceso,
  resuelto;

  // Getter para mostrar el estado en la UI con formato correcto
  String get label {
    switch (this) {
      case IncidentStatus.pendiente:
        return 'Pendiente';
      case IncidentStatus.enProceso:
        return 'En Proceso';
      case IncidentStatus.resuelto:
        return 'Resuelto';
    }
  }
}
