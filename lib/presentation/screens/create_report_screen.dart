import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/create_report_view_model.dart';

class CreateReportScreen extends StatelessWidget {
  const CreateReportScreen({super.key});

  static const routeName = '/create_report';

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CreateReportViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Nuevo reporte')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Descripción
            TextField(
              key: const Key('create.description'),
              controller: vm.descriptionController,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: 'Descripción',
                hintText: 'Describe el incidente...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Categoría (strings)
            DropdownButtonFormField<String>(
              key: const Key('create.category'),
              initialValue: vm.selectedCategory,
              items: vm.categories
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: vm.setCategory,
              decoration: InputDecoration(
                labelText: 'Categoría',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Adjuntar foto
            OutlinedButton.icon(
              key: const Key('create.attach'),
              onPressed: vm.isBusy ? null : vm.attachPhoto,
              icon: vm.isBusy
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.camera_alt_outlined),
              label: Text(vm.isBusy ? 'Abriendo cámara...' : 'Adjuntar foto'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 12),

            if (vm.imagePath != null) _ImagePreview(path: vm.imagePath!),

            const SizedBox(height: 24),

            // Enviar
            ElevatedButton(
              key: const Key('create.submit'),
              onPressed: (vm.canSubmit && !vm.isSubmitting)
                  ? () async {
                      final ok = await context
                          .read<CreateReportViewModel>()
                          .submit();

                      if (!context.mounted) return;

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            ok
                                ? 'Reporte guardado'
                                : 'Revisa descripción y foto',
                          ),
                        ),
                      );

                      if (ok) Navigator.pop(context);
                    }
                  : null,
              child: vm.isSubmitting
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Enviar'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ImagePreview extends StatelessWidget {
  const _ImagePreview({required this.path});

  final String path;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(14);
    return ClipRRect(
      borderRadius: radius,
      child: Container(
        constraints: const BoxConstraints(maxHeight: 220),
        decoration: BoxDecoration(
          borderRadius: radius,
          border: Border.all(color: Colors.black.withValues(alpha: 0.08)),
        ),
        child: Image.file(
          File(path),
          fit: BoxFit.cover,
          // Si el decodificador falla (PNG/JPG corrupto), mostramos placeholder
          errorBuilder: (_, __, ___) => Container(
            height: 180,
            alignment: Alignment.center,
            color: Colors.black12,
            child: const Text(
              'Vista previa no disponible',
              style: TextStyle(color: Colors.black54),
            ),
          ),
        ),
      ),
    );
  }
}
