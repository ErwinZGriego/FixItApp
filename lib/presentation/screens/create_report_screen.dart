import 'dart:io';

import 'package:fix_it_app/domain/enums/incident_area.dart'; // <--- Import
import 'package:fix_it_app/domain/enums/incident_building.dart'; // <--- Import
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/create_report_view_model.dart';

class CreateReportScreen extends StatelessWidget {
  const CreateReportScreen({super.key});
  static const routeName = '/create_report';

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CreateReportViewModel>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Nuevo reporte')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Descripción
            TextField(
              key: const ValueKey('create.description'),
              controller: vm.descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Descripción del problema *',
                alignLabelWithHint: true,
                border: OutlineInputBorder(),
                hintText: 'Ej: Proyector del aula 3 no enciende...',
              ),
              onChanged: (value) => vm.setDescription(value),
            ),
            const SizedBox(height: 20),

            // --- NUEVO: DROPDOWN EDIFICIO ---
            DropdownButtonFormField<IncidentBuilding>(
              decoration: const InputDecoration(
                labelText: 'Edificio / Facultad *',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.business),
              ),
              initialValue: vm.selectedBuilding,
              items: IncidentBuilding.values.map((building) {
                return DropdownMenuItem(
                  value: building,
                  // Usamos la extensión .prettyName para que se vea bonito
                  child: Text(building.prettyName),
                );
              }).toList(),
              onChanged: vm.setBuilding,
            ),
            const SizedBox(height: 20),

            // --- NUEVO: DROPDOWN ÁREA ---
            DropdownButtonFormField<IncidentArea>(
              decoration: const InputDecoration(
                labelText: 'Área específica *',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.place),
              ),
              initialValue: vm.selectedArea,
              items: IncidentArea.values.map((area) {
                return DropdownMenuItem(
                  value: area,
                  child: Text(area.prettyName),
                );
              }).toList(),
              onChanged: vm.setArea,
            ),
            const SizedBox(height: 20),
            // --------------------------------

            // Categoría (Dropdown existente)
            DropdownButtonFormField<String>(
              key: const ValueKey('create.category'),
              decoration: const InputDecoration(
                labelText: 'Categoría *',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.category),
              ),
              initialValue: vm.selectedCategory,
              items: vm.categories.map((cat) {
                return DropdownMenuItem(value: cat, child: Text(cat));
              }).toList(),
              onChanged: vm.setCategory,
            ),
            const SizedBox(height: 20),

            // Área de Foto
            _PhotoPickerArea(vm: vm, theme: theme),

            const SizedBox(height: 10),
            if (vm.lastError != null)
              Text(
                vm.lastError!,
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            const SizedBox(height: 20),

            // Botón Enviar
            SizedBox(
              height: 50,
              child: ElevatedButton(
                key: const ValueKey('create.submit'),
                // El botón se deshabilita si falta algún campo nuevo
                onPressed: (vm.canSubmit && !vm.isSubmitting)
                    ? () async {
                        final success = await vm.submit();
                        if (success && context.mounted) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('¡Reporte enviado con éxito!'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        }
                      }
                    : null,
                child: vm.isSubmitting
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Enviar reporte'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PhotoPickerArea extends StatelessWidget {
  const _PhotoPickerArea({required this.vm, required this.theme});

  final CreateReportViewModel vm;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final hasPhoto = vm.imagePath != null;

    return InkWell(
      key: const ValueKey('create.attach'),
      onTap: vm.isBusy ? null : vm.attachPhoto,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 180,
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: theme.colorScheme.outline.withValues(alpha: 0.5),
          ),
          image: hasPhoto
              ? DecorationImage(
                  image: FileImage(File(vm.imagePath!)),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: hasPhoto
            ? null
            : vm.isBusy
            ? const Center(child: CircularProgressIndicator())
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_a_photo_outlined,
                    size: 40,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Adjuntar evidencia *',
                    style: TextStyle(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
