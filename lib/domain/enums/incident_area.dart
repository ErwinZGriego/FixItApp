enum IncidentArea {
  aula,
  banos, // Usamos 'n' para evitar problemas de caracteres
  salonMaestros,
  areaComputo,
  laboratorio,
  taller,
  pasillo,
  exterior,
  otro,
}

// Helper para mostrar nombres bonitos
extension AreaExtension on IncidentArea {
  String get prettyName {
    switch (this) {
      case IncidentArea.banos:
        return 'Baños';
      case IncidentArea.salonMaestros:
        return 'Salón de Maestros';
      case IncidentArea.areaComputo:
        return 'Área de Cómputo';
      default:
        return name[0].toUpperCase() + name.substring(1);
    }
  }
}
