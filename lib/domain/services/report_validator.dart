import 'i_report_validator.dart';

/// Implementacion pura (sin dependencias externas).
class ReportValidator implements IReportValidator {
  @override
  ValidationResult validate({
    required String description,
    required String? imagePath,
  }) {
    final errors = <String, String>{};

    // Descripcion obligatoria
    final desc = description.trim();
    if (desc.isEmpty) {
      errors['description'] = 'La descripción es obligatoria.';
    }

    // Foto obligatoria
    if (imagePath == null || imagePath.isEmpty) {
      errors['image'] = 'La foto es obligatoria.';
    }

    return ValidationResult(isValid: errors.isEmpty, errors: errors);
  }
}
