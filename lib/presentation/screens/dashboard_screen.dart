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

    if (vm.items.isEmpty) {
      return const Center(child: Text('No hay incidentes registrados'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: vm.items.length,
      itemBuilder: (context, index) {
        final incident = vm.items[index];
        return Card(
          child: ListTile(
            title: Text(incident.title.isEmpty ? 'Sin título' : incident.title),
            subtitle: Text(
              '${incident.category.name} • ${incident.status.name.toUpperCase()}',
            ),
            trailing: IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: () => _showStatusDialog(context, vm, incident),
            ),
            onTap: () {
              Navigator.pushNamed(
                context,
                IncidentDetailScreen.routeName,
                arguments: incident,
              );
            },
          ),
        );
      },
    );
  }

  void _showStatusDialog(
    BuildContext context,
    DashboardViewModel vm,
    Incident incident,
  ) {
    // Usamos SimpleDialog en lugar de AlertDialog con Radios.
    // Esto evita los errores de 'groupValue deprecated' y es más rápido de usar.
    showDialog(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: const Text('Cambiar Estado'),
        children: IncidentStatus.values.map((status) {
          // Resaltamos la opción actual visualmente
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
                  Text(
                    status.name.toUpperCase(),
                    style: TextStyle(
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: isSelected
                          ? Theme.of(context).primaryColor
                          : Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
