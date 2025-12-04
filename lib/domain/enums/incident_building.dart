enum IncidentBuilding {
  // Carreras
  ambiental,
  biotecnologia,
  desarrolloNegocios,
  disenoModa,
  gastronomia,
  industrial,
  mantenimiento,
  mecatronica,
  mineria,
  paramedico,
  procesosIndustriales,
  tecnologiasInformacion,
  terapiaFisica,
  // Áreas comunes
  serviciosEscolares,
  gimnasio,
  cafeteria,
  auditorio,
  direccion,
  biblioteca,
  otro,
}

// Helper para mostrar nombres bonitos en el Dropdown
extension BuildingExtension on IncidentBuilding {
  String get prettyName {
    switch (this) {
      case IncidentBuilding.desarrolloNegocios:
        return 'Desarrollo de Negocios';
      case IncidentBuilding.disenoModa:
        return 'Diseño y Moda';
      case IncidentBuilding.procesosIndustriales:
        return 'Procesos Industriales';
      case IncidentBuilding.tecnologiasInformacion:
        return 'Tecnologías de la Información';
      case IncidentBuilding.terapiaFisica:
        return 'Terapia Física';
      case IncidentBuilding.serviciosEscolares:
        return 'Servicios Escolares';
      // Para el resto, simplemente capitalizamos la primera letra
      default:
        return name[0].toUpperCase() + name.substring(1);
    }
  }
}
