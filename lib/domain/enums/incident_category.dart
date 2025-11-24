enum IncidentCategory {
  mobiliario,
  electrico,
  limpieza,
  seguridad,
  otro;

  // Getter opcional para obtener el texto bonito en la UI
  String get label {
    switch (this) {
      case IncidentCategory.mobiliario:
        return 'Mobiliario';
      case IncidentCategory.electrico:
        return 'Eléctrico';
      case IncidentCategory.limpieza:
        return 'Limpieza';
      case IncidentCategory.seguridad:
        return 'Seguridad';
      case IncidentCategory.otro:
        return 'Otro';
    }
  }
}
