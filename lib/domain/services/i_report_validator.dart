// Resultado de validación simple para el formulario de reporte.
class ValidationResult {
  const ValidationResult({required this.isValid, this.errors = const {}});

  final bool isValid;
  final Map<String, String> errors; // keys: 'description', 'image'
}

abstract class IReportValidator {
  // Regla: descripción obligatoria y foto obligatoria.
  ValidationResult validate({
    required String description,
    required String? imagePath,
  });
}
