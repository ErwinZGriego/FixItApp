import 'dart:io';
import 'package:flutter/material.dart';
import '../../domain/models/incident.dart';

class IncidentDetailScreen extends StatelessWidget {
  const IncidentDetailScreen({super.key});
  static const routeName = '/incident_detail';

  @override
  Widget build(BuildContext context) {
    final incident = ModalRoute.of(context)!.settings.arguments as Incident;

    return Scaffold(
      appBar: AppBar(title: const Text('Detalle del reporte')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Foto en grande (Actualizada)
            _BigPhoto(path: incident.photoPath),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    incident.title.isEmpty ? 'Reporte' : incident.title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),

                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _Pill(
                        text: _pretty(incident.category.name),
                        color: Theme.of(context).colorScheme.secondary,
                        light: true,
                      ),
                      _Pill(
                        text: _pretty(incident.status.name),
                        color: Theme.of(context).primaryColor,
                        light: true,
                      ),
                      _Pill(
                        text: _formatDateTime(incident.createdAt),
                        color: Colors.black54,
                        light: true,
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  Text(
                    'Descripción',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    incident.description.isEmpty
                        ? 'Sin descripción'
                        : incident.description,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String _pretty(String s) =>
      s.isEmpty ? s : '${s[0].toUpperCase()}${s.substring(1)}';

  static String _formatDateTime(DateTime d) {
    final y = d.year.toString().padLeft(4, '0');
    final m = d.month.toString().padLeft(2, '0');
    final day = d.day.toString().padLeft(2, '0');
    final h = d.hour.toString().padLeft(2, '0');
    final min = d.minute.toString().padLeft(2, '0');
    return '$y-$m-$day $h:$min';
  }
}

// --- WIDGET ACTUALIZADO ---
class _BigPhoto extends StatelessWidget {
  const _BigPhoto({required this.path});
  final String path;

  @override
  Widget build(BuildContext context) {
    Widget child;

    if (path.isEmpty) {
      child = const Center(
        child: Icon(Icons.image_not_supported_outlined, size: 42),
      );
    } else if (path.startsWith('http')) {
      // URL Remota
      child = Image.network(
        path,
        fit: BoxFit.cover,
        loadingBuilder: (_, widget, progress) {
          if (progress == null) return widget;
          return Center(
            child: CircularProgressIndicator(
              value: progress.expectedTotalBytes != null
                  ? progress.cumulativeBytesLoaded /
                        progress.expectedTotalBytes!
                  : null,
            ),
          );
        },
        errorBuilder: (_, __, ___) => const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.broken_image, size: 42, color: Colors.grey),
              Text('No se pudo cargar la imagen'),
            ],
          ),
        ),
      );
    } else {
      // Archivo Local
      final f = File(path);
      if (f.existsSync()) {
        child = Image.file(f, fit: BoxFit.cover);
      } else {
        child = const Center(
          child: Icon(Icons.broken_image_outlined, size: 42),
        );
      }
    }

    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Container(color: Colors.black12, child: child),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.text, required this.color, this.light = false});
  final String text;
  final Color color;
  final bool light;

  @override
  Widget build(BuildContext context) {
    final bg = light
        ? color.withValues(alpha: 0.12)
        : color.withValues(alpha: 0.15);
    final fg = light ? color : Colors.white;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: TextStyle(color: fg, fontWeight: FontWeight.w600),
      ),
    );
  }
}
