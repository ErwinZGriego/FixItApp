import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/enums/incident_status.dart';
import '../../domain/models/incident.dart';
import '../viewmodels/dashboard_view_model.dart';
import 'incident_detail_screen.dart';
import 'login_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});
  static const routeName = '/dashboard';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DashboardViewModel()..loadAll(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Panel de Administración'),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                Navigator.pushReplacementNamed(context, LoginScreen.routeName);
              },
            ),
          ],
        ),
        body: const _AdminBody(),
      ),
    );
  }
}

class _AdminBody extends StatelessWidget {
  const _AdminBody();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<DashboardViewModel>();

    if (vm.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // Filtramos los incidentes por estado
    final pendientes = vm.items
        .where((i) => i.status == IncidentStatus.pendiente)
        .toList();
    final enProceso = vm.items
        .where((i) => i.status == IncidentStatus.enProceso)
        .toList();
    final resueltos = vm.items
        .where((i) => i.status == IncidentStatus.resuelto)
        .toList();

    return RefreshIndicator(
      onRefresh: () => vm.loadAll(),
      child: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          _StatusGroup(
            title: 'PENDIENTES',
            color: Colors.orange,
            incidents: pendientes,
            vm: vm,
            initiallyExpanded: true, // Queremos ver estos primero
          ),
          const SizedBox(height: 10),
          _StatusGroup(
            title: 'EN PROCESO',
            color: Colors.blue,
            incidents: enProceso,
            vm: vm,
          ),
          const SizedBox(height: 10),
          _StatusGroup(
            title: 'RESUELTOS',
            color: Colors.green,
            incidents: resueltos,
            vm: vm,
          ),
        ],
      ),
    );
  }
}

class _StatusGroup extends StatelessWidget {
  const _StatusGroup({
    required this.title,
    required this.color,
    required this.incidents,
    required this.vm,
    this.initiallyExpanded = false,
  });

  final String title;
  final Color color;
  final List<Incident> incidents;
  final DashboardViewModel vm;
  final bool initiallyExpanded;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        initiallyExpanded: initiallyExpanded,
        shape: Border.all(color: Colors.transparent),
        collapsedShape: Border.all(
          color: Colors.transparent,
        ), // Quita bordes feos al abrir
        leading: Icon(Icons.circle, color: color, size: 16),
        title: Text(
          '$title (${incidents.length})',
          style: TextStyle(fontWeight: FontWeight.bold, color: color),
        ),
        children: incidents.isEmpty
            ? [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('No hay incidentes en este estado'),
                ),
              ]
            : incidents
                  .map(
                    (incident) =>
                        _AdminIncidentTile(incident: incident, vm: vm),
                  )
                  .toList(),
      ),
    );
  }
}

class _AdminIncidentTile extends StatelessWidget {
  const _AdminIncidentTile({required this.incident, required this.vm});

  final Incident incident;
  final DashboardViewModel vm;

  @override
  Widget build(BuildContext context) {
    final hasNotes =
        incident.staffNotes != null && incident.staffNotes!.isNotEmpty;

    return Column(
      children: [
        const Divider(height: 1),
        ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 4,
          ),
          title: Text(
            incident.title.isEmpty ? 'Sin título' : incident.title,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${incident.category.name} • ${_formatDate(incident.createdAt)}',
              ),
              if (hasNotes)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    'Nota: ${incident.staffNotes}',
                    style: TextStyle(
                      color: Colors.amber.shade900,
                      fontStyle: FontStyle.italic,
                      fontSize: 12,
                    ),
                  ),
                ),
            ],
          ),
          onTap: () {
            Navigator.pushNamed(
              context,
              IncidentDetailScreen.routeName,
              arguments: incident,
            );
          },
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Botón Notas
              IconButton(
                icon: Icon(
                  hasNotes ? Icons.note : Icons.note_add_outlined,
                  color: hasNotes ? Colors.amber.shade800 : Colors.grey,
                ),
                onPressed: () => _showNoteDialog(context),
              ),
              // Botón Estado
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue),
                onPressed: () => _showStatusDialog(context),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime d) => '${d.day}/${d.month} ${d.hour}:${d.minute}';

  void _showNoteDialog(BuildContext context) {
    final controller = TextEditingController(text: incident.staffNotes);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Nota del Personal'),
        content: TextField(
          controller: controller,
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: 'Escribe observaciones internas...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              vm.updateStaffNotes(incident, controller.text);
              Navigator.pop(ctx);
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  void _showStatusDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: const Text('Cambiar Estado'),
        children: IncidentStatus.values.map((status) {
          final isSelected = status == incident.status;
          return SimpleDialogOption(
            onPressed: () {
              vm.updateStatus(incident, status);
              Navigator.pop(ctx);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  Icon(
                    isSelected
                        ? Icons.radio_button_checked
                        : Icons.radio_button_unchecked,
                    color: isSelected
                        ? Theme.of(context).primaryColor
                        : Colors.grey,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Text(status.name.toUpperCase()),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
